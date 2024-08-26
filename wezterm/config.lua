local act = wezterm.action

-- TODO
-- capture current screen and open it in vim/nvim
-- https://github.com/wez/wezterm/issues/222
-- works very nicely but my path is not right. I need to find
-- a way to fix this
--
-- InputSelector/ActivateCommandPalette looks awesome for workspace selection.
-- Learn more about them at some point 
-- https://wezfurlong.org/wezterm/config/lua/keyassignment/InputSelector.html
-- https://wezfurlong.org/wezterm/config/lua/keyassignment/ActivateCommandPalette.html
--

local config = {}

-- on windows, starts powershell
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_prog = { 'powershell.exe' }
else
    -- on mac, trying to fix glitches on resize/new tab opening
    config.freetype_load_flags = 'NO_HINTING'
end


-- font configuration
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.font = wezterm.font "RobotoMono Nerd Font"
else
    config.font = wezterm.font "UbuntuMono Nerd Font Mono"
end
config.font_size = 18.0
-- config.font_antialias = "Subpixel", -- None, Greyscale, Subpixel
-- config.font_hinting = "Full",  -- None, Vertical, VerticalSubpixel, Full

-- theme & look
config.color_scheme = 'Default Dark (base16)'
-- config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = "Disabled"

config.scrollback_lines = 5000


-- key bindings
config.leader = { key = 'b', mods = 'CTRL' }

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
end)

config.keys = {
    { key = 'x', mods = 'LEADER',          action = act.CloseCurrentPane { confirm = true }},
    { key = 's', mods = 'LEADER',          action = act.ShowLauncher },
    { key = 'P', mods = 'LEADER|SHIFT',    action = act.ActivateCommandPalette },
    -- TODO create a local detachable domain
    { key = "d", mods = "LEADER",          action = act.DetachDomain "CurrentPaneDomain"}, 
    -- { key = "&", mods = "LEADER|SHIFT", action=act{CloseCurrentTab={confirm=true}}},
    { key = 'x', mods = 'LEADER|CTRL',     action = act.SplitHorizontal { domain = "CurrentPaneDomain" }},
    { key = 'v', mods = 'LEADER|CTRL',     action = act.SplitVertical { domain = "CurrentPaneDomain" }},
    { key = 'q', mods = 'LEADER',          action = act.PaneSelect },
    { key = "n", mods = "LEADER",          action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER",          action = act.ActivateTabRelative(-1) },
    { key = "z", mods = "LEADER",          action = act.TogglePaneZoomState },
    { key = "c", mods = "LEADER",          action = act.SpawnTab "CurrentPaneDomain"},
    -- Leader hjkl (or arrows) is a oneshot move to the relevant direction.
    { key = "h", mods = "LEADER",          action = act.ActivatePaneDirection "Left"},
    { key = "j", mods = "LEADER",          action = act.ActivatePaneDirection "Down"},
    { key = "k", mods = "LEADER",          action = act.ActivatePaneDirection "Up"},
    { key = "l", mods = "LEADER",          action = act.ActivatePaneDirection "Right"},
    { key = "LeftArrow", mods = "LEADER",  action = act.ActivatePaneDirection "Left"},
    { key = "DownArrow", mods = "LEADER",  action = act.ActivatePaneDirection "Down"},
    { key = "UpArrow",   mods = "LEADER",  action = act.ActivatePaneDirection "Up"},
    { key = "RightArrow", mods = "LEADER", action = act.ActivatePaneDirection "Right"},
    -- Leader a enters a move of moving between panes, that has to be
    -- cancelled explicitly
    { key = 'a', mods = 'LEADER',
      -- action = act.ActivateKeyTable { name = 'activate_pane', timeout_milliseconds = 1000, },
      action = act.ActivateKeyTable { name = 'activate_pane', one_shot = false, },
    },
    -- TODO same question for resizing panes
    { key = "H", mods = "LEADER|SHIFT",    action = act.AdjustPaneSize {"Left", 5}},
    { key = "J", mods = "LEADER|SHIFT",    action = act.AdjustPaneSize {"Down", 5}},
    { key = "K", mods = "LEADER|SHIFT",    action = act.AdjustPaneSize {"Up", 5}},
    { key = "L", mods = "LEADER|SHIFT",    action = act.AdjustPaneSize {"Right", 5}},
    { key = 'r', mods = 'LEADER',
      action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false, },
    },
    { key = "?", mods = "LEADER|SHIFT",    action = act.Search "CurrentSelectionOrEmptyString" },
    -- rename tab with prompt
    { key = ",", mods = "LEADER",
      action = act.PromptInputLine {
          description = "Enter new name for tab",
          action = wezterm.action_callback(function(window, pane, line)
              -- https://github.com/wez/wezterm/issues/522
              if line then window:active_tab():set_title(line) end
          end),
      }
    },
    { key = "[", mods = "LEADER",          action = act.ActivateCopyMode },
}

config.key_tables = {
  -- Defines the keys that are active in our activate-pane mode.
  -- 'activate_pane' here corresponds to the name="activate_pane" in
  -- the key assignments above.
  activate_pane = {
    { key = 'LeftArrow', action = act.ActivatePaneDirection 'Left' },
    { key = 'h', action = act.ActivatePaneDirection 'Left' },

    { key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
    { key = 'l', action = act.ActivatePaneDirection 'Right' },

    { key = 'UpArrow', action = act.ActivatePaneDirection 'Up' },
    { key = 'k', action = act.ActivatePaneDirection 'Up' },

    { key = 'DownArrow', action = act.ActivatePaneDirection 'Down' },
    { key = 'j', action = act.ActivatePaneDirection 'Down' },

    -- Exit options
    { key = 'Return', action = 'PopKeyTable' },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'q', action = 'PopKeyTable' },
  },
  -- Defines the keys that are active in our resize-pane mode.
  -- Since we're likely to want to make multiple adjustments,
  -- we made the activation one_shot=false. We therefore need
  -- to define a key assignment for getting out of this mode.
  -- 'resize_pane' here corresponds to the name="resize_pane" in
  -- the key assignments above.
  resize_pane = {
    { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'h', action = act.AdjustPaneSize { 'Left', 5 } },

    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 5 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 5 } },

    { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 5 } },

    { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 5 } },

    -- Cancel the mode by pressing escape
    { key = 'Return', action = 'PopKeyTable' },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'q', action = 'PopKeyTable' },
  },
}

-- config I don't understand yet :)
config.hyperlink_rules = {
    {
        -- Linkify things that look like URLs
        -- This is actually the default if you don't specify any hyperlink_rules
        regex = "\\b\\w+://(?:[\\w.-]+)\\.[a-z]{2,15}\\S*\\b",
        format = "$0",
    },
    {
        -- Make task, diff and paste numbers clickable
        regex = "\\b([tTdDpP]\\d+)\\b",
        format = "https://fburl.com/b/$1",
    },
}
  
-- See: https://wezfurlong.org/wezterm/quickselect.html
config.quick_select_patterns = {
    -- Make task, diff and paste numbers quick-selectable
    "\\b([tTdDpP]\\d+)\\b",
}

return config
