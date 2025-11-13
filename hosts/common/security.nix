{
  config,
  lib,
  ...
}: {
  ## System security tweaks
  # Prevent replacing the running kernel w/o reboot
  security.protectKernelImage = true;

  boot.tmp = {
    # tmpfs = /tmp is mounted in ram. Doing so makes temp file management speedy
    # on ssd systems, and volatile! Because it's wiped on reboot.
    useTmpfs = true;
    # If not using tmpfs, which is naturally purged on reboot, we must clean it
    # /tmp ourselves. /tmp should be volatile storage!
    cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);
  };

  systemd.coredump.enable = false;
  services.dbus.implementation = "broker";
  security = {
    audit.enable = true;
    polkit.enable = true;
    rtkit.enable = true;
  };
}
