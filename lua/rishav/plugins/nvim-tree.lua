return {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    lazy = false, -- Load immediately for directory handling
    keys = {
        { "<leader>ee", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
        { "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", desc = "Toggle file explorer on current file" },
        { "<leader>ec", "<cmd>NvimTreeCollapse<CR>", desc = "Collapse file explorer" },
        { "<leader>er", "<cmd>NvimTreeRefresh<CR>", desc = "Refresh file explorer" },
    },
    config = function()
        -- Disable netrw (recommended by nvim-tree)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            hijack_cursor = true,
            hijack_directories = {
                enable = true,
                auto_open = true,
            },
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
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
        })

        -- Auto open nvim-tree when opening a directory
        local function open_nvim_tree(data)
            -- Check if the buffer is a directory
            local directory = vim.fn.isdirectory(data.file) == 1

            if not directory then
                return
            end

            -- Change to the directory
            vim.cmd.cd(data.file)

            -- Open nvim-tree
            require("nvim-tree.api").tree.open()
        end

        vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
    end,
}
