return {
  "numToStr/Comment.nvim",
  event = "BufReadPre",
  opts = {
    ignore = "^$",
    toggler = {
      line = "gcc",
      block = "gbc",
    },
    opleader = {
      line = "gc",
      block = "gb",
    },
    mappings = {
      extra = true,
    },
  },
}
