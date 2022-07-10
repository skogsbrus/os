{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }:
  {
    nixosConfigurations = {
      voidm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/voidm
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.johanan = { ... }: {
              _module.args.unstable = unstable;
              imports = [ ./home ];
            };
          }
        ];
      };
      workstation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/workstation
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.johanan = { ... }: {
              _module.args.unstable = unstable;
              imports = [ ./home ];
            };
          }
        ];
      };
      router = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/router
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.johanan = { ... }: {
              _module.args.unstable = unstable;
              imports = [
                ./home/core.nix
                ./home/lsp.nix
                ./home/neovim.nix
              ];
            };
          }
        ];
      };
    };
  };
}
