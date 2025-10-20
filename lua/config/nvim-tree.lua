vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
})

require("nvim-tree").setup({
	view = {
		width = 30,
		side = "right",
		number = false,
		relativenumber = false,
	},
	renderer = {
		highlight_git = true,
		-- highlight_opened_files = "all",
		root_folder_modifier = ":t",
		icons = {
			show = {
				git = true,
				folder = true,
				file = true,
				folder_arrow = true,
			},
			glyphs = {
				default = " ",
				symlink = " ",
				folder = {
					arrow_closed = " ",
					arrow_open = " ",
					default = " ",
					open = " ",
					empty = " ",
					empty_open = " ",
					symlink = " ",
					symlink_open = " ",
				},
				git = {
					unstaged = "✗",
					staged = "✓",
					unmerged = "",
					renamed = "➜",
					untracked = "★",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	filters = {
		dotfiles = false,
		custom = { "^.git$", "node_modules", ".cache" },
	},
})

local keymap = vim.keymap
keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
