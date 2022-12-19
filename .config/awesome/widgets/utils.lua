local wibox = require("wibox")

local widgets = {}

widgets.separator = {
  ['gap']   = wibox.widget.textbox(" "),
  ['minor'] = wibox.widget.textbox(" // "),
  ['major'] = wibox.widget.textbox("  ///  ")
}

return widgets
