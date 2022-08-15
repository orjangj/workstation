local variables = {
  altkey = "Mod1",
  browser = "firefox",
  compositor = "compton -b",
  editor = os.getenv("EDITOR") or "nvim",
  modkey = "Mod4",
  terminal = "kitty",
  terminal_opacity = 0.90,
  theme = "nord",
  wallpapers = os.getenv("HOME") .. "/.local/share/backgrounds/nordic-wallpapers/wallpapers",
}

return variables
