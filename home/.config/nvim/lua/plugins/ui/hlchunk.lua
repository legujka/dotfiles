return {
  "shellRaining/hlchunk.nvim",
  ft = {
    "go", "gomod", "gosum", "gowork",
    "lua", "vim", "help",
    "markdown",
    "sh", "bash", "zsh",
    "json", "yaml", "dockerfile", "make",
  },
  config = function()
    require("hlchunk").setup {
      chunk = {
        enable = true
      },
      indent = {
        enable = true
      },
      line_num = {
        enable = true
      }
    }
  end
}
