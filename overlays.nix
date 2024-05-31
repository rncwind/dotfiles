self: super: {
  bambu-studio = super.bambu-studio.overrideAttrs (old: rec {
    name = "bambu-studio";
    version = "1.8.3";
    src = super.fetchFromGitHub {
      owner = "bambulab";
      repo = "BambuStudio";
      rev = "v${version}";
      hash = "sha256-RBctBhKo7mjxsP7OJhGfoU1eIiGVuMiAqwwSU+gsMds=";
    };
  });
}
