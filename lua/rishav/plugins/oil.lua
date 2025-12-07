return {
    {
        "stevearc/oil.nvim",
        opts = {
            view_options = {
                show_hidden = true,
            },
            skip_confirm_for_simple_edits = true,
            float = {
                padding = 2,
                max_width = 0.45,
                max_height = 0.8,
                border = "rounded",
                win_options = {
                    winblend = 0,
                },
            },
            default_file_explorer = false,
            columns = {
                "icon",
            },
        },
        keys = {
            {
                "<leader>o",
                function()
                    require("oil").toggle_float()
                end,
                mode = { "n", "v", "x" },
                desc = "toggle oil file tree",
            },
        },
    },
}
