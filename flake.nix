{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    notashelf-vim.url = "github:notashelf/neovim-flake";
    notashelf-vim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    nixos-hardware,
    home-manager,
    sops-nix,
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

          sops-nix.nixosModules.sops

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users = {
                andreas = {
                  imports = [(import ./users/andreas/home.nix)];
                };
                romy = import ./users/romy/home.nix;
              };
            };

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
