return {
  "romgrk/barbar.nvim",
  dependencies = {
    "lewis6991/gitsigns.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  keys = {
    { "<S-Tab>", "<Cmd>BufferPrevious<CR>", desc = "Previous buffer" },
    { "<Tab>", "<Cmd>BufferNext<CR>", desc = "Next buffer" },
    { "<A-,>", "<Cmd>BufferMovePrevious<CR>", desc = "Move buffer left" },
    { "<A-.>", "<Cmd>BufferMoveNext<CR>", desc = "Move buffer right"},
    { "<C-1>", "<Cmd>BufferGoto1<CR>", desc = "Buffer 1" },
    { "<C-2>", "<Cmd>BufferGoto2<CR>", desc = "Buffer 2" },
    { "<C-3>", "<Cmd>BufferGoto3<CR>", desc = "Buffer 3" },
    { "<C-4>", "<Cmd>BufferGoto4<CR>", desc = "Buffer 4" },
    { "<C-5>", "<Cmd>BufferGoto5<CR>", desc = "Buffer 5" },
    { "<C-6>", "<Cmd>BufferGoto6<CR>", desc = "Buffer 6" },
    { "<C-7>", "<Cmd>BufferGoto7<CR>", desc = "Buffer 7" },
    { "<C-8>", "<Cmd>BufferGoto8<CR>", desc = "Buffer 8" },
    { "<C-9>", "<Cmd>BufferGoto9<CR>", desc = "Buffer 9" },
    { "<C-0>", "<Cmd>BufferLast<CR>", desc = "Buffer last" },
    { "<C-p>", "<Cmd>BufferPin<CR>", desc = "Pin buffer" },
    { "<C-x>", "<Cmd>BufferClose<CR>", desc = "Close buffer" },
  },
  opts = {
    animation = true,
    auto_hide = false,
    sidebar_filetypes = {
      NvimTree = true,
      ["neo-tree"] = {
        event = "BufWipeout",
        text = "Neo-tree",
        align = "left"
      },
    }
  }
}
