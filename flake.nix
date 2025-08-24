{
  description = "COIN-OR Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";

    # last fetched on 2025-08-24
    coinutils-src = { url = "github:coin-or/CoinUtils"; flake = false; };
    osi-src = { url = "github:coin-or/Osi"; flake = false; };
    clp-src = { url = "github:coin-or/Clp"; flake = false; };
    cgl-src = { url = "github:coin-or/Cgl"; flake = false; };
    cbc-src = { url = "github:coin-or/Cbc"; flake = false; };
  };

  outputs = { self, nixpkgs, coinutils-src, osi-src, clp-src, cgl-src, cbc-src }:
    let
      systems = [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];
      perSystem = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          coinutils = pkgs.callPackage ./packages/coinutils.nix { input = coinutils-src; };
          osi = pkgs.callPackage ./packages/osi.nix {
            input = osi-src;
            coinutils = coinutils;
          };
          clp = pkgs.callPackage ./packages/clp.nix {
            input = clp-src;
            coinutils = coinutils;
            osi = osi;
          };
          cgl = pkgs.callPackage ./packages/cgl.nix {
            input = cgl-src;
            coinutils = coinutils;
            osi = osi;
            clp = clp;
          };
          cbc = pkgs.callPackage ./packages/cbc.nix {
            input = cbc-src;
            coinutils = coinutils;
            osi = osi;
            cgl = cgl;
            clp = clp;
          };
        in
        {
          packages = {
            default = pkgs.symlinkJoin {
              name = "coin-or-nix";
              paths = [ cbc cgl clp osi coinutils ];
            };
            coinutils = coinutils;
            osi = osi;
            clp = clp;
            cgl = cgl;
            cbc = cbc;
          };
          devShell = pkgs.mkShell {
            buildInputs = [ cbc cgl clp osi coinutils ];
          };
        };
    in
    {
      packages = builtins.listToAttrs (map
        (system: {
          name = system;
          value = (perSystem system).packages;
        })
        systems);
      devShells = builtins.listToAttrs (map
        (system: {
          name = system;
          value = { default = (perSystem system).devShell; };
        })
        systems);
    };
}
