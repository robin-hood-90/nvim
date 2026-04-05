---@module "rishav.plugins.tabout"
---Tabout configuration (Tab mapping handled by nvim-cmp)
return {
    "abecodes/tabout.nvim",
    lazy = false,
    config = function()
        require("tabout").setup({
            tabkey = "", -- Disabled: Tab is handled by nvim-cmp's unified mapping
            backwards_tabkey = "", -- Disabled: S-Tab is handled by nvim-cmp's unified mapping
            act_as_tab = true, -- shift content if tab out is not possible
            act_as_shift_tab = false, -- reverse shift content if tab out is not possible
            default_tab = "<C-t>", -- shift default action (only at the beginning of a line)
            default_shift_tab = "<C-d>", -- reverse shift default action
            enable_backwards = true,
            completion = false, -- not used in completion pum
            tabouts = {
                { open = "'", close = "'" },
                { open = '"', close = '"' },
                { open = "`", close = "`" },
                { open = "(", close = ")" },
                { open = "[", close = "]" },
                { open = "{", close = "}" },
                { open = "<", close = ">" },
            },
            ignore_beginning = true,
            exclude = {},
        })
    end,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "L3MON4D3/LuaSnip",
        "hrsh7th/nvim-cmp",
    },
    event = "InsertCharPre",
    priority = 1000,
}
