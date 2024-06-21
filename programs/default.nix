{ config
, pkgs
, ...
}:
{
  imports = [
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./jj.nix
    ./pyenv.nix
    ./tmux.nix
    ./yazi.nix
  ];

  home.packages = with pkgs; [
    nixpkgs-fmt
    # The ones I can't live without
    curl
    jq
    fd
    ripgrep
    tree
    # The "k8s" ones"
    awscli2
    grpcurl
    kubernetes-helm
    k9s
    openshift
    terraform
    wget
    # The others
    coder
    fluxcd
    graphviz
    hexedit
    irssi
    lazygit
    postgresql
    protobuf
    sqlite
    sqlite.out
    # nvim related things. TODO: clean-up
    lua-language-server
    nil
    nixd
    terraform-ls
    tree-sitter
    # Python stuff
    kraken-wrapper
    pipx
    # Rust stuff
    cargo-nextest
    rustup
  ];
}
