return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            background = {
                light = "latte",
                dark = "mocha",
            },
            transparent_background = true, -- Enable transparency
            show_end_of_buffer = false,
            term_colors = true,
            dim_inactive = {
                enabled = false,
                shade = "dark",
                percentage = 0.15,
            },
            no_italic = false,
            no_bold = false,
            no_underline = false,
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = {},
                functions = { "bold" },
                keywords = { "italic" },
                strings = {},
                variables = {},
                numbers = {},
                booleans = { "bold" },
                properties = {},
                types = { "bold" },
                operators = {},
            },
            color_overrides = {},
            custom_highlights = function(colors)
                return {
                    -- Better visibility for completion menu selection
                    PmenuSel = { bg = colors.surface1, fg = colors.text, bold = true },
                    CmpItemAbbrMatch = { fg = colors.blue, bold = true },
                    CmpItemAbbrMatchFuzzy = { fg = colors.blue, bold = true },
                    -- Floating windows
                    FloatBorder = { fg = colors.blue },
                    -- Cursor line
                    CursorLine = { bg = colors.surface0 },
                    -- Visual selection
                    Visual = { bg = colors.surface1 },
                }
            end,
            default_integrations = true,
            integrations = {
                alpha = true,
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                treesitter_context = true,
                notify = true,
                noice = true,
                indent_blankline = {
                    enabled = true,
                    scope_color = "lavender",
                    colored_indent_levels = false,
                },
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
                    inlay_hints = {
                        background = true,
                    },
                },
                dap = true,
                dap_ui = true,
                telescope = {
                    enabled = true,
                },
                lsp_trouble = true,
                which_key = true,
                mason = true,
                ufo = true,
            },
        })

        vim.cmd.colorscheme("catppuccin")

        -- Set up nvim-notify with transparent background
        local ok, notify = pcall(require, "notify")
        if ok then
            notify.setup({
                background_colour = "#000000",
            })
        end
    end,
}
