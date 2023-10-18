{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    notashelf-vim.url = "github:notashelf/neovim-flake";
    notashelf-vim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    nixos-hardware,
    home-manager,
    alejandra,
    notashelf-vim,
    ...
  }: {
    nixosConfigurations = {
      phantom = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-t480
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users = {
              andreas = import ./users/andreas/home.nix;
              romy = import ./users/romy/home.nix;
            };
          }

          {
            environment.systemPackages = [
              alejandra.defaultPackage.x86_64-linux
              notashelf-vim.packages.x86_64-linux.default
            ];
          }
        ];
      };
    };
  };
}
