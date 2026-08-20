{
  description = "Development enviroment for Terraos";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};

    fhs = pkgs.buildFHSEnv {
      name = "terraos-fhs";
      targetPkgs = pkgs: (with pkgs; [
        cargo
        rustc
        rustfmt
        rust-analyzer
        wget
        cpio
        unzip
        rsync
        bc
        clang
	file
	gcc13
	libxcrypt
	libxcrypt.dev
      ]);
      runScript = "bash";
    };
  in {
    devShells.${system}.default = fhs.env;
  };
}
