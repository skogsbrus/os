{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
  };

  outputs = { self, nixpkgs,  home-manager, ... }:
  {
    nixosConfigurations.voidm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./new.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.johanan = { ... }: {
            imports = [
              ./home2.nix
              ./neovim.nix
            ];
          };
        }
      ];
    };
  };
}
