{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    generator.url = "github:xinux-org/generator";
  };

  outputs = { self, nixpkgs, utils, generator }:
    utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; {
        devShells.default = mkShell {
          packages = [
            brotli
            generator.defaultPackage.${system}
          ];
        };
      });
}
