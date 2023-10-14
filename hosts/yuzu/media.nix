{pkgs, ...}: let
  downloadDir = "/media/nfs/Downloads";
  fixDownloadPerms = pkgs.writeShellScriptBin "fixdlperms" ''
    find ${downloadDir} -type d -exec chmod 2775 {} +
    find ${downloadDir} -type f -exec chmod 0664 {} +
  '';
in {
  services.jellyfin.enable = true;

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    dataDir = "/srv/qbittorrent";
    port = 5090;
  };
}
