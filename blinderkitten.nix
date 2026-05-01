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
    ];

  runScript = ''
    exec ./squashfs-root/AppRun
  '';
}
