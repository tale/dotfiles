local home = os.getenv("HOME")
local root = home .. "/code/gh"

local function quote(value)
  return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function output(command)
  local pipe = io.popen(command .. " 2>/dev/null")
  if not pipe then
    error("Cannot execute: " .. command, 0)
  end

  local value = pipe:read("*a")
  pipe:close()

  return (value:gsub("\n$", ""))
end

local function read_line(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local line = file:read("*l")
  file:close()

  return line
end

local function project_label(cwd)
  local label = cwd:sub(1, #root + 1) == root .. "/" and cwd:sub(#root + 2)
    or cwd
  local marker = read_line(cwd .. "/.git")
  local gitdir = marker and marker:match("^gitdir: (.+)$")
  if not gitdir then
    return label
  end

  if gitdir:sub(1, 1) ~= "/" then
    gitdir = cwd .. "/" .. gitdir
  end

  local main = read_line(gitdir .. "/commondir") == "../.."
    and gitdir:match("^(.*)/%.git/worktrees/[^/]+$")
  if not main then
    local worktrees =
      output("git -C " .. quote(cwd) .. " worktree list --porcelain")
    main = worktrees:match("^worktree ([^\n]+)")
  end

  if not main then
    error("Cannot read worktrees for " .. cwd, 0)
  end

  local head = read_line(gitdir .. "/HEAD") or ""
  local branch = head:match("^ref: refs/heads/(.+)$")
    or output("git -C " .. quote(cwd) .. " rev-parse --short HEAD")
  if branch == "" then
    error("Cannot read HEAD for " .. cwd, 0)
  end

  label = main:sub(1, #root + 1) == root .. "/" and main:sub(#root + 2) or main
  return label .. " [" .. branch .. "]"
end

local function call(method, args)
  local result, err = rex.call(method, args)
  if err ~= nil then
    error(err, 0)
  end

  return result
end

local function open_project(cwd, harness)
  if cwd:sub(1, 2) == "~/" then
    cwd = home .. cwd:sub(2)
  end

  cwd = output("git -C " .. quote(cwd) .. " rev-parse --show-toplevel")
  if cwd == "" then
    error("Project directory is not a Git repository", 0)
  end

  local label = project_label(cwd)
  local sessions = {}

  for _, session in ipairs(call("session.list", {}).sessions or {}) do
    sessions[session.label] = sessions[session.label] or session.session_id
  end

  local previous_label = cwd:sub(1, #root + 1) == root .. "/"
      and cwd:sub(#root + 2)
    or cwd
  local session_id = sessions[label] or sessions[previous_label]
  if session_id and not sessions[label] then
    call("session.set_label", { session_id = session_id, label = label })
  end

  if not session_id then
    local windows = {}
    local names = harness and { harness, "nvim" } or { "shell" }

    for _, name in ipairs(names) do
      windows[#windows + 1] = {
        window_label = name,
        layout = rex.layout.block({
          flavor = "com.superlogical.terminal.shell",
          options = { cwd = cwd, command = harness and { name } or nil },
        }),
      }
    end

    session_id = call(
      "session.create",
      { label = label, initial_windows = windows }
    ).session_id
  end

  rex.client.queue("session.select", { session_id = session_id })
  return { session_id = session_id }
end

if rex.args and rex.args.picker then
  local items = {}
  local paths =
    output("find " .. quote(root) .. " -maxdepth 3 -name .git -prune -print0")

  for marker in paths:gmatch("([^%z]+)%z") do
    local cwd = marker:sub(1, -6)
    items[#items + 1] = { label = project_label(cwd), cwd = cwd }
  end

  if #items == 0 then
    return
  end

  table.sort(items, function(a, b)
    return a.label < b.label
  end)

  local terminal = assert(io.open("/dev/tty", "r+"))
  terminal:setvbuf("no")
  local settings = output("stty -g < /dev/tty")
  os.execute("stty raw -echo min 0 time 5 < /dev/tty")

  local ok, colors = pcall(function()
    terminal:write("\27]10;?\27\\\27]11;?\27\\")
    local response = ""
    local values = {}
    local pattern = "\27%](1[01]);rgb:(%x+)/(%x+)/(%x+)\7"

    while not values[10] or not values[11] do
      local byte = terminal:read(1)
      if not byte then
        error("Rex did not report its terminal theme", 0)
      end

      response = (response .. byte):gsub("\27\\", "\7")

      for key, r, g, b in response:gmatch(pattern) do
        local channels = { r, g, b }

        for index, hex in ipairs(channels) do
          channels[index] =
            math.floor(tonumber(hex, 16) * 255 / (16 ^ #hex - 1) + 0.5)
        end

        values[tonumber(key)] = string.format("#%02x%02x%02x", unpack(channels))
      end
    end

    return values
  end)

  os.execute("stty " .. quote(settings) .. " < /dev/tty")
  terminal:close()

  if not ok then
    error(colors, 0)
  end

  local rows = {}
  for index, item in ipairs(items) do
    rows[#rows + 1] = quote(index .. "\t" .. item.label:gsub("[%c]", " "))
  end

  local foreground, background = colors[10], colors[11]
  local color = table.concat({
    "16",
    "fg:" .. foreground,
    "fg+:" .. background,
    "bg:" .. background,
    "bg+:" .. foreground,
    "gutter:" .. background,
    "border:" .. foreground,
  }, ",")
  local fzf = "@fzf@"

  -- Rex renders edge coordinates but sizes the PTY as width/height.
  local command = "printf '%s\\0' "
    .. table.concat(rows, " ")
    .. " | FZF_DEFAULT_OPTS= FZF_DEFAULT_OPTS_FILE= "
    .. quote(fzf)
    .. " --read0 --print0 --delimiter='\t' --with-nth=2.. --accept-nth=1"
    .. " --layout=reverse --border --margin=0,12%,18%,0 --color="
    .. quote(color)
    .. " --prompt='project > ' --bind=ctrl-j:accept"
  local pipe = io.popen(command)
  local selected = pipe:read("*a")
  pipe:close()

  if selected == "" then
    return
  end

  local index = tonumber((selected:gsub("%z", "")))
  local item = items[index]

  return open_project(item.cwd, rex.args.harness)
end

local config = os.getenv("REX_CONFIG")
  or (os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config")
    .. "/rex/init.lua"

rex.action({
  name = "sessionizer",
  title = "Open Project…",
  category = "Projects",
  keywords = "project repository worktree sessionizer",
  args = { cwd = "string?", harness = "string?" },
  run = function(ctx, args)
    if args.cwd then
      return open_project(args.cwd, args.harness)
    end

    if not ctx.session_id or not ctx.client_id then
      error("Open the picker from a Rex session", 0)
    end

    if ctx.block_id then
      local block = call("session.describe_block", {
        session_id = ctx.session_id,
        block_id = ctx.block_id,
      }).block
      if block.label == "Projects" then
        return
      end
    end

    local command = {
      "/Applications/Rex.app/Contents/Helpers/rex",
      "-C",
      ctx.client_id,
      "do",
      "-s",
      ctx.session_id,
      config,
      "picker=true",
    }
    if args.harness then
      command[#command + 1] = "harness=" .. args.harness
    end

    return call("session.new_layer", {
      session_id = ctx.session_id,
      bounds = { x = 0.1, y = 0.15, w = 0.9, h = 0.85 },
      focus = true,
      layout = rex.layout.block({
        flavor = "com.superlogical.terminal.shell",
        label = "Projects",
        options = {
          command = command,
          shell = "none",
          exit = { on_completion = true, quick_exit_threshold_ms = 0 },
        },
      }),
    })
  end,
})

rex.bind("ctrl+f", "sessionizer")
rex.bind("ctrl+space", "client.tab.previous")
