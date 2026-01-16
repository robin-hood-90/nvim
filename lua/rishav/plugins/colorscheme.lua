return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha",
            transparent_background = true,
            show_end_of_buffer = false,
            term_colors = true,
            dim_inactive = { enabled = false },
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                functions = { "bold" },
                keywords = { "italic" },
                booleans = { "bold" },
                types = { "bold" },
            },
            custom_highlights = function(colors)
                return {
                    -- Solid background for completion menu (not transparent)
                    Pmenu = { bg = colors.base, fg = colors.text },
                    PmenuSel = { bg = colors.surface1, fg = colors.text, bold = true },
                    PmenuSbar = { bg = colors.surface0 },
                    PmenuThumb = { bg = colors.surface2 },

                    -- nvim-cmp specific (solid backgrounds)
                    CmpItemMenu = { bg = colors.base },
                    CmpItemAbbr = { fg = colors.text, bg = "NONE" },
                    CmpItemAbbrMatch = { fg = colors.blue, bold = true },
                    CmpItemAbbrMatchFuzzy = { fg = colors.blue, bold = true },
                    CmpItemAbbrDeprecated = { fg = colors.overlay0, strikethrough = true },
                    CmpItemKind = { fg = colors.blue },

                    -- Floating windows (transparent)
                    NormalFloat = { bg = "NONE" },
                    FloatBorder = { fg = colors.blue, bg = "NONE" },
                    FloatTitle = { fg = colors.mauve, bg = "NONE", bold = true },

                    -- Telescope (transparent)
                    TelescopeNormal = { bg = "NONE" },
                    TelescopeBorder = { fg = colors.blue, bg = "NONE" },
                    TelescopePromptNormal = { bg = "NONE" },
                    TelescopePromptBorder = { fg = colors.blue, bg = "NONE" },
                    TelescopeResultsNormal = { bg = "NONE" },
                    TelescopeResultsBorder = { fg = colors.blue, bg = "NONE" },
                    TelescopePreviewNormal = { bg = "NONE" },
                    TelescopePreviewBorder = { fg = colors.blue, bg = "NONE" },

                    -- Noice (transparent)
                    NoiceCmdlinePopup = { bg = "NONE" },
                    NoiceCmdlinePopupBorder = { fg = colors.blue, bg = "NONE" },
                    NoicePopupmenu = { bg = colors.base }, -- Keep menu solid
                    NoicePopupmenuBorder = { fg = colors.blue, bg = "NONE" },

                    -- Which-key (transparent)
                    WhichKeyFloat = { bg = "NONE" },
                    WhichKeyBorder = { fg = colors.blue, bg = "NONE" },

                    -- Notify (transparent)
                    NotifyBackground = { bg = colors.base },

                    -- UI elements
                    CursorLine = { bg = colors.surface0 },
                    Visual = { bg = colors.surface1 },
                    LineNr = { fg = colors.surface1 },
                    CursorLineNr = { fg = colors.lavender, bold = true },
                }
            end,
            integrations = {
                alpha = true,
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                treesitter_context = true,
                notify = true,
                noice = true,
                indent_blankline = { enabled = true, scope_color = "lavender" },
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                    inlay_hints = { background = true },
                },
                dap = true,
                dap_ui = true,
                telescope = { enabled = true },
                lsp_trouble = true,
                which_key = true,
                mason = true,
            },
        })

        vim.cmd.colorscheme("catppuccin")

        -- Ensure notify has proper background for transparency
        local ok, notify = pcall(require, "notify")
        if ok then
            ---@diagnostic disable-next-line: missing-fields
            notify.setup({ background_colour = "#1e1e2e" })
        end
    end,
}
