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

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    nixpkgs,
    nixos-hardware,
    home-manager,
    sops-nix,
    alejandra,
    notashelf-vim,
    nix-colors,
    ...
  }: {
    nixosConfigurations = {
      phantom = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit sops-nix;};
        system = "x86_64-linux";
        modules = [
          ./system/configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-t480

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users = {
                andreas = import ./users/andreas/home.nix;
                romy = import ./users/romy/home.nix;
              };
              extraSpecialArgs = {inherit nix-colors;};
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
