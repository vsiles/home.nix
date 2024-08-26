# Helix `config.toml`

{ ... }:
{
  theme = "vsiles";
  # theme = "base16_default_dark";
  # theme = "zed_onedark";
  editor = {
    # === Basics ===
    color-modes = true;
    completion-replace = true;
    completion-trigger-len = 1;
    cursorline = true;
    idle-timeout = 250;
    completion-timeout = 50;
    line-number = "absolute";
    mouse = false;
    # preview-completion-insert = false;
    rulers = [ 100 120 150 ];
    bufferline = "multiple";

    # === Cursor ===
    cursor-shape = {
      insert = "bar";
      normal = "block";
      # select = "underline";
    };

    # === Diagnostics ===
    # Minimum severity of diagnostics rendered at the end of a line
    end-of-line-diagnostics = "hint";
    inline-diagnostics.cursor-line = "info"; # Show warnings and errors on the cursor line inline

    # === LSP ===
    lsp.display-messages = true;
    lsp.display-inlay-hints = true;

    # === File Picker ===
    file-picker.hidden = false;

    # === Whitespaces ===
    whitespace.render = {
      space = "none";
      tab = "all";
      newline = "none";
    };

    # === Indent guides ===
    indent-guides = {
      render = true;
      character = "▏";
    };

    # === Statusline ===
    statusline = {
      left = [
        "mode"
        "spinner"
        "read-only-indicator"
        "file-modification-indicator"
        "file-name"
        "spacer"
        "diagnostics"
        "spacer"
        "workspace-diagnostics"
        "register"
      ];
      center = [ "version-control" ];
      right = [
        "file-encoding"
        "file-type"
        "separator"
        "selections"
        "separator"
        "primary-selection-length"
        "separator"
        "position"
        "separator"
        "spacer"
        "position-percentage"
        "total-line-numbers"
      ];
    };
  };
  keys = {
    normal = {
      space.i = ":toggle lsp.display-inlay-hints";
    };
  };
}
