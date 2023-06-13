final: prev: {
  codeship-jet = prev.callPackage ./codeship-jet {};
  rsgain = prev.callPackage ./rsgain {};
  #beatoraja = prev.callPackage ./beatoraja { variant = "-modernchic"; };
}
