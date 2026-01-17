local opt = vim.opt
local g = vim.g

-- Leader
g.mapleader = " "
g.maplocalleader = " "

-- UI
opt.number = true
opt.relativenumber = true

opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.wrap = false

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.wildignorecase = true

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Files
opt.autoread = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Undo
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undolevels = 10000
opt.undoreload = 10000

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Mouse (disabled)
opt.mouse = ""
opt.mousescroll = "ver:0,hor:0"

-- Russian layout support in normal mode
-- Map Russian keys to English equivalents for navigation
opt.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- Other
opt.backspace = "indent,eol,start"

-- Disable netrw
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
