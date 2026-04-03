## Goal

Extend project-local `.nvim/dap.json` parsing so Go local attach configurations can use `"processId": "pick"` to select a running process interactively at debug start time.

## Current Problem

The current parser forwards JSON values directly into the Go DAP configuration. That works for a numeric `processId`, but JSON cannot represent the runtime callback needed for `nvim-dap` process picking. As a result, project-local attach configs cannot express the same interactive process picker that the built-in `dap-go` defaults provide.

## Design

### Config shape

Continue reading project-local `root/.nvim/dap.json` with the same top-level structure:

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

### Parsing behavior

When `project_conf.go.processId` is the string `"pick"`, convert it to `require("dap.utils").pick_process` in the generated Go config table.

This preserves deferred selection behavior: the process picker should run when the debug session starts, not when the config file is loaded.

### Scope rules

Support `"processId": "pick"` for local attach use. The intended configuration is:

1. `request = "attach"`
2. `mode = "local"`
3. no remote `host` / `port`

No extra compatibility syntax is added. Strings such as `${command:pickProcess}` are out of scope.

### Validation

Accept these `processId` forms:

1. number: preserve as-is
2. `"pick"`: convert to `dap.utils.pick_process`
3. absent: preserve existing behavior

Reject any other string value with a notification and restore default Go configurations instead of producing a broken attach configuration.

## Verification

Manual/runtime verification is sufficient for this config-only change:

1. In a temp Go project with `.nvim/dap.json` containing `request = "attach"`, `mode = "local"`, and `processId = "pick"`, confirm `:lua vim.print(require('dap').configurations.go)` shows `processId` as a function.
2. Start debugging and confirm `nvim-dap` opens the local process picker.
3. Re-run the existing remote launch verification to confirm `host` / `port` remote sessions are unchanged.
4. Confirm a Go project without `.nvim/dap.json` still retains the default `dap-go` configurations.

## Scope

This change remains limited to `lua/config/dap.lua`. No new commands, no new config file location, and no extra process picker syntax are introduced.
