{
  stdenv,
  lib,
  fetchzip,
  ...
}:
stdenv.mkDerivation
{
  pname = "replicated-cli";
  version = "0.59.0";
  src = fetchzip {
    url = "https://github.com/replicatedhq/replicated/releases/download/v0.59.0/replicated_0.59.0_linux_amd64.tar.gz";
    sha256 = "0hy5dikw8ryw18xkqa3p4yb7x60dn7zb4rmkbfzr72121gz83fwx";
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
