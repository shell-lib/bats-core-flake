{
  description = "Bash Automated Testing System";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ...}:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {inherit system; };        
      in rec {
        bats-core = pkgs.stdenv.mkDerivation {
          name = "bats-core";
          src = pkgs.fetchgit {
            url = "https://github.com/bats-core/bats-core.git";
            rev = "v1.7.0";
            sha256 = "sha256-joNne/dDVCNtzdTQ64rK8GimT+DOWUa7f410hml2s8Q=";
          };

          buildInputs = [];

          installPhase = ''
            mkdir -p $out
            # /usr/bin/env from the install script's shebang ('#!/usr/bin/env bash') is not avaliable during the install step.
            # I know nix breaks FHS, but I thought that /usr/bin/env would be on the path, but its not.
            # We need to remove the script's shebang and run under bash
            sed -i "1d" ./install.sh
            bash ./install.sh $out
          '';
        };
        packages = {default = bats-core;};
      });
    
}
