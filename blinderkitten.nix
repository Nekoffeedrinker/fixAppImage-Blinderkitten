{pkgs ? import <nixpkgs> {}}: let
  oldPkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/23.11.tar.gz";
  }) {};

  curl = oldPkgs.curlWithGnuTls;
in
  pkgs.buildFHSEnv {
    name = "blinderkitten";

    targetPkgs = pkgs: [
      curl
      pkgs.glib
      pkgs.zlib
      pkgs.openssl
      pkgs.stdenv.cc.cc.lib
      pkgs.alsa-lib
      pkgs.freetype
      pkgs.mesa
      pkgs.libglvnd
      pkgs.avahi
    ];

    extraOutputsToInstall = ["lib"];

    runScript = ''
      ./squashfs-root/AppRun
    '';
  }
