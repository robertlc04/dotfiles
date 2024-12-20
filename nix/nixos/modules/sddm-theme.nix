{pkgs}:

let
  imgLink = "https://raw.githubusercontent.com/robertlc04/dotfiles/main/config/swww/light/samurai_strike.jpg";
  img = pkgs.fetchurl {
    url = imgLink;
    sha256 = "sha256-Jk4WKUBhXq/PyvcXSdJtoICTh/x+K9OSXh1PwrKdCWI=";
  };
in
  pkgs.stdenv.mkDerivation {
    name = "sddm-theme";
    src = pkgs.fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
      sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
    };
    installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out
    rm Background.jpg
    cp -r ${img} $out/Background.jpg
   '';
}
