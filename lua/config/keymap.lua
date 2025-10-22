vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("n", "<leader>q", ":q<CR>")

keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- some other key bindings

-- increment/decrement numbers

keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<C-j>", "<C-w>j", { desc = "move to down window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "move to top window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "move to right window" })
keymap.set("n", "<C-h>", "<C-w>h", { desc = "move to left window" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- resize window
keymap.set({ "n", "t" }, "<C-Down>", ":resize -2<CR>", { desc = "resize to down window" })
keymap.set({ "n", "t" }, "<C-Up>", ":resize +2<CR>", { desc = "resize to top window" })
keymap.set({ "n", "t" }, "<C-Right>", ":vertical resize -2<CR>", { desc = "resize to right window" })
keymap.set({ "n", "t" }, "<C-Left>", ":vertical resize +2<CR>", { desc = "resize to left window" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

keymap.set("n", "<leader>/", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
keymap.set("n", "H", "^")
keymap.set("n", "L", "$")

vim.keymap.set("n", "<C-t>", function()
	vim.cmd.vsplit()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 12)
end)
-- Telescope keymaps
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "find help_tags" })
vim.keymap.set("n", "<leader>fn", "<cmd>Telescope notify<cr>", { desc = "find notifictions" })

-- Trouble keymaps
vim.keymap.set(
	"n",
	"<leader>xw",
	"<cmd>Trouble diagnostics toggle<cr>",
	{ desc = "Open diagnostics for the workspace" }
)
vim.keymap.set(
	"n",
	"<leader>xd",
	"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
	{ desc = "Open diagnostics for the current buffer" }
)
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Open location list" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", { desc = "Open quickfix list" })

vim.keymap.set("n", "<leader>nd", "<cmd>NotificationsClear<CR>", { desc = "Toggle Neotree" })
