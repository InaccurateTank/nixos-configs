{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  ...
}: buildNpmPackage rec {
  pname = "phocus-gtk";
  version = "unstable-2024-19-3";

  src = fetchFromGitHub {
    owner = "phocus";
    repo = "gtk";
    rev = "d77ea24";
    hash = "sha256-RvqcjJmz354ukKJhgYP/A5Dn1urt20L+LKbRk0C8Nhs=";
  };

  npmDepsHash = "sha256-PEXClnWZHmO3pdES6QcAGXBUhBklsdFqz1LjnFMtcs4=";

  installPhase = ''
    runHook preInstall
    install -D -t $out/share/themes/phocus-gtk/ index.theme
    mv assets $out/share/themes/phocus-gtk
    mv gtk-3.0 $out/share/themes/phocus-gtk
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/phocus/gtk";
    description = "Part of the Phocus theme collection.";
    license = licenses.mit;
  };
}
