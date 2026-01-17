---@module "rishav.plugins.telescope"
---Fuzzy finder configuration
---
--- Primary keybindings under <leader>f (find):
--- <leader>ff - Find files
--- <leader>fg - Live grep (search text)
--- <leader>fw - Grep word under cursor
--- <leader>fb - Buffers
--- <leader>fr - Recent files
--- <leader>fh - Help tags
--- <leader>fk - Keymaps
--- <leader><leader> - Resume last picker
return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
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
        -- Primary find operations (most used)
        { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
        { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Grep word under cursor" },
        { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
        { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
        { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in buffer" },

        -- Git
        { "<leader>gf", "<cmd>Telescope git_files<CR>", desc = "Git files" },
        { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git commits" },
        { "<leader>gC", "<cmd>Telescope git_bcommits<CR>", desc = "Git buffer commits" },
        { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git branches" },
        { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git status" },

        -- Help / Info
        { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
        { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
        { "<leader>fm", "<cmd>Telescope marks<CR>", desc = "Marks" },
        { "<leader>fR", "<cmd>Telescope registers<CR>", desc = "Registers" },
        { "<leader>fc", "<cmd>Telescope commands<CR>", desc = "Commands" },
        { "<leader>fC", "<cmd>Telescope command_history<CR>", desc = "Command history" },
        { "<leader>fn", "<cmd>Telescope notify<CR>", desc = "Notifications" },

        -- LSP (under <leader>l for LSP consistency)
        { "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
        { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },

        -- Special
        { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Todo comments" },
        { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },

        -- Resume last picker (very useful!)
        { "<leader><leader>", "<cmd>Telescope resume<CR>", desc = "Resume last picker" },

        -- Quick access (alternative bindings for speed)
        { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
        { "<leader>/", "<cmd>Telescope live_grep<CR>", desc = "Search in project" },
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
