# sources for lua dev
# https://luals.github.io/#install
# https://github.com/LuaLS/lua-language-server
# https://www.chiarulli.me/Neovim/28-neovim-lua-development/

{ config, pkgs, nixvim, lib, ... }:
{
  imports = [
    ./helix
    ./nixvim
  ];
}
