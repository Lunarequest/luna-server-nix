{
  config,
  pkgs,
  ...
}: {
  virtualisation.docker.enable = true;

  services.postgresql = {
    ensureDatabases = [config.services.forgejo.user];
    ensureUsers = [
      {
        name = config.services.forgejo.database.user;
        ensureDBOwnership = true;
      }
    ];
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
      ui = {
        DEFAULT_THEME = "bthree-dark";
        THEMES = "bthree-dark,arc-blue,forgejo-auto,forgejo-light,forgejo-dark,gitea-auto,gitea-light,gitea-dark,forgejo-auto-deuteranopia-protanopia,forgejo-light-deuteranopia-protanopia,forgejo-dark-deuteranopia-protanopia,forgejo-auto-tritanopia,forgejo-light-tritanopia,forgejo-dark-tritanopia";
      };
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
      token = "jV7y9pBi5afeR6aiahVQtZZ9dya0pqRuGm5NlSnp";
      labels = [
        "docker:docker://catthehacker/ubuntu:act-latest"
        "debian-latest:docker://node:22-bookworm"
        "ubuntu-latest:docker://node:22-bookworm"
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
