---@module "rishav.plugins.which-key"
---Key binding hints and organization
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        delay = 300,
        icons = {
            breadcrumb = "»",
            separator = "➜",
            group = "+",
            mappings = true,
        },
        spec = {
            -- Groups
            { "<leader>b", group = "Buffer" },
            { "<leader>c", group = "Code" },
            { "<leader>e", group = "Explorer" },
            { "<leader>f", group = "Find" },
            { "<leader>g", group = "Git" },
            { "<leader>h", group = "Hunk" },
            { "<leader>l", group = "LSP" },
            { "<leader>r", group = "Rename/Replace" },
            { "<leader>s", group = "Split" },
            { "<leader>t", group = "Tab/Terminal" },
            { "<leader>x", group = "Quickfix" },

            -- Direct mappings
            { "<leader>q", desc = "Quit" },
            { "<leader>w", desc = "Save all" },
            { "<leader>L", desc = "Lazy" },
        },
        win = {
            border = "rounded",
        },
    },
}
