{pkgs ? import <nixpkgs> {}}: let
  oldPkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/23.11.tar.gz";
  }) {};

  curl = oldPkgs.curlWithGnuTls.out;
in
  pkgs.buildFHSEnv {
    name = "blinderkitten";

    targetPkgs = pkgs:
      [curl]
      ++ (with pkgs; [
        glib
        zlib
        openssl
        stdenv.cc.cc.lib
        alsa-lib # libasound.so.2
        freetype # libfreetype.so.6
        mesa # libGL.so.1
        libglvnd # tambien libGL.so.1
        curlWithGnuTls # libcurl-gnutls.so.4
        avahi # libavahi-common.so.3

        # Usarlo sin extraer
        appimage-run
        squashfsTools
      ]);

    extraOutputsToInstall = ["lib"];

    runScript = ''
      bash -c '
        export LD_LIBRARY_PATH=${curl}/lib:$LD_LIBRARY_PATH
        APPIMAGE="$1"
        EXTRACT_DIR="$(dirname "$APPIMAGE")/squashfs-root"
        if [ ! -d "$EXTRACT_DIR" ]; then
          unsquashfs -o 944632 -d "$EXTRACT_DIR" "$APPIMAGE"
        fi
        exec "$EXTRACT_DIR/AppRun" 2>/dev/null
      ' -- "$@"
    '';
  }
