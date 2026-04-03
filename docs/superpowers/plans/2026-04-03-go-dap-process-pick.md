# Go DAP Process Pick Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add support for `"processId": "pick"` in project-local `.nvim/dap.json` for local Go attach sessions.

**Architecture:** Keep the change inside `lua/config/dap.lua`. Validate `processId` during project config parsing, convert the special string `"pick"` into `require("dap.utils").pick_process`, and preserve the existing remote launch and default `dap-go` fallback behaviors.

**Tech Stack:** Neovim Lua, `mfussenegger/nvim-dap`, `nvim-dap-go`

---

### Task 1: Parse `processId = "pick"` safely

**Files:**
- Modify: `lua/config/dap.lua`

- [ ] **Step 1: Add `processId` validation rules before the config table is assembled**

```lua
if type(go_conf.processId) == "string" and go_conf.processId ~= "pick" then
  reset_go_configurations()
  vim.notify("Invalid Go dap processId in " .. config_path, vim.log.levels.ERROR)
  return
end
```

- [ ] **Step 2: Convert `"pick"` to the runtime picker callback**

```lua
local process_id = go_conf.processId
if process_id == "pick" then
  process_id = require("dap.utils").pick_process
end
```

- [ ] **Step 3: Inject the normalized `processId` into the merged config**

```lua
local go_config = vim.tbl_extend("force", {
  type = "go",
  name = "Go Debug",
  request = "launch",
  mode = "debug",
  cwd = root,
  showLog = true,
  trace = "verbose",
  logOutput = "rpc,dap",
}, go_conf)

go_config.processId = process_id
```

- [ ] **Step 4: Run syntax verification**

Run: `luac -p lua/config/dap.lua`
Expected: no output

### Task 2: Verify attach pick and regression coverage

**Files:**
- Modify: none

- [ ] **Step 1: Create a temp Go project with local attach config using `processId = "pick"`**

```json
{
  "go": {
    "name": "Attach Local PID",
    "request": "attach",
    "mode": "local",
    "processId": "pick"
  }
}
```

- [ ] **Step 2: Print the resolved config in headless Neovim**

Run: `nvim --headless -u "/home/linko/.config/nvim/init.lua" "+lua require('lazy').load({plugins={'nvim-dap'}}); vim.wait(200)" "+lua vim.print(require('dap').configurations.go)" "+qa"`
Expected: the project config has `request = "attach"`, `mode = "local"`, and `processId` is printed as a function

- [ ] **Step 3: Re-run remote launch verification**

Run: the existing headless verification against a temp project with remote `host`, `port`, `request = "launch"`, `mode = "exec"`, and `program`
Expected: remote config still resolves unchanged and adapter still prints `{ type = "server", host = ..., port = ... }`

- [ ] **Step 4: Re-run default Go config verification without `.nvim/dap.json`**

Run: headless Neovim in a temp Go project without `.nvim/dap.json`
Expected: default `dap-go` configurations are still present
