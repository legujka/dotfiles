local keymaps = require("lsp.keymaps")

-- autosave
vim.api.nvim_create_autocmd(
  "InsertLeave",
  {
    pattern = "*",
    callback = function()
      if vim.bo.modified and vim.bo.filetype ~= "nofile" and vim.fn.getbufvar('%', '&modifiable') == 1 then
        if vim.bo.buftype == "" then
          vim.cmd("silent! write")
        end
      end
    end,
    desc = "Auto save files after editing",
  }
)

-- disable undo on secrets
vim.api.nvim_create_autocmd(
  "BufReadPre",
  {
    pattern = { "*/*.env" },
    callback = function()
      vim.opt_local.undofile = false
    end,
    desc = "Disable undofiles on secrets",
  }
)

-- Lsp

-- Auto-attach keymaps when LSP client connects
vim.api.nvim_create_autocmd(
  "LspAttach",
  {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        keymaps.on_attach(client, args.buf)

        if client.name == "gopls" then
          vim.api.nvim_create_autocmd(
            "BufWritePre",
            {
              buffer = args.buf,
              callback = function()
                -- Organize imports using gopls code action
                local params = {
                  textDocument = vim.lsp.util.make_text_document_params(),
                  range = {
                    start = { line = 0, character = 0 },
                    ["end"] = { line = vim.api.nvim_buf_line_count(0), character = 0 }
                  },
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {}
                  }
                }

                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                if result then
                  for _, res in pairs(result) do
                    if res.result then
                      for _, action in pairs(res.result) do
                        -- Execute the action
                        if action.edit then
                          vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                        elseif action.command then
                          local cmd = action.command
                          vim.lsp.buf_request_sync(0, "workspace/executeCommand", {
                            command = cmd.command,
                            arguments = cmd.arguments,
                          }, 3000)
                        end
                      end
                    end
                  end
                end

                -- Then format
                vim.lsp.buf.format({ async = false })
              end,
            }
          )
        end
      end
    end
  }
)


-- Auto-enable LSP for appropriate filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserLspStart", { clear = true }),
  pattern = { "go", "gomod", "gowork", "gotmpl", "lua", "dockerfile", "yaml", "yml", "proto", "helm", "make" },
  callback = function(args)
    local filetype_to_server = {
      go = "gopls",
      gomod = "gopls",
      gowork = "gopls",
      gotmpl = "gopls",
      lua = "lua_ls",
      dockerfile = "dockerls",
      yaml = "yamlls",
      yml = "yamlls",
      proto = "bufls",
      helm = "helm_ls",
    }

    local server = filetype_to_server[vim.bo[args.buf].filetype]
    if server then
      vim.lsp.enable(server)
    end
  end,
})

-- LSP ready notifications (simple, no progress spam)
local lsp_ready_notified = {}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspReadyNotify", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    if not lsp_ready_notified[client.id] then
      lsp_ready_notified[client.id] = true

      vim.notify(string.format("%s attached", client.name), vim.log.levels.INFO, {
        title = "LSP",
        icon = "",
        timeout = 2000,
      })
    end
  end,
})

-- Performance: Disable LSP for large files (> 100KB)
-- EXCEPT for .proto files (protobuf files can be large)
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function(args)
    local filename = vim.api.nvim_buf_get_name(args.buf)

    -- Skip size check for .proto files
    if filename:match("%.proto$") then
      return
    end

    local max_filesize = 100 * 1024 -- 100KB
    local uv = vim.uv or vim.loop   -- Compatibility with older Neovim
    local ok, stats = pcall(uv.fs_stat, filename)
    if ok and stats and stats.size > max_filesize then
      vim.notify("File too large, LSP disabled", vim.log.levels.WARN)
      vim.b.large_file = true
      return
    end
  end,
})

-- Performance: Disable treesitter-context for large files
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("TreesitterContextLargeFile", { clear = true }),
  callback = function(args)
    -- Check if treesitter-context is loaded
    if not pcall(require, "treesitter-context") then
      return
    end

    local max_filesize = 100 * 1024 -- 100KB
    local uv = vim.uv or vim.loop
    local ok, stats = pcall(uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))

    if ok and stats and stats.size > max_filesize then
      pcall(vim.cmd, "TSContextDisable")
      return
    end

    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if line_count > 5000 then
      pcall(vim.cmd, "TSContextDisable")
    else
      pcall(vim.cmd, "TSContextEnable")
    end
  end,
})

-- Linting
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
  callback = function()
    local ok, lint = pcall(require, "lint")
    if ok then
      lint.try_lint()
    end
  end,
})
