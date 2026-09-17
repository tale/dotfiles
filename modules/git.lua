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
    allowed_signers = { "git@tale.me", "atale@spear.ai" },
  },
  lfs = true,
  pull_rebase = true,
  merge_conflictstyle = "zdiff3",
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
  },
  extra = {
    delta = {
      features = "color-only",
      ["zero-style"] = "dim syntax",
    },
    interactive = {
      diffFilter = "delta --color-only",
    },
    rerere = {
      enabled = true,
      autoUpdate = true,
    },
    rebase = {
      autoStash = true,
      autoSquash = true,
      updateRefs = true,
    },
    fetch = {
      prune = true,
      pruneTags = true,
    },
    diff = {
      algorithm = "histogram",
      colorMoved = "default",
      mnemonicPrefix = true,
      renames = "copies",
    },
    tag = { sort = "-version:refname" },
    branch = { sort = "-committerdate" },
    column = { ui = "auto" },
    init = { defaultBranch = "main" },
    push = { followTags = true },
  },
})
