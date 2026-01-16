---@module "rishav.plugins"
---Base plugin specifications (plugins that need no config or minimal config)
return {
    -- Lua utilities (many plugins depend on this)
    { "nvim-lua/plenary.nvim", lazy = true },

    -- Tmux integration
    {
        "christoomey/vim-tmux-navigator",
        event = "VeryLazy",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
        },
        keys = {
            { "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Navigate left (tmux-aware)" },
            { "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Navigate down (tmux-aware)" },
            { "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Navigate up (tmux-aware)" },
            { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Navigate right (tmux-aware)" },
        },
    },

    -- Java LSP (loaded by ftplugin)
    { "mfussenegger/nvim-jdtls", ft = "java" },

    -- LSP progress indicator
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            notification = {
                window = {
                    winblend = 0,
                },
            },
        },
    },
}
