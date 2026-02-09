{pkgs, ...}: let
  inherit (pkgs) lib;
in
  pkgs.writeShellApplication {
    name = "database.sh";

    runtimeInputs = with pkgs; [
      brotli
      xinux-generator
    ];

    text = ''
      sleep $((RANDOM % 60))

      cat versions | while IFS= read -r Line
      do
        PREV_VERSION=$(cat "$Line/nixpkgs.ver")
        RUST_LOG=generator=trace nix develop --command -- generator -v "$Line" --src "$Line" 1>&2
        NEW_VERSION=$(cat "$Line/nixpkgs.ver")
        if [ "$PREV_VERSION" != "$NEW_VERSION" ]; then
          if [ -f "$Line/nixpkgs.db" ]; then
            brotli "./$Line/nixpkgs.db" -o "./$Line/nixpkgs.db.br" -v -f 1>&2
          fi
          if [ -f "$Line/nixpkgs_versions.db" ]; then
            brotli "./$Line/nixpkgs_versions.db" -o "./$Line/nixpkgs_versions.db.br" -v -f 1>&2
          fi
        fi
      done
    '';

    meta = {
      maintainers = with lib.maintainers; [orzklv];
    };
  }
