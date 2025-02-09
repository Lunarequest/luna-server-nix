{
  stdenv,
  fetchzip,
}: {
  vuetorrent = stdenv.mkDerivation rec {
    pname = "vuetorrent";
    version = "2.14.1";
    dontBuild = true;
    src = fetchzip {
      url = "https://github.com/WDaan/VueTorrent/releases/download/v${version}/vuetorrent.zip";
      sha256 = "sha256-qs/muP+eIh43rekffEMSoyOT3d6rOINMH3oOBcqfjT8=";
    };

    installPhase = ''
      mkdir -p $out
      mv public $out
    '';
  };
}
