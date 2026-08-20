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
        pkg-config
        llvmPackages.libclang
        util-linux.dev
      ]);
      profile = ''
        export LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib"
        export BINDGEN_EXTRA_CLANG_ARGS="-I/usr/include"
      '';
      runScript = "bash";
    };
  in {
    devShells.${system}.default = fhs.env;
  };
}
