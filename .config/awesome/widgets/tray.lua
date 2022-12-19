local awful = require("awful")
local wibox = require("wibox")
local utils = require("widgets.utils")
local cpu_widget = require("widgets.cpu-widget.cpu-widget")

return wibox.widget {
    {
        cpu_widget({
            width = 12,
            step_width = 3,
            step_spacing = 0,
            color = '#fff'
        }),
        layout = wibox.layout.fixed.horizontal
    },
    {
        visible = true,
        widget = wibox.widget.systray(),
    },
    layout = wibox.layout.fixed.horizontal
}
