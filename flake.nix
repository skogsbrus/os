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
          ./hosts/lenovo-p1.nix
          ./sys/work.nix
          ./sys/client.nix
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
          ./hosts/workstation.nix
          ./sys/client.nix
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
          ./hosts/router.nix
          ./sys/router.nix
          ./sys/server.nix
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
