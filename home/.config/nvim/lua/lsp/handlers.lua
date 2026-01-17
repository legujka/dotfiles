local M = {}

function M.setup_diagnostics()
  vim.diagnostic.config {
    virtual_text = {
      prefix = "●",
      source = true,  -- Всегда показываем источник (gopls, golangci:errcheck, etc)
      -- Форматирование: показываем источник в скобках
      format = function(diagnostic)
        if diagnostic.source then
          return string.format("%s (%s)", diagnostic.message, diagnostic.source)
        end
        return diagnostic.message
      end,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      }
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
      focusable = false,
    }
  }
end

function M.setup_handlers()
  local border = "rounded"

  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or border
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end

  -- Модифицируем LSP diagnostics для показа источника
  local original_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
    -- Добавляем префикс LSP сервера к source
    if result and result.diagnostics then
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if client then
        for _, diagnostic in ipairs(result.diagnostics) do
          -- Если source уже указан (например staticcheck, unused, etc)
          if diagnostic.source and diagnostic.source ~= client.name then
            diagnostic.source = client.name .. ":" .. diagnostic.source
          else
            -- Иначе просто используем имя клиента
            diagnostic.source = client.name
          end
        end
      end
    end

    -- Вызываем оригинальный handler
    original_handler(err, result, ctx, config)
  end
end

function M.setup()
  M.setup_diagnostics()
  M.setup_handlers()
end

return M
