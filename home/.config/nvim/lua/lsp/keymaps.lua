local M = {}

function M.on_attach(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap.set

  -- Navigation
  keymap("n", "gd", vim.lsp.buf.definition, opts)
  keymap("n", "gD", vim.lsp.buf.declaration, opts)
  keymap("n", "gi", vim.lsp.buf.implementation, opts)
  keymap("n", "gr", vim.lsp.buf.references, opts)
  keymap("n", "gt", vim.lsp.buf.type_definition, opts)

  -- Documentation
  keymap("n", "<leader>gd", vim.lsp.buf.hover, opts)

  -- Code actions
  keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)

  -- Diagnostics navigation
  keymap("n", "<leader>e", vim.diagnostic.open_float, opts)
  keymap("n", "<leader>q", vim.diagnostic.setloclist, opts)

  -- Formatting
  keymap("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, opts)

  -- Inlay hints toggle (Neovim 0.11)
  if client.server_capabilities.inlayHintProvider then
    keymap("n", "<leader>ih", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
    end, opts)
  end

  -- Code lens (if supported)
  if client.server_capabilities.codeLensProvider then
    keymap("n", "<leader>cl", vim.lsp.codelens.run, opts)
  end
end

return M
