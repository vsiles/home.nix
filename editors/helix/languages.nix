# Language config for helix

{ config, lib, pkgs, home, ... }:
let
  indent = { tab-width = 4; unit = "    "; };
in
{
  language-server = {
    clangd.args = [ "--background-index" ];

    nixd = {
      command = "nixd";
      args = [ "--inlay-hints" ];

      # <https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md>
      # By default there is no home-manager options completion, thus you can add this entry.
      # TODO: make this work on Linux
      config.home-manager.expr = ''(builtins.getFlake "${home}/.config/home-manager").darwinConfigurations.mac.options'';
    };

    pyright = {
      command = "pyright-langserver";
      args = [ "--stdio" ];
    };


    ruff = {
      command = "ruff";
      args = [ "server" ];
      config = {
        settings = {
          args = [ "--ignore" "E501" ];
          lineLength = 120;
          lint = {
            # TODO: learn about this ?
            select = [ "E4" "E7" ];
            preview = false;
          };
          format = {
            preview = true;
          };
        };
      };
    };

    rust-analyzer.config = {
      assist.importGranularity = "module";
      check.command = "clippy";
      completion.fullFunctionSignatures.enable = true;
      hover.actions.references.enable = true;
      lens.references = {
        adt.enable = true;
        enumVariant.enable = true;
        method.enable = true;
        trait.enable = true;
      };

      inlayHints = {
        closingBraceHints.minLines = 10;
        closureReturnTypeHints.enable = "with_block";
        discriminantHints.enable = "fieldless";
        lifetimeElisionHints.enable = "skip_trivial";
        typeHints.hideClosureInitialization = false;
        expressionAdjustmentHints.enable = "never";
        expressionAdjustmentHints.hideOutsideUnsafe = false;
        expressionAdjustmentHints.mode = "prefer_prefix";
      };

      lruCapacity = 256;
      workspace.symbol.search = {
        limit = 128;
        kind = "all_symbols";
        scope = "workspace";
      };

      diagnostics.disabled = [
        "inactive-code"
        "inactive_code"
        "unresolved-proc-macro"
        "unresolved_proc_macro"
      ];
    };

    yaml-language-server.config.yaml.keyOrdering = false;
  };

  language = [
    {
      name = "bash";
      inherit indent;
    }

    {
      name = "c";
      inherit indent;
    }

    {
      name = "markdown";
      text-width = 150;

      soft-wrap.enable = true;
      soft-wrap.wrap-at-text-width = true;
    }

    {
      name = "nix";
      auto-format = false;
      formatter.command = lib.getExe pkgs.nixpkgs-fmt;
      language-servers = [ "nixd" ];
    }

    {
      name = "python";
      language-servers = [ "pyright" "ruff" ];
      roots = [ "pyproject.toml" "poetry.lock" ];
      formatter = { command = "ruff"; args = [ "format" "--line-length=120" "-" ]; };
      inherit indent;
    }

    {
      name = "protobuf";
      inherit indent;
    }

    {
      name = "toml";
      auto-format = false;
      inherit indent;
    }
  ];
}
