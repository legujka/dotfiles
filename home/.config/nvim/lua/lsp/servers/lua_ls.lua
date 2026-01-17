-- Lua language server configuration
-- Optimized for Neovim config development
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },

  settings = {
    Lua = {
      -- Runtime
      runtime = {
        version = 'LuaJIT',
      },

      -- Diagnostics
      diagnostics = {
        globals = { 'vim' }, -- Recognize 'vim' global
        disable = { 'missing-fields' }, -- Often false positives
      },

      -- Workspace
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false, -- Don't ask about luassert/busted
        maxPreload = 10000,
        preloadFileSize = 10000,
      },

      -- Completion
      completion = {
        callSnippet = "Replace",
        keywordSnippet = "Replace",
      },

      -- Telemetry
      telemetry = {
        enable = false,
      },

      -- Formatting
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      },

      -- Hint
      hint = {
        enable = true,
        arrayIndex = "Auto",
        setType = true,
      },
    },
  },
}
