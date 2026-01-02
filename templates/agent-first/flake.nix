{
  description = "Clawdis local";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-clawdis.url = "github:joshp123/nix-clawdis";
  };

  outputs = { self, nixpkgs, home-manager, nix-clawdis }:
    let
      system = "<system>";
      pkgs = import nixpkgs { inherit system; };
    in {
      homeManagerConfigurations.<user> = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nix-clawdis.homeManagerModules.clawdis
          {
            programs.clawdis = {
              enable = true;
              providers.telegram = {
                enable = true;
                botTokenFile = "<tokenPath>";
                allowFrom = [ <allowFrom> ];
              };
              routing.queue.mode = "interrupt";
            };
          }
        ];
      };
    };
}
