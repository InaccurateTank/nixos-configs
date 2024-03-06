local icons = require 'utils.icons'

local module = {}

---Equivalent to POSIX `basename(3)`
---@param path string Any string representing a path.
---@return string str The basename string.
---
---```lua
----- Example usage
---local name = fn.basename("/foo/bar") -- will be "bar"
---local name = fn.basename("C:\\foo\\bar") -- will be "bar"
---```
module.basename = function(path)
        local res = path:gsub("(.*[/\\])(.*)", "%2")
        return res
    end

---Pulls an icon for the tab depending on the running process
---@param process string Name of the process
---@return string str Nerdfont icon with spacing
module.running_program = function(process)
        local name = module.basename(process)
            :gsub("%.exe$", "")
        if name:match('powershell') or process:match('pwsh') then
            name = icons.win_shell .. ' '
        elseif name:match('nu') then
            name = icons.win_shell .. ' '
        elseif name:match('cmd') then
            name = icons.win_shell .. ' '
        else
            name = icons.linux_shell .. ' '
        end
        return name
    end

return module