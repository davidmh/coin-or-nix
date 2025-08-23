{
  description = "COIN-OR Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        coinutils = pkgs.stdenv.mkDerivation rec {
          pname = "coinutils";
          version = "master";
          name = "${pname}-${version}";
          src = pkgs.fetchFromGitHub {
            owner = "coin-or";
            repo = "CoinUtils";
            rev = "master";
            sha256 = "sha256-X03J/qvbP9YVlt+GQrS3rUIQl9ogumxyyBgcC7VV+ME=";
          };
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
        };

        osi = pkgs.stdenv.mkDerivation rec {
          pname = "osi";
          version = "master";
          name = "${pname}-${version}";
          src = pkgs.fetchFromGitHub {
            owner = "coin-or";
            repo = "Osi";
            rev = "master";
            sha256 = "sha256-X04kvwCO3vvRR6zxAKQuMSPtC0+HxWeKcU2sh7G8VX8=";
          };

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
        };

        clp = pkgs.stdenv.mkDerivation rec {
          pname = "clp";
          version = "master";
          name = "${pname}-${version}";
          src = pkgs.fetchFromGitHub {
            owner = "coin-or";
            repo = "Clp";
            rev = "master";
            sha256 = "sha256-JfV1KltH8VHNgPGqvWQtuD4XdZMUIih/zsuV+R9BNo8=";
          };

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
        };

        cgl = pkgs.stdenv.mkDerivation rec {
          pname = "cgl";
          version = "master";
          name = "${pname}-${version}";
          src = pkgs.fetchFromGitHub {
            owner = "coin-or";
            repo = "Cgl";
            rev = "master";
            sha256 = "sha256-R07DXqY3hH7NubsO0rYk7YnarEEinBDyQl1fD+A0Dkg=";
          };

          nativeBuildInputs = with pkgs; [
            updateAutotoolsGnuConfigScriptsHook
            pkg-config
          ];

          buildInputs = [ coinutils osi clp ];

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
        };

        cbc = pkgs.stdenv.mkDerivation rec {
          pname = "cbc";
          version = "master";
          name = "${pname}-${version}";
          src = pkgs.fetchFromGitHub {
            owner = "coin-or";
            repo = "Cbc";
            rev = "master";
            sha256 = "sha256-8Y6I57bUapOx8PBAzRey02/sH0YR98B74GZnmvl5Teg=";
          };

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
        };
      in
      {
        packages = {
          default = pkgs.symlinkJoin {
            name = "coin-or-nix";
            paths = [ cbc cgl clp osi coinutils ];
          };
          osi = osi;
          clp = clp;
          cgl = cgl;
          cbc = cbc;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ cbc cgl clp osi ];
        };
      });
}

