local rb = require("rootbeer")

rb.profile.define({
  strategy = "command",
  profiles = {
    -- Iru is endpoint security for work
    work = { "iru" },
    personal = {},
  },
})

require("modules.git")
require("modules.ripgrep")
require("modules.ssh")
require("modules.zsh.config")
require("modules.secrets")
require("modules.ghostty.config")
require("modules.nvim.config")
require("modules.mise.config")

if rb.host.os == "macos" then
  require("modules.brew")
  require("modules.aerospace.config")
  require("modules.macos.config")
end

-- Ensure after setup we use SSH for git operations
rb.remote("git@github.com:tale/dotfiles.git")
