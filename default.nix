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
    
    # Python and Jupyter for mybinder
    python3Packages.jupyterlab
    
    # Additional tools
    git
  ];
}
