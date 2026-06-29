---@module "rishav.plugins.nvim-treesitter-text-objects"
---Treesitter textobjects for code navigation and selection (josean-dev style)
return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

        local function move_map(mode, lhs, rhs, opts)
            vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = opts.desc or "" }))
        end

        require("nvim-treesitter.configs").setup({
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["a="] = { query = "@assignment.outer", desc = "Select outer assignment" },
                        ["i="] = { query = "@assignment.inner", desc = "Select inner assignment" },
                        ["l="] = { query = "@assignment.lhs", desc = "Select assignment LHS" },
                        ["r="] = { query = "@assignment.rhs", desc = "Select assignment RHS" },

                        ["a:"] = { query = "@property.outer", desc = "Select outer property" },
                        ["i:"] = { query = "@property.inner", desc = "Select inner property" },
                        ["l:"] = { query = "@property.lhs", desc = "Select property LHS" },
                        ["r:"] = { query = "@property.rhs", desc = "Select property RHS" },

                        ["aa"] = { query = "@parameter.outer", desc = "Select outer parameter" },
                        ["ia"] = { query = "@parameter.inner", desc = "Select inner parameter" },

                        ["ai"] = { query = "@conditional.outer", desc = "Select outer conditional" },
                        ["ii"] = { query = "@conditional.inner", desc = "Select inner conditional" },

                        ["al"] = { query = "@loop.outer", desc = "Select outer loop" },
                        ["il"] = { query = "@loop.inner", desc = "Select inner loop" },

                        ["af"] = { query = "@call.outer", desc = "Select outer function call" },
                        ["if"] = { query = "@call.inner", desc = "Select inner function call" },

                        ["am"] = { query = "@function.outer", desc = "Select outer function" },
                        ["im"] = { query = "@function.inner", desc = "Select inner function" },

                        ["ac"] = { query = "@class.outer", desc = "Select outer class" },
                        ["ic"] = { query = "@class.inner", desc = "Select inner class" },
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>na"] = "@parameter.inner",
                        ["<leader>n:"] = "@property.outer",
                        ["<leader>nm"] = "@function.outer",
                    },
                    swap_previous = {
                        ["<leader>pa"] = "@parameter.inner",
                        ["<leader>p:"] = "@property.outer",
                        ["<leader>pm"] = "@function.outer",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = { query = "@call.outer", desc = "Next function call start" },
                        ["]m"] = { query = "@function.outer", desc = "Next function start" },
                        ["]c"] = { query = "@class.outer", desc = "Next class start" },
                        ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
                        ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
                        ["]s"] = { query = "@scope", query_type = "locals", desc = "Next scope" },
                        ["]z"] = { query = "@fold", query_type = "folds", desc = "Next fold" },
                    },
                    goto_next_end = {
                        ["]F"] = { query = "@call.outer", desc = "Next function call end" },
                        ["]M"] = { query = "@function.outer", desc = "Next function end" },
                        ["]C"] = { query = "@class.outer", desc = "Next class end" },
                        ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
                        ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
                    },
                    goto_previous_start = {
                        ["[f"] = { query = "@call.outer", desc = "Previous function call start" },
                        ["[m"] = { query = "@function.outer", desc = "Previous function start" },
                        ["[c"] = { query = "@class.outer", desc = "Previous class start" },
                        ["[i"] = { query = "@conditional.outer", desc = "Previous conditional start" },
                        ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
                    },
                    goto_previous_end = {
                        ["[F"] = { query = "@call.outer", desc = "Previous function call end" },
                        ["[M"] = { query = "@function.outer", desc = "Previous function end" },
                        ["[C"] = { query = "@class.outer", desc = "Previous class end" },
                        ["[I"] = { query = "@conditional.outer", desc = "Previous conditional end" },
                        ["[L"] = { query = "@loop.outer", desc = "Previous loop end" },
                    },
                },
            },
        })

        -- Repeatable moves
        local repeatable_move_mappings = {
            next = { "]f", "]F", "]m", "]M", "]c", "]C", "]i", "]I", "]l", "]L", "]s", "]z" },
            prev = { "[f", "[F", "[m", "[M", "[c", "[C", "[i", "[I", "[l", "[L" },
        }

        -- Make move mappings repeatable with ; and ,
        move_map({ "n", "x", "o" }, ";", function()
            ts_repeat_move.repeat_last_move_next()
        end, { desc = "Repeat last move next" })

        move_map({ "n", "x", "o" }, ",", function()
            ts_repeat_move.repeat_last_move_previous()
        end, { desc = "Repeat last move previous" })

        -- Also make f, F, t, T repeatable alongside the TS textobject moves
        move_map({ "n", "x", "o" }, "f", function()
            ts_repeat_move.builtin_f()
        end)
        move_map({ "n", "x", "o" }, "F", function()
            ts_repeat_move.builtin_F()
        end)
        move_map({ "n", "x", "o" }, "t", function()
            ts_repeat_move.builtin_t()
        end)
        move_map({ "n", "x", "o" }, "T", function()
            ts_repeat_move.builtin_T()
        end)
    end,
}
