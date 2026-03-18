{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.buildGoModule {
          pname = "engram";
          version = "1.9.1";

          src = pkgs.fetchFromGitHub {
            owner = "Gentleman-Programming";
            repo = "engram";
            rev = "v1.9.1";
            sha256 = "sha256-mHqKsK0tSkgldxBfJFzF8k7aBOdUcsUmklB2IrJpC6I=";
          };

          vendorHash = "sha256-AA5yR6Pb3NeXNRel+ypowPAp/Xk2nzbd+dqvKKkt+JU=";

          doCheck = false; # skip integration tests that require Docker

          ldflags = [
            "-X main.version=v1.9.1"
          ];

          meta = {
            description = "Engram Persistent Memory for AI.";
            homepage = "https://github.com/Gentleman-Programming/engram";
            license = "MIT";
            mainProgram = "engram";
          };
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/engram";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            go
            git
          ];
        };
      }
    );
}
