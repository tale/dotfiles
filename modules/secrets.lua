local profile = require("rootbeer.profile")
local rb = require("rootbeer")

-- WakaTime
local wakatime = {
  "[settings]",
  "debug = false",
  "ignore =",
  "    COMMIT_EDITMSG$",
  "    PULLREQ_EDITMSG$",
  "    MERGE_MSG$",
  "    TAG_EDITMSG$",
  "",
  'api_url = "' .. rb.secret.op("op://Development/WakaTime Key/url") .. '"',
  'api_key = "'
    .. rb.secret.op("op://Development/WakaTime Key/credential")
    .. '"',
}

profile.when("work", function()
  table.insert(wakatime, "")
  table.insert(wakatime, "hide_file_names = true")
  table.insert(wakatime, "hide_branch_names = true")
  table.insert(wakatime, "hide_dependencies = true")
end)

rb.file("~/.wakatime.cfg", table.concat(wakatime, "\n") .. "\n")

-- SOPS age key
rb.file("~/.config/sops/age/keys.txt", table.concat({
  "# public key: " .. rb.secret.op("op://Development/AGE Key/username"),
  "AGE-SECRET-KEY-" .. rb.secret.op("op://Development/AGE Key/password"),
}, "\n") .. "\n")
