local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local mywidgets = require("widgets")
local settings = require("settings")
local colours = require("colour_schemes/"..settings.colour_scheme)

local _L = {}

local theme = {
  -----------------------------------------------
  -- Standard Values
  bg_normal    = colours['bg'],  
  fg_normal    = colours['fg'],
  bg_focus     = colours['primary'],
  fg_focus     = colours['fg'],
  bg_minimize  = colours['secondary'],
  fg_minimize  = colours['fg'],
  bg_urgent    = colours['warning'],
  fg_urgent    = colours['fg'],
  bg_volatile  = colours['red600'],
  fg_volatile  = colours['yellow400'],
  bg_systray   = colours['bg'],
  font		     = "SauceCodePro Nerd Font Bold 9",
  taglist_font = "SauceCodePro Nerd Font Mono Bold 10",
  useless_gap  = dpi(2),
  border_width = dpi(2), 
  -----------------------------------------------
  -- Custom colour mappings
  border_normal = colours['grey'],
  border_focus  = colours['primary'],
  tasklist_bg_minimize = colours['secondary'],
}

-- Taglist (workspaces) widget
local taglist = function(s, taglist_btns) 
    return awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        style   = {
            -- custom style & shapes when you've worked out what a 'cairo context' is
            shape = gears.shape.powerline
        },
        layout   = {
            spacing = -4,
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id     = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left   = 14,
                right  = 14,
                widget = wibox.container.margin
            },
            id     = "background_role",
            widget = wibox.container.background,
        },
        buttons = taglist_btns
    }
end

-- Tasklist (window tray)
local tasklist = function(s, tasklist_btns)
  return awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_btns,
    style = {
      shape = gears.shape.powerline,
      bg_normal = colours['secondary'],
      bg_urgent = colours['warning'],
      bg_minimize = colours['dark'],
    },
    layout = {
      spacing = -4,
      layout  = wibox.layout.flex.horizontal
    },
    widget_template = {
      {
        {
          {
            {
              id     = 'icon_role',
              widget = wibox.widget.imagebox,
            },
            margins = 2,
            widget  = wibox.container.margin,
          },
          {
            id     = 'text_role',
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        left  = 20,
        right = 20,
        widget = wibox.container.margin
      },
      id     = 'background_role',
      widget = wibox.container.background,
    }
  }
end

local separator = wibox.widget{
  markup = '<span foreground="'..colours['secondary']..'"> >> </span>',
  align = 'center',
  valign = 'center',
  font = 'SauceCodePro Nerd Font Bold 9',
  widget = wibox.widget.textbox
}

-- Status bar
local statusbar = function(s)
  return awful.wibar({
      position = "top", 
      screen = s,
      height = dpi(16),
      bg = '#000',
    }):setup {
      {
        -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        
        s.mytaglist,
        separator,
      },
      {
        -- Center widgets
        layout = wibox.layout.align.horizontal,
        s.mytasklist,
      },
      {
        -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        
        mywidgets.tray,
        separator,
        
        -- wibox.widget{
          --   markup = '<span foreground="'..colour_scheme.palette_colours['primary']..'">%-l:%M</span> %a %_d %B',
          --   widget = wibox.widget.textclock
          -- },
          wibox.widget.textclock( '%-l:%M %a %_d %B' ),
          -- wibox.widget.textbox(' '),
          separator,
          s.mylayoutbox,
      },
      layout = wibox.layout.align.horizontal
  } 
end

_L.theme     = theme
_L.taglist   = taglist
_L.tasklist  = tasklist
_L.statusbar = statusbar

return _L
