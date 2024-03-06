local wez = require 'wezterm'

local module = {
    {
        event = { Down = { streak = 3, button = 'Left' } },
        action = wez.action.SelectTextAtMouseCursor 'SemanticZone',
        mods = 'NONE',
    },
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wez.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(wez.action.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(wez.action.ClearSelection, pane)
			else
				window:perform_action(wez.action({ PasteFrom = "Clipboard" }), pane)
			end
		end),
    },
};

return module