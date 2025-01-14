{...}: {
  virtualisation.oci-containers.containers."navidrome" = {
    autoStart = true;
    image = "docker.io/deluan/navidrome:latest";
    #user: 1000:1000 # should be owner of volumes
    ports = ["4533:4533"];
    environment = {
      # Optional: put your config options customization here. Examples:
      ND_SCANSCHEDULE = "1h";
      ND_LOGLEVEL = "info";
      ND_SESSIONTIMEOUT = "24h";
      ND_BASEURL = "https://navidrome.nullrequest.com";
    };
    volumes = [
      "/srv/containers/Navidrome/data:/data"
      "/media/nfs/Music:/music:ro"
    ];
    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };
}
