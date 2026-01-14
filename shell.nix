flake: {pkgs, ...}: let
  system = pkgs.hostPlatform.system;
  base = flake.packages.${system}.default;
in
  pkgs.mkShell {
    inputsFrom = [base];

    packages = with pkgs; [
      nixd
      statix
      deadnix
      alejandra

      shfmt
    ];

    shellHook = ''
      rm -rf result
    '';
  }
