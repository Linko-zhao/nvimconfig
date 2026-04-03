# Go DAP Remote Launch Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make project-local `.nvim/dap.json` support remote Go launch sessions against an already running `dlv dap` server.

**Architecture:** Keep all logic inside `lua/config/dap.lua`. Detect server-backed sessions from `host` and `port`, preserve user-provided Go DAP fields from `.nvim/dap.json`, and only add `substitutePath` when the config explicitly requests it.

**Tech Stack:** Neovim Lua, `mfussenegger/nvim-dap`, Delve DAP

---

### Task 1: Update adapter selection for remote DAP servers

**Files:**
- Modify: `lua/config/dap.lua`

- [ ] **Step 1: Update the adapter branch to use remote server detection**

```lua
dap.adapters.go = function(callback, config)
  if config.host or config.port then
    callback({
      type = "server",
      host = config.host or "127.0.0.1",
      port = assert(config.port, "`port` is required for server-backed Go debug sessions"),
    })
    return
  end

  callback({
    type = "server",
    port = "${port}",
    executable = {
      command = "dlv",
      args = { "dap", "-l", "127.0.0.1:${port}" },
    },
  })
end
```

- [ ] **Step 2: Verify the adapter still has a local fallback path**

Run: inspect `lua/config/dap.lua`
Expected: remote sessions connect to `host`/`port`; local sessions still spawn `dlv dap -l 127.0.0.1:${port}`

### Task 2: Preserve remote launch fields from `.nvim/dap.json`

**Files:**
- Modify: `lua/config/dap.lua`

- [ ] **Step 1: Build the Go configuration from user fields without forcing attach/remote defaults**

```lua
local config = {
  type = go_conf.type or "go",
  name = go_conf.name or "Go Debug",
  request = go_conf.request or "launch",
  mode = go_conf.mode or "debug",
  program = go_conf.program,
  host = go_conf.host,
  port = go_conf.port,
  cwd = go_conf.cwd or root,
  env = go_conf.env,
  args = go_conf.args,
  showLog = go_conf.showLog ~= false,
  trace = go_conf.trace or "verbose",
  logOutput = go_conf.logOutput or "rpc,dap",
}
```

- [ ] **Step 2: Only add `substitutePath` when both ends are provided**

```lua
if go_conf.local_path and go_conf.remote_path then
  config.substitutePath = {
    {
      from = go_conf.local_path,
      to = go_conf.remote_path,
    },
  }
end
```

- [ ] **Step 3: Assign the assembled config to `dap.configurations.go`**

```lua
dap.configurations.go = { config }
```

- [ ] **Step 4: Verify the resulting config shape**

Run: inspect `lua/config/dap.lua`
Expected: `request = "launch"`, `mode = "exec"`, and `program` remain user-controlled when present in `.nvim/dap.json`

### Task 3: Manual verification in Neovim

**Files:**
- Modify: none

- [ ] **Step 1: Reload Neovim and print the resolved Go DAP configuration**

```vim
:lua vim.print(require('dap').configurations.go)
```

Expected: output includes `request = "launch"`, `mode = "exec"`, `program = "/root/application"`, `host = "10.18.10.100"`, and `port = 2345`

- [ ] **Step 2: Start the remote DAP session**

Run: trigger your normal debug start mapping, such as `<F5>`
Expected: Neovim connects to the remote `dlv dap --listen :2345` server instead of spawning a local `dlv` process

- [ ] **Step 3: Confirm remote launch behavior**

Run: inspect Delve logs or debug outcome on the remote host
Expected: the remote Delve server launches `/root/application` using the `launch + exec` request from `.nvim/dap.json`
