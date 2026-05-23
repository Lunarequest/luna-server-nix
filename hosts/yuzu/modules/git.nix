{
  config,
  pkgs,
  ...
}:
{
  services.postgresql = {
    ensureDatabases = [ config.services.forgejo.user ];
    ensureUsers = [
      {
        name = config.services.forgejo.database.user;
        ensureDBOwnership = true;
      }
    ];
  };

  services.anubis = {
    instances = {
      forgejo = {
        enable = true;
        settings = {
          DIFFICULTY = 5;
          BIND = "127.0.0.1:3003";
          BIND_NETWORK = "tcp";
          METRICS_BIND = "127.0.0.1:6000";
          METRICS_BIND_NETWORK = "tcp";
          TARGET = "http://localhost:3001";
          WEBMASTER_EMAIL = "luna@nullrequest.com";
          SERVE_ROBOTS_TXT = true;
        };
      };
    };
  };

  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    database = {
      type = "postgres";
      passwordFile = config.sops.secrets."forgejo_dbpass".path;
    };
    settings = {
      DEFAULT.APP_NAME = "Forgegay: Beyond coding. We gay.";
      ui = {};
      service.DISABLE_REGISTRATION = true;
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "https://code.forgejo.org";
        ARTIFACT_RETENTION_DAYS = 90;
      };
      server = {
        DOMAIN = "git.nullrequest.com";
        ROOT_URL = "https://git.nullrequest.com";
        SSH_DOMAIN = "100.88.197.54";
        HTTP_PORT = 3001;
      };
    };
  };
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.lunas_runner = {
      url = "https://git.nullrequest.com";
      name = "lunas runner";
      enable = false;
      tokenFile = config.sops.secrets."forgejo_runner".path;
      labels = [
        "baremetal:docker://ghcr.io/catthehacker/ubuntu:act-latest"
        "docker:docker://ghcr.io/catthehacker/ubuntu:act-latest"
        "debian-latest:docker://node:trixie"
        "ubuntu-latest:docker://node:trixie"
        "alpine-latest:docker://node:current-alpine"
      ];
      settings = {
        log.level = "info";
        runner = {
          capacity = 1;
          cache.enable = true;
        };
        container = {
          privileged = true;
          network = "host";
        };
      };
    };
  };
}
