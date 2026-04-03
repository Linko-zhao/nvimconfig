## Goal

Keep reading project-local `.nvim/dap.json` and support Go remote debugging against an already running `dlv dap --listen :2345` server. When the config uses `request = "launch"` and `mode = "exec"`, Neovim should connect to the remote DAP server and let the remote Delve instance start the `program` path specified in the config.

## Current Problem

The current `lua/config/dap.lua` only treats `request = "attach"` with `mode = "remote"` as a remote server session. All other Go configurations are forced into a local adapter path that starts a new local `dlv dap` process. This breaks remote launch because the configuration is never sent to the existing remote Delve DAP server.

## Design

### Adapter behavior

Change `dap.adapters.go` to detect remote-server usage by connection fields instead of by `attach/remote` only.

Rules:

1. If a Go config provides `host` or `port`, treat it as a server-backed session and return a `type = "server"` adapter using that host and port.
2. Otherwise, preserve the existing local behavior that starts `dlv dap -l 127.0.0.1:${port}`.

This keeps local debugging intact while allowing remote `launch`, remote `attach`, and other server-backed modes to work.

### Config parsing

Continue reading `root/.nvim/dap.json` with the existing top-level shape:

```json
{
  "go": {
    "name": "Dlv debug",
    "request": "launch",
    "mode": "exec",
    "program": "/root/application",
    "port": 2345,
    "host": "10.18.10.100"
  }
}
```

The parser should preserve user-provided fields instead of overriding them toward `attach/remote` defaults. In particular, `request`, `mode`, and `program` must flow through unchanged when present.

### Path mapping

Only set `substitutePath` when the config explicitly provides both local and remote path information. Do not inject a default mapping from project root to `/app`, because that can corrupt otherwise valid remote launch setups.

### Defaults

Use defaults only when the field is absent:

1. `name`: `Go Debug`
2. `request`: `launch`
3. `mode`: `debug`
4. `host`: `127.0.0.1`
5. `port`: `38697` for local adapter spawn fallback, `2345` for project config if a remote host is specified without a port
6. `cwd`: project root

The exact local fallback port behavior can remain aligned with the existing adapter implementation as long as remote configs use their explicit `host` and `port` values.

## Error Handling

1. If the project is not a Go module, clear `dap.configurations.go`.
2. If `.nvim/dap.json` is missing or invalid, clear `dap.configurations.go` and notify on invalid JSON/read failure.
3. If a remote server config omits `port`, fail with a clear error when trying to create the adapter or default it consistently during config assembly.

## Verification

Manual verification is sufficient for this config-only change:

1. Open a Go project with `.nvim/dap.json` matching the example.
2. Confirm `:lua vim.print(require('dap').configurations.go)` shows `request = "launch"`, `mode = "exec"`, `program = "/root/application"`, and the configured `host`/`port`.
3. Start remote debugging and confirm Neovim connects to the existing remote `dlv dap` server instead of spawning a local one.

## Scope

This change is limited to `lua/config/dap.lua`. No plugin changes, command changes, or alternate config file locations are introduced.
