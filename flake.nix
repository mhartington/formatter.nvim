{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import (inputs.nixpkgs) { inherit system; });
      in {
        devShell = pkgs.mkShell {
          buildInputs=[
              pkgs.lua
              pkgs.luajitPackages.luarocks
          ];
          shellHook = ''
            LUA_PATH='lua_modules/share/lua/5.1/?.lua;lua_modules/share/lua/5.1/?/init.lua;;' 
            LUA_CPATH='lua_modules/lib/lua/5.1/?.so'
          '';
        };
      }
    );
}
