{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ... }:
  {
    nixosConfigurations.voidm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # system level configs
        ./default.nix
        ./sys/sound.nix
        ./sys/tmux.nix
        ./sys/steam.nix
        ./sys/zsh.nix
        ./sys/xserver.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.johanan = { ... }: {
            _module.args.unstable = unstable;
            imports = [
              # Configs managed by home-manager
              ./home/packages.nix
              ./home/dconf.nix
              ./home/gnome.nix
              ./home/neovim.nix
            ];
          };
        }
      ];
    };
  };
}
