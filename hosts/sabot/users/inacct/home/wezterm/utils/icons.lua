local wez = require 'wezterm'

local module = {}

module.seperators = {
  -- ple_lower_right_triangle
  left = '',
  -- ple_upper_left_triangle
  right = '',
  -- block = utf8.char(0x2588)
  -- Full Block
  block = '█',
}

module.decorations = {
  hide = wez.nerdfonts.md_window_minimize .. ' ',
  max = wez.nerdfonts.md_window_maximize .. ' ',
  close = wez.nerdfonts.md_close .. ' '
}

module.programs = {
  -- Special Shells
  fish = wez.nerdfonts.md_fish .. ' ',
  powershell = wez.nerdfonts.seti_powershell .. ' ',
  pwsh = wez.nerdfonts.seti_powershell .. ' ',
  -- File Managers
  yazi = wez.nerdfonts.md_folder .. ' ',
}

-- Misc
module.default_shell = wez.nerdfonts.seti_shell .. ' ',
module.admin = wez.nerdfonts.md_shield_lock .. ' ',

return module
