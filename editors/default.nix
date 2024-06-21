# sources for lua dev
# https://luals.github.io/#install
# https://github.com/LuaLS/lua-language-server
# https://www.chiarulli.me/Neovim/28-neovim-lua-development/

{ config, pkgs, nixvim, lib, ... }:
let
  map_key = key: action: {
    inherit key action;
    mode = "n";
    options.silent = true;
    options.noremap = true;
  };
  my_plugins = import ./plugins.nix { inherit pkgs; };
in
{
  imports = [
    nixvim.homeManagerModules.nixvim
    ./lsp.nix
    ./completion.nix
  ];

  programs.nixvim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # TODO: find a way to use my own python def in home.nix
    globals.python3_host_prog = "/Users/vincent.siles/.nix-profile/bin/python3";
    globals.maplocalleader = " ";

    # rust-fmt
    globals.rustfmt_autosave = 1;
    globals.rustfmt_emit_files = 1;
    globals.rustfmt_fail_silently = 0;

    opts = {
      # In windows, we want unix file support anyway
      fileformats = [ "unix" "dos" ];
      # -- Not sure I need this, but keeping it around just in case
      # -- vim.opt.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'

      # 'split' opens a live window for off-screen occurrences
      inccommand = "nosplit";
      shiftwidth = 4;
      softtabstop = 4;
      expandtab = true;
      textwidth = 78;
      cursorline = true;
      cursorcolumn = true;
      # relative (to textwidth) columns to highlight
      colorcolumn = "+1,+21";
      splitbelow = true;
      splitright = true;
      # Tab completion behavior
      wildmode = [ "longest" "list" "full" ];
      wildmenu = true;
      number = true;
      # I don't really like this one
      # relativenumber = true;
      # See cmp.nix
      # completeopt = "menuone,noinsert,noselect";
      # Better display for messages
      cmdheight = 2;
      # You will have bad experience for diagnostic messages when it's default 4000.
      updatetime = 300;
      # airline related stuff
      showmode = false;
      laststatus = 2;
      ttimeoutlen = 10;
      # colorscheme
      background = "dark";
      termguicolors = true;
    };

    keymaps = [
      # centering jump and search commands
      # TODO: learn how to do this for gd in the lsp config too
      (map_key "n" "nzz")
      (map_key "n" "nzz")
      (map_key "N" "Nzz")
      (map_key "*" "*zz")
      (map_key "#" "#zz")
      (map_key "g*" "g*zz")
    ];

    plugins = {
      airline = {
        enable = true;
        settings = {
          powerline_fonts = true;
        };
      };
      oil.enable = true;
      treesitter = {
        enable = true;
        disabledLanguages = [ "c" "rust" "python" ];
        ensureInstalled = [ "c" "lua" "vim" "vimdoc" "nix" "rust" "python" ];
      };
      fzf-lua = {
        enable = true;
        profile = "fzf-vim";
      };
      # Note: might be interesting at some point in the future
      # https://haseebmajid.dev/posts/2024-04-21-til-how-to-fix-neorg-metadata-treesitter-issues-with-nixvim/
      neorg = {
        enable = true;
        modules = {
          "core.defaults" = {
            __empty = null;
          };
          "core.concealer" = {
            __empty = null;
          };
          "core.dirman" = {
            config = {
              workspaces = {
                work = "~/notes/work";
                home = "~/notes/home";
              };
              default_workspace = "work";
            };
          };
          "core.summary" = {
            __empty = null;
          };
          "core.completion" = {
            config = {
              engine = "nvim-cmp";
            };
          };
        };
      };
      commentary.enable = true;
      # TODO: understand why x in visual mode doesn't delete but seems to
      # trigger leap
      leap = {
        enable = true;
        specialKeys.prevTarget = "<bs>";
        specialKeys.prevGroup = "<bs>";
      };
      fugitive.enable = true;
      neogit = {
        enable = true;
        settings.integrations.diffview = true;
      };
      diffview = {
        enable = true;
        enhancedDiffHl = true;
        view.mergeTool.layout = "diff4_mixed";
      };
      gitsigns = {
        enable = true;
        settings = { trouble = true; };
      };
      luasnip.enable = true;
      nix.enable = true;
    };

    extraPlugins = with my_plugins; [
      base16
      glow
      lsp-signature
      vim-airline-themes
      vim-crates
      vim-lawrencium
      vim-repeat
      vim-rooter
    ];

    extraConfigLuaPost =
      # lua
      ''
        -- colorscheme
        vim.cmd.colorscheme "base16-default-dark"

        -- Make comments more prominent -- they are important.
        local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
        vim.api.nvim_set_hl(0, 'Comment', bools)

        -- Make it clearly visible which argument we're at.
        local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
        vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', {
            fg = marked.fg,
            bg = marked.bg,
            ctermfg = marked.ctermfg,
            ctermbg = marked.ctermbg,
            bold = true
        })

        -- airline
        vim.g.airline_theme = "base16_gruvbox_dark_hard"

        -- read /Users/vincent.siles/.local/share/nvim/lazy/base16-vim
        -- vim.api.nvim_set_hl(0, 'NeogitDiffDelete', { fg = 'red' })
        vim.api.nvim_set_hl(0, 'NeogitDiffDeleteHighlight', { fg = 'red' })

        -- glow: markdown preview
        require('glow').setup()

        -- leap unsupported config by nixvim
        require('leap.user').set_repeat_keys('<cr>', '<bs>')
      '';

    extraConfigLua =
      # lua
      ''
        local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
        local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

        -- I don't know how to write that in nixvim
        vim.opt.cino = vim.opt.cino + '(0'
        vim.opt.switchbuf = vim.opt.switchbuf + 'usetab' + 'newtab'

        -- I don't like tabs
        vim.cmd([[
            syn match tab display "\t"
            hi link tab Error
        ]])

        -- Permanent undo
        local undodir = vim.fn.stdpath('data') .. '/undodir'
        vim.fn.mkdir(undodir, 'p')
        vim.opt.undodir = undodir
        vim.opt.undofile = true

        -- vim commentary
        augroup('vim-commentary', { clear = true })
        autocmd('FileType', {
            pattern = {'ocaml', 'coq'},
            group = 'vim-commentary',
            callback = function()
                vim.opt.commentstring = '(* %s *)'
        end,
        })

        -- rust
        vim.cmd [[autocmd BufRead Cargo.toml call crates#toggle()]]
        
        -- neorg
        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2
      '';
  };
}
