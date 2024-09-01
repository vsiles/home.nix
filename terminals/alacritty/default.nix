{ pkgs, config, lib, ... }:
let
  font = "UbuntuMono Nerd Font Mono";
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "alacritty";
      scrolling.history = 10000;
      shell = { program = "${pkgs.fish}/bin/fish"; };
      keyboard.bindings = [
        {
          chars = "\u0002p";
          key = "LBracket";
          mods = "Command|Shift";
        }
        {
          chars = "\u0002n";
          key = "RBracket";
          mods = "Command|Shift";
        }
        {
          chars = "\u001E";
          key = "Key6";
          mods = "Control";
        }
      ];
      font = {
        size = 18.0;
        normal = {
          family = font;
          style = "Regular";
        };
        bold = {
          family = font;
          style = "Bold";
        };
        bold_italic = {
          family = font;
          style = "Bold Italic";
        };
        italic = {
          family = font;
          style = "Italic";
        };
      };
      window = {
        decorations = "none";
        dynamic_padding = true;
        padding = {
          x = 2;
          y = 2;
        };
        startup_mode = "Maximized";
      };
      selection = {
        save_to_clipboard = true;
        semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
      };
      colors = {
        draw_bold_text_with_bright_colors = false;
        # enable_rgb = true;

        bright = {
          black = "0x585858";
          blue = "0xb8b8b8";
          cyan = "0xa16946";
          green = "0x282828";
          magenta = "0xe8e8e8";
          red = "0xdc9656";
          white = "0xf8f8f8";
          yellow = "0x383838";
        };
        cursor = {
          cursor = "0xd8d8d8";
          text = "0x181818";
        };
        normal = {
          black = "0x181818";
          blue = "0x7cafc2";
          cyan = "0x86c1b9";
          green = "0xa1b56c";
          magenta = "0xba8baf";
          red = "0xab4642";
          white = "0xd8d8d8";
          yellow = "0xf7ca88";
        };
        primary = {
          background = "0x181818";
          foreground = "0xd8d8d8";
        };
      };
    };
  };
}

