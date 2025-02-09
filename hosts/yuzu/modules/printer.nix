{pkgs, ...}: {
  services.printing = {
    enable = true; # enables printing support via the CUPS daemon
    drivers = [];
    browsing = true;
    listenAddresses = ["*:631"];
    allowFrom = ["all"];
    defaultShared = true;
  };
  services.avahi = {
    enable = true; # runs the Avahi daemon
    nssmdns4 = true; # enables the mDNS NSS plug-in
    nssmdns6 = true;
    openFirewall = true; # opens the firewall for UDP port 5353
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
