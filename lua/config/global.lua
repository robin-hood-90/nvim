vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/kylechui/nvim-surround" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.8" },
	{ src = "https://github.com/rcarriga/nvim-notify" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/LinArcX/telescope-env.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-jdtls" },
})
require("nvim-surround").setup()
require("render-markdown").setup({})
require("nvim-autopairs").setup({})
require("ibl").setup()

-- Telescope settings
local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup({
	defaults = {
		color_devicons = true,
		sorting_strategy = "ascending",
		path_displays = { "smart" },
		layout_config = {
			height = 30,
			width = 150,
			prompt_position = "top",
			preview_cutoff = 60,
		},
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous, -- move to prev result
				["<C-j>"] = actions.move_selection_next, -- move to next result
			},
		},
	},
})
telescope.load_extension("ui-select")

--trouble settings
require("trouble").setup({})

require("noice").setup({
	presets = {
		bottom_search = false,
		command_palette = false,
		long_message_to_split = false,
		inc_rename = false,
		lsp_doc_border = true, -- ✅ set to true to give LSP docs rounded borders
	},
	views = {
		popup = {
			border = {
				style = "rounded", -- ✅ force rounded
			},
		},
	},
})

vim.cmd("colorscheme vague")
vim.cmd("hi statusline guibg=NONE")
