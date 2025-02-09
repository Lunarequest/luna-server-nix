{...}: {
  virtualisation.oci-containers.containers."nfty" = {
    autoStart = true;
    image = "docker.io/binwiederhier/ntfy";
    ports = ["8000:80"];

    environment = {
      TS = "Etc/IN";
      NTFY_BASE_URL = "https://ntfy.nullrequest.com";
      NTFY_CACHE_FILE = "/var/lib/ntfy/cache.db";
      NTFY_AUTH_FILE = "/var/lib/ntfy/auth.db";
      NTFY_AUTH_DEFAULT_ACCESS = "deny-all";
      NTFY_BEHIND_PROXY = "true";
      NTFY_ATTACHMENT_CACHE_DIR = "/var/lib/ntfy/attachments";
      NTFY_ENABLE_LOGIN = "true";
    };

    volumes = [
      "/srv/containers/nfty/cache:/var/cache/ntfy"
      "/srv/containers/nfty/config:/etc/ntfy"
      "/srv/containers/nfty/db:/var/lib/ntfy/"
    ];
    cmd = ["serve"];

    labels = {
      "io.containers.autoupdate" = "registry";
    };
  };
}
