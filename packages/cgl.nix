{ input, stdenv, pkgs, coinutils, osi, clp }:

stdenv.mkDerivation rec {
  pname = "cgl";
  name = "${pname}-git";
  src = input;

  nativeBuildInputs = with pkgs; [
    updateAutotoolsGnuConfigScriptsHook
    pkg-config
  ];

  buildInputs = [
    coinutils
    osi
    clp
  ];

  configureFlags = [
    "--enable-shared"
  ];

  enableParallelBuilding = true;

  meta = with pkgs.lib; {
    description = "COIN-OR Cut Generation Library";
    homepage = "https://github.com/coin-or/Cgl";
    license = licenses.epl20;
    platforms = platforms.unix;
  };
}
