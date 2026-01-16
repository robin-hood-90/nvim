---@module "rishav.plugins.nvim-cmp"
---Completion engine configuration
return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                dependencies = {
                    "rafamadriz/friendly-snippets",
                },
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            local icons = require("rishav.core.icons")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                ---@diagnostic disable-next-line: missing-fields
                performance = {
                    debounce = 60,
                    throttle = 30,
                    fetching_timeout = 500,
                    max_view_entries = 50,
                },

                completion = {
                    completeopt = "menu,menuone,noinsert,preview",
                },

                mapping = cmp.mapping.preset.insert({
                    -- Navigation
                    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),

                    -- Scrolling docs
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),

                    -- Trigger completion
                    ["<C-Space>"] = cmp.mapping.complete(),

                    -- Abort
                    ["<C-e>"] = cmp.mapping.abort(),

                    -- Confirm selection
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() and cmp.get_selected_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    -- Tab for navigation and snippet jumping
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),

                sources = cmp.config.sources({
                    { name = "lazydev", group_index = 0 },
                    { name = "nvim_lsp", priority = 1000, max_item_count = 30 },
                    { name = "luasnip", priority = 750, max_item_count = 10 },
                    { name = "path", priority = 500 },
                }, {
                    {
                        name = "buffer",
                        priority = 250,
                        max_item_count = 10,
                        option = {
                            get_bufnrs = function()
                                -- Only visible buffers (performance optimization)
                                local bufs = {}
                                for _, win in ipairs(vim.api.nvim_list_wins()) do
                                    bufs[vim.api.nvim_win_get_buf(win)] = true
                                end
                                return vim.tbl_keys(bufs)
                            end,
                        },
                    },
                }),

                sorting = {
                    priority_weight = 2,
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },

                formatting = {
                    expandable_indicator = true,
                    fields = { "abbr", "kind", "menu" },
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                        show_labelDetails = true,
                        symbol_map = icons.kinds,
                        before = function(entry, vim_item)
                            vim_item.menu = ({
                                nvim_lsp = "[LSP]",
                                luasnip = "[Snip]",
                                buffer = "[Buf]",
                                path = "[Path]",
                                lazydev = "[Lazy]",
                                cmdline = "[Cmd]",
                            })[entry.source.name] or ("[" .. entry.source.name .. "]")
                            return vim_item
                        end,
                    }),
                },

                window = {
                    completion = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                        scrollbar = true,
                    }),
                    documentation = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                        max_width = 80,
                        max_height = 20,
                    }),
                },

                experimental = {
                    ghost_text = false, -- Disabled for Copilot compatibility
                },
            })

            -- Cmdline setup for search
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Cmdline setup for commands
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
                }),
                ---@diagnostic disable-next-line: missing-fields
                matching = {
                    disallow_symbol_nonprefix_matching = false,
                },
            })
        end,
    },
}
