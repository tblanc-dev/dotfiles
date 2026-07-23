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

-- Make mouse text selection clearly visible (rose-pine-moon's default is faint).
-- Overrides just these two entries on top of the color_scheme.
config.colors = {
  selection_bg = "#c4a7e7", -- iris (matches the active pane border)
  selection_fg = "#232136", -- base (dark text on the bright selection)
}

local act = wezterm.action

config.keys = {
  -- Cmd+Shift+F toggles full screen
  { key = 'F', mods = 'CMD|SHIFT', action = act.ToggleFullScreen },

  -- Cmd+W closes the tab without the confirmation prompt.
  { key = 'w', mods = 'CMD', action = act.CloseCurrentTab { confirm = false } },

  -- Shift+Enter => insert a newline instead of submitting.
  -- By default Shift+Enter sends the same \r as Enter, so apps can't tell
  -- them apart. Send ESC+CR (\x1b\r), which multi-line TUIs (Claude Code,
  -- IPython, etc.) interpret as "newline". tmux forwards these bytes as-is.
  { key = 'Enter', mods = 'SHIFT', action = act.SendString '\x1b\r' },

  -- Cmd+K clears the terminal (like macOS Terminal / iTerm).
  -- Inside tmux, WezTerm's ClearScrollback would wipe the whole composited
  -- grid (every pane), so instead send prefix+C-l to let tmux clear only the
  -- active pane (see the matching `bind C-l` in .tmux.conf). Outside tmux,
  -- clear WezTerm's scrollback + viewport and Ctrl-L for a fresh prompt.
  { key = 'k', mods = 'CMD', action = wezterm.action_callback(function(window, pane)
    local proc = pane:get_foreground_process_name() or ''
    if proc:find('tmux') then
      window:perform_action(act.SendString '\x02\x0c', pane) -- C-b then C-l
    else
      window:perform_action(act.ClearScrollback 'ScrollbackAndViewport', pane)
      window:perform_action(act.SendString '\x0c', pane)
    end
  end) },

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

  -- Option+N => emit ~ in a single press.
  -- On the French Mac layout Option+N is a dead key (˜) that waits for a
  -- second keystroke. Bind it directly so one press yields a literal tilde.
  { key = 'n', mods = 'OPT', action = act.SendString '~' },
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
  -- Finer scrollback: 1 line per wheel tick (default jumps several).
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'NONE',
    action = act.ScrollByLine(-1),
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'NONE',
    action = act.ScrollByLine(1),
  },
}

return config
