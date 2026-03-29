return {
	"mfussenegger/nvim-dap",
  dependencies = {
    "leoluz/nvim-dap-go",
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
	keys = {
    { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
    { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
    { "<leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: Set Breakpoint" },
    { "<leader>lp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "Debug: Log Point" },
    { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug: Open REPL" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Debug: Run Last" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },

		-- 监视 (Watch) 与 计算 (Eval)
    { "<leader>dw", function() require("dapui").elements.watches.add() end, desc = "Debug: Add Watch" },
    { "<leader>de", function() require("dapui").eval() end, mode = {"n", "v"}, desc = "Debug: Eval" },

    -- Go 特有快捷键 (由 nvim-dap-go 提供)
    { "<leader>dt", function() require("dap-go").debug_test() end, desc = "Debug: Go Test" },
    { "<leader>dgt", function() require("dap-go").debug_last() end, desc = "Debug: Go Last Test" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()
		require("dap-go").setup()

		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })

		vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e06c75" })
    vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#98c379" })

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      -- dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end,
}
