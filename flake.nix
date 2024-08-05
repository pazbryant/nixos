{
 description = "Bryant Flake";

 inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  home-manager.url = "github:nix-community/home-manager/release-24.05";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";

  # st terminal
  st.url = "github:pazbryant/st";
  st.inputs.nixpkgs.follows = "nixpkgs-unstable";
 };

 outputs = {
  self, 
  nixpkgs, 
  nixpkgs-unstable, 
  home-manager,
  st,
  ...
 }:
 let 
  lib = nixpkgs.lib;
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
  st-pkgs = st.packages.${system};
 in {
  nixosConfigurations = {
   nixos = lib.nixosSystem {
    inherit system;
    modules = [ ./configuration.nix ];
    specialArgs = {
     inherit pkgs-unstable;
    };
   };
  };

  homeConfigurations = {
   bryant = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [ 
     ./home.nix
    ];
    extraSpecialArgs = {
     inherit pkgs-unstable;
     inherit st-pkgs;
    };
   };
  };
 };
}
