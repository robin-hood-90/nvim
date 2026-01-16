---@module "rishav.plugins.indent-blankline"
---Indentation guides
return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        indent = {
            char = "│",
            tab_char = "│",
        },
        scope = {
            enabled = true,
            show_start = true,
            show_end = false,
            highlight = { "Function", "Label" },
        },
        exclude = {
            filetypes = {
                "help",
                "alpha",
                "dashboard",
                "neo-tree",
                "NvimTree",
                "Trouble",
                "trouble",
                "lazy",
                "mason",
                "notify",
                "toggleterm",
                "lazyterm",
                "oil",
            },
        },
    },
}
