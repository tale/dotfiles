local rb = require("rootbeer")

rb.packages({
  "age@1.3.1",
  "fd@10.4.2",
  "curl",
  "fzf",
  "git",
  "gh",
  "delta",
  "git-lfs",
  "jq",
  "lsd",
  "make",
  "mise",
  "neovim",
  "op",
  "prtui",
  "rage",
  "ripgrep",
  "rsync",
  "stylua",
  "tree-sitter",
  "uv",
  "xz",
  "yq",
})

if rb.host.os == "macos" then
  rb.packages({ "bobrwm" })
end
