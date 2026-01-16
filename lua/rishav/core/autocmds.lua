---@module "rishav.core.autocmds"
---Autocommands configuration
local utils = require("rishav.core.utils")

local augroup = utils.augroup
local autocmd = utils.autocmd

-- Highlight yanked text
autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = augroup("highlight_yank"),
    callback = function()
        vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

-- Auto-resize splits on window resize
autocmd("VimResized", {
    desc = "Auto-resize splits on window resize",
    group = augroup("resize_splits"),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- Terminal settings
autocmd("TermOpen", {
    desc = "Set terminal-specific options",
    group = augroup("terminal_settings"),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.scrolloff = 0
    end,
})

-- Check if we need to reload the file when it changes
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    desc = "Check for file changes on focus",
    group = augroup("checktime"),
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd.checktime()
        end
    end,
})

-- Go to last location when opening a buffer
autocmd("BufReadPost", {
    desc = "Go to last location when opening a buffer",
    group = augroup("last_location"),
    callback = function(event)
        local exclude = { "gitcommit", "gitrebase", "help" }
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

-- Close some filetypes with <q>
autocmd("FileType", {
    desc = "Close certain windows with q",
    group = augroup("close_with_q"),
    pattern = {
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "checkhealth",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
    end,
})

-- Auto create directory when saving a file
autocmd("BufWritePre", {
    desc = "Auto create directory when saving a file",
    group = augroup("auto_create_dir"),
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- Disable concealment for specific filetypes
autocmd("FileType", {
    desc = "Disable conceallevel for specific filetypes",
    group = augroup("no_conceal"),
    pattern = { "json", "jsonc", "markdown" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})

-- Set wrap and spell for text filetypes
autocmd("FileType", {
    desc = "Enable wrap and spell for text filetypes",
    group = augroup("wrap_spell"),
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Fix conceallevel for json files
autocmd("FileType", {
    desc = "Fix JSON files conceallevel",
    group = augroup("json_conceal"),
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})

-- Custom ColorColumn highlight
local function set_custom_highlights()
    vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = 0, bg = "#2e2e2e" })
end

autocmd("ColorScheme", {
    desc = "Set custom highlights on colorscheme change",
    group = augroup("custom_highlights"),
    pattern = "*",
    callback = set_custom_highlights,
})

-- Apply custom highlights on startup
set_custom_highlights()
