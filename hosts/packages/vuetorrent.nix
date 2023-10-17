{
  stdenv,
  fetchzip,
}: {
  vuetorrent = stdenv.mkDerivation rec {
    pname = "vuetorrent";
    version = "1.8.0";
    dontBuild = true;
    src = fetchzip {
      url = "https://github.com/WDaan/VueTorrent/releases/download/v${version}/vuetorrent.zip";
      sha256 = "sha256-ZXuHJYieIX+yzwrBQ+Ck/MOnG7DKkBjDwbtAncA2CNU=";
    };

    installPhase = ''
      mkdir -p $out
      mv public $out
    '';
  };
}
