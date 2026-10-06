local rb = require("rootbeer")

local config = rb.read_file("modules/rex/init.lua")
config = config:gsub('"@fzf@"', function()
  return string.format("%q", rb.bin_path("fzf"))
end)

rb.file("~/.config/rex/init.lua", config)
