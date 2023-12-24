{
  stdenv,
  fetchzip,
}: {
  vuetorrent = stdenv.mkDerivation rec {
    pname = "vuetorrent";
    version = "2.4.0";
    dontBuild = true;
    src = fetchzip {
      url = "https://github.com/WDaan/VueTorrent/releases/download/v${version}/vuetorrent.zip";
      sha256 = "sha256-Lw4lyzS9TtqHt/sf/4ZQD9GkqYXYc1R/96CyR4OogQE=";
    };

    installPhase = ''
      mkdir -p $out
      mv public $out
    '';
  };
}
