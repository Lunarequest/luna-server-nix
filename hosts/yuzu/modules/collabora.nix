{...}: {
  services.collabora-online = {
    enable = true;
    port = 9980;

    settings = {
      ssl = {
        enable = false;
        termination = true;
      };

      net = {
        listen = "loopback";
        post_allow.host = ["::1" "127.0.0.1"];
      };

      storage.wopi = {
        "@allow" = true;
        host = ["nextcloud.nullrequest.com"];
      };

      server_name = "collabora.nullrequest.com";
    };
  };
}
