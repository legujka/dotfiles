local keymap = vim.keymap
local utils = require("utils")

-- Esc
keymap.set("i", "jk", "<ESC>", {desc = "Exit Insert mode with jk"})

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", {desc = "Split window vertically"})
keymap.set("n", "<leader>sh", "<C-w>s", {desc = "Split window horizontally"})
keymap.set("n", "<leader>se", "<C-w>=", {desc = "Make splits equal size"})
keymap.set("n", "<C-k>", "<C-w>k", {desc = "Go to up split"})
keymap.set("n", "<C-j>", "<C-w>j", {desc = "Go to down split"})
keymap.set("n", "<C-h>", "<C-w>h", {desc = "Go to left split"})
keymap.set("n", "<C-l>", "<C-w>l", {desc = "Go to right split"})
keymap.set("n", "<leader><C-x>", "<cmd>close<CR>", {desc = "Close current split"})

-- Disable arrows
keymap.set("n", "<Up>", ':echoe "Use k"<CR>', {desc = "Use k"})
keymap.set("n", "<Down>", ':echoe "Use j"<CR>', {desc = "Use j"})
keymap.set("n", "<Right>", ':echoe "Use l"<CR>', {desc = "Use l"})
keymap.set("n", "<Left>", ':echoe "Use h"<CR>', {desc = "Use h"})

keymap.set("i", "<Up>", '<ESC>:echoe "Use k"<CR>', {desc = "Use k"})
keymap.set("i", "<Down>", '<ESC>:echoe "Use j"<CR>', {desc = "Use j"})
keymap.set("i", "<Right>", '<ESC>:echoe "Use l"<CR>', {desc = "Use l"})
keymap.set("i", "<Left>", '<ESC>:echoe "Use h"<CR>', {desc = "Use h"})

-- Insert mode navigation
keymap.set("i", "<C-k>", "<Up>", {desc = "Up"})
keymap.set("i", "<C-j>", "<Down>", {desc = "Down"})
keymap.set("i", "<C-h>", "<Left>", {desc = "Left"})
keymap.set("i", "<C-l>", "<Right>", {desc = "Right"})

-- nohl
keymap.set("n", "<leader>nh", ":nohl<CR>", {desc = "Clear search highlights"})

-- Increment and decrement numbers
keymap.set("n", "<leader>+", "<C-a>", {desc = "Increment Number"})
keymap.set("n", "<leader>-", "<C-x>", {desc = "Decrement Number"})

-- Toggle relativenumber
keymap.set("n", "<leader>tn", utils.toggle_relativenumber, {desc = "Toggle relative/absolute line numbers"})
