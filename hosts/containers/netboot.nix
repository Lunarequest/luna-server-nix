{...}: {
  virtualisation.oci-containers.containers."netboot" = {
    autoStart = true;
    image = "docker.io/linuxserver/netbootxyz";
    ports = [
      "3000:3000"
      "69:69/udp"
      "8080:80"
    ];
    environment = {
      PUID = "1000";
      PGID = "1000";
      TS = "Etc/IN";
    };
    volumes = [
      "/srv/containers/Navidrome/config:/config"
      "/srv/containers/Navidrome/assets:/assets"
    ];
    labels = {
      "io.containers.autoupdate"="registry";
    };
  };
}