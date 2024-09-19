{
  description = "flake to deploy to jellyfin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nix-eval-jobs = {
    #  url = "git+https://git.lix.systems/lix-project/nix-eval-jobs.git";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    colmena = {
      url = "github:zhaofengli/colmena";
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
    colmena,
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
        zstd
        colmena.packages.${system}.colmena
        sops-nix.packages.${system}.default
      ];
      shellHook = ''
        test ~/.zshrc && exec zsh
      '';
    };
    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [];
        };
        specialArgs = {
          inherit inputs;
        };
      };

      yuzu = ./hosts/yuzu/configuration.nix;
      tingyun = ./hosts/tingyun/configuration.nix;
    };
  };
}
