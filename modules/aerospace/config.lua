local profile = require("rootbeer.profile")
local rb = require("rootbeer")

local file = profile.select({
  personal = "modules/aerospace/personal.toml",
  work = "modules/aerospace/work.toml",
})

rb.link_file(file, "~/.config/aerospace/aerospace.toml")
