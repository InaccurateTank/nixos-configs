local wez = require 'wezterm'

return {
  { key = 'q', mods = 'CTRL', action = wez.action.CloseCurrentTab { confirm = true } },
}
