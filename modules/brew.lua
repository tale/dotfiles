local brew = require("rootbeer.brew")
local profile = require("rootbeer.profile")
local rb = require("rootbeer")

local common_casks = {
  "1password",
  "aldente",
  "bartender",
  "betterdisplay",
  "cleanshot",
  "datagrip",
  "helium-browser",
  "imageoptim",
  "logi-options+",
  "notion-calendar",
  "orbstack",
  "raycast",
  "slack",
  "spotify",
}

local extra_casks = profile.select({
  personal = {
    "discord",
    "modrinth",
    "soulver",
    "steam",
    "tailscale-app",
    "the-unarchiver",
    "zoom",
  },
  work = {
    "linear",
    "notion",
    "notion-mail",
  },
})

local casks =
  table.move(extra_casks, 1, #extra_casks, #common_casks + 1, common_casks)

brew.config({
  casks = casks,
  mas = profile.select({
    default = {},
    personal = {
      { name = "Things", id = 904280696 },
      { name = "Xcode", id = 497799835 },
    },
  }),
})

if not rb.path_exists("~/.local/share/gh/extensions/gh-stack") then
  rb.exec("sh", {
    "-c",
    '. "$1"; exec gh extension install github/gh-stack',
    "rootbeer-gh",
    rb.env_export("sh"),
  })
end
