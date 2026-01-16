---@module "rishav.plugins.telescope"
---Fuzzy finder configuration
return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end,
        },
        "nvim-tree/nvim-web-devicons",
        "folke/todo-comments.nvim",
    },
    keys = {
        -- Find
        { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
        { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
        { "<leader>fs", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
        { "<leader>fc", "<cmd>Telescope grep_string<CR>", desc = "Grep under cursor" },
        { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
        { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
        { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
        { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Todo comments" },
        { "<leader>fn", "<cmd>Telescope notify<CR>", desc = "Notifications" },
        { "<leader>fm", "<cmd>Telescope marks<CR>", desc = "Marks" },
        { "<leader>fg", "<cmd>Telescope git_files<CR>", desc = "Git files" },
        { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in buffer" },
        -- LSP
        { "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
        { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
        -- Resume
        { "<leader><leader>", "<cmd>Telescope resume<CR>", desc = "Resume last search" },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local transform_mod = require("telescope.actions.mt").transform_mod

        -- Trouble integration
        local trouble_ok, trouble = pcall(require, "trouble")
        local trouble_telescope_ok, trouble_telescope = pcall(require, "trouble.sources.telescope")

        local custom_actions = transform_mod({
            open_trouble_qflist = function()
                if trouble_ok then
                    trouble.toggle("quickfix")
                end
            end,
        })

        telescope.setup({
            defaults = {
                prompt_prefix = "   ",
                selection_caret = " ",
                entry_prefix = "  ",
                multi_icon = " ",
                path_display = { "smart" },
                file_ignore_patterns = {
                    "%.git/",
                    "node_modules/",
                    "%.cache/",
                    "__pycache__/",
                    "%.class$",
                    "%.o$",
                    "%.pyc$",
                },
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                    },
                    vertical = {
                        mirror = false,
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                sorting_strategy = "ascending",
                winblend = 0,
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
                        ["<C-t>"] = trouble_telescope_ok and trouble_telescope.open or actions.select_tab,
                        ["<C-u>"] = actions.preview_scrolling_up,
                        ["<C-d>"] = actions.preview_scrolling_down,
                        ["<C-x>"] = actions.delete_buffer,
                        ["<Esc>"] = actions.close,
                    },
                    n = {
                        ["q"] = actions.close,
                        ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
                    },
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                    follow = true,
                },
                live_grep = {
                    additional_args = function()
                        return { "--hidden", "--glob", "!.git" }
                    end,
                },
                buffers = {
                    show_all_buffers = true,
                    sort_lastused = true,
                    mappings = {
                        i = {
                            ["<C-x>"] = actions.delete_buffer,
                        },
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        })

        -- Load extensions
        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "notify")
    end,
}
