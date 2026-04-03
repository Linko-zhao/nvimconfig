local dap = require("dap")
local default_go_configurations = vim.deepcopy(dap.configurations.go or {})

dap.adapters.go = function(callback, config)
  if config.host ~= nil or config.port ~= nil then
    callback({
      type = "server",
      host = config.host or "127.0.0.1",
      port = assert(config.port, "`port` is required for server-backed Go sessions"),
    })
  else
    callback({
      type = "server",
      port = "${port}",
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
      },
    })
  end
end

local function file_exists(path)
  return vim.fn.filereadable(path) == 1
end

local function find_go_project_root()
  local current = vim.api.nvim_buf_get_name(0)
  local start_path

  if current ~= "" then
    start_path = vim.fs.dirname(current)
  else
    start_path = vim.fn.getcwd()
  end

  local gomod = vim.fs.find("go.mod", {
    upward = true,
    path = start_path,
    stop = vim.loop.os_homedir(),
  })[1]

  if not gomod then
    return nil
  end

  return vim.fs.dirname(gomod)
end

local function load_json_file(path)
  if not file_exists(path) then
    return nil
  end

  local ok_read, lines = pcall(vim.fn.readfile, path)
  if not ok_read then
    vim.notify("Failed to read dap config: " .. path, vim.log.levels.ERROR)
    return nil
  end

  local content = table.concat(lines, "\n")
  if content == "" then
    vim.notify("Empty dap config: " .. path, vim.log.levels.WARN)
    return nil
  end

  local ok_decode, data = pcall(vim.json.decode, content)
  if not ok_decode then
    vim.notify("Invalid JSON in " .. path, vim.log.levels.ERROR)
    return nil
  end

  return data
end

local function reset_go_configurations()
  dap.configurations.go = vim.deepcopy(default_go_configurations)
end

local function normalize_go_process_id(go_conf, config_path)
  if go_conf.processId == nil then
    return true
  end

  if type(go_conf.processId) == "number" then
    if go_conf.processId > 0 and math.floor(go_conf.processId) == go_conf.processId then
      return true
    end

    vim.notify("Invalid Go dap processId in " .. config_path .. ": expected a positive integer pid", vim.log.levels.ERROR)
    return false
  end

  if go_conf.processId == "pick" then
    go_conf.processId = require("dap.utils").pick_process
    return true
  end

  vim.notify("Invalid Go dap processId in " .. config_path .. ": expected nil, \"pick\", or a number", vim.log.levels.ERROR)
  return false
end

local function setup_go_dap_from_project()
  local root = find_go_project_root()

  -- 不是 Go 工程：清掉 Go 的配置
  if not root then
    reset_go_configurations()
    return
  end

  local config_path = root .. "/.nvim/dap.json"

  -- 是 Go 工程，但没有项目配置：也不加载
  if not file_exists(config_path) then
    reset_go_configurations()
    return
  end

  local project_conf = load_json_file(config_path)
  if not project_conf or type(project_conf.go) ~= "table" or vim.islist(project_conf.go) then
    reset_go_configurations()

    if project_conf and project_conf.go ~= nil then
      vim.notify("Invalid Go dap config in " .. config_path, vim.log.levels.ERROR)
    end

    return
  end

  local go_conf = project_conf.go
  if (go_conf.host ~= nil and type(go_conf.host) ~= "string") or (go_conf.port ~= nil and type(go_conf.port) ~= "number") then
    reset_go_configurations()
    vim.notify("Invalid Go dap host/port in " .. config_path, vim.log.levels.ERROR)
    return
  end

  go_conf = vim.deepcopy(go_conf)
  if not normalize_go_process_id(go_conf, config_path) then
    reset_go_configurations()
    return
  end

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

  if go_conf.local_path and go_conf.remote_path then
    go_config.substitutePath = {
      {
        from = go_conf.local_path,
        to = go_conf.remote_path,
      },
    }
  end

  dap.configurations.go = {
    go_config,
  }
end

setup_go_dap_from_project()

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  callback = function()
    setup_go_dap_from_project()
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.go",
  callback = function()
    setup_go_dap_from_project()
  end,
})
