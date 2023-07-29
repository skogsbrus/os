{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
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
        voidm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/voidm
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.johanan = { ... }: {
                _module.args.unstable = unstable;
                imports = [ ./hosts/voidm/home.nix ];
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
        airm2_vm = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit
              agenix
              skogsbrus
              unstable;
          };
          modules = [
            ./hosts/airm2_vm
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.johanan = { ... }: {
                _module.args.unstable = unstable;
                imports = [ ./hosts/airm2_vm/home.nix ];
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
      };
    };
}

