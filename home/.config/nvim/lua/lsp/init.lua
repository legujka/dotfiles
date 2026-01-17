local handlers = require("lsp.handlers")

handlers.setup()

local servers = {
  "gopls",
  "lua_ls",
  "dockerls",
  "yamlls",
  "bufls",   -- Protocol Buffers
  "helm_ls", -- Helm charts
}

for _, server_name in ipairs(servers) do
  local ok, server_config = pcall(require, "lsp.servers." .. server_name)
  if ok then
    vim.lsp.config(server_name, server_config)
  else
    vim.notify("Failed to load LSP config for " .. server_name, vim.log.levels.ERROR)
  end
end
