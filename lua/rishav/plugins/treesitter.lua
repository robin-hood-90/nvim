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
                    -- LaTeX: VimTeX handles highlighting; skip treesitter parsers
                    -- (latex parser requires tree-sitter CLI which may not be installed)
                    -- "latex",
                    -- "bibtex",
                    -- Typst
                    "typst",
                },
                sync_install = false,
                auto_install = false,
                highlight = {
                    enable = true,
                    -- Disable treesitter highlighting for LaTeX; VimTeX's mature
                    -- Vimscript syntax engine handles it better. Treesitter still
                    -- provides folds and textobjects for LaTeX.
                    disable = { "latex" },
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

    -- Treesitter textobjects (using main branch)
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            -- Configure textobjects using the new API
            require("nvim-treesitter-textobjects").setup({
                select = {
                    enable = true,
                    lookahead = true,
                    selection_modes = {
                        ["@parameter.outer"] = "v",
                        ["@function.outer"] = "V",
                        ["@class.outer"] = "V",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                },
            })

            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")
            local swap = require("nvim-treesitter-textobjects.swap")

            -- Select keymaps
            vim.keymap.set({ "x", "o" }, "af", function()
                select.select_textobject("@call.outer")
            end, { desc = "Select outer function call" })
            vim.keymap.set({ "x", "o" }, "if", function()
                select.select_textobject("@call.inner")
            end, { desc = "Select inner function call" })
            vim.keymap.set({ "x", "o" }, "am", function()
                select.select_textobject("@function.outer")
            end, { desc = "Select outer function" })
            vim.keymap.set({ "x", "o" }, "im", function()
                select.select_textobject("@function.inner")
            end, { desc = "Select inner function" })
            vim.keymap.set({ "x", "o" }, "ac", function()
                select.select_textobject("@class.outer")
            end, { desc = "Select outer class" })
            vim.keymap.set({ "x", "o" }, "ic", function()
                select.select_textobject("@class.inner")
            end, { desc = "Select inner class" })
            vim.keymap.set({ "x", "o" }, "aa", function()
                select.select_textobject("@parameter.outer")
            end, { desc = "Select outer parameter" })
            vim.keymap.set({ "x", "o" }, "ia", function()
                select.select_textobject("@parameter.inner")
            end, { desc = "Select inner parameter" })
            vim.keymap.set({ "x", "o" }, "ai", function()
                select.select_textobject("@conditional.outer")
            end, { desc = "Select outer conditional" })
            vim.keymap.set({ "x", "o" }, "ii", function()
                select.select_textobject("@conditional.inner")
            end, { desc = "Select inner conditional" })
            vim.keymap.set({ "x", "o" }, "al", function()
                select.select_textobject("@loop.outer")
            end, { desc = "Select outer loop" })
            vim.keymap.set({ "x", "o" }, "il", function()
                select.select_textobject("@loop.inner")
            end, { desc = "Select inner loop" })
            vim.keymap.set({ "x", "o" }, "ab", function()
                select.select_textobject("@block.outer")
            end, { desc = "Select outer block" })
            vim.keymap.set({ "x", "o" }, "ib", function()
                select.select_textobject("@block.inner")
            end, { desc = "Select inner block" })

            -- Move keymaps
            vim.keymap.set({ "n", "x", "o" }, "]f", function()
                move.goto_next_start("@call.outer")
            end, { desc = "Next function call" })
            vim.keymap.set({ "n", "x", "o" }, "]m", function()
                move.goto_next_start("@function.outer")
            end, { desc = "Next function" })
            vim.keymap.set({ "n", "x", "o" }, "]c", function()
                move.goto_next_start("@class.outer")
            end, { desc = "Next class" })
            vim.keymap.set({ "n", "x", "o" }, "]i", function()
                move.goto_next_start("@conditional.outer")
            end, { desc = "Next conditional" })
            vim.keymap.set({ "n", "x", "o" }, "]l", function()
                move.goto_next_start("@loop.outer")
            end, { desc = "Next loop" })
            vim.keymap.set({ "n", "x", "o" }, "]a", function()
                move.goto_next_start("@parameter.outer")
            end, { desc = "Next parameter" })
            vim.keymap.set({ "n", "x", "o" }, "]b", function()
                move.goto_next_start("@block.outer")
            end, { desc = "Next block" })

            vim.keymap.set({ "n", "x", "o" }, "]F", function()
                move.goto_next_end("@call.outer")
            end, { desc = "Next function call end" })
            vim.keymap.set({ "n", "x", "o" }, "]M", function()
                move.goto_next_end("@function.outer")
            end, { desc = "Next function end" })
            vim.keymap.set({ "n", "x", "o" }, "]C", function()
                move.goto_next_end("@class.outer")
            end, { desc = "Next class end" })
            vim.keymap.set({ "n", "x", "o" }, "]I", function()
                move.goto_next_end("@conditional.outer")
            end, { desc = "Next conditional end" })
            vim.keymap.set({ "n", "x", "o" }, "]L", function()
                move.goto_next_end("@loop.outer")
            end, { desc = "Next loop end" })

            vim.keymap.set({ "n", "x", "o" }, "[f", function()
                move.goto_previous_start("@call.outer")
            end, { desc = "Prev function call" })
            vim.keymap.set({ "n", "x", "o" }, "[m", function()
                move.goto_previous_start("@function.outer")
            end, { desc = "Prev function" })
            vim.keymap.set({ "n", "x", "o" }, "[c", function()
                move.goto_previous_start("@class.outer")
            end, { desc = "Prev class" })
            vim.keymap.set({ "n", "x", "o" }, "[i", function()
                move.goto_previous_start("@conditional.outer")
            end, { desc = "Prev conditional" })
            vim.keymap.set({ "n", "x", "o" }, "[l", function()
                move.goto_previous_start("@loop.outer")
            end, { desc = "Prev loop" })
            vim.keymap.set({ "n", "x", "o" }, "[a", function()
                move.goto_previous_start("@parameter.outer")
            end, { desc = "Prev parameter" })
            vim.keymap.set({ "n", "x", "o" }, "[b", function()
                move.goto_previous_start("@block.outer")
            end, { desc = "Prev block" })

            vim.keymap.set({ "n", "x", "o" }, "[F", function()
                move.goto_previous_end("@call.outer")
            end, { desc = "Prev function call end" })
            vim.keymap.set({ "n", "x", "o" }, "[M", function()
                move.goto_previous_end("@function.outer")
            end, { desc = "Prev function end" })
            vim.keymap.set({ "n", "x", "o" }, "[C", function()
                move.goto_previous_end("@class.outer")
            end, { desc = "Prev class end" })
            vim.keymap.set({ "n", "x", "o" }, "[I", function()
                move.goto_previous_end("@conditional.outer")
            end, { desc = "Prev conditional end" })
            vim.keymap.set({ "n", "x", "o" }, "[L", function()
                move.goto_previous_end("@loop.outer")
            end, { desc = "Prev loop end" })

            -- Swap keymaps
            vim.keymap.set({ "n", "x" }, "<leader>na", function()
                swap.swap_next("@parameter.inner")
            end, { desc = "Swap next parameter" })
            vim.keymap.set({ "n", "x" }, "<leader>nm", function()
                swap.swap_next("@function.outer")
            end, { desc = "Swap next function" })
            vim.keymap.set({ "n", "x" }, "<leader>pa", function()
                swap.swap_previous("@parameter.inner")
            end, { desc = "Swap prev parameter" })
            vim.keymap.set({ "n", "x" }, "<leader>pm", function()
                swap.swap_previous("@function.outer")
            end, { desc = "Swap prev function" })

            -- Repeatable movement with ; and , (main branch API)
            local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
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

            -- Make builtin f, F, t, T also repeatable (new main branch API uses expr functions)
            vim.keymap.set(
                { "n", "x", "o" },
                "f",
                ts_repeat_move.builtin_f_expr,
                { expr = true, desc = "Find char forward" }
            )
            vim.keymap.set(
                { "n", "x", "o" },
                "F",
                ts_repeat_move.builtin_F_expr,
                { expr = true, desc = "Find char backward" }
            )
            vim.keymap.set(
                { "n", "x", "o" },
                "t",
                ts_repeat_move.builtin_t_expr,
                { expr = true, desc = "Till char forward" }
            )
            vim.keymap.set(
                { "n", "x", "o" },
                "T",
                ts_repeat_move.builtin_T_expr,
                { expr = true, desc = "Till char backward" }
            )
        end,
    },
}
