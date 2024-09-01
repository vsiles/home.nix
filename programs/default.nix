{ config
, pkgs
, lib
, ...
}:
let
  funcs = import ../functions.nix { inherit config lib pkgs; };
  nixPkgs = with pkgs; [
    nixpkgs-fmt
  ];
  # The ones I can't live without
  mandatoryPkgs = with pkgs; [
    curl
    jq
    fd
    ripgrep
    tree
  ];
  # The "k8s" ones"
  k8sPkgs = with pkgs; [
    awscli2
    grpcurl
    kubernetes-helm
    k9s
    openshift
    terraform
    wget
  ];
  miscPkgs = with pkgs; [
    # TODO(vsiles) bugged at the moment, see
    # https://github.com/NixOS/nixpkgs/issues/328067
    # coder
    bat
    delta
    difftastic
    fluxcd
    git-lfs
    graphviz
    hexedit
    irssi
    jujutsu
    # lazygit
    gitui
    marksman
    postgresql
    protobuf
    sqlite
    sqlite.out
    topgrade
  ];
  nvimPkgs = with pkgs; [
    # nvim related things. TODO: clean-up
    lua-language-server
    nil
    nixd
    terraform-ls
    tree-sitter
  ];
  rustPkgs = with pkgs; [
    # Rust stuff
    cargo-update
    cargo-nextest
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
    # ./pyenv.nix
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
