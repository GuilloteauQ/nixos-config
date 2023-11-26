{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
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
       };

      devShells.${system} = {
        default = pkgs.mkShell {
          packages = with pkgs; [

          ];
        };
      };

    };
}
