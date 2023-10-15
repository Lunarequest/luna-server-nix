{pkgs, ...}: {
  services.printing = {
    enable = true; # enables printing support via the CUPS daemon
    drivers = with pkgs; [epson-201401w];
    browsing = true;
    listenAddresses = ["*:631"];
    allowFrom = [ "all" ];
    defaultShared = true; 
  };
  services.avahi = {
    enable = true; # runs the Avahi daemon
    nssmdns = true; # enables the mDNS NSS plug-in
    openFirewall = true; # opens the firewall for UDP port 5353
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
