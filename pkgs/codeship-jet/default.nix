#{ stdenv, pkgs, lib, fetchzip, ... }:
{ stdenv, lib, fetchzip, ... }:

stdenv.mkDerivation
{
  pname = "codeship-jet";
  version = "2.14.0";
  src = fetchzip {
    url = "https://s3.amazonaws.com/codeship-jet-releases/2.14.0/jet-linux_amd64_2.14.0.tar.gz";
    sha256 = "lngR+1xqaYr6g+GxWm7q9H81bzxP74yDRuzHkjz1jrc=";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv jet $out/bin
  '';

  meta = with lib; {
    description = "Codeship Jet";
    homepage = "https://docs.cloudbees.com/docs/cloudbees-codeship/latest/pro-jet-cli/";
    license = licenses.unfree;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
