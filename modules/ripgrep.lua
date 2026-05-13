local rb = require("rootbeer")

rb.file(
  "~/.config/ripgrep/rc",
  [[
--hidden
--glob=!.git
]]
)
