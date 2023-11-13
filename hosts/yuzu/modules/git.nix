{
  config,
  pkgs,
  ...
}: {
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services.postgresql = {
    ensureDatabases = [config.services.forgejo.user];
    ensureUsers = [
      {
        name = config.services.forgejo.database.user;
        ensurePermissions."DATABASE ${config.services.forgejo.database.name}" = "ALL PRIVILEGES";
      }
    ];
  };

  services.forgejo = {
    enable = true;
    database = {
      type = "postgres";
      passwordFile = config.sops.secrets."forgejo_dbpass".path;
    };
    settings = {
      DEFAULT.APP_NAME = "Forgejo: Beyond coding. We gay.";
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
    package = pkgs.forgejo-actions-runner;
    instances.lunas_runner = {
      url = "https://git.nullrequest.com";
      name = "lunas runner";
      enable = true;
      tokenFile = config.sops.secrets."forgejo_runner".path;
      labels = [
        "debian-latest:docker://node:20-bookworm"
        "ubuntu-latest:docker://node:20-bookworm"
        "alpine-latest:docker://node:current-alpine"
      ];
      settings = {
        log.level = "info";
        runner = {
          capacity = 1;
          cache.enable = true;
          container.privileged = true;
        };
      };
    };
  };
}
