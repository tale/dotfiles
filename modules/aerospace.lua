local profile = require("rootbeer.profile")
local rb = require("rootbeer")

--- Builds an `on-window-detected` entry matching a single app id.
--- @param app_id string
--- @param run string|string[]
local function rule(app_id, run)
  return { ["if"] = { ["app-id"] = app_id }, run = run }
end

-- Rules shared by every profile.
local common_rules = {
  rule("com.mitchellh.ghostty", {
    "layout floating",
    "move-node-to-workspace 1",
    "fullscreen",
  }),
  rule("net.imput.helium", "move-node-to-workspace 2"),
  rule("com.cron.electron", "move-node-to-workspace A"),
  rule("com.spotify.client", "move-node-to-workspace S"),
  rule("com.1password.1password", "layout floating"),
  rule("com.apple.finder", "layout floating"),
  {
    ["if"] = {
      ["app-id"] = "com.apple.systempreferences",
      ["app-name-regex-substring"] = "settings",
      ["window-title-regex-substring"] = "substring",
    },
    run = "layout floating",
  },
}

-- The only thing that differs between machines: which apps go where.
local profile_rules = profile.select({
  work = {
    rule("com.tinyspeck.slackmacgap", "move-node-to-workspace 3"),
    rule("com.linear", "move-node-to-workspace 4"),
    rule("notion.id", "move-node-to-workspace S"),
    rule("notion.mail.id", "move-node-to-workspace D"),
  },
  personal = {
    rule("com.hnc.Discord", "move-node-to-workspace 3"),
    rule("com.apple.mail", "move-node-to-workspace D"),
    rule("com.apple.MobileSMS", "layout floating"),
    rule("com.culturedcode.ThingsMac", "layout floating"),
    rule("com.valvesoftware.steam.helper", "layout tiling"),
  },
})

local rules = {}
for _, r in ipairs(common_rules) do
  rules[#rules + 1] = r
end
for _, r in ipairs(profile_rules) do
  rules[#rules + 1] = r
end

local config = {
  ["start-at-login"] = true,
  gaps = {
    inner = { horizontal = 4, vertical = 4 },
    outer = { left = 4, right = 4, bottom = 4, top = 4 },
  },
  mode = {
    main = {
      binding = {
        ["alt-h"] = "focus left",
        ["alt-j"] = "focus down",
        ["alt-k"] = "focus up",
        ["alt-l"] = "focus right",

        ["alt-minus"] = "resize smart -50",
        ["alt-equal"] = "resize smart +50",
        ["alt-shift-equal"] = "balance-sizes",

        ["alt-shift-h"] = "move-through left",
        ["alt-shift-j"] = "move-through down",
        ["alt-shift-k"] = "move-through up",
        ["alt-shift-l"] = "move-through right",
        ["alt-f"] = "fullscreen",
        ["alt-shift-space"] = "layout floating tiling",
        ["ctrl-alt-shift-space"] = "move-workspace-to-monitor --wrap-around next",
        ["alt-e"] = "layout tiles horizontal vertical",

        ["cmd-alt-ctrl-r"] = "reload-config",

        ["alt-1"] = "workspace 1",
        ["alt-2"] = "workspace 2",
        ["alt-3"] = "workspace 3",
        ["alt-4"] = "workspace 4",
        ["alt-a"] = "workspace A",
        ["alt-s"] = "workspace S",
        ["alt-d"] = "workspace D",

        ["alt-shift-1"] = { "move-node-to-workspace 1", "workspace 1" },
        ["alt-shift-2"] = { "move-node-to-workspace 2", "workspace 2" },
        ["alt-shift-3"] = { "move-node-to-workspace 3", "workspace 3" },
        ["alt-shift-4"] = { "move-node-to-workspace 4", "workspace 4" },
        ["alt-shift-a"] = { "move-node-to-workspace A", "workspace A" },
        ["alt-shift-s"] = { "move-node-to-workspace S", "workspace S" },
        ["alt-shift-d"] = { "move-node-to-workspace D", "workspace D" },
      },
    },
  },
  ["on-window-detected"] = rules,
}

rb.file("~/.config/aerospace/aerospace.toml", rb.toml.encode(config))
