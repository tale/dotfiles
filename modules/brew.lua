local brew = require("rootbeer.brew")
local profile = require("rootbeer.profile")

local common_casks = {
  "1password",
  "1password-cli",
  "aldente",
  "bartender",
  "betterdisplay",
  "brave-browser",
  "cleanshot",
  "datagrip",
  "font-input",
  "ghostty",
  "imageoptim",
  "logi-options+",
  "nikitabobko/tap/aerospace",
  "notion-calendar",
  "orbstack",
  "postman",
  "raycast",
  "slack",
  "spotify",
}

local extra_casks = profile.select({
  personal = {
    "craft",
    "discord",
    "modrinth",
    "signal",
    "soulver",
    "steam",
    "tailscale-app",
    "the-unarchiver",
    "zoom",
  },
  work = {
    "linear-linear",
    "notion",
    "notion-mail",
  },
})

local casks = table.move(common_casks, 1, #common_casks, 1, extra_casks)

brew.config({
  formulae = {
    "chezmoi",
    "xz",
    "curl",
    "fzf",
    "git",
    "git-delta",
    "git-lfs",
    "jq",
    "lsd",
    "make",
    "mise",
    "mkcert",
    "opencode",
    "ripgrep",
    "rsync",
    "telnet",
    "wget",
    "yq",
  },
  casks = casks,
  mas = profile.select({
    default = nil,
    personal = {
      { name = "Streaks", id = 963034692 },
      { name = "Things", id = 904280696 },
      { name = "Xcode", id = 497799835 },
    },
  }),
})
