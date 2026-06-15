---@module "rishav.plugins.treesitter"
---Treesitter auto-tagging
return {
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },
}

