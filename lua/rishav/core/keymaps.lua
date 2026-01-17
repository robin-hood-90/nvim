---@module "rishav.core.keymaps"
---Core keymaps configuration
---
--- Keymap Philosophy:
--- - Home row priority for frequent actions
--- - Logical groupings under leader key
--- - Bracket motions for navigation ([/])
--- - Ctrl for system-level actions
--- - Alt for line manipulation
--- - Single keys for most common operations

local utils = require("rishav.core.utils")

local map = utils.map

--------------------------------------------------------------------------------
-- General / Essential
--------------------------------------------------------------------------------
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("i", "kj", "<ESC>", { desc = "Exit insert mode (alt)" })
map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>W", "<cmd>wa<CR>", { desc = "Save all" })
map("n", "<Esc>", "<cmd>nohl<CR>", { desc = "Clear highlights" })

-- Quick access (no leader needed for frequent ops)
map("n", "<BS>", "X", { desc = "Delete char before" })

--------------------------------------------------------------------------------
-- Better Movement
--------------------------------------------------------------------------------
-- Move on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up" })

-- Keep cursor centered
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Previous search centered" })
map("n", "*", "*zzzv", { desc = "Search word centered" })
map("n", "#", "#zzzv", { desc = "Search word back centered" })
map("n", "G", "Gzz", { desc = "Go to end centered" })

-- Join lines without moving cursor
map("n", "J", "mzJ`z", { desc = "Join lines" })

-- Quick line navigation (use gh/gl to avoid conflict with Shift+H/L for buffers)
map({ "n", "x", "o" }, "gh", "^", { desc = "Start of line (non-blank)" })
map({ "n", "x", "o" }, "gl", "$", { desc = "End of line" })

--------------------------------------------------------------------------------
-- Editing
--------------------------------------------------------------------------------
-- Better indenting (stay in visual mode)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
map("n", "<", "<<", { desc = "Indent left" })
map("n", ">", ">>", { desc = "Indent right" })

-- Move lines up/down (Alt + Up/Down - works reliably in tmux)
-- Note: C-j/C-k conflict with vim-tmux-navigator pane switching
map("n", "<M-Down>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<M-Up>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("i", "<M-Down>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<M-Up>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move line up" })
map("v", "<M-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<M-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Also map to <leader>mj/mk for reliability (m = move)
map("n", "<leader>mj", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<leader>mk", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("v", "<leader>mj", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<leader>mk", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Duplicate line/selection
map("n", "<M-d>", "<cmd>t.<CR>", { desc = "Duplicate line" })
map("v", "<M-d>", ":t'><CR>gv", { desc = "Duplicate selection" })
map("n", "<leader>md", "<cmd>t.<CR>", { desc = "Duplicate line" })
map("v", "<leader>md", ":t'><CR>gv", { desc = "Duplicate selection" })

-- Increment/decrement numbers (easier than C-a/C-x)
map("n", "+", "<C-a>", { desc = "Increment number" })
map("n", "-", "<C-x>", { desc = "Decrement number" })
map("v", "+", "g<C-a>", { desc = "Increment numbers" })
map("v", "-", "g<C-x>", { desc = "Decrement numbers" })

-- Better paste (don't yank replaced text)
map("x", "p", [["_dP]], { desc = "Paste without yanking" })

-- Delete without yanking (use 'x' prefix for cut operations)
map({ "n", "v" }, "x", [["_x]], { desc = "Delete char without yank" })
map({ "n", "v" }, "<leader>x", [["_d]], { desc = "Delete without yank" })

-- Yank to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })
map({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from clipboard" })
map({ "n", "v" }, "<leader>P", [["+P]], { desc = "Paste before from clipboard" })

-- Quick replace word under cursor
map("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

--------------------------------------------------------------------------------
-- Windows / Splits
--------------------------------------------------------------------------------
-- Split management (leader + s prefix)
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=", { desc = "Equal size splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })
map("n", "<leader>so", "<cmd>only<CR>", { desc = "Close other splits" })
map("n", "<leader>sr", "<C-w>r", { desc = "Rotate splits" })

-- Navigation (Ctrl + hjkl) - works with vim-tmux-navigator
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize with leader + arrow keys (C-arrows used by tmux)
map("n", "<leader>s<Up>", "<cmd>resize +4<CR>", { desc = "Increase height" })
map("n", "<leader>s<Down>", "<cmd>resize -4<CR>", { desc = "Decrease height" })
map("n", "<leader>s<Left>", "<cmd>vertical resize -4<CR>", { desc = "Decrease width" })
map("n", "<leader>s<Right>", "<cmd>vertical resize +4<CR>", { desc = "Increase width" })
-- Alternative: Use +/- for quick resize
map("n", "<leader>s+", "<cmd>resize +4<CR>", { desc = "Increase height" })
map("n", "<leader>s-", "<cmd>resize -4<CR>", { desc = "Decrease height" })
map("n", "<leader>s>", "<cmd>vertical resize +4<CR>", { desc = "Increase width" })
map("n", "<leader>s<", "<cmd>vertical resize -4<CR>", { desc = "Decrease width" })

--------------------------------------------------------------------------------
-- Tabs (josean-dev style - tabs shown in bufferline, buffers managed within)
-- Tabs = workspaces/contexts, Buffers = files within a workspace
--------------------------------------------------------------------------------
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

--------------------------------------------------------------------------------
-- Buffers (files within current tab)
--------------------------------------------------------------------------------
-- map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
-- map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader><Tab>", "<cmd>e #<CR>", { desc = "Alternate buffer" })

--------------------------------------------------------------------------------
-- Quickfix / Location List (use Trouble mainly, these are fallbacks)
--------------------------------------------------------------------------------
map("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
map("n", "[l", "<cmd>lprev<CR>zz", { desc = "Previous location" })
map("n", "]l", "<cmd>lnext<CR>zz", { desc = "Next location" })

--------------------------------------------------------------------------------
-- Diagnostics (bracket navigation)
--------------------------------------------------------------------------------
map("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
map("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "[e", function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Previous error" })
map("n", "]e", function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
end, { desc = "Next error" })
map("n", "[w", function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true })
end, { desc = "Previous warning" })
map("n", "]w", function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true })
end, { desc = "Next warning" })
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

--------------------------------------------------------------------------------
-- Better Command Line (C-a avoided - conflicts with tmux prefix)
--------------------------------------------------------------------------------
map("c", "<C-b>", "<Left>", { silent = false, desc = "Move left" })
map("c", "<C-f>", "<Right>", { silent = false, desc = "Move right" })
map("c", "<C-e>", "<End>", { silent = false, desc = "End of line" })
map("c", "<C-j>", "<Down>", { silent = false, desc = "Next history" })
map("c", "<C-k>", "<Up>", { silent = false, desc = "Previous history" })

-- Add undo break-points
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
-- map("i", ";", ";<C-g>u")
map("i", "!", "!<C-g>u")
map("i", "?", "?<C-g>u")

--------------------------------------------------------------------------------
-- Utilities
--------------------------------------------------------------------------------
map("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Lazy plugin manager" })
map("n", "<leader>M", "<cmd>Mason<CR>", { desc = "Mason package manager" })
map("n", "U", "<cmd>redo<CR>", { desc = "Redo" }) -- More intuitive than C-r

-- Toggle options
map("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "Toggle word wrap" })
map("n", "<leader>un", "<cmd>set number!<CR>", { desc = "Toggle line numbers" })
map("n", "<leader>ur", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative numbers" })
map("n", "<leader>us", "<cmd>set spell!<CR>", { desc = "Toggle spell check" })
map("n", "<leader>ul", "<cmd>set list!<CR>", { desc = "Toggle invisible chars" })
