{
  stdenv,
  fetchzip,
}: {
  vuetorrent = stdenv.mkDerivation rec {
    pname = "vuetorrent";
    version = "2.30.1";
    dontBuild = true;
    src = fetchzip {
      url = "https://github.com/WDaan/VueTorrent/releases/download/v${version}/vuetorrent.zip";
      sha256 = "1s7qi15gj5k2x6m3wnkl32c7mb9kdv7vrmmwm0vl45va8gfxzz6y";
    };

    installPhase = ''
      mkdir -p $out
      mv public $out
    '';
  };
}
