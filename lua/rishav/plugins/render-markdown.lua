---@module "rishav.plugins.render-markdown"
---Enhanced markdown rendering for Neovim
return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        {
            "<leader>um",
            function()
                require("render-markdown").toggle()
            end,
            desc = "Toggle markdown rendering",
            ft = "markdown",
        },
    },
    opts = {
        enabled = true,
        heading = {
            sign = false,
        },
        code = {
            sign = false,
        },
        sign = {
            enabled = false,
        },
    },
}
