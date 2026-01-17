return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "leoluz/nvim-dap-go",
  },
  event = "VeryLazy",
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dr", function() require("dap").repl.open() end, desc = "Open REPL" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Variable" },
    { "<leader>dp", function() require("dap.ui.widgets").preview() end, desc = "Preview Variable" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- DAP UI
    dapui.setup {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        }
      }
    }

    -- Auto-open/close UI
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- Go adapter
    require("dap-go").setup()

    -- Custom configurations
    local dap_go_configs = require("dap").configurations.go or {}
    table.insert(dap_go_configs, {
      type = "go",
      name = "Attach to server",
      request = "attach",
      mode = "remote",
      host = "127.0.0.1",
      port = "2345",
    })
    require("dap").configurations.go = dap_go_configs

    -- Signs
    local signs = {
      { name = "DapBreakpoint", text = "●", texthl = "DiagnosticError" },
      { name = "DapBreakpointCondition", text = "◆", texthl = "DiagnosticError" },
      { name = "DapBreakpointRejected", text = "○", texthl = "DiagnosticError" },
      { name = "DapLogPoint", text = "◉", texthl = "DiagnosticInfo" },
      { name = "DapStopped", text = "→", texthl = "DiagnosticWarn", linehl = "Visual" },
    }

    for _, sign in ipairs(signs) do
      vim.fn.sign_define(
        sign.name,
        {
          text = sign.text,
          texthl = sign.texthl,
          linehl = sign.linehl or "",
          numhl = sign.numhl or "",
        }
      )
    end
  end
}
