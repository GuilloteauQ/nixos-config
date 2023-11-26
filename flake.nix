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
      home-module = {
        home = rec {
          username = "quentin";
          homeDirectory = "/home/${username}";
          stateVersion = "23.05";
        };
      };
    in
    {
      homeConfigurations = {
        quentin = home-manager.lib.homeManagerConfiguration rec {
          inherit pkgs;
          modules = [
            home-module
            ./homes/quentin.nix
          ];
        };
      };

       nixosConfigurations = {
        # Configuration for my current working machine.
        kagel = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./deployments/kagel.nix
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
