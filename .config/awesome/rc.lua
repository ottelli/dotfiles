----                                         ----
--                                             --
--           Custom AwesomeWM Setup            --
--                                             --
----                                         ----


-------------------------------------------------
--                  Imports                    --
-------------------------------------------------
-- Check for LuaRocks package manager
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local cairo = require("lgi").cairo

-- Widget and layout library
local wibox = require("wibox")
local mywidgets = require("widgets")

-- Theme handling library
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Menu library
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")



-------------------------------------------------
--               Error Handling                --
-------------------------------------------------
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end
-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end



-------------------------------------------------
--                  Variables                  --
-------------------------------------------------
-- Use a tiny settings file for the most common items, rather than crawling through this or any other file
local settings = require("settings")
modkey = settings.modkey -- referenced a lot so keep it tidy

-- Custom Themes define theme colours, fonts, icons, and the statusbar and everything inside 
local myTheme = require("custom_themes/"..settings.theme)
local themeTable = require("theme")
beautiful.init(themeTable)



-------------------------------------------------
--                  Startup                    --
-------------------------------------------------
awful.spawn.with_shell('compton') -- Compositor
awful.spawn.with_shell('nitrogen --set-zoom-fill --random ~/Pictures/Wallpapers') -- Backgrounds
os.execute('xrdb ~/.Xresources') -- Use my Xresources for x-term config


-------------------------------------------------
--                  Layouts                    --
-------------------------------------------------
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}


-------------------------------------------------
--                    Menu                     --
-------------------------------------------------
-- Create a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", settings.terminal .. " -e man awesome" },
   { "edit config", settings.editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", settings.terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
            menu_awesome,
            { "Debian", debian.menu.Debian_menu.Debian },
            menu_terminal,
        }
    })
end

-- Menubar configuration
menubar.utils.terminal = settings.terminal -- Set the terminal for applications that require it


-------------------------------------------------
--                Mouse Bindings               --
-------------------------------------------------
-- Mouse Buttons
local mouseBtn = {
    ['left']        = 1,
    ['right']       = 3,

    ['wheelClick']  = 2,
    ['wheelUp']     = 4,    -- Up / Away
    ['wheelDown']   = 5,    -- Down / Towards

    ['slideRight']  = 6,    -- Guess, Not Mappable
    ['slideLeft']   = 7,

    ['back']        = 8,    -- Back / Tab Left
    ['forward']     = 9,    -- Forward / Tab Right

    ['thumb']       = 10    -- Guess, not mappable, non-responsive, other than freezing the mouse
}

-- Desktop
root.buttons(gears.table.join(
    
    awful.button({        }, mouseBtn.right,        -- Open the main menu
        function () 
            mymainmenu:toggle() 
        end),

    awful.button({        }, mouseBtn.wheelUp,      -- Scroll workspaces - right
        awful.tag.viewnext),

    awful.button({        }, mouseBtn.wheelDown,    -- Scroll workspaces - left
        awful.tag.viewprev)
))

local taglist_buttons = gears.table.join(
    
    awful.button({        }, mouseBtn.left,         -- Switch to workspace
        function(t) 
            t:view_only() 
        end),

    awful.button({ modkey }, mouseBtn.left,         -- Move client window to workspace
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),

    awful.button({        }, mouseBtn.right,        -- Peek workspace
        awful.tag.viewtoggle),

    awful.button({ modkey }, mouseBtn.right,        -- Change tag colour code
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),

    awful.button({        }, mouseBtn.wheelUp,      -- Scroll workspaces - right
        function(t) 
            awful.tag.viewnext(t.screen) 
        end),

    awful.button({        }, mouseBtn.wheelDown,    -- Scroll workspaces - left
        function(t) 
            awful.tag.viewprev(t.screen) 
        end)
)

local tasklist_buttons = gears.table.join(
    
    awful.button({        }, mouseBtn.left,         -- Select task
        function (c)
            if c == client.focus then
                -- minimise focused client
                c.minimized = true
            else -- switch client
                c:emit_signal(
                    "request::activate",
                    "tasklist",
                    {raise = true}
                )
            end
        end),

    awful.button({        }, mouseBtn.right,        -- Open menu of current tasks
        function()
            awful.menu.client_list({ theme = { width = 250 } })
        end),

    awful.button({        }, mouseBtn.wheelUp,      -- Scroll tasks - right
        function ()
            awful.client.focus.byidx(1)
        end),

    awful.button({        }, mouseBtn.wheelDown,    -- Scroll tasks - left
        function ()
            awful.client.focus.byidx(-1)
        end)
)

clientbuttons = gears.table.join(
    
    awful.button({        }, mouseBtn.left,         -- Switch to client
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end),

    awful.button({ modkey }, mouseBtn.left,         -- Grab client window
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end),

    awful.button({ modkey }, mouseBtn.right,        -- Resize nearest client anchor
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end)
)


-------------------------------------------------
--                 Key Bindings                --
-------------------------------------------------
globalkeys = gears.table.join(
    -----------------------------------------------------------------
    -- Awesome
    awful.key({ modkey,           }, "s",       -- Key help
        hotkeys_popup.show_help,
        {description="  Show help", group="Awesome"}),

    awful.key({ modkey, "Control" }, "r",       -- Reload awesome
        awesome.restart,
        {description = "  Reload awesome", group = "Awesome"}),

    awful.key({ modkey, "Control" }, "q",       -- Quit awesome
        awesome.quit,
        {description = "  Quit awesome", group = "Awesome"}),

    awful.key({ modkey,           }, "w",       -- Show awesome menu
        function () mymainmenu:show() end,
        {description = "  Show main menu", group = "Awesome"}),

    -----------------------------------------------------------------
    -- Tag / Workspace
    awful.key({ modkey,           }, "Right",   -- Switch Right
        awful.tag.viewnext,
        {description = "  Switch right", group = "Tag"}),

    awful.key({ modkey,           }, "Left",    -- Switch Left
        awful.tag.viewprev,
        {description = "  Switch left", group = "Tag"}),

    awful.key({ modkey,           }, "Escape",  -- Previous Tag
        awful.tag.history.restore,
        {description = "  Go to previous", group = "Tag"}),
    
    -----------------------------------------------------------------
    -- Client Window
    awful.key({ modkey,           }, "j",       -- Focus next
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "  Focus next by index", group = "Client"}),

    awful.key({ modkey,           }, "k",       -- Focus previous
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "  Focus previous by index", group = "Client"}),

    awful.key({ modkey, "Shift"   }, "j",       -- Swap with next
        function () awful.client.swap.byidx(  1)    end,
        {description = "  Swap with next client by index", group = "Client"}),

    awful.key({ modkey, "Shift"   }, "k",       -- Swap with previous
        function () awful.client.swap.byidx( -1)    end,
        {description = "  Swap with previous client by index", group = "Client"}),

    awful.key({ modkey,           }, "u",       -- Jump to urgent
        awful.client.urgent.jumpto,
        {description = "  Jump to urgent client", group = "Client"}),

    awful.key({ modkey,           }, "Tab",     -- Go back
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "  Go to previous", group = "Client"}),

    -----------------------------------------------------------------
    -- Screen
    awful.key({ modkey, "Control" }, "j",       -- Focus next screen
        function () awful.screen.focus_relative( 1) end,
        {description = "  Focus the next screen", group = "Screen"}),
    
    awful.key({ modkey, "Control" }, "k",       -- Focus previous screen
        function () awful.screen.focus_relative(-1) end,
        {description = "  Focus the previous screen", group = "Screen"}),

    -----------------------------------------------------------------
    -- Layout
    awful.key({ modkey,           }, "space",   -- Next Layout
        function () awful.layout.inc( 1) end,
        {description = "  Select next", group = "Layout"}),
    
    awful.key({ modkey, "Shift"   }, "space",   -- Previous Layout
        function () awful.layout.inc(-1) end,
        {description = "  Select previous", group = "Layout"}),
 
    awful.key({ modkey,           }, "h",       -- Master width ++
        function () awful.tag.incmwfact(-0.05) end,
        {description = "  Decrease master width factor", group = "Layout"}),

    awful.key({ modkey,           }, "l",       -- Master width --
        function () awful.tag.incmwfact( 0.05) end,
        {description = "  Increase master width factor", group = "Layout"}),

    awful.key({ modkey, "Shift"   }, "h",       -- Num. Masters ++
        function () awful.tag.incnmaster( 1, nil, true) end,
        {description = "  Increase the number of master clients", group = "Layout"}),

    awful.key({ modkey, "Shift"   }, "l",       -- Num. Masters --
        function () awful.tag.incnmaster(-1, nil, true) end,
        {description = "  Decrease the number of master clients", group = "Layout"}),

    awful.key({ modkey, "Control" }, "h",       -- Num. Columns ++
        function () awful.tag.incncol( 1, nil, true)    end,
        {description = "  Increase the number of columns", group = "Layout"}),

    awful.key({ modkey, "Control" }, "l",       -- Num. Columns --
        function () awful.tag.incncol(-1, nil, true) end,
        {description = "  Decrease the number of columns", group = "Layout"}),

    -----------------------------------------------------------------
    -- Quick Launch
    awful.key({ modkey,           }, "t",       -- Terminal
        function () awful.spawn(settings.terminal) end,
        {description = "  Terminal", group = "Quick Launch"}),
 
    awful.key({ modkey,           }, "b",       -- Firefox
        function() awful.util.spawn('firefox') end,
        {description = "  (browser) Firefox", group = "Quick Launch"}),

    awful.key({ modkey,           }, "m",       -- Thunderbird (Mail)
        function() awful.util.spawn('thunderbird') end,
        {description = "  (mail) Thunderbird", group = "Quick Launch"}),

    awful.key({ modkey,           }, "n",       -- Nautilus (file system)
        function() awful.util.spawn('nautilus') end,
        {description = "  Nautilus", group = "Quick Launch"}),

    awful.key({ modkey,           }, "r",       -- dmenu
        function() awful.util.spawn('dmenu_run') end,
        {description = "  (run) Dmenu", group = "Quick Launch"}),
 
    awful.key({ modkey,           }, "p",       -- Menubar
        function() menubar.show() end,
        {description = "  Menubar", group = "Quick Launch"}),

    awful.key({ modkey,           }, "v",       -- VS Code
        function() awful.util.spawn('code') end,
        {description = "  VS Code", group = "Quick Launch"}),

    awful.key({ modkey,           }, "e",       -- Sublime Text
        function() awful.util.spawn('subl') end,
        {description = "  (editor) Sublime Text", group = "Quick Launch"}),

    awful.key({ modkey,           }, "x",       -- XMind
        function() awful.util.spawn('xmind') end,
        {description = "  XMind", group = "Quick Launch"}),

    -----------------------------------------------------------------
    -- Super Utility
    awful.key({ modkey, "Control" }, "#",       -- Launch Work Environment
        function()
            -- VS Code editor
            awful.util.spawn('code')

            -- Server terminal
            awful.util.spawn(settings.terminal)

            -- Extra editor with sublime
            awful.util.spawn('subl')

            -- Put a browser window in www
            awful.util.spawn('firefox')
        end,
        {description = "  Set to Work", group = "Super Utility"}),


    awful.key({ modkey, "Control" }, '-',       -- Close all windows
        function() 
            for _, c in ipairs(client.get()) do
                c:kill()
            end
        end,
        {description = "  Close all Windows", group = "Super Utility"}),

    awful.key({ modkey, "Control" }, "Escape",  -- Close all and Shutdown
        function()
            for _,c in ipairs(client.get()) do
                c:kill()
            end
            os.execute("shutdown now")
        end,
        {description = "  Ejector Seat", group = "Super Utility"})

    -----------------------------------------------------------------
    -- Remap Arrows
    -- awful.key({ modkey, "Control" }, "k",
    --     root.fake_input('key_press', "Up"),
    --     -- root.fake_input('key_release', "Up"),
    --     {description = "Use Vim movement keys"}),

    -- awful.key({ modkey, "Control" }, "j",
    --     function()
    --         -- down
    --     end,
    --     {description = "Use Vim movement keys"}),

    -- awful.key({ modkey, "Control" }, "h",
    --     function()
    --         -- left
    --     end,
    --     {description = "Use Vim movement keys"}),

    -- awful.key({ modkey, "Control" }, "l",
    --     function()
    --         -- right
    --     end,
    --     {description = "Use Vim movement keys"})

)
-----------------------------------------------------------
-- Add workspace keys
for i = 1, #settings.tag_names do
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey            }, "#" .. i + 9,     -- Switch to < i >
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "  Switch to #" .. i, group = "Tag"}),
       
        awful.key({ modkey, "Control" }, "#" .. i + 9,     -- Peek at < i >
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "  Peek at #" .. i, group = "Tag"}),
        
        awful.key({ modkey, "Shift"   }, "#" .. i + 9,     -- Move client to < i >
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "  Throw client to #"..i, group = "Tag"}))
end


-- Bind global keys
root.keys(globalkeys)


clientkeys = gears.table.join(
    awful.key({ modkey,           }, "Up",      -- Maximise
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "  (un)maximize", group = "Client"}),

    awful.key({ modkey, "Control" }, "Up",      -- Fullscreen
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "  Toggle fullscreen", group = "Client"}),

    -- awful.key({ modkey, "Shift"   }, "i",        -- Vertical maximise
    --     function (c)
    --         c.maximized_vertical = not c.maximized_vertical
    --         c:raise()
    --     end ,
    --     {description = "(un)maximize vertically", group = "Client"}),
    -- awful.key({ modkey, "Control" }, "i",        -- Horizontal maximise
    --     function (c)
    --         c.maximized_horizontal = not c.maximized_horizontal
    --         c:raise()
    --     end ,
    --     {description = "(un)maximize horizontally", group = "Client"}),

    awful.key({ modkey,           }, "q",       -- Close
        function (c) c:kill() end,
        {description = "  Close", group = "Client"}),

    awful.key({ modkey,           }, "f",       -- Float
        awful.client.floating.toggle,
        {description = "  Toggle floating", group = "Client"}),
    
    awful.key({ modkey,           }, "Return",  -- Move to Master
        function (c) c:swap(awful.client.getmaster()) end,
        {description = "  Move to master", group = "Client"}),

    awful.key({ modkey, "Control" }, "Return",  -- Keep on top
        function (c) c.ontop = not c.ontop end,
        {description = "  Toggle keep on top", group = "Client"}),

    -- Minimise
    -- awful.key({ modkey,           }, "Down", -- minimise
    --     function (c)
    --         -- The client currently has the input focus, so it cannot be
    --         -- minimized, since minimized clients can't have the focus.
    --         c.minimized = true
    --     end ,
    --     {description = "minimize", group = "Client"}),

    -- awful.key({ modkey, "Control" }, "n",
    -- function ()
    --     local c = awful.client.restore()
    --     -- Focus restored client
    --     if c then
    --       c:emit_signal(
    --           "request::activate", "key.unminimize", {raise = true}
    --       )
    --     end
    -- end,
    -- {description = "restore minimized", group = "Client"}),

    -- UNUSED - Only use single screen
    awful.key({ modkey,           }, "o",       -- Move to screen
        function (c) c:move_to_screen() end,
        {description = "  Move to screen", group = "Client"})
)


-------------------------------------------------
--                    Rules                    --
-------------------------------------------------
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- Apply to all clients
    {
        rule = { },
        properties = { 
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            size_hints_honor = false,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },
    -- Always Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",  -- kalarm.
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        }, 
        properties = { floating = true }
    },

    -- Add titlebars inline with settings
    { 
        rule_any = {type = { "normal", "dialog" }}, 
        properties = { titlebars_enabled = settings.show_titlebars }
    }
}


-------------------------------------------------
--                   Signals                   --
-------------------------------------------------
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Put new window at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Titlebars are disabled in rules
-- but configure as a contingency
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )
    -- titlebar layout
    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Client focus changes borders
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Manage connections by clicking wifi name
mywidgets.wifiName:connect_signal("button::press", function(self) awful.spawn(settings.terminal .. " -e nmtui") end) 


-------------------------------------------------
--                 Setup Screen                --
-------------------------------------------------


-- Includes binding buttons for the top bar
awful.screen.connect_for_each_screen(function(s)

    awful.tag(settings.tag_names, s, awful.layout.layouts[1])
    
    -------------------------------------------------
    --                  Layouts                     --
    -------------------------------------------------
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        -- Click cycle
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        -- Scroll cycle
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -------------------------------------------------
    --                  Taglist                    --
    -------------------------------------------------
    s.mytaglist = myTheme.taglist(s, taglist_buttons)

    -------------------------------------------------
    --                  Tasklist                   --
    -------------------------------------------------
    s.mytasklist = myTheme.tasklist(s, tasklist_buttons)

    -------------------------------------------------
    --                Compose Bar                  --
    -------------------------------------------------
    s.wibar = myTheme.statusbar(s)
    
end)
