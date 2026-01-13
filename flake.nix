{
  inputs = {
    # Stable for keeping thins clean
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Fresh and new for testing
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # The flake-parts library
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Generator for database generation
    generator.url = "github:xinux-org/generator";
  };

  outputs = {
    self,
    flake-parts,
    generator,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem = {
        pkgs,
        system,
        ...
      }: {
        # Overlay for pkgs
        _module.args.pkgs = import self.inputs.nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              xinux-generator = generator.packages.${system}.default;
            })
          ];
          config.allowUnfree = true;
        };

        # Nix script formatter
        formatter = pkgs.alejandra;

        # Development environment
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            brotli
            xinux-generator
          ];
        };
      };
    });
}
