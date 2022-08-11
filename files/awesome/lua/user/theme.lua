local gears = require("gears")
local beautiful = require("beautiful")

local themes = {
  "nord", -- 1
}

local chosen_theme = themes[1]

beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" .. chosen_theme .. "/theme.lua")

