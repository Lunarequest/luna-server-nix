{...}: {
  services.jellyfin.enable = true;

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    dataDir = "/srv/qbittorrent";
    port = 5090;
  };
}
