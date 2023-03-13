local stockColours = require("colour_schemes/colours")

local colours = {
	-- Mariner Blue
	['primary'] 	= '#2985f7', -- slightly lighter choice. '#206bc7' is original mariner blue,
	['secondary'] = '#7e26e7', -- purple heart. another option is '#26caf2', (aqua)
	['contrast']	= '#7aaf27', -- olive drab
	['dark']			= '#123d72', -- -50% luminance from primary
	['warning']		= '#c77c20', -- +180deg hue (orange), #ffe6c6', -- very pale red
	['bg']				= '#000000', -- black
	['fg']        = '#ffffff', -- white
	['grey']			= '#272b2e', -- slate
}

-- merge in stock colours
for k,v in pairs(stockColours.color) do colours[k] = v end


return colours
