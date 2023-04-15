local wibox		= require("wibox")
local awful		= require("awful")


return wibox.widget {
    awful.widget.watch('bash -c "iw dev wlo1 link | awk \'NR==2 {print $2}\'"', 60),
    layout 	= wibox.layout.align.horizontal,
    pressed = function(self, button)
    	if button == 1 then
    		awful.spawn(terminal.." -e nmtui")
    	end
    end
}