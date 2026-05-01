{pkgs ? import <nixpkgs> {}}: let
  curl = pkgs.curlWithGnuTls.out;
in
  pkgs.buildFHSEnv {
    name = "blinderkitten";

    targetPkgs = pkgs:
      with pkgs; [
        curlWithGnuTls.out
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
      ];

    runScript = ''
      bash -c "export LD_LIBRARY_PATH=${curl}/lib:\$LD_LIBRARY_PATH; ./squashfs-root/AppRun"
    '';
  }
