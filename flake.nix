{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-generators }:
    let
      # system = "x86_64-linux";
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
      home-module = {
        #nixpkgs.overlays = [self.overlays.default];
        nixpkgs.config.allowUnfree = true;
        home = rec {
          # username = "guillo0001";
          # homeDirectory = "/Users/${username}";
          username = "quentin";
          homeDirectory = "/home/${username}";
          stateVersion = "23.11";
        };
      };
    in {

      homeConfigurations = {
        quentin = home-manager.lib.homeManagerConfiguration rec {
          inherit pkgs;
          modules = [ home-module ./homes/quentin.nix ];
        };
      };

      nixosConfigurations = {
        # Configuration for my current working machine.
        kagel = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./deployments/kagel.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.quentin = import ./homes/quentin.nix;
            }
          ];
        };
        darwinVM = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./deployments/kagel.nix
            # self.nixosModules.base
            # self.nixosModules.vm
            {
              virtualisation.vmVariant.virtualisation.host.pkgs =
                nixpkgs.legacyPackages.aarch64-darwin;
            }
          ];
        };
      };
      packages.aarch64-darwin.darwinVM =
        self.nixosConfigurations.darwinVM.config.system.build.vm;

      devShells.${system} = {
        default = pkgs.mkShell {
          packages = with pkgs;
            [
              home-manager.packages.${system}.default

		nixos-generators.packages.${system}.default
            ];
        };
        qemu = pkgs.mkShell {
          packages = with pkgs;
            [
		pkgs.qemu

            ];
        };
      };

    };
}
