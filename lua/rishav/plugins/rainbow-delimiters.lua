---@module "rishav.plugins.rainbow-delimiters"
---Rainbow bracket highlighting with treesitter precision
---
---Uses rainbow-delimiters.nvim for precise bracket pair highlighting
---with different colors for nested levels. Works seamlessly with
---existing treesitter, autopairs, and color scheme.
return {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local rainbow = require("rainbow-delimiters")

        require("rainbow-delimiters.setup").setup({
            -- Strategy: global for most buffers, local for vimscript
            -- Global strategy processes entire file at once
            -- Local strategy is more efficient for large files
            strategy = {
                [""] = rainbow.strategy["global"],
                vim = rainbow.strategy["local"],
                -- Disable for very large files (>10000 lines) to maintain performance
                -- You can adjust this threshold based on your machine
            },

            -- Query patterns for different languages
            -- Default "rainbow-delimiters" works for most languages
            -- "rainbow-blocks" is specialized for Lua blocks
            query = {
                [""] = "rainbow-delimiters",
                lua = "rainbow-blocks",
                -- Use default for query files (treesitter query language)
                query = "rainbow-delimiters",
                javascript = "rainbow-delimiters-react",
                typescript = "rainbow-delimiters-react",
                tsx = "rainbow-delimiters-react",
                jsx = "rainbow-delimiters-react",
            },

            -- Priority for highlighting - higher = shows on top
            priority = {
                [""] = 110,
                lua = 210,
            },

            -- Highlight groups - these should match your color scheme
            -- Default 7 colors that cycle through nested levels
            highlight = {
                "RainbowDelimiterRed",
                "RainbowDelimiterYellow",
                "RainbowDelimiterBlue",
                "RainbowDelimiterOrange",
                "RainbowDelimiterGreen",
                "RainbowDelimiterViolet",
                "RainbowDelimiterCyan",
            },

            -- Filetypes to enable - only LSP-supported languages
            -- Using whitelist ensures rainbow brackets only appear in code files
            whitelist = {
                -- C/C++ family
                "c",
                "cpp",
                "objc",
                "objcpp",
                -- Web development
                "html",
                "css",
                "scss",
                "sass",
                "less",
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
                "svelte",
                -- Data/Config
                "json",
                "yaml",
                "graphql",
                "gql",
                -- Programming languages
                "lua",
                "python",
                "go",
                "rust",
                "java",
                -- Typesetting
                "tex",
                "plaintex",
                "bib",
                "typst",
            },
            -- Blacklist specifically excludes text and markdown
            blacklist = {
                "text",
                "markdown",
                "markdown_inline",
            },
        })

        -- Set up highlight groups with BRIGHT vibrant colors
        -- These high-saturation colors will really pop on screen
        local function setup_highlights()
            -- Bright vibrant colors for maximum visibility
            vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#ff4444", bold = true })
            vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#ffdd00", bold = true })
            vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#00aaff", bold = true })
            vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#ff8800", bold = true })
            vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#00ff66", bold = true })
            vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#dd55ff", bold = true })
            vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#00ffff", bold = true })
        end

        -- Set up highlights immediately
        setup_highlights()

        -- Re-apply highlights when colorscheme changes
        -- This ensures colors persist through theme switching
        local group = vim.api.nvim_create_augroup("RainbowDelimitersHighlights", { clear = true })
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = group,
            callback = setup_highlights,
            desc = "Set up rainbow delimiter highlights after colorscheme change",
        })
    end,
}
