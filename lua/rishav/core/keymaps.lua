---@module "rishav.core.keymaps"
---Core keymaps configuration
local utils = require("rishav.core.utils")

local map = utils.map

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })
map("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("n", "<leader>q", "<cmd>q!<CR>", { desc = "Quit" })
map("n", "<leader>w", "<cmd>wa<CR>", { desc = "Save all" })
map("n", "<Esc>", "<cmd>nohl<CR>", { desc = "Clear highlights" })
map("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Clear search highlights" })

--------------------------------------------------------------------------------
-- Better Movement
--------------------------------------------------------------------------------
-- Move on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up" })

-- Quick line navigation
map({ "n", "x", "o" }, "H", "^", { desc = "Start of line" })
map({ "n", "x", "o" }, "L", "$", { desc = "End of line" })

-- Keep cursor centered
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Previous search centered" })

-- Join lines without moving cursor
map("n", "J", "mzJ`z", { desc = "Join lines" })

--------------------------------------------------------------------------------
-- Editing
--------------------------------------------------------------------------------
-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move line up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Increment/decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Better paste (don't yank replaced text)
map("x", "p", [["_dP]], { desc = "Paste without yanking" })

-- Delete without yanking
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })

--------------------------------------------------------------------------------
-- Windows
--------------------------------------------------------------------------------
-- Split management
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=", { desc = "Equal size splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize with arrows
map({ "n", "t" }, "<S-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
map({ "n", "t" }, "<S-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
map({ "n", "t" }, "<S-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map({ "n", "t" }, "<S-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

--------------------------------------------------------------------------------
-- Buffers
--------------------------------------------------------------------------------
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<CR>", { desc = "Force delete buffer" })
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to other buffer" })

--------------------------------------------------------------------------------
-- Tabs
--------------------------------------------------------------------------------
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Previous tab" })
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open buffer in new tab" })
map("n", "[t", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "]t", "<cmd>tabnext<CR>", { desc = "Next tab" })

--------------------------------------------------------------------------------
-- Quickfix / Location List
--------------------------------------------------------------------------------
map("n", "<leader>xq", "<cmd>copen<CR>", { desc = "Open quickfix" })
map("n", "<leader>xl", "<cmd>lopen<CR>", { desc = "Open location list" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix" })
map("n", "[l", "<cmd>lprev<CR>", { desc = "Previous location" })
map("n", "]l", "<cmd>lnext<CR>", { desc = "Next location" })

--------------------------------------------------------------------------------
-- Diagnostics
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

--------------------------------------------------------------------------------
-- Misc
--------------------------------------------------------------------------------
-- Better command line
map("c", "<C-a>", "<Home>", { silent = false, desc = "Start of line" })
map("c", "<C-e>", "<End>", { silent = false, desc = "End of line" })

-- Add undo break-points
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", ";", ";<C-g>u")

-- Lazy
map("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Lazy plugin manager" })
