---@module "rishav.plugins.lsp.lsp"
---LSP configuration
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
    },
    config = function()
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        -- Get capabilities from cmp-nvim-lsp
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Add folding capabilities for nvim-ufo
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        vim.lsp.enable("jdtls", false)
    end,
}
