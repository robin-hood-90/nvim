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
            },
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            -- Load VSCode-style snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            -- Modern completeopt setting
            vim.opt.completeopt = { "menu", "menuone", "noinsert", "preview" }

            ---@type cmp.ConfigSchema
            local config = {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

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
                    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if cmp.get_selected_entry() then
                                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                            else
                                fallback()
                            end
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    -- Tab/S-Tab for navigation only when cmp menu is visible
                    -- Copilot handles Tab when menu is not visible (see copilot.lua)
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
                    { name = "lazydev", group_index = 0 }, -- set group index to 0 to skip loading LuaLS completions
                    { name = "nvim_lsp", priority = 1000, max_item_count = 30 },
                    { name = "luasnip", priority = 750, max_item_count = 10 },
                    { name = "path", priority = 500 },
                }, {
                    {
                        name = "buffer",
                        priority = 250,
                        max_item_count = 10,
                        option = {
                            -- Only get completions from visible buffers (more performant)
                            get_bufnrs = function()
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
                        before = function(entry, vim_item)
                            -- Show source in menu
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
                        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
                        scrollbar = true,
                    }),
                    documentation = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
                        max_width = 80,
                        max_height = 20,
                    }),
                },

                experimental = {
                    ghost_text = false, -- Disabled to avoid conflicts with Copilot ghost text
                },
            }

            cmp.setup(config)

            -- Cmdline setup for '/' and '?' (search)
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Cmdline setup for ':' (commands)
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
                }),
                matching = { disallow_symbol_nonprefix_matching = false },
            })
        end,
    },
}
