# A customized build of adw3-gtk3 using the https://horizontheme.netlify.app/ color scheme
{
  lib,
  stdenvNoCC,
  adw-gtk3,
  ...
}: stdenvNoCC.mkDerivation rec {
  pname = "adw-gtk3-horizon";
  version = adw-gtk3.version;

  src = ./.;

  installPhase = ''
    mkdir -p $out/share/themes
    cp -rs --no-preserve=mode ${adw-gtk3}/share/themes/adw-gtk3-dark $out/share/themes/adw-gtk3-horizon
    install ./gtk3.css $out/share/themes/adw-gtk3-horizon/gtk-3.0/gtk.css
    install ./gtk3.css $out/share/themes/adw-gtk3-horizon/gtk-3.0/gtk-dark.css
    install ./gtk4.css $out/share/themes/adw-gtk3-horizon/gtk-4.0/gtk.css
    install ./gtk4.css $out/share/themes/adw-gtk3-horizon/gtk-4.0/gtk-dark.css
    install ./index.theme $out/share/themes/adw-gtk3-horizon/index.theme
  '';

  meta = with lib; {
    homepage = "https://github.com/lassekongo83/adw-gtk3";
    description = "Personal horizon recolor of the adw-gtk3 theme.";
    license = licenses.lgpl2Only;
  };
}
