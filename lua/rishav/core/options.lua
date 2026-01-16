-- Disable netrw in favor of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

opt.wrap = false

-- Performance optimizations
opt.lazyredraw = false -- Disabled when using noice.nvim
opt.updatetime = 250 -- Faster completion (default is 4000ms)
opt.timeoutlen = 300 -- Faster which-key popup
opt.redrawtime = 10000
opt.maxmempattern = 20000

-- Undo persistence
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undodir"

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.cursorline = true

-- Colors
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen" -- Keep text on screen when splitting

-- Disable swapfile (using undofile instead)
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.colorcolumn = "90"

-- Better completion experience
opt.pumheight = 10 -- Popup menu height
opt.pumblend = 10 -- Popup menu transparency

-- Misc
opt.mouse = "a"
opt.showmode = false -- Don't show mode since we have statusline
opt.virtualedit = "block" -- Allow cursor to move where there's no text in visual block mode
opt.inccommand = "split" -- Preview substitutions live

-- Diagnostic configuration (modern Neovim 0.10+)
vim.diagnostic.config({
    virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
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
    signs = true,
    severity_sort = true,
    update_in_insert = false,
})

-- Custom ColorColumn highlight
local function set_custom_highlights()
    vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 0, bg = "#2e2e2e" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = set_custom_highlights,
})
set_custom_highlights()

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

-- Auto-resize splits on window resize
vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("resize-splits", { clear = true }),
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Terminal settings
vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
    callback = function()
        opt.number = false
        opt.relativenumber = false
        opt.signcolumn = "no"
    end,
})

-- Check if we need to reload the file when it changes
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = vim.api.nvim_create_augroup("checktime", { clear = true }),
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("last-loc", { clear = true }),
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
            return
        end
        vim.b[buf].last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})
