{pkgs, ...}: {
  systemd.user.timers."postgresql-vac" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = [
        "Mon,Wed,Fri *-*-* 03:00:00"
        "Tue,Thu,Sat,Sun *-*-* 02:00:00"
      ];
      Persistent = true;
    };
  };

  systemd.user.services."postgresql-vac" = {
    script = ''
      ${pkgs.podman}/bin/podman exec -i iceshrimp.net_db psql -U luna luna -c 'VACUUM ANALYZE;'
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };
}
