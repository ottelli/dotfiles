local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local utils = require("widgets.utils")

local _T = {}

-- Define:
-- a layout for the bar,
-- and a widget template for task items

-- Show only icons in small boxes
_T.icons = {
  ['layout'] = {
    spacing = 28,
    spacing_widget = {
      {
          forced_width  = 28,
          forced_height = 24,
          thickness     = 1,
          color         = '#777777',
          widget        = utils.separator.minor,
      },
      valign = 'center',
      halign = 'center',
      widget = wibox.container.place,
    },
    layout  = wibox.layout.fixed.horizontal
  },

  ['widget_template'] = {
    {
      wibox.widget.base.make_widget(),
      forced_height = 5,
      id            = 'background_role',
      widget        = wibox.container.background,
    },
    {
      {
        id     = 'clienticon',
        widget = awful.widget.clienticon,
      },
      margins = 5,
      widget  = wibox.container.margin
    },
    nil,
    create_callback = function(self, c, index, objects) --luacheck: no unused args
      self:get_children_by_id('clienticon')[1].client = c
    end,
    layout = wibox.layout.align.vertical,
  }
}


-- Show icons and names in a box that fills space
_T.full = {
  ['layout'] = {
    spacing = 10,
    spacing_widget = {
      {
        forced_width = 5,
        shape        = gears.shape.circle,
        widget       = utils.separator.gap,
      },
      valign = 'center',
      halign = 'center',
      widget = wibox.container.place,
    },
    layout  = wibox.layout.flex.horizontal
  },

  ['widget_template'] = {
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
  },
}


return _T
