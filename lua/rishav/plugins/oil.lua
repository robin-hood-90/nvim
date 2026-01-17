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
            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-v>"] = "actions.select_vsplit",
                ["<C-s>"] = "actions.select_split",
                ["<C-t>"] = "actions.select_tab",
                ["<C-p>"] = "actions.preview",
                ["q"] = "actions.close",
                ["<Esc>"] = "actions.close",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = "actions.tcd",
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
            },
        },
        keys = {
            {
                "-",
                function()
                    require("oil").open()
                end,
                desc = "Open parent directory",
            },
            {
                "<leader>o",
                function()
                    require("oil").toggle_float()
                end,
                desc = "Oil: Toggle float",
            },
        },
    },
}
