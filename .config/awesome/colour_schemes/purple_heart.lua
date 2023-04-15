local stockColours = require("colour_schemes/colours")

local colours = {
	-- Purple Heart
	['primary'] 	= '#7e26e7', -- purple heart
	['secondary'] = '#1974d2', -- curious blue
	['contrast']	= '#196ec4', -- +180deg hue
	['dark']			= '#4c178b', -- +40% pure black
	['warning']		= '#ffc6c6', -- red
	['bg']				= '#000000', -- black
	['fg']				= '#fefef2', -- off-white
	['grey']			= '#272b2e', -- slate
}

-- merge in stock colours
for k,v in pairs(stockColours.color) do colours[k] = v end


return colours
