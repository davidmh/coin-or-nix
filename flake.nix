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

        osi = pkgs.stdenv.mkDerivation rec {
          pname = "osi";
          version = "0.108.11";

          src = pkgs.fetchFromGitHub {
            owner = "coin-or";
            repo = "Osi";
            rev = "releases/${version}";
            sha256 = "sha256-3aTO7JGEOP/RCOZ1X9b68rrtv6T78euf1TYGTjyXSRE=";
          };

          nativeBuildInputs = with pkgs; [
            updateAutotoolsGnuConfigScriptsHook
            pkg-config
          ];

          buildInputs = with pkgs; [
            coin-utils
          ];

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
          version = "1.17.10";

          src = pkgs.fetchFromGitHub {
            owner = "coin-or";
            repo = "Clp";
            rev = "releases/${version}";
            sha256 = "sha256-9IlBT6o1aHAaYw2/39XrUis72P9fesmG3B6i/e+v3mM=";
          };

          nativeBuildInputs = with pkgs; [
            updateAutotoolsGnuConfigScriptsHook
            pkg-config
          ];

          buildInputs = with pkgs; [
            zlib
            blas
            lapack
            coin-utils
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
          version = "0.60.9";

          src = pkgs.fetchFromGitHub {
            owner = "coin-or";
            repo = "Cgl";
            rev = "releases/${version}";
            sha256 = "sha256-E84yCrgpRMjt7owPLPk1ATW+aeHNw8V24DHgkb6boIE=";
          };

          nativeBuildInputs = with pkgs; [
            updateAutotoolsGnuConfigScriptsHook
            pkg-config
          ];

          buildInputs = with pkgs; [
            coin-utils
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
        };

        cbc = pkgs.stdenv.mkDerivation rec {
          pname = "cbc";
          version = "2.10.12";

          src = pkgs.fetchFromGitHub {
            owner = "coin-or";
            repo = "Cbc";
            rev = "releases/${version}";
            sha256 = "sha256-0Sz4/7CRKrArIUy/XxGIP7WMmICqDJ0VxZo62thChYQ=";
          };

          nativeBuildInputs = with pkgs; [
            updateAutotoolsGnuConfigScriptsHook
            pkg-config
          ];

          buildInputs = with pkgs; [
            zlib
            blas
            lapack
            coin-utils
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
            paths = [ cbc clp ];
          };
          osi = osi;
          clp = clp;
          cgl = cgl;
          cbc = cbc;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ cbc clp ];
        };
      });
}

