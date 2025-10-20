vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})
require("oil").setup({
	view_options = {
		show_hidden = true,
	},
	skip_confirm_for_simple_edits = true,
	float = {
		padding = 2,
		max_width = 0.35,
		max_height = 0.5,
		border = "rounded", -- You can change to "single", "double", etc.
		win_options = {
			winblend = 0,
		},
	},
	default_file_explorer = false,
	columns = {
		"icon",
	},
})

vim.keymap.set({ "n", "v", "x" }, "<leader>o", require("oil").toggle_float, { desc = "toggle oil file tree" })
