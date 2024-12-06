{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    generator.url = "github:xinux-org/generator";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
      generator,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Nix script formatter
        formatter = pkgs.nixfmt-rfc-style;

        # Development environment
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.brotli
            generator.packages.${system}.default
          ];
        };
      }
    );
}
