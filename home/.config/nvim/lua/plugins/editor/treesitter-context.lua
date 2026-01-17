return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {
      "[c",
      function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end,
      desc = "Jump to context",
    },
  },
  opts = {
    max_lines = 3,
    min_window_height = 20,
    multiline_threshold = 10,
    trim_scope = "outer",
    separator = nil,
    mode = "cursor",
    zindex = 20,
    on_attach = function(buf)
      local ft = vim.bo[buf].filetype
      local lang = vim.treesitter.language.get_lang(ft) or ft
      return pcall(vim.treesitter.language.inspect, lang)
    end,
  },
}
