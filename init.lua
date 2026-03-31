local rb = require("rootbeer")

require("modules.git")
require("modules.ssh")
require("modules.zsh")
require("modules.secrets")
require("modules.ghostty.config")
require("modules.nvim.config")
require("modules.mise.config")

if rb.host.os == "macos" then
  require("modules.brew")
  require("modules.aerospace.config")
  require("modules.macos.config")
end
