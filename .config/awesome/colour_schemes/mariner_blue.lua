local stockColours = require("colour_schemes/colours")

local colours = {
	-- Mariner Blue
	['primary'] 	= '#206bc7',
	['secondary'] = '#26caf2',
	['contrast']	= '#c77c20', -- +180deg hue
	['dark']			= '#123d72', -- -50% luminance
	['warning']		= '#ffe6c6', -- red
	['bg']				= '#000000', -- black
	['fg']        = '#ffffff', -- white
	['grey']			= '#272b2e', -- slate
}

-- merge in stock colours
for k,v in pairs(stockColours.color) do colours[k] = v end


return colours
