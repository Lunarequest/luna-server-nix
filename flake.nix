{
  description = "flake to deploy to jellyfin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cloudflared = {
      url = "github:piperswe/nix-cloudflared";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lunarfetch = {
      url = "git+ssh://git@github.com/Lunarequest/lunarfetch.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    deploy-rs,
    sops-nix,
    cloudflared,
    lanzaboote,
    lunarfetch,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.alejandra;
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        zsh
        niv
        nil
        zstd
        deploy-rs.packages.${system}.default
        sops-nix.packages.${system}.default
      ];
      shellHook = ''
        test ~/.zshrc && exec zsh
      '';
    };

    nixosConfigurations = {
      yuzu = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          inherit inputs;
        };
        modules = [./hosts/yuzu/configuration.nix];
      };
    };
    deploy.nodes = {
      yuzu = {
        sshUser = "root";
        hostname = "100.88.197.54";
        profiles = {
          system = {
            user = "root";
            path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.yuzu;
          };
        };
      };
    };
    checks =
      builtins.mapAttrs
      (system: deployLib: deployLib.deployChecks self.deploy)
      deploy-rs.lib;
  };
}
