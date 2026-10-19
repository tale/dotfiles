local home = os.getenv("HOME")
local root = home .. "/code/gh"

local picker = [[
cd "$1" || exit
dir=$(find . -maxdepth 3 -name .git -prune \
  | sed 's|^\./||; s|/\.git$||; h; s|@\([^/]*\)$| [\1]|; G; s|\(.*\)\n\(.*\)|\2\t\1|' \
  | sort -t "$(printf '\t')" -k2 | "$2" --delimiter='\t' --with-nth=2 \
    --accept-nth=1 --layout=reverse --border --prompt='project > ' \
    --bind=ctrl-j:accept) || exit
exec "$REX_BIN_DIR/rex" do sessionizer "cwd=$1/$dir"
]]

local function call(method, args)
  local result, err = rex.call(method, args)
  if err ~= nil then
    error(err, 0)
  end

  return result
end

local function select_session(ctx, session_id)
  local args = { session_id = session_id }
  if ctx.origin ~= "api" then
    rex.client.queue("session.select", args)
    return
  end

  -- From the CLI the caller is its own client; switch the app instead.
  for _, client in ipairs(call("client.list", {}).clients) do
    if client.info and client.info.kind == "app" then
      call("client.perform", {
        client_id = client.client_id,
        action = "session.select",
        args = args,
      })
      return
    end
  end
end

local function open_project(ctx, cwd)
  cwd = cwd:gsub("^~/", home .. "/")
  local label = cwd:find(root .. "/", 1, true) == 1 and cwd:sub(#root + 2)
    or cwd
  label = label:gsub("@([^/]+)$", " [%1]")

  local session_id
  for _, session in ipairs(call("session.list", {}).sessions or {}) do
    if session.label == label then
      session_id = session.session_id
      break
    end
  end

  if not session_id then
    session_id = call("session.create", {
      label = label,
      initial_windows = {
        {
          window_label = "shell",
          layout = rex.layout.block({
            flavor = "com.superlogical.terminal.shell",
            options = { cwd = cwd },
          }),
        },
      },
    }).session_id
  end

  select_session(ctx, session_id)
  return { session_id = session_id }
end

rex.action({
  name = "sessionizer",
  title = "Open Project…",
  category = "Projects",
  keywords = "project repository worktree sessionizer",
  args = { cwd = "string?" },
  run = function(ctx, args)
    if args.cwd then
      return open_project(ctx, args.cwd)
    end

    if not ctx.session_id then
      error("Open the picker from a Rex session", 0)
    end

    return call("session.new_split", {
      session_id = ctx.session_id,
      anchor_block_id = ctx.block_id,
      direction = "horizontal",
      side = "after",
      focus = true,
      layout = rex.layout.block({
        flavor = "com.superlogical.terminal.shell",
        label = "Projects",
        options = {
          command = { "/bin/sh", "-c", picker, "sh", root, "@fzf@" },
          shell = "none",
          exit = { on_completion = true, quick_exit_threshold_ms = 0 },
        },
      }),
    })
  end,
})

rex.bind("ctrl+f", "sessionizer")
rex.bind("ctrl+space", "client.tab.previous")
