local icons = require 'utils.icons'
local func = require 'utils.func'

local wez = require 'wezterm'

wez.on('format-tab-title', function(tab, _, _, _, hover, max_width)
  local pane = tab.active_pane

  local program = func.running_program(pane.foreground_process_name)
  local title = func.basename(pane.title)
    :gsub("^Administrator: %w+", icons.admin) -- Replaces admin mode notification with shield icon
    --:gsub("^%w+@(%w+)", "%1") -- Culls user from SSH a SSH tab
  title = wez.truncate_right(title, max_width - 6)

  local highlight = '#BBBBBB'
  local background = '#2E303E'
  local foreground = '#BBBBBB'
  local edge_background = '#2E303E'
  if tab.is_active then
    background = '#1A1C23'
    foreground = '#D5D8DA'
    highlight = '#E95678'
  elseif hover then
    background = '#6C6F93'
    foreground = '#D5D8DA'
  end
  local edge_foreground = background

  local left_side = icons.seperators.left
  if tab.tab_index == 0 then
    left_side = icons.seperators.block
  end

  return {
    { Attribute = { Intensity = "Bold" } },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = left_side },
    { Background = { Color = background } },
    { Foreground = { Color = highlight } },
    { Text = ' ' .. program },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title .. ' ' },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = icons.seperators.right },
  }
end)
