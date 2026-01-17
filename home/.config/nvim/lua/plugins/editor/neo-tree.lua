return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim"
  },
  cmd = "Neotree",
  keys = {
    { "<C-n>", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
    { "<C-m>", "<cmd>Neotree focus<cr>", desc = "Focus file explorer" },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = false,

    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          -- "node_modules",
          -- ".git",
          -- ".DS_Store",
        },
      },
    },

    window = {
      position = "right",
      width = 35,
      mappings = {
        ["<space>"] = "none",
        ["<cr>"] = "open",
        ["l"] = "set_root",
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
        ["t"] = "open_tabnew",
        ["C"] = "close_node",
        ["z"] = "close_all_nodes",
        ["R"] = "refresh",
        ["a"] = "add",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["q"] = "close_window",
        ["H"] = function(_)
          vim.cmd("normal! 10zh")
        end,
        ["L"] = function(_)
          vim.cmd("normal! 10zl")
        end,
      },
    },

    default_component_configs = {
      git_status = {
        symbols = {
          added     = "✚",
          modified  = "",
          deleted   = "✖",
          renamed   = "󰁕",
          untracked = "",
          ignored   = "",
          unstaged  = "󰄱",
          staged    = "",
          conflict  = "",
        },
      },
    },
  },
}
