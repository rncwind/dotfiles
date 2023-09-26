{
  stdenv,
  lib,
  fetchzip,
  ...
}:
stdenv.mkDerivation
{
  pname = "kots";
  version = "1.102.0";
  src = fetchzip {
    url = "https://github.com/replicatedhq/kots/releases/download/v1.102.0/kots_linux_amd64.tar.gz";
    sha256 = "066lf5ihqp0gjd90irf6h22na8g29194wr9yqaxi8x4jlagx6b7j";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/bin
    mv kots $out/bin
  '';

  meta = with lib; {
    description = "Replicated KOTS";
    homepage = "https://kots.io/";
    license = licenses.asl20;
    maintainers = [];
    platforms = platforms.all;
  };
}
