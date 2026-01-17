{ lib
, stdenvNoCC
, fetchzip
, autoPatchelfHook
, makeWrapper
, gtk3
, glib
, pango
, cairo
, gdk-pixbuf
, atk
, at-spi2-atk
, at-spi2-core
, dbus
, libxkbcommon
, fontconfig
, freetype
, zlib
, nss
, nspr
, alsa-lib
, cups
, libGL
, libGLU
, libdrm
, mesa
, libpng
, libjpeg
, xorg
}:

stdenvNoCC.mkDerivation rec {
  pname = "nuclei-studio-ide";
  version = "2025.10";

  src = fetchzip {
    url = "https://download.nucleisys.com/upload/files/nucleistudio/NucleiStudio_IDE_202510-lin64.tgz";
    hash = "sha256-Iv+kwq47FL4WGZmXpZ3LWwUT3mF3ZqWjKG6NcB0BamM=";
    stripRoot = true;
  };

  sourceRoot = "NucleiStudio";

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [
    gtk3
    glib
    pango
    cairo
    gdk-pixbuf
    atk
    at-spi2-atk
    at-spi2-core
    dbus
    libxkbcommon
    fontconfig
    freetype
    zlib
    nss
    nspr
    alsa-lib
    cups
    libGL
    libGLU
    libdrm
    mesa
    libpng
    libjpeg
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXtst
    xorg.libXi
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXfixes
    xorg.libXdamage
    xorg.libXcomposite
    xorg.libXinerama
    xorg.libXss
    xorg.libxcb
    xorg.libSM
    xorg.libICE
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/nuclei-studio-ide
    cp -r . $out/opt/nuclei-studio-ide

    chmod +x $out/opt/nuclei-studio-ide/NucleiStudio

    mkdir -p $out/bin $out/share/applications $out/share/pixmaps
    ln -s $out/opt/nuclei-studio-ide/icon.xpm $out/share/pixmaps/nuclei-studio-ide.xpm

    makeWrapper $out/opt/nuclei-studio-ide/NucleiStudio $out/bin/nuclei-studio-ide \
      --chdir $out/opt/nuclei-studio-ide

    cat > $out/share/applications/nuclei-studio-ide.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=NucleiStudio IDE
Comment=Eclipse-based IDE for Nuclei RISC-V
Exec=nuclei-studio-ide
Icon=nuclei-studio-ide
Categories=Development;IDE;
Terminal=false
EOF

    runHook postInstall
  '';

  meta = with lib; {
    description = "Eclipse-based IDE for Nuclei RISC-V";
    homepage = "https://www.nucleisys.com/";
    license = licenses.unfree;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "nuclei-studio-ide";
  };
}
