{ stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "hugmetight-font";
  version = "unstable-2023-11-22";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "HugMeTight";
    rev = "main";
    sha256 = "1i5q8d3n4h2p9f6c3a7k8j0x2y5u4r9t8w7e6v5s1b2n0m9l8k7j6h5g4f3d2c1";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/fonts/opentype

    # 安装 TTF 文件
    cp -r fonts/ttf/*.ttf $out/share/fonts/truetype/ || true
    # 安装 OTF 文件
    cp -r fonts/otf/*.otf $out/share/fonts/opentype/ || true
    # 如果在根目录下，也复制
    cp *.ttf $out/share/fonts/truetype/ 2>/dev/null || true
    cp *.otf $out/share/fonts/opentype/ 2>/dev/null || true
  '';

  meta = {
    description = "Hug Me Tight font family";
    homepage = "https://github.com/EliverLara/HugMeTight";
    license = stdenvNoCC.lib.licenses.ofl;
    platforms = stdenvNoCC.lib.platforms.all;
  };
}