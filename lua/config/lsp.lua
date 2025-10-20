vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})
require("mason").setup({})
require("mason-lspconfig").setup({})
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"gopls",
		"clangd",
		"stylua",
		"jdtls",
		"java-debug-adapter",
		"java-test",
		"ts_ls",
		"tailwindcss",
		"rust-analyzer",
		"prettier",
		"isort",
		"black",
		"eslint",
		"emmet_ls",
	},
	automatic_installation = true,
	automatic_enable = {
		exclude = { "jdtls" },
	},
})

vim.diagnostic.config({
	virtual_text = {
		prefix = "■", -- or "▎", "■", "", anything you like
		spacing = 2, -- space between text and diagnostic message
		source = true, -- show the diagnostic source (like 'lua_ls')
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	float = {
		border = "rounded",
	},
	underline = true,
	update_in_insert = true, -- disable diagnostics while typing
	severity_sort = true,
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			completion = { callSnippet = "Replace" },
			workspace = {
				library = {
					vim.fn.stdpath("config"),
					vim.fn.expand("$VIMRUNTIME"),
					vim.fn.stdpath("data"),
				},
			},
		},
	},
})

vim.lsp.config("tailwindcss", {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"svelte",
		"vue",
	},
})

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--compile-commands-dir=./",
		"--background-index",
		"--pch-storage=memory",
		"--all-scopes-completion",
		"--pretty",
		"--header-insertion=never",
		"-j=4",
		"--inlay-hints",
		"--header-insertion-decorators",
		"--function-arg-placeholders",
		"--completion-style=detailed",
	},
	filetypes = { "c", "cpp", "objc", "objcpp" },
})

vim.lsp.config("eslint", {
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

vim.lsp.config("emmet_ls", {
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

vim.lsp.config("gopls", {
	settings = {
		gopls = {
			analyses = { unusedparams = true, shadow = true },
			staticcheck = true,
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = vim.fs.dirname(vim.fs.find({
		"go.work",
		"go.mod",
		".git",
	}, { upward = true })[1]),
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local keymap = vim.keymap
		local opts = { buffer = ev.buf, silent = true }

		opts.desc = "Show LSP references"
		keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

		opts.desc = "Go to declaration"
		keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

		opts.desc = "Show LSP definitions"
		keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

		opts.desc = "Show LSP implementations"
		keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

		opts.desc = "Show LSP type definitions"
		keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

		opts.desc = "See available code actions"
		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

		opts.desc = "Smart rename"
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

		opts.desc = "Show buffer diagnostics"
		keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

		opts.desc = "Show line diagnostics"
		keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

		opts.desc = "Go to previous diagnostic"
		keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, opts)

		opts.desc = "Go to next diagnostic"
		keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opts)

		opts.desc = "Show documentation for what is under cursor"
		keymap.set("n", "K", vim.lsp.buf.hover, opts)

		opts.desc = "Restart LSP"
		keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

		opts.desc = "Apply quickfix automatically"
		keymap.set("n", "<leader>cf", function()
			vim.lsp.buf.code_action({ apply = true })
		end, { desc = "Apply quickfix automatically" })
	end,
})
