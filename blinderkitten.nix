{pkgs ? import <nixpkgs> {}}:
pkgs.buildFHSUserEnv {
  name = "blinderkitten-env";

  targetPkgs = pkgs:
    with pkgs; [
      curlWithGnuTls
      glib
      zlib
      openssl
      stdenv.cc.cc.lib
    ];

  runScript = ''
    ${pkgs.appimage-run}/bin/appimage-run "$@"
  '';
}
