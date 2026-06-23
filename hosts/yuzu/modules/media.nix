{pkgs, ...}: {
  services.jellyfin.enable = true;

  services.qbittorrent = {
    package = pkgs.qbittorrent-enhanced-nox;
    enable = true;
    openFirewall = true;
    profileDir = "/srv/qbittorrent";
    webuiPort = 5090;
  };

  environment.etc."vuetorrent" = let
    vuetorrent = pkgs.callPackage ../../packages/vuetorrent.nix {};
  in {
    source = vuetorrent.vuetorrent;
    target = "vuetorrent";
  };
}
