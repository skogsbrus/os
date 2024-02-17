{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager, darwin, agenix }:
  let
      skogsbrus = import ./lib { inherit nixpkgs; };
  in
    {
      nixosConfigurations = {
        keeper = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit
              agenix
              skogsbrus
              unstable;
          };
          modules = [
            ./hosts/keeper
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.johanan = { ... }: {
                _module.args.unstable = unstable;
                imports = [ ./hosts/keeper/home.nix ];
              };
            }
          ];
        };
        router = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit agenix;
          };
          modules = [
            ./hosts/router
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.johanan = { ... }: {
                _module.args.unstable = unstable;
                imports = [ ./hosts/router/home.nix ];
              };
            }
          ];
        };
        void0 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/void0
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.johanan = { ... }: {
                _module.args.unstable = unstable;
                imports = [ ./hosts/void0/home.nix ];
              };
            }
          ];
        };
        vm-airm2 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit
              agenix
              skogsbrus
              unstable;
          };
          modules = [
            ./hosts/vm-airm2
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.johanan = { ... }: {
                _module.args.unstable = unstable;
                imports = [ ./hosts/vm-airm2/home.nix ];
              };
            }
          ];
        };
        vm-prom2 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit
              agenix
              skogsbrus
              unstable;
          };
          modules = [
            ./hosts/vm-prom2
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.johanan = { ... }: {
                _module.args.unstable = unstable;
                imports = [ ./hosts/vm-prom2/home.nix ];
              };
            }
          ];
        };
        workstation = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/workstation
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.johanan = { ... }: {
                _module.args.unstable = unstable;
                imports = [ ./hosts/workstation/home.nix ];
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        airm2 = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/airm2
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.johanan = { ... }: {
                _module.args.unstable = unstable;
                imports = [ ./hosts/airm2/home.nix ];
              };
            }
          ];
        };
        JOHANAN-M-1H6F = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/prom2
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.johanan = { ... }: {
                _module.args.unstable = unstable;
                imports = [ ./hosts/prom2/home.nix ];
              };
            }
          ];
        };
      };
    };
}

