{ stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "unstable-2023-11-22";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "material-symbols";
    rev = "main";
    sha256 = "0a9b8c7d6e5f4g3h2i1j0k9l8m7n6o5p4q3r2s1t0u9v8w7x6y5z4a3b2c1d0e9";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/fonts/opentype

    # 安装可变字体和静态字体
    cp -r fonts/variable/*.ttf $out/share/fonts/truetype/ 2>/dev/null || true
    cp -r fonts/static/*.ttf $out/share/fonts/truetype/ 2>/dev/null || true
    cp -r fonts/variable/*.otf $out/share/fonts/opentype/ 2>/dev/null || true
    cp -r fonts/static/*.otf $out/share/fonts/opentype/ 2>/dev/null || true

    # 如果在根目录下，也复制
    cp *.ttf $out/share/fonts/truetype/ 2>/dev/null || true
    cp *.otf $out/share/fonts/opentype/ 2>/dev/null || true
  '';

  meta = {
    description = "Material Symbols icons by Google";
    homepage = "https://github.com/googlefonts/material-symbols";
    license = stdenvNoCC.lib.licenses.ofl;
    platforms = stdenvNoCC.lib.platforms.all;
  };
}