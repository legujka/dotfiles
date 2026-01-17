return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Find golangci-lint binary: prioritize local ./bin/golangci-lint
    local function find_golangci_lint_cmd()
      local root = vim.fs.root(0, { "go.mod", "go.work", ".git" })
      if not root then return nil end

      local local_bin = root .. "/bin/golangci-lint"
      if vim.fn.filereadable(local_bin) == 1 and vim.fn.executable(local_bin) == 1 then
        return local_bin
      end

      if vim.fn.executable("golangci-lint") == 1 then
        return "golangci-lint"
      end

      return nil
    end

    -- Check if golangci-lint config exists
    local function has_golangci_config()
      local root = vim.fs.root(0, { "go.mod", "go.work", ".git" })
      if not root then return false end

      local config_files = {
        ".golangci.yml", ".golangci.yaml",
        ".golangci-lint.yml", ".golangci-lint.yaml",
        ".golangci.json", ".golangci.toml",
      }

      for _, name in ipairs(config_files) do
        if vim.fn.filereadable(root .. "/" .. name) == 1 then
          return true
        end
      end

      return false
    end

    -- Run linting without golangcilint
    local function lint_without_golangci()
      local original = lint.linters_by_ft.go or {}
      lint.linters_by_ft.go = vim.tbl_filter(function(l)
        return l ~= "golangcilint"
      end, original)

      lint.try_lint()
      lint.linters_by_ft.go = original
    end

    -- Configure linters
    lint.linters_by_ft = {
      dockerfile = { "hadolint" },
      go = { "golangcilint" },
    }

    -- golangci-lint configuration
    lint.linters.golangcilint = {
      cmd = function()
        return find_golangci_lint_cmd() or "golangci-lint"
      end,
      stdin = false,
      append_fname = true,
      args = { "run", "--output.json.path=stdout" },
      ignore_exitcode = true,
      stream = "stdout",
      parser = function(output, bufnr)
        local diagnostics = {}
        if not output or output == "" then return diagnostics end

        -- Extract JSON (v2.x appends text summary)
        local json_str = output:match("^(.-%})\n") or output:match("^(.-%})$") or output
        local ok, data = pcall(vim.json.decode, json_str)

        if not ok or not data or not data.Issues then
          return diagnostics
        end

        local buf_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p")

        for _, issue in ipairs(data.Issues) do
          if issue.Pos and issue.Pos.Filename then
            local issue_path = vim.fn.fnamemodify(issue.Pos.Filename, ":p")
            if issue_path == buf_path then
              table.insert(diagnostics, {
                lnum = (issue.Pos.Line or 1) - 1,
                col = (issue.Pos.Column or 1) - 1,
                end_lnum = (issue.Pos.Line or 1) - 1,
                end_col = (issue.Pos.Column or 1) - 1,
                severity = vim.diagnostic.severity.WARN,
                message = issue.Text or "unknown issue",
                source = "golangci:" .. (issue.FromLinter or "unknown"),
              })
            end
          end
        end

        return diagnostics
      end,
    }

    -- Auto-trigger linting
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
      callback = function()
        if vim.bo.filetype == "go" then
          if not has_golangci_config() then
            lint_without_golangci()
            return
          end

          if not find_golangci_lint_cmd() then
            if not vim.b.golangci_warn_shown then
              vim.b.golangci_warn_shown = true
              vim.notify(
                "golangci-lint not found (checked ./bin/golangci-lint and $PATH)",
                vim.log.levels.WARN,
                { title = "nvim-lint" }
              )
            end
            lint_without_golangci()
            return
          end
        end

        lint.try_lint()
      end,
    })

    -- Manual trigger
    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
    end, { desc = "Trigger linting" })
  end,
}
