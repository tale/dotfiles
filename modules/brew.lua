local brew = require("rootbeer.brew")
local profile = require("rootbeer.profile")

local common_casks = {
  "1password",
  "1password-cli",
  "aldente",
  "betterdisplay",
  "cleanshot",
  "datagrip",
  "font-iosevka-ss14",
  "ghostty",
  "helium-browser",
  "imageoptim",
  "logi-options+",
  "nikitabobko/tap/aerospace",
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
    "fantastical",
    "modrinth",
    "soulver",
    "steam",
    "tailscale-app",
    "the-unarchiver",
    "zoom",
  },
  work = {
    "linear-linear",
    "notion",
    "notion-calendar",
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
    "neovim",
    "ripgrep",
    "rsync",
    "telnet",
    "wget",
  },
  casks = casks,
  mas = profile.select({
    default = {},
    personal = {
      { name = "Things", id = 904280696 },
      { name = "Xcode", id = 497799835 },
    },
  }),
})
