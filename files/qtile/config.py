import distro
import os
import random
import shutil
import subprocess

from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

# from libqtile.log_utils import logger

mod = "mod4"
terminal = "kitty"
browser = "firefox"  # qutebrowser?
font = "Ubuntu"
nerdfont = "Ubuntu Mono 11"
fontsize = 11

# TODO
# 0) Notification server
# 2) keymaps
#    - browser
#    - launcher
# 3) application launcher (dmenu?)
# 4) bar layout
# 6) Some apps should not be tiled, eg. VirtualBox, ++
# 8) Theme
#    - put colorscheme and stuff here
#    - rounded corners
#    - layout
#    - font
# 9) Screen lock
# 10) Power management?
# BUG?
# - if dotfiles are pulled, then qtile won't start. I suspect bashrc isn't loaded properly
#   - maybe due to some dependency error?

# --- Custom functions (TODO: move into separate module)


def get_wallpaper():
    path = os.path.expanduser("~/.local/share/backgrounds/wallpapers/nord")
    # TODO: impl backup if directory does not exist
    wallpapers = os.listdir(path)
    index = random.randint(0, len(wallpapers) - 1)
    return f"{path}/{wallpapers[index]}"


# Used by CheckUpdates widget
def get_distro():
    name = distro.name()
    if name == "Arch Linux":
        return "Arch_checkupdates"
    return name


def colorscheme():
    return [
        ["#2e3440", "#2e3440"],  # nord0
        ["#2e3440", "#2e3440"],  # nord0
        ["#3b4252", "#3b4252"],  # nord1
        ["#434c5e", "#434c5e"],  # nord2
        ["#4c566a", "#4c566a"],  # nord3
        ["#d8dee9", "#d8dee9"],  # nord4
        ["#e5e9f0", "#e5e9f0"],  # nord5
        ["#eceff4", "#eceff4"],  # nord6
        ["#8fbcbb", "#8fbcbb"],  # nord7
        ["#88c0d0", "#88c0d0"],  # nord8
        ["#81a1c1", "#81a1c1"],  # nord9
        ["#5e81ac", "#5e81ac"],  # nord10
        ["#bf616a", "#bf616a"],  # nord11
        ["#d08770", "#d08770"],  # nord12
        ["#ebcb8b", "#ebcb8b"],  # nord13
        ["#a3be8c", "#a3be8c"],  # nord14
        ["#b48ead", "#b48ead"],  # nord15
    ]


def init_layout_theme():
    return {
        "margin": 8,
        "border_width": 1,
        "border_focus": "#88c0d0",
        "border_normal": "#4c566a",
    }


# --- End custom functions

# A list of available commands that can be bound to keys can be found
# at https://docs.qtile.org/en/latest/manual/config/lazy.html
keys = [
    # Essentials
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "d", lazy.spawn("dmenu_run -i -nb '#2E3440' -sf '#2E3440' -sb '#88C0D0' -nf '#88C0D0' -fn 'Ubuntu:bold:pixelsize=12'"), desc="Launch dmenu"),
    Key([mod], "b", lazy.spawn(browser), desc="Launch browser"),
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Window management
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # TODO: Screen/monitor management
    # - Move focused window to other screen and focus that window
    # - Move focus to other screen
    # Layout management
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),

    # multiple stack panes ... what's this?
    Key([mod, "shift"], "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
        ),
    # Other
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]

groups = [
    Group("", layout="monadtall"),
    Group("", layout="max", matches=[Match(wm_class=["firefox", "chromium", "brave"])]),
    Group("", layout="monadtall", matches=[Match(wm_class=["emacs", "code"])]),
    Group("", layout="monadtall", matches=[Match(wm_class=["qpdfview", "thunar", "pcmanfm", "nautilus"])]),
    Group("", layout="max"),
    Group("", layout="max", matches=[Match(wm_class=["spotify"])]),
    Group("", layout="max"),  # virtualbox?
]

for i, g in zip(["1", "2", "3", "4", "5", "6", "7"], groups):
    keys.append(Key([mod], i, lazy.group[g.name].toscreen(), desc=f"Switch to group {g.name}"))
    keys.append(Key([mod, "shift"], i, lazy.window.togroup(g.name, switch_group=True), desc=f"Switch to & move focused window to group {g.name}"))


check_updates_distro = get_distro()
colors = colorscheme()
layout_theme = init_layout_theme()

layouts = [
    # layout.Columns(border_focus_stack=['#d75f5f', '#8f3d3d'], border_width=4),
    layout.Max(**layout_theme),
    # layout.Stack(num_stacks=2, **layout_theme),
    layout.Bsp(**layout_theme),
    layout.Matrix(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Tile(**layout_theme),
    # layout.TreeTab(
    #    sections=['FIRST', 'SECOND'],
    #    bg_color='#3b4252',
    #    active_bg='#bf616a',
    #    inactive_bg='#a3be8c',
    #    padding_y=5,
    #    section_top=10,
    #    panel_width=280
    # ),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font=font, fontsize=fontsize, padding=3, background=colors[1], foreground=colors[5]
)
extension_defaults = widget_defaults.copy()

# TODO: remove?
separator = widget.Sep(
    background=colors[1],  # #2e3440
    foreground=colors[5],  # #d8dee9
    linewidth=1,
    padding=10,
)


screens = [
    Screen(
        wallpaper=get_wallpaper(),
        wallpaper_mode="fill",
        top=bar.Bar(
            [
                widget.GroupBox(
                    active=colors[5],
                    block_highlight_text_color=colors[9],
                    borderwidth=2,
                    disable_drag=True,
                    font=font,
                    fontsize=fontsize,
                    hide_unused=False,
                    highlight_method="line",
                    highlight_color=["2e3440", "4c566a"],  # when usnig "line" method
                    inactive=colors[3],
                    margin_x=0,
                    margin_y=3,
                    padding_x=5,
                    padding_y=8,
                    rounded=False,
                    this_current_screen_border=colors[9],
                    urgent_alert_method="line",
                ),
                widget.Prompt(
                    background=colors[1],
                    font=font,
                    fontsize=fontsize,
                    foreground=colors[6],
                ),
                widget.Spacer(),
                widget.TextBox(
                    background=colors[1],
                    font=nerdfont,
                    fontsize=fontsize,
                    foreground=colors[6],
                    padding=0,
                    text=" ",
                ),
                widget.ThermalSensor(
                    background=colors[1],
                    font=font,
                    fontsize=fontsize,
                    foreground=colors[6],
                    update_interval=2,
                ),
                widget.TextBox(
                    background=colors[1],
                    font=nerdfont,
                    fontsize=fontsize,
                    foreground=colors[6],
                    padding=0,
                    text=" ",
                ),
                widget.Memory(
                    background=colors[1],
                    font=font,
                    fontsize=fontsize,
                    foreground=colors[6],
                    format="{MemUsed: .0f}{mm}",
                    update_interval=1.0,
                ),
                widget.TextBox(
                    background=colors[1],
                    font=nerdfont,
                    fontsize=fontsize,
                    foreground=colors[6],
                    padding=0,
                    text=" ",
                ),
                widget.CPU(
                    background=colors[1],
                    font=font,
                    fontsize=fontsize,
                    foreground=colors[6],
                    format="CPU {load_percent}%",
                    update_interval=1,
                ),
                widget.TextBox(
                    background=colors[1],
                    font=nerdfont,
                    fontsize=fontsize,
                    foreground=colors[6],
                    padding=0,
                    text="  ",
                ),
                widget.Net(
                    background=colors[1],
                    font=font,
                    fontsize=fontsize,
                    foreground=colors[5],
                    format="{interface}: {down} ↓ ",
                    interface="all",
                    padding=0,
                ),
                widget.CheckUpdates(
                    update_interval=1800,
                    distro=check_updates_distro,
                    display_format="Updates: {updates} ",
                    foreground=colors[5],
                    colour_have_updates=colors[5],
                    colour_no_updates=colors[5],
                    padding=5,
                    background=colors[0],
                ),
                widget.Clock(
                    background=colors[1],
                    font=font,
                    fontsize=fontsize,
                    foreground=colors[6],
                    format="%a %b %d, %H:%M",
                ),
            ],
            22,
            opacity=0.9,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True


@hook.subscribe.restart
def cleanup():
    shutil.rmtree(os.path.expanduser("~/.config/qtile/__pycache__"))


@hook.subscribe.shutdown
def killall():
    shutil.rmtree(os.path.expanduser("~/.config/qtile/__pycache__"))
    # TODO -- Popen shutdown processes


# @hook.subscribe.startup_once
# def start_once():
#     home = os.path.expanduser('~')
#     subprocess.call([home + '/.config/qtile/autostart.sh'])


@hook.subscribe.startup
def start_always():
    subprocess.Popen(["/usr/bin/xset", "r", "rate", "200", "40"])


# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
