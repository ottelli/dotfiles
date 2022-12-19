local wibox = require("wibox")
local utils = require("widgets.utils")
local beautiful = require("beautiful")

local textclock = {}


-- 12-Hour : Minute
local time = "%I:%M "

-- Weekday, Day Month
local date = "%A, %d %B"

local format = "%-l:%M %a %_d %B"

return wibox.widget {
    wibox.widget.textclock( "%-l:%M %a %_d %B" ),
    -- wibox.widget.textclock( date ),
    layout = wibox.layout.fixed.horizontal
}
