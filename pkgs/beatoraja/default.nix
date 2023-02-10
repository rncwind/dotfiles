{ lib, pkgs, stdenv, fetchzip, variant }:

stdenv.mkDerivation rec {
  pname = "beatoraja";
  version = "0.8.4";

  src = fetchzip {
    url = "https://mocha-repository.info/download/beatoraja${version}${variant}.zip";
    sha256 = "sha256-Ec+wSqj69UU1u+6+AVbW/b3o68ZrDouE/h5UCWMyKnk=";
  };

  buildInputs = [
    pkgs.jetbrains.jdk
  ];

  installPhase = ''
    rm beatoraja-config.bat
    rm beatoraja-config.command
    mkdir -p $out/bin
    mv ./* $out/bin
  '';
}
