{ config
, pkgs
, ...
}: {
  imports = [
    ./alacritty
    ./wezterm
  ];
}
