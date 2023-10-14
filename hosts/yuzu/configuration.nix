{
  config,
  lib,
  pkgs,
  inputs,
  sops-nix,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix
    ./media.nix
    ../common/qbittorrent.nix
    inputs.sops-nix.nixosModules.sops
    inputs.cloudflared.nixosModules.cloudflared
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmp.useTmpfs = true;
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      compressor = "zstd";
      kernelModules = [];
    };
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };

  nix = {
    package = pkgs.nixUnstable;
    settings = {auto-optimise-store = true;};
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
  };

  networking.hostName = "yuzu"; # Define your hostname.
  # Pick only one of the below networking options.

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "enp1s0";
    networkConfig = {
      # start a DHCP Client for IPv4 Addressing/Routing
      DHCP = "ipv4";
      # accept Router Advertisements for Stateless IPv6 Autoconfiguraton (SLAAC)
      IPv6AcceptRA = true;
    };
    # make routing on this interface a dependency for network-online.target
    linkConfig.RequiredForOnline = "routable";
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.luna = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmJ37s/9ASDgUuYNFytjH4Q54FM8E0SZZBOvxSep5ZP luna.dragon@suse.com"
    ];
    packages = with pkgs; [
      tree
      pkgs.cloudflared
    ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmJ37s/9ASDgUuYNFytjH4Q54FM8E0SZZBOvxSep5ZP luna.dragon@suse.com"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; let
    uimods = pkgs.callPackage ../packages/vuetorrent.nix {};
  in [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    nv-codec-headers-12
    uimods.vuetorrent
  ];

  swapDevices = [
    {
      device = "/swapfile";
    }
  ];
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.rpcbind.enable = true;
  services.nfs.server = {
    enable = true;
    exports = ''
      /export        *(rw,fsid=0,no_subtree_check,no_all_squash,crossmnt)
      /export/media  *(rw,nohide,insecure,no_subtree_check,no_all_squash,crossmnt)
    '';
  };

  services.cloudflared-flake = {
    enable = true;
    tokenFile = "${config.sops.secrets.cloudflared.path}";
  };

  sops = {
    defaultSopsFile = ./secrets.json;
    defaultSopsFormat = "json";
    secrets.cloudflared = {
      mode = "0440";
      owner = "cloudflared";
      group = "cloudflared";
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [111 2049 4000 4001 4002 20048 8096];
  networking.firewall.allowedUDPPorts = [111 2049 4000 4001 4002 20048 1900 7359];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
