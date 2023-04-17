{
  nixConfig = {
    extra-substituters = [
      "https://cache.iog.io"
      "https://cache.zw3rk.com"
    ];
    extra-trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk="
    ];
    allow-import-from-derivation = true;
  };

  inputs.plutus.url = "github:input-output-hk/plutus";

  outputs = inps':
    let
      inps = inps'.plutus.inputs;
      system = "x86_64-linux";
      pkgs = import inps.nixpkgs {
        inherit system;
        overlays = [
          inps.haskell-nix.overlay
          (import "${inps.iohk-nix}/overlays/crypto")
        ];
      };
      project = pkgs.haskell-nix.cabalProject' {
        src = ./.;
        compiler-nix-name = "ghc925"; # sync with https://github.com/input-output-hk/plutus/blob/master/nix/cells/plutus/library/ghc-compiler-nix-name.nix#L2
        inputMap = { "https://input-output-hk.github.io/cardano-haskell-packages" = inps.CHaP; };
        modules = [{
          packages = {
            cardano-crypto-class.components.library.pkgconfig = pkgs.lib.mkForce [ [ pkgs.libsodium-vrf pkgs.secp256k1 ] ];
            cardano-crypto-praos.components.library.pkgconfig = pkgs.lib.mkForce [ [ pkgs.libsodium-vrf ] ];
          };
        }];
        shell = {
          exactDeps = true;
          withHoogle = false;
          nativeBuildInputs = [ pkgs.cabal-install ];
        };
      };
      flk = project.flake {};
    in {
      legacyPackages.x86_64-linux = pkgs;
      packages.${system} = flk.packages // { default = flk.packages."reward:exe:create-sc"; };
      devShells.${system}.default = flk.devShell;
    };
}
