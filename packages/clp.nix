{ input, stdenv, pkgs, coinutils, osi }:

stdenv.mkDerivation rec {
  pname = "clp";
  name = "${pname}-git";
  src = input;

  nativeBuildInputs = with pkgs; [
    updateAutotoolsGnuConfigScriptsHook
    pkg-config
  ];

  buildInputs = with pkgs; [
    zlib
    blas
    lapack
    coinutils
    osi
  ];

  configureFlags = [
    "--enable-shared"
    "--with-blas"
    "--with-lapack"
  ];

  enableParallelBuilding = true;

  meta = with pkgs.lib; {
    description = "COIN-OR Linear Programming Solver";
    homepage = "https://github.com/coin-or/Clp";
    license = licenses.epl20;
    platforms = platforms.unix;
  };
}
