{
  description = "basic flake-utils";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixos-generators = {
    url = "github:nix-community/nixos-generators";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, nixos-generators, ... }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };


        in
        {

          packages.default = nixos-generators.nixosGenerate {
            system = "i686-linux";
            format = "raw";

            modules = [
              {
                # boot.kernelParams = [ "console=COM1" ];
                # https://discourse.nixos.org/t/creating-nixos-iso-for-an-older-laptop-with-i686-32bit/26002/2
                nixpkgs.hostPlatform.system = "i686-linux";
                users.users.alice = {
                  isNormalUser = true;
                  extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
                };
                # allow sudo without password for wheel
                security.sudo.wheelNeedsPassword = false;
              }
            ];
          };
        })
    );
}
