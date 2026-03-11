local mac = require("rootbeer.mac")
local profile = require("rootbeer.profile")
local rb = require("rootbeer")

rb.link_file(
  "modules/macos/1password-agent.toml",
  "~/.config/1Password/ssh/agent.toml"
)

if not rb.path_exists("~/.config/1Password/agent.sock") then
  rb.link(
    "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock",
    "~/.config/1Password/agent.sock"
  )
end

mac.defaults({
  {
    domain = "NSGlobalDomain",
    key = "NSWindowShouldDragOnGesture",
    type = "bool",
    value = true,
  },
  {
    domain = "NSGlobalDomain",
    key = "NSAutomaticWindowAnimationsEnabled",
    type = "bool",
    value = false,
  },
  {
    domain = "NSGlobalDomain",
    key = "AppleFontSmoothing",
    type = "int",
    value = 1,
  },
  {
    domain = "com.apple.menuextra.clock",
    key = "ShowSeconds",
    type = "bool",
    value = true,
  },
  {
    domain = "com.apple.spaces",
    key = "spans-displays",
    type = "bool",
    value = true,
  },
  {
    domain = "com.apple.dock",
    key = "expose-group-apps",
    type = "bool",
    value = true,
  },
})

mac.dock({
  autohide = true,
  autohide_delay = 1000.0,
})

mac.hot_corners({
  top_left = "notification_center",
  top_right = "notification_center",
  bottom_left = "launchpad",
  bottom_right = "launchpad",
})

mac.finder({
  show_path_bar = true,
  show_status_bar = true,
})

profile.when("personal", function()
  mac.hostname({ name = "Aarnavs-MBP" })
  mac.touch_id_sudo()

  if not rb.path_exists("~/.amp/bin/amp") then
    rb.exec(
      "bash",
      { "-c", "curl -fsSL https://ampcode.com/install.sh | bash" }
    )
  end
end)
