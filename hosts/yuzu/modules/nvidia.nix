{ config, ... }:
{
  nixpkgs.config.allowUnfree = true;
  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      modesetting.enable = true;
      open = false;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ ];
}
