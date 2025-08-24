{ input, stdenv, pkgs, coinutils, osi, cgl, clp }:

stdenv.mkDerivation rec {
  pname = "cbc";
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
    cgl
    clp
  ];

  configureFlags = [
    "--enable-shared"
    "--with-blas"
    "--with-lapack"
  ];

  enableParallelBuilding = true;

  meta = with pkgs.lib; {
    description = "COIN-OR Branch-and-Cut Mixed Integer Programming Solver";
    homepage = "https://github.com/coin-or/Cbc";
    license = licenses.epl20;
    platforms = platforms.unix;
  };
}
