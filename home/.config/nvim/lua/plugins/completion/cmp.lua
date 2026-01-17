return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind.nvim",
  },
  event = "InsertEnter",
  opts = function()
    local cmp = require("cmp")

    return {
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      },
      sources = cmp.config.sources {
        {
          name = "nvim_lsp",
          max_item_count = 20, -- Limit LSP results for performance
        },
        {
          name = "luasnip",
          max_item_count = 10,
        },
        {
          name = "buffer",
          max_item_count = 10,
          option = {
            get_bufnrs = function()
              -- Only current buffer in monorepo
              return { vim.api.nvim_get_current_buf() }
            end
          }
        },
        {
          name = 'path',
          max_item_count = 10,
        },
      },
      performance = {
        debounce = 150,              -- Delay before triggering completion
        throttle = 80,               -- Minimum time between completions
        fetching_timeout = 500,      -- Timeout for source fetching
        max_view_entries = 20,       -- Max visible items
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        format = require("lspkind").cmp_format {
          mode = "symbol_text",
          maxwidth = 50,
        }
      }
    }
  end
}
