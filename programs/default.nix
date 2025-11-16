{ config
, pkgs
, lib
, ...
}:
let
  funcs = import ../functions.nix { inherit config lib pkgs; };
  nixPkgs = with pkgs; [
    nixpkgs-fmt
    nixfmt-rfc-style
    any-nix-shell
  ];
  # The ones I can't live without
  mandatoryPkgs = with pkgs; [
    coreutils
    curl
    jq
    fd
    neovim
    ripgrep
    tree
    wget
  ];
  # The "k8s" ones"
  k8sPkgs = with pkgs; [
    awscli2
    # grpcurl
    kubernetes-helm
    k9s
    openshift
    # terraform
  ];
  miscPkgs = with pkgs; [
    # TODO(vsiles) bugged at the moment, see
    # https://github.com/NixOS/nixpkgs/issues/328067
    # coder
    bat
    delta
    difftastic
    git-lfs
    # irssi
    # jujutsu # from unstable, see jujutsu.nix
    # gitui
    marksman
    topgrade
    # claude
    claude-code
    nodejs_24
  ];
  nvimPkgs = with pkgs; [
    # nvim related things. TODO: clean-up
    lua-language-server
    nil
    nixd
    taplo
    # terraform-ls
    tree-sitter
  ];
  rustPkgs = with pkgs; [
    # Rust stuff
    cargo-update
    cargo-nextest
    cargo-machete
    rustup
  ];
  pythonPkgs = with pkgs; [
    ruff
    pyright
  ];
in
{
  imports = [
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./jujutsu.nix
    ./topgrade.nix
    ./tmux.nix
    ./yazi.nix
  ];

  home.packages =
    nixPkgs ++
    mandatoryPkgs ++
    k8sPkgs ++
    miscPkgs ++
    nvimPkgs ++
    rustPkgs ++
    pythonPkgs ++
    [
      # Voluntarily override the helix from the nixpkgs source to allow building the one from master
      # or any other dev branch easily
      (funcs.overrideNixProvidedBinary
        "hx"
        (lib.getExe config.programs.helix.package)
        "${config.home.sessionVariables.CARGO_HOME}/bin/hx")
    ];
}
