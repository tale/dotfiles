local git = require("rootbeer.git")
local profile = require("rootbeer.profile")
local rb = require("rootbeer")

git.config({
  user = {
    name = "Aarnav Tale",
    email = profile.select({
      default = "git@tale.me",
      work = "atale@spear.ai",
    }),
  },
  editor = "nvim",
  pager = "delta",
  signing = {
    key = rb.secret.op("op://Development/GitHub Key/public key"),
    format = "ssh",
  },
  lfs = true,
  pull_rebase = true,
  merge_conflictstyle = "diff3",
  ignores = {
    ".DS_Store",
    ".AppleDouble",
    ".LSOverride",
    "Icon",
    "._*",
    ".DocumentRevisions-V100",
    ".fseventsd",
    ".Spotlight-V100",
    ".TemporaryItems",
    ".Trashes",
    ".VolumeIcon.icns",
    ".com.apple.timemachine.donotpresent",
    ".AppleDB",
    ".AppleDesktop",
    "Network Trash Folder",
    "Temporary Items",
    ".apdisk",
    "*~",
    ".fuse_hidden*",
    ".directory",
    ".Trash-*",
    ".nfs*",
  },
  extra = {
    delta = {
      features = "color-only",
      ["zero-style"] = "dim syntax",
    },
    interactive = {
      diffFilter = "delta --color-only",
    },
  },
})
