---@module "rishav.core.options"
---Core Neovim options and settings

local opt = vim.opt
local g = vim.g

--------------------------------------------------------------------------------
-- Globals
--------------------------------------------------------------------------------
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

--------------------------------------------------------------------------------
-- Line Numbers
--------------------------------------------------------------------------------
opt.number = true
opt.relativenumber = true

--------------------------------------------------------------------------------
-- Tabs & Indentation
--------------------------------------------------------------------------------
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.shiftround = true -- Round indent to multiple of shiftwidth

--------------------------------------------------------------------------------
-- Text Display
--------------------------------------------------------------------------------
opt.wrap = false
opt.linebreak = true -- Wrap at word boundaries when wrap is enabled
opt.breakindent = true -- Preserve indentation in wrapped text
opt.showbreak = "↪ " -- String to show at the start of wrapped lines

--------------------------------------------------------------------------------
-- Search
--------------------------------------------------------------------------------
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.grepprg = "rg --vimgrep --smart-case --hidden"
opt.grepformat = "%f:%l:%c:%m"

--------------------------------------------------------------------------------
-- UI
--------------------------------------------------------------------------------
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.colorcolumn = "90"
opt.showmode = false -- Don't show mode (statusline handles it)
opt.pumheight = 10 -- Popup menu height
opt.pumblend = 10 -- Popup menu transparency
opt.cmdheight = 1
opt.laststatus = 3 -- Global statusline
opt.list = true -- Show invisible characters
opt.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣",
    extends = "❯",
    precedes = "❮",
}
opt.fillchars = {
    fold = " ",
    diff = "╱",
    eob = " ",
}

--------------------------------------------------------------------------------
-- Windows & Splits
--------------------------------------------------------------------------------
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.winminwidth = 5

--------------------------------------------------------------------------------
-- Scrolling
--------------------------------------------------------------------------------
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.smoothscroll = true

--------------------------------------------------------------------------------
-- Editing
--------------------------------------------------------------------------------
opt.backspace = "indent,eol,start"
opt.virtualedit = "block" -- Allow cursor to move where there's no text in visual block mode
opt.inccommand = "split" -- Preview substitutions live
opt.formatoptions = "jcroqlnt" -- Better formatting options

--------------------------------------------------------------------------------
-- Clipboard
--------------------------------------------------------------------------------
opt.clipboard = "unnamedplus"

--------------------------------------------------------------------------------
-- Files & Backup
--------------------------------------------------------------------------------
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undolevels = 10000
opt.undodir = vim.fn.stdpath("state") .. "/undodir"
opt.autowrite = true
opt.confirm = true -- Confirm before closing unsaved buffers

--------------------------------------------------------------------------------
-- Performance
--------------------------------------------------------------------------------
opt.lazyredraw = false -- Disabled when using noice.nvim
opt.updatetime = 200 -- Faster completion
opt.timeoutlen = 300 -- Faster which-key popup
opt.redrawtime = 10000
opt.maxmempattern = 20000
opt.synmaxcol = 300 -- Don't syntax highlight long lines

--------------------------------------------------------------------------------
-- Mouse
--------------------------------------------------------------------------------
opt.mouse = "a"
opt.mousemoveevent = true

--------------------------------------------------------------------------------
-- Session
--------------------------------------------------------------------------------
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

--------------------------------------------------------------------------------
-- Completion
--------------------------------------------------------------------------------
opt.completeopt = "menu,menuone,noinsert,preview"
opt.wildmode = "longest:full,full"
opt.shortmess:append({ W = true, I = true, c = true, C = true })

--------------------------------------------------------------------------------
-- Folding (use treesitter/ufo)
--------------------------------------------------------------------------------
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "0"

--------------------------------------------------------------------------------
-- Diagnostics (Modern Neovim 0.10+)
--------------------------------------------------------------------------------
local icons = require("rishav.core.icons")

vim.diagnostic.config({
    virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = icons.ui.circle,
    },
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
    underline = true,
    signs = icons.get_diagnostic_signs(),
    severity_sort = true,
    update_in_insert = false,
})
