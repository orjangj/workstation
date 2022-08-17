--       █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗
--      ██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝
--      ███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗
--      ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝
--      ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗
--      ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

-- TODO
-- 2) Keybindings
  -- Vim and arrow keybindings when navigating between windows
  -- Browser launcher
  -- i3 like bindings
  -- Lock screen (see point 18)
-- 3) Cleanup/organize code
  -- configuration folder <-- all awesome configurations goes here
  -- compontents folder <-- all components goes here (i.e. xrandr?)
-- 4) Polybar vs customizing awesome bar?
-- 7) Screen tearing (not sure if it's due to running inside VirtualBox)
  -- Occurs when reloading rc.lua
-- 8) Dynamic tags (workspaces)
-- 12) Use rofi as application launcher
-- 13) Device configurations
  -- touchpad inverted scroll
  -- touchpad tap
  -- mouse/touchpad sensitivity
  -- scroll (and sensitivity) when holding down arrows or h,j,k,l
-- 16) Fonts used by Awesome
-- 17) Holding down up,down or j,k does not scroll
-- 18) Lock screen -- sddm? Or something else? Some people use i3-lock, but I would rather use sddm if that's possible.
-- 19) xrandr vs autorandr
  -- NOTE:
  -- The current impl of xrandr.lua works fine in terms of enabling screens on demand
  -- but it doesn't seem to work very well with compton. I.e. transparency not working, text still visible in background when typing.
  -- The only workaround for now is reloading awesome config (ctrl + super + r) after changing the screen layout 
  -- Maybe I'm missing some essential code in the rc.lua when screen/monitor geometry/setup changes
  -- Maybe reload awesome config in the xrandr command.
  -- NOTE:
  -- Should awesome wm even handle multi-head setup? Doesn't seem like the best solution so far
-- 20) Learn essential navigation
  -- Move between windows in same tag
  -- Move between tags
  -- Move between active monitors (not sure if necessary if using shared tags between displays)
-- 21) Adjust screen brightness on active screen/monitor
-- 22) Systray (nm-applet, bluetooth (headset), cpu usage, temp, battery, etc..)
-- 23) Icons
-- 24) Floating applications
  -- VirtualBox
  -- VPN clients (FortiNet, NetExtender)
-- 25) Sound/microphone setup -- TODO (This is blocking me from using awesome WM at work)
-- 26) Border color around active window (i.e. around terminal emulator)
   -- Add colorizer to nvim to view theme colors more easily
-- 27) Why does firefox always pop up on tag nr 2? Why cant it tile on e.g. tag 1?

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
              require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")

local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- User specific libraries
local keys = require("user.keys")
local vars = require("user.variables")

beautiful.init(
  string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), vars.theme)
)

-- {{{ Layout 
awful.layout.layouts = {
  awful.layout.suit.tile,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual", vars.terminal .. " -e man awesome" },
  { "edit config", vars.terminal .. " -e " .. vars.editor .. " " .. awesome.conffile },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end },
}

local mymainmenu = awful.menu({
  items = {{ "awesome", myawesomemenu, beautiful.awesome_icon }, { "open terminal", vars.terminal }}
})

-- Menubar configuration
menubar.utils.terminal = vars.terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({        }, 1, function(t) t:view_only() end),
  awful.button({ vars.modkey }, 1, function(t)
                                if client.focus then
                                  client.focus:move_to_tag(t)
                                end
                              end),
  awful.button({        }, 3, awful.tag.viewtoggle),
  awful.button({ vars.modkey }, 3, function(t)
                                if client.focus then
                                  client.focus:toggle_tag(t)
                                end
                              end),
  awful.button({        }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({        }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
   awful.button({ }, 1, function (c)
                          if c == client.focus then
                            c.minimized = true
                          else
                            c:emit_signal(
                              "request::activate",
                              "tasklist",
                              {raise = true}
                            )
                          end
                        end),
   awful.button({ }, 3, function()
                          awful.menu.client_list({ theme = { width = 250 } })
                        end),
   awful.button({ }, 4, function ()
                          awful.client.focus.byidx(1)
                        end),
   awful.button({ }, 5, function ()
                          awful.client.focus.byidx(-1)
                        end)
)

awful.screen.connect_for_each_screen(function(s)
  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)
  ))

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons
  }

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      mykeyboardlayout,
      wibox.widget.systray(),
      mytextclock,
      s.mylayoutbox,
    },
  }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({ }, 3, function () mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
local clientbuttons = gears.table.join(
  awful.button({ }, 1, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
  end),
  awful.button({ vars.modkey }, 1, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.move(c)
  end),
  awful.button({ vars.modkey }, 3, function (c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(keys.global)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = keys.client,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen
    }
  },

  -- Floating clients.
  { rule_any = {
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

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
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

  { rule = { class = vars.terminal }, properties = { opacity = vars.terminal_opacity } },

  -- Not sure why this rule is required for firefox to make it tile properly
  --{ rule = { class = "firefox" }, properties = { opacity = 1, maximized = false, floating = false } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Autostart
awful.util.spawn(vars.compositor)
awful.spawn.with_shell("feh --randomize --bg-fill " .. vars.wallpapers)

