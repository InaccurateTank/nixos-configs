local wez = require 'wezterm'
local icons = require 'utils.icons'

require 'events.format-tab-title'

local config = wez.config_builder()

if wez.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = {'pwsh.exe'}
  config.launch_menu = {
    {
      label = 'PowerShell',
      args = {'powershell.exe', '-NoLogo'},
    },
    {
      label = 'PowerShell Core',
      args = {'pwsh.exe'},
    },
    {
      label = 'Cmd',
      args = {'cmd.exe'},
    },
    {
      label = '-----'
    }
  }
end

config.font = wez.font_with_fallback {
  'Aporetic Sans Mono',
  { family = 'Symbols Nerd Font Mono', scale = 0.75 },
}
config.font_size = 11.0
config.color_scheme_dirs = {'$HOME/.config/wezterm/colors'}
config.color_scheme = "HorizonDark"
config.initial_rows = 35
config.initial_cols = 125
config.use_fancy_tab_bar = false
config.tab_max_width = 60
config.enable_scroll_bar = true
config.window_background_opacity = 0.95
config.status_update_interval = 2000
config.mouse_bindings = require 'utils.mousebinds'
-- config.disable_default_key_bindings = true
config.keys = require 'utils.keybinds'
config.default_cursor_style = "BlinkingUnderline"
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.tab_bar_style = {
  window_hide = wez.format {
    { Text = icons.decorations.hide }
  },
  window_hide_hover = wez.format {
    { Text = icons.decorations.hide }
  },
  window_maximize = wez.format {
    { Text = icons.decorations.max }
  },
  window_maximize_hover = wez.format {
    { Text = icons.decorations.max }
  },
  window_close = wez.format {
    { Text = icons.decorations.close }
  },
  window_close_hover = wez.format {
    { Text = icons.decorations.close }
  }
}
-- Rendering issues on default webgpu choice, needs Gl
config.front_end = 'WebGpu'
for _, gpu in ipairs(wez.gui.enumerate_gpus()) do
	if gpu.backend == "Gl" then
		config.webgpu_preferred_adapter = gpu
		break
	end
end

return config
