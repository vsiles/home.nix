{ pkgs }: {
  vim-airline-themes = pkgs.vimUtils.buildVimPlugin {
    name = "vim-airline-themes";
    src = pkgs.fetchFromGitHub {
      owner = "vim-airline";
      repo = "vim-airline-themes";
      rev = "a9aa25ce323b2dd04a52706f4d1b044f4feb7617";
      hash = "sha256-XwlNwTawuGvbwq3EbsLmIa76Lq5RYXzwp9o3g7urLqM=";
    };
  };
  base16 = pkgs.vimUtils.buildVimPlugin {
    name = "base16";
    src = pkgs.fetchFromGitHub {
      owner = "chriskempson";
      repo = "base16-vim";
      rev = "3be3cd82cd31acfcab9a41bad853d9c68d30478d";
      hash = "sha256-uJvaYYDMXvoo0fhBZUhN8WBXeJ87SRgof6GEK2efFT0=";
    };
  };
  vim-crates = pkgs.vimUtils.buildVimPlugin {
    name = "vim-crates";
    src = pkgs.fetchFromGitHub {
      owner = "mhinz";
      repo = "vim-crates";
      rev = "f6f13113997495654a58f27d7169532c0d125214";
      hash = "sha256-88QX1iF72zj+ec+yBUhHK4n9zWS8I8+ejhCDTaEolak=";
    };
  };
  lsp-signature = pkgs.vimUtils.buildVimPlugin {
    name = "lsp-signature";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "lsp_signature.nvim";
      rev = "2ec2ba23882329c1302dff773b0d3620371d634f";
      hash = "sha256-ezNJvVjwGUpb3D77DshVAVnh9fDIiLW21CcPRDxlzJY=";
    };
  };
  glow = pkgs.vimUtils.buildVimPlugin {
    name = "glow";
    src = pkgs.fetchFromGitHub {
      owner = "ellisonleao";
      repo = "glow.nvim";
      rev = "238070a686c1da3bccccf1079700eb4b5e19aea4";
      hash = "sha256-GsNcASzVvY0066kak2nvUY5luzanoBclqcUOsODww8g=";
    };
  };
  vim-rooter = pkgs.vimUtils.buildVimPlugin {
    name = "vim-rooter";
    src = pkgs.fetchFromGitHub {
      owner = "airblade";
      repo = "vim-rooter";
      rev = "45e53f01e4e1c4a3ee20814de232162713aff578";
      hash = "sha256-sSktn6HYuXDnsQYWAdk5lleJi106KJQgBM+KoifkuIk=";
    };
  };
  vim-lawrencium = pkgs.vimUtils.buildVimPlugin {
    name = "vim-lawrencium";
    src = pkgs.fetchFromGitHub {
      owner = "ludovicchabant";
      repo = "vim-lawrencium";
      rev = "a790513b278eba1279e1f053aab760cbddbc3872";
      hash = "sha256-GzBzND7VBWrAqn+PjYTDXj4GxYW81Fb7VGIqDp4gnSs=";
    };
  };
  vim-repeat = pkgs.vimUtils.buildVimPlugin {
    name = "vim-repeat";
    src = pkgs.fetchFromGitHub {
      owner = "tpope";
      repo = "vim-repeat";
      rev = "24afe922e6a05891756ecf331f39a1f6743d3d5a";
      hash = "sha256-8rfZa3uKXB3TRCqaDHZ6DfzNbm7WaYnLvmTNzYtnKHg=";
    };
  };
}
