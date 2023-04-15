-- Paths
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir() .. "default"
local titlebar_path = gfs.get_themes_dir() .. "zenburn/titlebar"
local layouts_path = gfs.get_themes_dir() .. "default/layouts"
local theme_assets = require("beautiful.theme_assets")
-- Resources
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
-- Local modules
local settings = require("settings")
local custom_theme = require("custom_themes/"..settings.theme)

-------------------------------------------------
-- Builds the theme table
--
-- use the makeThemeTable function to inflate a custom_theme.theme table into a complete theme table
-- 
-- Return theme table for use in rc.lua with beautiful.init(..)
-------------------------------------------------

local default_theme = {
    bg_normal    = '#000',     
    fg_normal    = '#fff',     
    bg_focus     = '#000',      
    fg_focus     = '#fff',
    bg_minimize  = '#000',
    fg_minimize  = '#fff',
    bg_urgent    = '#000',
    fg_urgent    = '#fff',
    bg_volatile  = '#000',
    fg_volatile  = '#fff',
    bg_systray   = '#000',
    font		 = "SauceCodePro Nerd Font Bold 9",
    taglist_font = "SauceCodePro Nerd Font Mono Bold 10",
    useless_gap  = dpi(3),
    border_width = dpi(3),
}

-- param:   custom_values  , overwrites to the default_theme values
-- returns: theme table    , theme table with base values mapped to elements
function makeThemeTable(custom_values)
    
    local theme = default_theme
    
    -- Overwrite defaults with any scheme values
    -- And add any custom references mappings
    for k,v in pairs(custom_values) do theme[k] = v end
    
    -------------------------------------------------
    --             Add referenced values           --
    -------------------------------------------------
    local default_references = {
        border_normal = theme.fg_normal,
        border_focus  = theme.fg_focus,
        border_marked = theme.fg_urgent,
    
        -- prompt_bg = ''
        -- prompt_fg = ''
        -- prompt_bg_cursor = ''
        -- prompt_fg_cursor = ''
    
        taglist_bg_focus    = theme.bg_focus,         -- active workspace
        taglist_fg_focus    = theme.fg_focus,
        taglist_bg_occupied = theme.bg_minimize,        -- inactive, with windows
        taglist_fg_occupied = theme.fg_minimize,
        taglist_bg_empty    = theme.bg_normal,           -- inactive, no windows
        taglist_fg_empty    = theme.fg_normal .. '80',   -- 50% opacity
        taglist_bg_urgent   = theme.bg_urgent,           -- just opened on other workspace
        taglist_fg_urgent   = theme.fg_urgent,
        taglist_bg_volatile = theme.bg_volatile,         -- oh no! what happened!? leap to action at once! dont wait around! you really need to see this, delaying any longer would be such folly, I cant believe your not already attending to this volatile matter, who would do such a thing? Not me thats for sure, if my workspace was volatile I would tend to it straight away, no dilly-dallying around or typing long comments, just straight over to that volatile workspace that clearly needs a lot of help and attention RIGHT NOW!
        taglist_fg_volatile = theme.fg_volatile,
        -- Generate taglist squares:
        -- local taglist_square_size = dpi(6)
        -- theme.taglist_squares_sel = _D_assets.taglist_squares_sel(
        --     taglist_square_size, theme.fg_focus
        -- )
        -- theme.taglist_squares_unsel = _D_assets.taglist_squares_unsel(
        --     taglist_square_size, theme.fg_normal
        -- )
    
        tasklist_bg_focus  = theme.bg_focus,
        tasklist_fg_focus  = theme.fg_focus,
        tasklist_fg_urgent = theme.fg_urgent,
        tasklist_bg_urgent = theme.bg_urgent,
    
        titlebar_bg_normal = theme.bg_normal,
        titlebar_fg_normal = theme.fg_normal,
        titlebar_bg_focus  = theme.bg_focus,
        titlebar_fg_focus  = theme.fg_focus,
    
        menu_height         = dpi(18),
        menu_width          = dpi(150),
        menu_context_height = dpi(18),
        menu_border_width   = 3,
        menu_border_color   = theme.bg_focus,
        menu_bg_normal      = theme.bg_normal,
        menu_bg_focus       = theme.bg_focus,
        menu_fg_focus       = theme.fg_focus,
    
        hotkeys_font 	         = theme.taglist_font,
        hotkeys_description_font = theme.font,
        hotkeys_border_width 	 = dpi(6),
        hotkeys_border_color 	 = theme.border_color,
        hotkeys_group_margin     = dpi(12),
        -- hotkeys_shape 	       = ""
        hotkeys_bg               = theme.bg_normal,
        hotkeys_fg               = theme.fg_normal,
        hotkeys_modifiers_fg     = theme.fg_normal,
        hotkeys_label_bg 	     = theme.bg_focus,
        hotkeys_label_fg         = theme.fg_focus,
    
        notification_font = theme.font,
        notification_bg   = theme.bg_urgent,
        notification_fg   = theme.fg_urgent,
        -- notification_[width|height|margin]
        -- notification_[border_color|border_width|shape|opacity]
        notification_border_color = theme.bg_volatile,
        notification_border_width = theme.border_width,
    }

    for k,v in pairs(default_references) do
        -- If the reference is explicit in the scheme, then keep that value
        if theme[k] == nil then
            theme[k] = v
        end
    end

    ------------------------------------------------
    --                    ICONS                   --
    ------------------------------------------------
    local default_icons = {
        -- Menu
        menu_submenu_icon = themes_path.."/submenu.png",
        -- Titlebar
        titlebar_close_button_normal              = titlebar_path.."/close_normal.png",
        titlebar_close_button_focus               = titlebar_path.."/close_focus.png",
        titlebar_minimize_button_normal           = titlebar_path.."/minimize_normal.png",
        titlebar_minimize_button_focus            = titlebar_path.."/minimize_focus.png",
        titlebar_ontop_button_normal_inactive     = titlebar_path.."/ontop_normal_inactive.png",
        titlebar_ontop_button_focus_inactive      = titlebar_path.."/ontop_focus_inactive.png",
        titlebar_ontop_button_normal_active       = titlebar_path.."/ontop_normal_active.png",
        titlebar_ontop_button_focus_active        = titlebar_path.."/ontop_focus_active.png",
        titlebar_sticky_button_normal_inactive    = titlebar_path.."/sticky_normal_inactive.png",
        titlebar_sticky_button_focus_inactive     = titlebar_path.."/sticky_focus_inactive.png",
        titlebar_sticky_button_normal_active      = titlebar_path.."/sticky_normal_active.png",
        titlebar_sticky_button_focus_active       = titlebar_path.."/sticky_focus_active.png",
        titlebar_floating_button_normal_inactive  = titlebar_path.."/floating_normal_inactive.png",
        titlebar_floating_button_focus_inactive   = titlebar_path.."/floating_focus_inactive.png",
        titlebar_floating_button_normal_active    = titlebar_path.."/floating_normal_active.png",
        titlebar_floating_button_focus_active     = titlebar_path.."/floating_focus_active.png",
        titlebar_maximized_button_normal_inactive = titlebar_path.."/maximized_normal_inactive.png",
        titlebar_maximized_button_focus_inactive  = titlebar_path.."/maximized_focus_inactive.png",
        titlebar_maximized_button_normal_active   = titlebar_path.."/maximized_normal_active.png",
        titlebar_maximized_button_focus_active    = titlebar_path.."/maximized_focus_active.png",
        -- Layouts
        layout_fairh      = layouts_path.."/fairhw.png",
        layout_fairv      = layouts_path.."/fairvw.png",
        layout_floating   = layouts_path.."/floatingw.png",
        layout_magnifier  = layouts_path.."/magnifierw.png",
        layout_max        = layouts_path.."/maxw.png",
        layout_fullscreen = layouts_path.."/fullscreenw.png",
        layout_tilebottom = layouts_path.."/tilebottomw.png",
        layout_tileleft   = layouts_path.."/tileleftw.png",
        layout_tile       = layouts_path.."/tilew.png",
        layout_tiletop    = layouts_path.."/tiletopw.png",
        layout_spiral     = layouts_path.."/spiralw.png",
        layout_dwindle    = layouts_path.."/dwindlew.png",
        layout_cornernw   = layouts_path.."/cornernww.png",
        layout_cornerne   = layouts_path.."/cornernew.png",
        layout_cornersw   = layouts_path.."/cornersww.png",
        layout_cornerse   = layouts_path.."/cornersew.png",
        -- Generate Awesome icon:
        awesome_icon = theme_assets.awesome_icon(
            theme.menu_height, theme.bg_focus, theme.fg_focus
        ),
        -- Define the icon theme for application icons. If not set then the icons
        -- from /usr/share/icons and /usr/share/icons/hicolor will be used.
        icon_theme = nil,
    }

    for k,v in pairs(default_icons) do
        -- If the reference is explicit in the scheme, then keep that value
        if theme[k] == nil then
            theme[k] = v
        end
    end

    return theme 
end

return makeThemeTable(custom_theme.theme)
