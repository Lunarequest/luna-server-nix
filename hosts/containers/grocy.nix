{...}: {
  virtualisation.oci-containers.containers."grocy" = {
    autoStart = true;
    image = "lscr.io/linuxserver/grocy:latest";
    ports = [
      "9283:80"
    ];
    environment = {
      PUID = "1000";
      PGID = "1000";
      TS = "Etc/IN";
    };
    volumes = [
      "/srv/containers/grocy:/config"
    ];
    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };
}
