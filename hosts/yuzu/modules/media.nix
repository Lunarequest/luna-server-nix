{pkgs, ...}: {
  services.jellyfin.enable = true;

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    dataDir = "/srv/qbittorrent";
    port = 5090;
  };

  environment.etc."vuetorrent" = let
    vuetorrent = pkgs.callPackage ../../packages/vuetorrent.nix {};
  in {
    source = vuetorrent.vuetorrent;
    target = "vuetorrent";
  };
}
