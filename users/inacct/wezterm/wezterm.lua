local wez = require 'wezterm'

require 'events.format-tab-title'

local default_prog = {}
local launch_menu = {}

if wez.target_triple == 'x86_64-pc-windows-msvc' then
    default_prog = {'pwsh.exe'}
    table.insert(launch_menu, {
        label = 'NuShell',
        args = {'nu'},
    })
    table.insert(launch_menu, {
      label = 'PowerShell',
      args = {'powershell.exe', '-NoLogo'},
    })
    table.insert(launch_menu, {
        label = 'PowerShell Core',
        args = {'pwsh.exe'},
    })
    table.insert(launch_menu, {
        label = 'Cmd',
        args = {'cmd.exe'},
    })
    table.insert(launch_menu, {
        label = '-----'
    })
end

local config = {}
if wez.config_builder then
    config = wez.config_builder()
end
config.font = wez.font('Iosevka Tonk Term')
config.font_size = 11.0
config.color_scheme_dirs = {'$HOME/.config/wezterm/colors'}
config.color_scheme = "HorizonDark"
-- config.default_prog = default_prog
config.initial_rows = 35
config.initial_cols = 125
config.use_fancy_tab_bar = false
config.tab_max_width = 60
config.enable_scroll_bar = true
-- config.launch_menu = launch_menu
config.window_background_opacity = 0.95
config.status_update_interval = 2000
config.mouse_bindings = require 'utils.mousebinds'
-- config.disable_default_key_bindings = true
config.keys = require 'utils.keybinds'
config.default_cursor_style = "BlinkingUnderline"
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- Rendering issues on default webgpu choice, needs Gl
config.front_end = 'WebGpu'
-- for _, gpu in ipairs(wez.gui.enumerate_gpus()) do
-- 	if gpu.backend == "Gl" then
-- 		config.webgpu_preferred_adapter = gpu
-- 		break
-- 	end
-- end
config.enable_wayland = false

return config
