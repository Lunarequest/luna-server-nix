{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./modules/hardware-configuration.nix
    ./modules/nvidia.nix
    ./modules/media.nix
    ./modules/printer.nix
    ./modules/samba.nix
    ./modules/git.nix
    ../containers/grocy.nix
    ../common/qbittorrent.nix
    ../containers/navidrome.nix
    ../containers/netboot.nix
    inputs.sops-nix.nixosModules.sops
    inputs.cloudflared.nixosModules.cloudflared
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.lix-module.nixosModules.default
  ];

  ##### Colmena Configuration #####
  deployment = {
    targetUser = "root";
    targetHost = "192.168.1.15";
    targetPort = 22;
    tags = ["x86_64" "infra=heavy"];
  };
  ##### Colmena Configuration #####

  virtualisation.oci-containers.backend = "docker";

  # Use the systemd-boot EFI boot loader.
  boot = {
    bootspec.enable = true;
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
      configurationLimit = 2;
    };
    tmp.useTmpfs = true;
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      compressor = "zstd";
      kernelModules = ["tcp_bbr"];
    };
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      extra-substituters = [
        "https://cache.lix.systems"
      ];
      trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
    };
    optimise.automatic = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
  };

  networking = {
    hostName = "yuzu"; # Define your hostname.
    nameservers = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];

    # Open ports in the firewall.
    firewall.allowedTCPPorts = [80 443 5357 8096 631 3000 8080];
    firewall.allowedUDPPorts = [3702 1900 7359 631 3000 8080 69];
    firewall.allowPing = true;
  };
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };

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
    ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmJ37s/9ASDgUuYNFytjH4Q54FM8E0SZZBOvxSep5ZP luna.dragon@suse.com"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    linuxPackages.nvidia_x11
    neofetch
    screen
    unzip
    inputs.lunarfetch.packages.x86_64-linux.default
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

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
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
    secrets."forgejo_dbpass" = {
      owner = "${config.services.forgejo.user}";
    };
    secrets."forgejo_runner" = {
      mode = "0444";
    };
  };

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
