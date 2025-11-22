{ stdenvNoCC, fetchurl, unzip }:

stdenvNoCC.mkDerivation {
  pname = "kose-font";
  version = "unstable-2023-11-22";

  src = fetchurl {
    url = "https://github.com/Biro-Biro/Font-Kose/releases/download/v1.0.0/kose-font.zip";
    sha256 = "0z9g7yf0r3n7h2h6v2d8x9a5y8q4m6k4f4l0c5d9b3e2r1t2y7u8i9o0p1q2";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src -d font
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp font/*.ttf $out/share/fonts/truetype/
    cp font/*.otf $out/share/fonts/truetype/ || true
  '';

  meta = {
    description = "Kose font family";
    homepage = "https://github.com/Biro-Biro/Font-Kose";
    license = stdenvNoCC.lib.licenses.ofl;
    platforms = stdenvNoCC.lib.platforms.all;
  };
}