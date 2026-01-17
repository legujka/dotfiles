return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  keys = {
    { "<leader>un", "<cmd>lua require('notify').dismiss({ silent = true, pending = true })<cr>", desc = "Dismiss notifications" },
    { "<leader>uh", "<cmd>Telescope notify<cr>", desc = "Notification history (session)" },
    { "<leader>ul", function()
        local log_file = vim.fn.stdpath("cache") .. "/nvim-errors.log"
        vim.cmd("edit " .. log_file)
      end, desc = "Open error log file" },
  },
  opts = {
    stages = "fade",
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { focusable = false })
    end,
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)

    local log_file = vim.fn.stdpath("cache") .. "/nvim-errors.log"
    local max_log_size = 1024 * 100

    local function rotate_log()
      local uv = vim.uv or vim.loop
      local stat = uv.fs_stat(log_file)
      if stat and stat.size > max_log_size then
        local backup = log_file .. ".old"
        os.rename(log_file, backup)
      end
    end

    local log_buffer = {}
    local flush_scheduled = false

    local function flush_logs()
      if #log_buffer == 0 then
        flush_scheduled = false
        return
      end

      local file = io.open(log_file, "a")
      if file then
        file:write(table.concat(log_buffer))
        file:close()
        log_buffer = {}
      end
      flush_scheduled = false
    end

    local function log_error(msg, level_name)
      local timestamp = os.date("%Y-%m-%d %H:%M:%S")
      local log_entry = string.format("[%s] [%s] %s\n", timestamp, level_name, msg)
      table.insert(log_buffer, log_entry)

      if not flush_scheduled then
        flush_scheduled = true
        vim.defer_fn(flush_logs, 1000)
      end
    end

    rotate_log()

    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = flush_logs,
    })

    local orig_notify = notify
    vim.notify = function(msg, level, notify_opts)
      if level == vim.log.levels.ERROR or level == vim.log.levels.WARN then
        local level_name = level == vim.log.levels.ERROR and "ERROR" or "WARN"
        log_error(msg, level_name)
      end
      return orig_notify(msg, level, notify_opts)
    end

    local orig_error = _G.error
    _G.error = function(message, level)
      local msg = tostring(message)

      local ignore_patterns = {
        "^Vim:E",      -- Vim errors (already shown)
        "interrupted", -- User interrupt
      }

      local should_ignore = false
      for _, pattern in ipairs(ignore_patterns) do
        if msg:match(pattern) then
          should_ignore = true
          break
        end
      end

      if not should_ignore then
        log_error(msg, "LUA_ERROR")
        notify(msg, vim.log.levels.ERROR, { title = "Lua Error", timeout = 5000 })
      end

      orig_error(message, (level or 1) + 1)
    end
  end,
}
