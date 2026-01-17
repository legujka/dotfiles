return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSUpdate", "TSInstall" },
  config = function()
    local ok, ts_config = pcall(require, "nvim-treesitter.configs")
    if not ok then
      return
    end

    ts_config.setup({
      ensure_installed = {
        "go", "gomod", "gosum", "gowork",
        "lua", "vim", "vimdoc", "query",
        "markdown", "markdown_inline",
        "bash", "json", "yaml", "dockerfile", "make",
      },
      highlight = {
        enable = true,
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100KB
          local ok_stat, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok_stat and stats and stats.size > max_filesize then
            return true
          end
          return vim.api.nvim_buf_line_count(buf) > 10000
        end,
      },
      indent = { enable = true },
    })
  end,
}
