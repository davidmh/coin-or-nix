{ input, stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "coinutils";
  name = "${pname}-git";
  src = input;
  nativeBuildInputs = with pkgs; [
    updateAutotoolsGnuConfigScriptsHook
    pkg-config
  ];
  configureFlags = [
    "--enable-shared"
  ];
  enableParallelBuilding = true;
  meta = with pkgs.lib; {
    description = "COIN-OR Utilities";
    homepage = "https://github.com/coin-or/CoinUtils";
    license = licenses.epl20;
    platforms = platforms.unix;
  };
}
