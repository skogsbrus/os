{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager/release-21.05";
  };

  outputs = { self, nixpkgs, neovim, home-manager, ... }:
  let
    overlays = [ neovim.overlay ];
  in
  {
    nixosConfigurations.voidm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./new.nix
        home-manager.nixosModules.home-manager {
          nixpkgs.overlays = overlays;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.johanan = { ... }: {
            imports = [
              ./home2.nix
            ];
          };
        }
      ];
    };
  };
}
