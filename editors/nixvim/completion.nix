{ config, pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          completion = {
            # menuone: popup even when there's only one match
            # noinsert: Do not insert text until a selection is made
            # noselect: Do not select, force user to select one from the menu
            completeopt = "menuone,noinsert,noselect";
            # autocomplete = [ "InsertEnter" ];
          };
          snippet.expand =
            # lua
            ''
              function(args)
                  require("luasnip").lsp_expand(args.body)
              end,
            '';
          sources = [
            { name = "nvim_lsp"; }
            { name = "nvim_lsp_signature_help"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "treesitter"; }
            { name = "nvim_lua"; }
            { name = "calc"; }
            { name = "treesitter"; }
            { name = "crates"; }
            { name = "spell"; }
            # Don't add cmdline to global sources
            # https://github.com/hrsh7th/nvim-cmp/issues/1310#issuecomment-1326712312
            # {name = "cmdline";}
          ];
          mapping = {
            "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 'c' })";
            "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 'c' })";
            # "Tab" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { 'i', 'c' })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), { 'i','c' })";
            "<C-k>" = "cmp.mapping.scroll_docs(-4)"; # was -b
            "<C-j>" = "cmp.mapping.scroll_docs(4)"; # was -f
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-X><C-O>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping(cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace,select = true,}), { 'i' })";
            "<Right>" = "cmp.mapping(cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace,select = true,}), { 'c' })";
            # -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            # ['<CR>'] = cmp.mapping.confirm({ select = true }),
            # -- ['<CR>'] = cmp.mapping.confirm {
            # --     behavior = cmp.ConfirmBehavior.Replace,
            # --     select = true,
            # -- },
          };
          experimental = {
            ghost_text = true;
          };
        };
        cmdline = {
          "/" = {
            mapping = {
              __raw = "cmp.mapping.preset.cmdline()";
            };
            sources = [
              { name = "buffer"; }
            ];
          };
          ":" = {
            mapping = {
              __raw = "cmp.mapping.preset.cmdline()";
            };
            sources = [
              { name = "path"; }
              {
                name = "cmdline";
                option = {
                  ignore_cmds = [ "Man" "!" ];
                };
              }
            ];
          };
        };
      };
      # TODO: From Omar's config. Play with that
      # cmp-buffer.enable = true;
      # cmp-fuzzy-buffer.enable = true;
      # cmp-fuzzy-path.enable = true;
      # cmp-cmdline.enable = true;
      # cmp-cmdline-history.enable = true;
      # cmp-git.enable = true;
      # cmp-greek.enable = true;
      # cmp-nvim-lsp.enable = true;
      # cmp-nvim-lsp-document-symbol.enable = true;
      # cmp-nvim-lsp-signature-help.enable = true;
      # cmp-nvim-lua.enable = true;
      # cmp-treesitter.enable = true;
      # cmp_luasnip.enable = true;
    };
  };
}
#     ['<Tab>'] = cmp.mapping.confirm({ select = true }),
#     -- ["<Tab>"] = cmp.mapping(function(fallback)
#     --     if cmp.visible() then
#     --       cmp.select_next_item()
#     --     elseif luasnip.expand_or_jumpable() then
#     --       luasnip.expand_or_jump()
#     --     elseif has_words_before() then
#     --       cmp.complete()
#     --     else
#     --       fallback()
#     --     end
#     --   end, { "i", "s" }),
#     --   ["<S-Tab>"] = cmp.mapping(function(fallback)
#     --     if cmp.visible() then
#     --       cmp.select_prev_item()
#     --     elseif luasnip.jumpable(-1) then
#     --       luasnip.jump(-1)
#     --     else
#     --       fallback()
#     --     end
#     --   end, { "i", "s" }),
#     --{
#   }),
# })

# cmp.setup.filetype('nix', {
#   sources = cmp.config.sources({
#       { name = 'nvim_lsp' },
#       { name = 'nix-cmp' }
#   }, {
#       { name = 'buffer' },
#   })
# })

# -- Enable completing paths in :
# cmp.setup.cmdline(':', {
#   sources = cmp.config.sources({
#     { name = 'path' }
#    }, {
#     { name = 'cmdline' }
#   })
# })


# local cmp = require('cmp')
# -- cmp.register_source('nix-cmp', require('nix-cmp'))
