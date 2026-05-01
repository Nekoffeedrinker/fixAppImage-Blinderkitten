{pkgs ? import <nixpkgs> {}}:
pkgs.buildFHSEnv {
  name = "blinderkitten";

  targetPkgs = pkgs:
    with pkgs; [
      curlWithGnuTls
      glib
      zlib
      openssl
      stdenv.cc.cc.lib
      alsa-lib # libasound.so.2
      freetype # libfreetype.so.6
      mesa # libGL.so.1
      libglvnd # tambien libGL.so.1
      curlWithGnuTls # libcurl-gnutls.so.4
    ];

  runScript = "bash";
}
