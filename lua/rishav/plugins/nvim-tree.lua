return {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
        { "<leader>ee", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
        { "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Toggle file explorer on current file" },
        { "<leader>ec", "<cmd>NvimTreeCollapse<CR>", desc = "Collapse file explorer" },
        { "<leader>er", "<cmd>NvimTreeRefresh<CR>", desc = "Refresh file explorer" },
    },
    opts = {
        view = {
            width = 40,
            relativenumber = true,
            side = "right",
        },
        renderer = {
            indent_markers = {
                enable = true,
            },
            icons = {
                glyphs = {
                    folder = {
                        arrow_closed = "",
                        arrow_open = "",
                    },
                },
            },
        },
        actions = {
            open_file = {
                window_picker = {
                    enable = false,
                },
                quit_on_open = false,
            },
        },
        filters = {
            custom = { ".DS_Store" },
            dotfiles = false,
        },
        git = {
            enable = true,
            ignore = false,
        },
        diagnostics = {
            enable = true,
            show_on_dirs = true,
        },
        update_focused_file = {
            enable = true,
            update_root = false,
        },
    },
}
