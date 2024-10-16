## Developing 
You can use [Nix](https://nixos.org/download/#download-nix) package manager to install the required packages.
Or you an install by yourself:
- Gnumake
- Lua
- Luarocks

### Nix
```bash
nix develop .
```

### Luarocks
Remember to set local by default
```bash 
luarocks config local_by_default true
```
To install:
```bash
luarocks make --tree lua_modules
```

It's going to install:
- Plenary.nvim

## Running tests
```bash
make test
```

### Format this repository code
We are using:
- Stylua
