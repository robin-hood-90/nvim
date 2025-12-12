return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer", -- source for text in buffer
        "hrsh7th/cmp-path", -- source for file system paths
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = "make install_jsregexp",
        },
        "saadparwaiz1/cmp_luasnip", -- for autocompletion
        "rafamadriz/friendly-snippets", -- useful snippets
        "onsails/lspkind.nvim", -- vs-code like pictograms
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        -- Load VSCode-style snippets
        require("luasnip.loaders.from_vscode").lazy_load()
        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                -- Tab only handles snippet jumping when inside a snippet
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.in_snippet() and luasnip.jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback() -- Let tabout handle it
                    end
                end, { "i", "s" }),
                -- Shift-Tab only handles snippet jumping when inside a snippet
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.in_snippet() and luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback() -- Let tabout handle it
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
            }),
            formatting = {
                format = lspkind.cmp_format({
                    maxwidth = 50,
                    ellipsis_char = "...",
                }),
            },
            window = {
                completion = cmp.config.window.bordered({
                    border = "rounded",
                }),
                documentation = cmp.config.window.bordered({
                    border = "rounded",
                }),
            },
        })
        -- Optional: Make the borders visually appealing
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#7aa2f7", bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
}
