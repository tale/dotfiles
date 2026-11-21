local profile = require("rootbeer.profile")
local rb = require("rootbeer")

-- 1Password comes from `rb use 1password`, since applying this config reads
-- secrets through it.
rb.packages({
  "aldente",
  "bartender",
  "betterdisplay",
  "cleanshot",
  "datagrip",
  "helium",
  "linear",
  "notion-calendar",
  "orbstack",
  "slack",
  "spotify",
  "tinycast",
})

rb.packages(profile.select({
  personal = {
    "copilot-money",
    "discord",
    "google-chrome",
    "soulver",
    "steam",
    "the-unarchiver",
  },
  work = {
    "notion",
  },
}))
