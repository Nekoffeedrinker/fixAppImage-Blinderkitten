{pkgs ? import <nixpkgs> {}}:
pkgs.buildFHSEnv {
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
    export LD_LIBRARY_PATH=${pkgs.curlWithGnuTls}/lib:$LD_LIBRARY_PATH
    exec ${pkgs.appimage-run}/bin/appimage-run "$@"
  '';
}
