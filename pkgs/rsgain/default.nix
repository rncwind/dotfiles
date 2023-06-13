{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation rec {
  pname = "rsgain";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "complexlogic";
    repo = "rsgain";
    rev = "v${version}";
    sha256 = "sha256-jkSqWw7QL6j7nL/6hb0d1ewRcJD28ohHz2TlCWKdkAA=";
  };

  buildInputs = [
    pkgs.libebur128
    pkgs.taglib
    pkgs.ffmpeg
    pkgs.fmt
    pkgs.inih
    pkgs.cmake
    pkgs.pkgconfig
    pkgs.zlib
  ];

  buildPhase = ''
    cmake ./ -DCMAKE_BUILD_TYPE=Release
  '';
}
