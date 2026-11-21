local brew = require("rootbeer.brew")
local profile = require("rootbeer.profile")
local rb = require("rootbeer")

-- These need a system installer, so rb can't install them as apps.
brew.config({
  casks = profile.select({
    default = { "logi-options+" },
    personal = { "logi-options+", "tailscale-app" },
  }),
})

-- TODO: Install Things.app on personal macOS
if not rb.path_exists("~/.local/share/gh/extensions/gh-stack") then
  rb.exec("sh", {
    "-c",
    '. "$1"; exec gh extension install github/gh-stack',
    "rootbeer-gh",
    rb.env_export("sh"),
  })
end
