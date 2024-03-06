local wez = require 'wezterm'

local module = {}

-- Seperators

module.seperators = {
    -- left = wez.nerdfonts.ple_lower_right_triangle,
    left = utf8.char(0xe0ba),
    -- right = wez.nerdfonts.ple_upper_left_triangle,
    right = utf8.char(0xe0bc),
    block = utf8.char(0x2588)
}

-- Misc

-- module.admin = wez.nerdfonts.md_shield_lock
module.admin = utf8.char(0xf099d)

-- Shells

-- module.win_shell = wez.nerdfonts.seti_powershell
module.win_shell = utf8.char(0xe683)
-- module.linux_shell = wez.nerdfonts.seti_shell
module.linux_shell = utf8.char(0xe691)

-- Programs

-- module.git = wez.nerdfonts.seti_git
module.git = utf8.char(0xe65d)
-- module.ssh = wez.nerdfonts.md_ssh
module.ssh = utf8.char(0xf08c0)

return module