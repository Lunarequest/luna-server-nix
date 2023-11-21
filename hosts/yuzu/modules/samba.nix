{pkgs, ...}: {
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
    interface = "eth0 tailscale0";
    hostname = "yuzu";
    discovery = true;
  };
  services.samba = {
    enable = true;
    package = pkgs.sambaFull;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = yuzu
      netbios name = yuzu
      security = user
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.1. 127.0.0.1 100.110.13.97 100.127.121.93 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
      load printers = yes
      printing = cups
      printcap name = cups

    '';
    shares = {
      public = {
        path = "/export/Public";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nobody";
        "force group" = "nobody";
      };
      private = {
        path = "/export/media";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "luna";
        "force group" = "users";
      };
      printers = {
        comment = "All Printers";
        path = "/var/spool/samba";
        public = "yes";
        browseable = "yes";
        # to allow user 'guest account' to print.
        "guest ok" = "yes";
        writable = "no";
        printable = "yes";
        "create mode" = 0700;
      };
    };
  };
  systemd.tmpfiles.rules = [
    "d /var/spool/samba 1777 root root -"
  ];
}
