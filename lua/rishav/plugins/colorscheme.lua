---@module "rishav.plugins.colorscheme"
---Rose Pine colorscheme configuration (main variant)
return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
        require("rose-pine").setup({
            variant = "main",
            dim_inactive_windows = false,
            enable = {
                terminal = true,
            },
            styles = {
                bold = true,
                italic = true,
                transparency = true,
            },
            highlight_groups = {
                -- Syntax style overrides
                Comment = { italic = true },
                Conditional = { italic = true },
                Function = { bold = true },
                Keyword = { italic = true },
                Boolean = { bold = true },
                Type = { bold = true },

                -- Float window styling
                FloatBorder = { fg = "foam", bg = "NONE" },
                FloatTitle = { fg = "iris", bg = "NONE", bold = true },
                NormalFloat = { bg = "NONE" },

                -- UI elements
                CursorLineNr = { fg = "iris", bold = true },

                -- Terminal
                TermCursor = { bg = "rose" },
                TermCursorNC = { bg = "highlight_high" },
            },
        })

        vim.cmd.colorscheme("rose-pine")
    end,
}
