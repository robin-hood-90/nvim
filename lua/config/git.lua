vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
})

-- ============ Gitsigns Setup ============
require("gitsigns").setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signcolumn = true,
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 300,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
})

local gs = require("gitsigns")

local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
end
-- Actions
map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
map("v", "<leader>hs", function()
	gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, "Stage Selection")
map("v", "<leader>hr", function()
	gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, "Reset Selection")
map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
map("n", "<leader>hb", function()
	gs.blame_line({ full = true })
end, "Blame Line")
map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle Line Blame")
map("n", "<leader>hd", gs.diffthis, "Diff This")
-- ============ LazyGit Setup ============
-- vim.g.lazygit_floating_window_winblend = 10
-- vim.g.lazygit_floating_window_scaling_factor = 0.9
-- vim.g.lazygit_floating_window_use_plenary = 1
-- vim.g.lazygit_use_neovim_remote = 1

vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Open LazyGit" })
