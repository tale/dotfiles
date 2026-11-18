local root = os.getenv("HOME") .. "/code/gh"

local function list_projects()
  local find = rex.exec(
    { "find", ".", "-mindepth", "3", "-maxdepth", "3", "-name", ".git" },
    { cwd = root }
  )

  local items = {}
  for owner, repo in find.stdout:gmatch("%./([^/\n]+)/([^/\n]+)/%.git") do
    local name, branch = repo:match("^(.-)@(.+)$")
    table.insert(items, {
      id = owner .. "/" .. repo,
      title = name or repo,
      subtitle = branch,
      detail = owner,
      icon = branch and "branch" or "folder",
    })
  end

  table.sort(items, function(a, b)
    return a.id:gsub("@", " ") < b.id:gsub("@", " ")
  end)

  return items
end

rex.action({
  name = "sessionizer",
  title = "Open Project…",
  category = "Projects",
  keywords = "project repository worktree sessionizer",
  run = function()
    local project = rex.ui.pick({
      title = "Open project",
      placeholder = "Filter projects",
      confirm = "Open",
      items = list_projects(),
    })

    if not project then
      return
    end

    local label = project:gsub("@(.+)$", " [%1]")
    local session_id
    for _, session in ipairs(rex.call("session.list").sessions) do
      if session.label == label then
        session_id = session.session_id
      end
    end

    session_id = session_id
      or rex.call("session.create", {
        label = label,
        initial_windows = {
          {
            window_label = "shell",
            layout = rex.layout.block({
              flavor = "com.superlogical.terminal.shell",
              options = { cwd = root .. "/" .. project },
            }),
          },
        },
      }).session_id

    rex.client.queue("session.select", { session_id = session_id })
  end,
})

rex.bind("ctrl+f", "sessionizer")
rex.bind("ctrl+space", "client.tab.previous")
