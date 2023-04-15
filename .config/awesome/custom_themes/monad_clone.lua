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
  fg_normal    = colours['grey600'], -- only applied to un-focused windows, other places are overwritten in this theme
  bg_focus     = colours['bg'],
  fg_focus     = colours['primary'],
  bg_minimize  = colours['dark'],
  fg_minimize  = colours['secondary'],
  bg_urgent    = colours['bg'],
  fg_urgent    = colours['warning'],
  bg_volatile  = colours['bg'],
  fg_volatile  = colours['red600'],
  bg_systray   = colours['bg'],
  font		     = "SauceCodePro Nerd Font Bold 9",
  taglist_font = "SauceCodePro Nerd Font Bold 10",
  useless_gap  = dpi(0),
  border_width = dpi(2), 
  -----------------------------------------------
  -- Custom colour mappings
  border_focus        = colours['primary'],
  border_normal       = colours['grey'],
  taglist_bg_occupied = colours['black'],
  taglist_fg_occupied = colours['contrast'],
  taglist_fg_empty    = colours['fg'],
}

-- Taglist (workspaces) widget
local taglist = function(s, taglist_btns) 
  return awful.widget.taglist {
      screen = s,
      filter = awful.widget.taglist.filter.all,
      style  = {
        shape = gears.shape.rounded_rect
      },
      layout = {
        spacing = 0,
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
          left   = 6,
          right  = 6,
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
    screen          = s,
    filter          = awful.widget.tasklist.filter.currenttags,
    buttons         = tasklist_btns,
    layout          = {
      spacing = 10,
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
  markup = '<span foreground="'..colours['secondary']..'"> // </span>',
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
    height = dpi(20),
    bg = colours['bg'],
    fg = colours['fg'],
  }):setup {
    {
      -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mylayoutbox,
      separator,

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

      wibox.widget.textclock( '%-l:%M %a %_d %B' ),
      wibox.widget.textbox(' '),
    },
    layout = wibox.layout.align.horizontal
  } 
end

_L.theme     = theme
_L.taglist   = taglist
_L.tasklist  = tasklist
_L.statusbar = statusbar

return _L
