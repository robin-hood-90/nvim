---@module "rishav.core.options"
---Core Neovim options and settings (josean-dev inspired minimaalism)
local opt = vim.opt
local g = vim.g

vim.cmd("let g:netrw_liststyle = 3")

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

opt.number = true
opt.relativenumber = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.showmode = false
opt.laststatus = 3

opt.splitright = true
opt.splitbelow = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")

opt.mouse = "a"

opt.swapfile = false
opt.undofile = true

opt.updatetime = 200
opt.timeoutlen = 300

opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "0"
