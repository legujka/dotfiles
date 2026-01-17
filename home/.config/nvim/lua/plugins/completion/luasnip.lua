return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "honza/vim-snippets",
  },
  event = "InsertEnter",
  config = function()
    local ls = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load {
      paths = {
        vim.fn.stdpath("config") .. "/lua/snippets"
      }
    }

    ls.setup {
      update_events = "TextChanged,TextChangedI",
      enable_autosnippets = true,
      ext_opts = {
        [require("luasnip.util.types").choiceNode] = {
          active = { virt_text = { { "●", "DiagnosticWarn" } } }
        }
      }
    }

    local keymap = vim.keymap

    keymap.set({"i", "s"}, "<C-f>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-f>", true, false, true), "n", false)
      end
    end, { silent = true, desc = "Expand or jump forward" })

    keymap.set({"i", "s"}, "<C-b>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-b>", true, false, true), "n", false)
      end
    end, { silent = true, desc = "Jump backward" })

    keymap.set("i", "<C-l>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "n", false)
      end
    end, { silent = true, desc = "Cycle choices" })
  end
}
