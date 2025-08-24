{ input, stdenv, pkgs, coinutils }:

stdenv.mkDerivation rec {
  pname = "osi";
  name = "${pname}-git";
  src = input;

  nativeBuildInputs = with pkgs; [
    updateAutotoolsGnuConfigScriptsHook
    pkg-config
  ];

  buildInputs = [ coinutils ];

  configureFlags = [
    "--enable-shared"
  ];

  enableParallelBuilding = true;

  meta = with pkgs.lib; {
    description = "COIN-OR Open Solver Interface";
    homepage = "https://github.com/coin-or/Osi";
    license = licenses.epl20;
    platforms = platforms.unix;
  };
}
