---@module "rishav.plugins"
---Base plugin specifications (plugins that need no config or minimal config)
return {
    -- Lua utilities (many plugins depend on this)
    { "nvim-lua/plenary.nvim", lazy = true },

    -- Tmux and split window navigation
    { "christoomey/vim-tmux-navigator", lazy = false },

    -- Java LSP (loaded by ftplugin)
    -- nvim-dap is a dependency here to prevent triggering a synchronous
    -- lazy-load of nvim-dap + nvim-dap-ui mid-way through jdtls startup
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        dependencies = { "mfussenegger/nvim-dap" },
    },
}
