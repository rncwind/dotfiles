
{
  stdenv,
  lib,
  fetchzip,
  ...
}:
stdenv.mkDerivation
{
  pname = "replicated-cli";
  version = "0.57.0";
  src = fetchzip {
    url = "https://github.com/replicatedhq/replicated/releases/download/v0.57.0/replicated_0.57.0_linux_amd64.tar.gz";
    sha256 = "0kvmlbrjzgskk09vka77h2i7yvcw445fwy6rk1zn0xlbgpgcfis2";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/bin
    mv replicated $out/bin
  '';

  meta = with lib; {
    description = "Replicated CLI";
    homepage = "https://www.replicated.com/";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
