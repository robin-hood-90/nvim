vim.pack.add({
	{ src = "https://github.com/github/copilot.vim" },
	{
		src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"github/copilot.vim",
			"nvim-lua/plenary.nvim",
		},
	},
})

-- vim.g.copilot_no_tab_map = true

require("CopilotChat").setup({
	debug = false,
	model = "claude-3.5-sonnet",
	temperature = 0.6,
	headers = {
		user = "👤 You",
		assistant = "🤖 Copilot",
		tool = "🔧 Tool",
	},
	context = "buffer",
	separator = "━━",
	auto_fold = true,
	highlight_headers = true,
	markdown = {
		enable = true,
		highlight = true,
		theme = "nord",
	},
	-- Modern way to add context
	sources = {
		buffer = true, -- include current buffer
		lsp_diagnostics = function()
			local diagnostics = vim.diagnostic.get(0)
			local text = ""
			for _, d in ipairs(diagnostics) do
				text = text .. ("[%s] %s (line %d)\n"):format(d.source or "LSP", d.message, d.lnum + 1)
			end
			return text
		end,
		lsp_symbols = function()
			local result = ""
			local responses = vim.lsp.buf_request_sync(
				0,
				"textDocument/documentSymbol",
				{ textDocument = vim.lsp.util.make_text_document_params() },
				500
			)
			if responses then
				for _, res in pairs(responses) do
					for _, s in pairs(res.result or {}) do
						result = result .. ("- %s (%s)\n"):format(s.name, s.kind)
					end
				end
			end
			return result
		end,
	},
})

-- Keymaps
vim.api.nvim_set_keymap("i", "<Tab>", "copilot#Accept('<CR>')", { expr = true, desc = "Accept Copilot suggestion" })
vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChat<CR>", { desc = "Open Copilot Chat" })
vim.keymap.set("n", "<leader>cm", "<cmd>CopilotChatModels<CR>", { desc = "Choose Copilot Model" })
vim.keymap.set("v", "<leader>ce", ":CopilotChat explain<CR>", { desc = "Explain code" })
vim.keymap.set("v", "<leader>cr", ":CopilotChat review<CR>", { desc = "Review code" })
vim.keymap.set("v", "<leader>ct", ":CopilotChat tests<CR>", { desc = "Generate tests" })
vim.keymap.set("v", "<leader>cf", ":CopilotChat refactor<CR>", { desc = "Refactor code" })
