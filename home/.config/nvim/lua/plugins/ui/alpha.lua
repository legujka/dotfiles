return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local dashboard = require("alpha.themes.dashboard")
    local art = require("assets.alpha-header")

    dashboard.section.header.val = art.header
    dashboard.section.header.opts.hl = art.hl

    dashboard.section.buttons.val = {
      dashboard.button("f", " Find files", ":Telescope find_files <CR>"),
      dashboard.button("r", " Recent files", ":Telescope oldfiles <CR>"),
      dashboard.button("p", " Select project", ":Telescope project <CR>"),
      dashboard.button("l", "󰚰 LazyUI", ":Lazy <CR>"),
    }
    for _, btn in ipairs(dashboard.section.buttons.val) do
      btn.opts.hl = "AlphaButtons"
      btn.opts.hl_shortcut = "AlphaShortcut"
    end

    dashboard.section.buttons.opts.hl = "Identifier"
    dashboard.section.footer.opts.hl  = "Function"
    dashboard.opts.layout[1].val      = 4

    return dashboard
  end,
  config = function(_, dashboard)
    require("alpha").setup(dashboard.opts)
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local v = vim.version()
        local dev = v.prerelease == "dev" and ("-dev+" .. v.build) or ""
        local version = v.major .. "." .. v.minor .. "." .. v.patch .. dev
        local stats = require("lazy").stats()
        local plugins_count = stats.loaded .. "/" .. stats.count
        local ms = math.floor(stats.startuptime + 0.5)

        local line1 = " " .. plugins_count .. " plugins loaded in " .. ms .. "ms"
        local line2 = " Neovim " .. version
        local max_width = math.max(vim.fn.strdisplaywidth(line1), vim.fn.strdisplaywidth(line2))

        local function center(str)
          local width = vim.fn.strdisplaywidth(str)
          local padding = math.floor((max_width - width) / 2)
          return string.rep(" ", padding) .. str
        end

        dashboard.section.footer.val = {
          center(line1),
          center(line2),
        }
        pcall(vim.cmd.AlphaRedraw)
        end
      }
    )
  end
}
