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

module.programs = {
  -- Special Shells
  fish = '󰈺 ',
  powershell = ' ',
  pwsh = ' ',
  -- File Managers
  yazi = '󰉋 ',
}

-- Misc
module.default_shell = ' '
module.admin = '󰦝 '

return module
