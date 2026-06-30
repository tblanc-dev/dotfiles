local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'rose-pine-moon'
config.max_fps = 120

-- Use the smooth, animated native macOS fullscreen transition
config.native_macos_fullscreen_mode = true
config.max_fps = 120
config.font = wezterm.font("Hack Nerd Font", { weight = "Regular" })

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.window_frame = {
  font = wezterm.font("Hack Nerd Font", { weight = "Bold"}),
}

config.inactive_pane_hsb = {
  saturation = 0.0,
  brightness = 0.5,
}

config.window_background_opacity = 0.9

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

local act = wezterm.action

config.keys = {
  -- Cmd+Shift+F toggles full screen
  { key = 'F', mods = 'CMD|SHIFT', action = act.ToggleFullScreen },

  -- Shift+Enter => insert a newline instead of submitting.
  -- By default Shift+Enter sends the same \r as Enter, so apps can't tell
  -- them apart. Send ESC+CR (\x1b\r), which multi-line TUIs (Claude Code,
  -- IPython, etc.) interpret as "newline". tmux forwards these bytes as-is.
  { key = 'Enter', mods = 'SHIFT', action = act.SendString '\x1b\r' },

  -- Cmd+K clears the terminal (like macOS Terminal / iTerm).
  -- Clears WezTerm's scrollback + viewport, then sends Ctrl-L so the shell
  -- (incl. inside tmux) redraws a fresh prompt at the top.
  { key = 'k', mods = 'CMD', action = act.Multiple {
    act.ClearScrollback 'ScrollbackAndViewport',
    act.SendString '\x0c',
  } },

  -- Option + Left/Right => jump word-by-word
  -- Emits the Ctrl+Left/Right sequences, which nvim maps to word motion (b / w)
  -- and zsh/readline maps to backward-word / forward-word.
  { key = 'LeftArrow', mods = 'OPT', action = act.SendString '\x1b[1;5D' },
  { key = 'RightArrow', mods = 'OPT', action = act.SendString '\x1b[1;5C' },

  -- Cmd + Left/Right => jump to start/end of line
  -- Emits Home/End, which nvim and shells handle natively.
  { key = 'LeftArrow', mods = 'CMD', action = act.SendString '\x1b[H' },
  { key = 'RightArrow', mods = 'CMD', action = act.SendString '\x1b[F' },

  -- Option + Delete (Backspace) => delete previous word (stops at dots)
  -- Emits Ctrl-W, which nvim's insert mode and the shell treat as
  -- keyword-aware backward-kill-word.
  { key = 'Backspace', mods = 'OPT', action = act.SendString '\x17' },

  -- Cmd + Delete (Backspace) => delete to start of line
  -- Emits Ctrl-U (kill line back), handled natively by nvim and the shell.
  { key = 'Backspace', mods = 'CMD', action = act.SendString '\x15' },
}

-- Cmd+Click opens links. Because tmux has `mouse on`, plain clicks are
-- captured by tmux; `mouse_reporting = true` lets these bindings fire anyway.
-- The Nop on the Down event stops the click from also reaching tmux (which
-- would move the pane selection / start a drag).
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'SUPER',
    action = act.OpenLinkAtMouseCursor,
    mouse_reporting = true,
  },
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'SUPER',
    action = act.Nop,
    mouse_reporting = true,
  },
}

return config
