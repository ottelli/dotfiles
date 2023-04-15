local wibox = require("wibox")

local volume = {}

volume.text_widget = wibox.widget {
	align = "center",
	widget = wibox.widget.textbox,
	text = " ♫..%"
}

local function update_text_widget(widget, stdout, _, _, _)
	local mute = string.match(stdout, "%[(o%D%D?)%]")
    local volume = string.match(stdout, "(%d?%d?%d)%%")
    volume = tonumber(string.format("% 3d", volume))
	if mute == "off" then
		widget:set_text("♫MM%")
	else
		widget:set_text("♫" .. volume .. "%")
	end
end

-- future implementation of volume control
-- function volume.control(cmd, value)
--     value = value or 2
--         if cmd == "increase" then cmd = commands.SET_VOL_CMD .. value .. '%+'

-- Future implementation of volume control
-- volume.text_widget:buttons(gears.table.join(
-- 	awful.button({ }, 1, function () volume.control("toggle") end),
		
--     awful.button({ }, 3, show_pulse_sink_menu),
	
--     awful.button({ }, 4,
-- 			function ()
--                 volume.control("increase", 2)
-- 			end),
		
--     awful.button({ "Shift" }, 4, function () volume.control("increase", 10) end),
		
--     awful.button({ }, 5, function () volume.control("decrease", 2) end),
		
--     awful.button({ "Shift" }, 5, function () volume.control("decrease", 10) end))
-- )

return volume