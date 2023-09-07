final: prev: {
  codeship-jet = prev.callPackage ./codeship-jet {};
  rsgain = prev.callPackage ./rsgain {};
  kots = prev.callPackage ./kots {};
  replicated-cli = prev.callPackage ./replicated-cli {};
}
