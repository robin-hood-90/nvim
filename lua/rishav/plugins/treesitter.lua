---@module "rishav.plugins.treesitter"
---Treesitter syntax highlighting and related features
return {
    -- Main treesitter config (using master branch for stable parser installation)
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            "windwp/nvim-ts-autotag",
            {
                "nvim-treesitter/nvim-treesitter-context",
                opts = {
                    enable = true,
                    mode = "topline",
                    line_numbers = true,
                    multiwindow = true,
                    max_lines = 3,
                    min_window_height = 20,
                },
            },
        },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "html",
                    "css",
                    "javascript",
                    "typescript",
                    "tsx",
                    "json",
                    "yaml",
                    "svelte",
                    "graphql",
                    "prisma",
                    "lua",
                    "python",
                    "rust",
                    "go",
                    "c",
                    "cpp",
                    "java",
                    "markdown",
                    "markdown_inline",
                    "bash",
                    "dockerfile",
                    "gitignore",
                    "vim",
                    "vimdoc",
                    "query",
                    "regex",
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
            })

            -- Setup autotag
            require("nvim-ts-autotag").setup()

            -- Use bash parser for zsh files
            vim.treesitter.language.register("bash", "zsh")
        end,
    },

    -- Treesitter textobjects (using master branch for compatibility)
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "master",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = { query = "@call.outer", desc = "Select outer function call" },
                            ["if"] = { query = "@call.inner", desc = "Select inner function call" },
                            ["am"] = { query = "@function.outer", desc = "Select outer function" },
                            ["im"] = { query = "@function.inner", desc = "Select inner function" },
                            ["ac"] = { query = "@class.outer", desc = "Select outer class" },
                            ["ic"] = { query = "@class.inner", desc = "Select inner class" },
                            ["aa"] = { query = "@parameter.outer", desc = "Select outer parameter" },
                            ["ia"] = { query = "@parameter.inner", desc = "Select inner parameter" },
                            ["ai"] = { query = "@conditional.outer", desc = "Select outer conditional" },
                            ["ii"] = { query = "@conditional.inner", desc = "Select inner conditional" },
                            ["al"] = { query = "@loop.outer", desc = "Select outer loop" },
                            ["il"] = { query = "@loop.inner", desc = "Select inner loop" },
                            ["a="] = { query = "@assignment.outer", desc = "Select outer assignment" },
                            ["i="] = { query = "@assignment.inner", desc = "Select inner assignment" },
                            ["l="] = { query = "@assignment.lhs", desc = "Select assignment LHS" },
                            ["r="] = { query = "@assignment.rhs", desc = "Select assignment RHS" },
                            ["ab"] = { query = "@block.outer", desc = "Select outer block" },
                            ["ib"] = { query = "@block.inner", desc = "Select inner block" },
                        },
                        selection_modes = {
                            ["@parameter.outer"] = "v",
                            ["@function.outer"] = "V",
                            ["@class.outer"] = "V",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = { query = "@call.outer", desc = "Next function call" },
                            ["]m"] = { query = "@function.outer", desc = "Next function" },
                            ["]c"] = { query = "@class.outer", desc = "Next class" },
                            ["]i"] = { query = "@conditional.outer", desc = "Next conditional" },
                            ["]l"] = { query = "@loop.outer", desc = "Next loop" },
                            ["]a"] = { query = "@parameter.outer", desc = "Next parameter" },
                            ["]b"] = { query = "@block.outer", desc = "Next block" },
                        },
                        goto_next_end = {
                            ["]F"] = { query = "@call.outer", desc = "Next function call end" },
                            ["]M"] = { query = "@function.outer", desc = "Next function end" },
                            ["]C"] = { query = "@class.outer", desc = "Next class end" },
                            ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
                            ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
                        },
                        goto_previous_start = {
                            ["[f"] = { query = "@call.outer", desc = "Prev function call" },
                            ["[m"] = { query = "@function.outer", desc = "Prev function" },
                            ["[c"] = { query = "@class.outer", desc = "Prev class" },
                            ["[i"] = { query = "@conditional.outer", desc = "Prev conditional" },
                            ["[l"] = { query = "@loop.outer", desc = "Prev loop" },
                            ["[a"] = { query = "@parameter.outer", desc = "Prev parameter" },
                            ["[b"] = { query = "@block.outer", desc = "Prev block" },
                        },
                        goto_previous_end = {
                            ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
                            ["[M"] = { query = "@function.outer", desc = "Prev function end" },
                            ["[C"] = { query = "@class.outer", desc = "Prev class end" },
                            ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
                            ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>na"] = "@parameter.inner",
                            ["<leader>nm"] = "@function.outer",
                        },
                        swap_previous = {
                            ["<leader>pa"] = "@parameter.inner",
                            ["<leader>pm"] = "@function.outer",
                        },
                    },
                },
            })

            -- Repeatable movement with ; and ,
            local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
            vim.keymap.set(
                { "n", "x", "o" },
                ";",
                ts_repeat_move.repeat_last_move_next,
                { desc = "Repeat last move next" }
            )
            vim.keymap.set(
                { "n", "x", "o" },
                ",",
                ts_repeat_move.repeat_last_move_opposite,
                { desc = "Repeat last move prev" }
            )

            -- Make builtin f, F, t, T also repeatable
            vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f, { desc = "Find char forward" })
            vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F, { desc = "Find char backward" })
            vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t, { desc = "Till char forward" })
            vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T, { desc = "Till char backward" })
        end,
    },
}
