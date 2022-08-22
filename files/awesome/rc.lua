--       █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗
--      ██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝
--      ███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗
--      ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝
--      ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗
--      ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

-- TODO review
-- 0) Get list of all dependencies (i.e. xbacklight, pavucontrol, etc..)
-- 1) keybindings (remove unused, apply better keys, etc..)
-- 2) battery widget 
-- 3) volume widget (extend with mute speaker -- and attach keybinding)
-- TODO cleanup
-- 1) Go back to single rc.lua file if folding is fixed
-- TODO features
-- 0) Widgets from streetturtle/awesome-wm-widgets
--    - brightness
--      -- See redshift
--      -- Could use xrandr + https://awesomewm.org/doc/api/classes/screen.html
--      -- Also look at: https://www.reddit.com/r/archlinux/comments/fopuht/comment/flguaep/
--    - todo
--    - clock/calendar
--    - logout
--    - cpu
--    - ram
-- 1) Conky
-- 2) Xorg monitor config? is this recommended for dynamic setups?
-- 3) Use dmenu or rofi scripts to save keybindings?
-- 4) Create a battery widget
--    - See https://github.com/ChrisTitusTech/titus-awesome/blob/8dfe3e37b651f6fce1bf2a3bfe535cf7cf85d751/widget/battery/init.lua
--    - Requires installing xfce4-power-manager (is this the best alternative? What about TLP? See Arch wiki for ideas)
-- 5) Automatic screen lock (see sway config for ideas)
--    - Possible to use login manager?
--    - Currently using i3lock
-- 6) Dynamic tags (create tags on demand, rather than having a predefined set)
-- 7) Rofi application launcher
--     - Want a drop-down list in the upper left corner
-- 8) Dynamic monitor configuration (multihead) -- xrandr vs autorandr vs mons vs xorg conf
  -- NOTE:
  -- The current impl of xrandr.lua works fine in terms of enabling screens on demand
  -- but it doesn't seem to work very well with compton. I.e. transparency not working, text still visible in background when typing.
  -- The only workaround for now is reloading awesome config (ctrl + super + r) after changing the screen layout 
  -- Maybe I'm missing some essential code in the rc.lua when screen/monitor geometry/setup changes
  -- Maybe reload awesome config in the xrandr command.
  -- NOTE:
  -- Should awesome wm even handle multi-head setup? Doesn't seem like the best solution so far
-- 9) Adjust screen brightness on active screen/monitor
--    - Can be solved with a keybinding?
-- 10) Floating applications
--     - VirtualBox
--     - VPN clients (FortiNet, NetExtender)
-- 11) Sound/microphone setup -- TODO (This is blocking me from using awesome WM at work)
--     - Figure out why my BLE headset/mic doesn't work on linux (i.e. youtube is open, but not playing, then I cant switch to phone)
-- TODO issues
-- 1) Using xset in autostart doesnt seem to persist between locked screen
-- 3) Screen tearing (compton issue?)
--    - Occurs when reloading rc.lua and changing tags
--    - Use different backend?

-- Awesome libraries
local gears = require("gears")
local awful = require("awful")
              require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")

-- User specific settings
local keys = require("user.keys")
local vars = require("user.variables")

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), vars.theme))

-- User specific widgets
local battery_widget = require("widget.battery")
local volume_widget = require("widget.volume")
local todo_widget = require("widget.todo")

-- {{{ Layout
awful.layout.layouts = {
  awful.layout.suit.tile,
}
-- }}}

-- {{{ Menu
menubar.utils.terminal = vars.terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({        }, 1, function(t) t:view_only() end),
  awful.button({ vars.modkey }, 1,
    function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end
  ),
  awful.button({        }, 3, awful.tag.viewtoggle),
  awful.button({ vars.modkey }, 3,
    function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end
  ),
  awful.button({        }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({        }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.screen.connect_for_each_screen(function(s)
  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mytaglist,
    },
    nil, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      todo_widget(),
      volume_widget(),
      battery_widget(),
      wibox.widget.systray(),
      wibox.widget.textclock(),
    },
  }
end)
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
-- TODO: What's the difference between awful.util.spawn and awful.spawn.with_shell?
awful.spawn.with_shell(vars.compositor)
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("blueman-applet")
awful.spawn.with_shell("feh --randomize --bg-fill " .. vars.wallpapers)
awful.spawn.with_shell("xset r rate 200 30")  -- TODO: Consider using xorg conf file for this
