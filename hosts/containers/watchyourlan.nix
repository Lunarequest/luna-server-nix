{...}: {
  virtualisation.oci-containers.containers."wyl" = {
    autoStart = true;
    image = "aceberg/watchyourlan:v2";
    environment = {
      IFACES = "enp7s0";
      TZ = "Etc/IN";
    };
    extraOptions = ["--network=host"];
  };

  systemd.tmpfiles.rules = [
    "d /srv/containers/wyl 0755 root root"
  ];
}
