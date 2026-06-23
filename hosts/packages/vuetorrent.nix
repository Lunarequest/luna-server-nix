{
  stdenv,
  fetchzip,
}: {
  vuetorrent = stdenv.mkDerivation rec {
    pname = "vuetorrent";
    version = "2.34.0";
    dontBuild = true;
    src = fetchzip {
      url = "https://github.com/WDaan/VueTorrent/releases/download/v${version}/vuetorrent.zip";
      sha256 = "1s90izqfjimwhi04y8q8j4sv6pxc59gxpwrchp4mw23cxphcvm1j";
    };

    installPhase = ''
      mkdir -p $out
      mv public $out
    '';
  };
}
