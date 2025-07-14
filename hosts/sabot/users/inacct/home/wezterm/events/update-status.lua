local wez = require 'wezterm'

wez.on("update-status", function(window, pane)
    window:set_right_status()
end)