{ pkgs ? import <nixpkgs> {
    config.allowUnfree = true;
    config.ihaskell.packages = ps: with ps; [
      hasktorch
      HList
      ihaskell-hvega
    ];
    config.allowBroken = true;
  }
}:

let
  ghcWithHasktorch = pkgs.haskellPackages.ghcWithPackages (ps: with ps; [
    hasktorch
    haskell-language-server
    HList
  ]);
in

pkgs.mkShell {
  buildInputs = with pkgs; [
    #ghcWithHasktorch
    cabal-install
    stack
    ihaskell
    libtorch-bin
    
    # Python and Jupyter for mybinder
    python3Packages.jupyter
    python3Packages.notebook
    
    # Additional tools
    git
  ];

  shellHook = ''
    echo "Hasktorch Binder Environment"
    echo "============================"
    echo "GHC version: $(ghc --version)"
    echo "Cabal version: $(cabal --version | head -n1)"
    echo ""
    echo "To start Jupyter with IHaskell:"
    echo "  jupyter notebook"
    echo ""
    
    # Export library paths for libtorch
    export LD_LIBRARY_PATH=${pkgs.libtorch-bin}/lib:$LD_LIBRARY_PATH
    export LIBTORCH=${pkgs.libtorch-bin}
  '';
}
