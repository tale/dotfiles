local rb = require("rootbeer")
local ssh = require("rootbeer.ssh")

local includes = { "~/.ssh/private.config" }
if rb.path_exists("~/.orbstack/ssh/config") then
  table.insert(includes, 1, "~/.orbstack/ssh/config")
end

ssh.config({
  includes = includes,
  hosts = {
    ["*"] = {
      IdentityAgent = "SSH_AUTH_SOCK",
      ForwardAgent = "yes",
      Compression = "yes",
      ServerAliveInterval = 0,
      ServerAliveCountMax = 3,
      HashKnownHosts = false,
      UserKnownHostsFile = "~/.ssh/known_hosts",
      ControlMaster = "auto",
      ControlPath = "/tmp/ssh-%C",
      ControlPersist = "yes",
    },
  },
})
