---@module "rishav.plugins.treesitter"
---Treesitter syntax highlighting and related features
return {
    -- Main treesitter config (new main branch API)
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false, -- nvim-treesitter does not support lazy-loading
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
            -- Setup nvim-treesitter with the new API
            require("nvim-treesitter").setup({})

            -- List of parsers to ensure installed
            local parsers = {
                "html", "css", "javascript", "typescript", "tsx", "json",
                "yaml", "svelte", "graphql", "prisma", "lua", "python", "rust",
                "go", "c", "cpp", "java", "markdown", "markdown_inline", "bash",
                "dockerfile", "gitignore", "vim", "vimdoc", "query", "regex",
            }

            -- Only install missing parsers (check if parser is available)
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    local to_install = {}
                    for _, lang in ipairs(parsers) do
                        local ok = pcall(vim.treesitter.language.inspect, lang)
                        if not ok then
                            table.insert(to_install, lang)
                        end
                    end
                    if #to_install > 0 then
                        vim.cmd("TSInstall " .. table.concat(to_install, " "))
                    end
                end,
                once = true,
            })

            -- Enable treesitter-based highlighting
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })

            -- Enable treesitter-based folding
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo.foldenable = false -- Don't fold by default
                end,
            })

            -- Setup autotag
            require("nvim-ts-autotag").setup()

            -- Use bash parser for zsh files
            vim.treesitter.language.register("bash", "zsh")
        end,
    },

    -- Treesitter textobjects (new main branch API)
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            -- Setup textobjects with the new API
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                    selection_modes = {
                        ["@parameter.outer"] = "v",
                        ["@function.outer"] = "V",
                        ["@class.outer"] = "V",
                    },
                    include_surrounding_whitespace = false,
                },
                move = {
                    set_jumps = true,
                },
            })

            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")
            local swap = require("nvim-treesitter-textobjects.swap")
            local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

            -- Text object selection keymaps
            local select_keymaps = {
                -- Function calls
                { "af", "@call.outer", "Select outer part of a function call" },
                { "if", "@call.inner", "Select inner part of a function call" },
                -- Method/Function definitions
                { "am", "@function.outer", "Select outer part of a method/function definition" },
                { "im", "@function.inner", "Select inner part of a method/function definition" },
                -- Classes
                { "ac", "@class.outer", "Select outer part of a class" },
                { "ic", "@class.inner", "Select inner part of a class" },
                -- Parameters/Arguments
                { "aa", "@parameter.outer", "Select outer part of a parameter/argument" },
                { "ia", "@parameter.inner", "Select inner part of a parameter/argument" },
                -- Conditionals
                { "ai", "@conditional.outer", "Select outer part of a conditional" },
                { "ii", "@conditional.inner", "Select inner part of a conditional" },
                -- Loops
                { "al", "@loop.outer", "Select outer part of a loop" },
                { "il", "@loop.inner", "Select inner part of a loop" },
                -- Assignments
                { "a=", "@assignment.outer", "Select outer part of an assignment" },
                { "i=", "@assignment.inner", "Select inner part of an assignment" },
                { "l=", "@assignment.lhs", "Select left hand side of an assignment" },
                { "r=", "@assignment.rhs", "Select right hand side of an assignment" },
                -- Blocks
                { "ab", "@block.outer", "Select outer part of a block" },
                { "ib", "@block.inner", "Select inner part of a block" },
            }

            for _, mapping in ipairs(select_keymaps) do
                vim.keymap.set({ "x", "o" }, mapping[1], function()
                    select.select_textobject(mapping[2], "textobjects")
                end, { desc = mapping[3] })
            end

            -- Move keymaps - goto next start
            local move_next_start = {
                { "]f", "@call.outer", "Next function call start" },
                { "]m", "@function.outer", "Next method/function def start" },
                { "]c", "@class.outer", "Next class start" },
                { "]i", "@conditional.outer", "Next conditional start" },
                { "]l", "@loop.outer", "Next loop start" },
                { "]a", "@parameter.outer", "Next argument start" },
                { "]b", "@block.outer", "Next block start" },
            }

            for _, mapping in ipairs(move_next_start) do
                vim.keymap.set({ "n", "x", "o" }, mapping[1], function()
                    move.goto_next_start(mapping[2], "textobjects")
                end, { desc = mapping[3] })
            end

            -- Move keymaps - goto next end
            local move_next_end = {
                { "]F", "@call.outer", "Next function call end" },
                { "]M", "@function.outer", "Next method/function def end" },
                { "]C", "@class.outer", "Next class end" },
                { "]I", "@conditional.outer", "Next conditional end" },
                { "]L", "@loop.outer", "Next loop end" },
            }

            for _, mapping in ipairs(move_next_end) do
                vim.keymap.set({ "n", "x", "o" }, mapping[1], function()
                    move.goto_next_end(mapping[2], "textobjects")
                end, { desc = mapping[3] })
            end

            -- Move keymaps - goto previous start
            local move_prev_start = {
                { "[f", "@call.outer", "Prev function call start" },
                { "[m", "@function.outer", "Prev method/function def start" },
                { "[c", "@class.outer", "Prev class start" },
                { "[i", "@conditional.outer", "Prev conditional start" },
                { "[l", "@loop.outer", "Prev loop start" },
                { "[a", "@parameter.outer", "Prev argument start" },
                { "[b", "@block.outer", "Prev block start" },
            }

            for _, mapping in ipairs(move_prev_start) do
                vim.keymap.set({ "n", "x", "o" }, mapping[1], function()
                    move.goto_previous_start(mapping[2], "textobjects")
                end, { desc = mapping[3] })
            end

            -- Move keymaps - goto previous end
            local move_prev_end = {
                { "[F", "@call.outer", "Prev function call end" },
                { "[M", "@function.outer", "Prev method/function def end" },
                { "[C", "@class.outer", "Prev class end" },
                { "[I", "@conditional.outer", "Prev conditional end" },
                { "[L", "@loop.outer", "Prev loop end" },
            }

            for _, mapping in ipairs(move_prev_end) do
                vim.keymap.set({ "n", "x", "o" }, mapping[1], function()
                    move.goto_previous_end(mapping[2], "textobjects")
                end, { desc = mapping[3] })
            end

            -- Swap keymaps
            vim.keymap.set("n", "<leader>na", function()
                swap.swap_next("@parameter.inner")
            end, { desc = "Swap with next parameter" })

            vim.keymap.set("n", "<leader>pa", function()
                swap.swap_previous("@parameter.inner")
            end, { desc = "Swap with previous parameter" })

            vim.keymap.set("n", "<leader>nm", function()
                swap.swap_next("@function.outer")
            end, { desc = "Swap with next function" })

            vim.keymap.set("n", "<leader>pm", function()
                swap.swap_previous("@function.outer")
            end, { desc = "Swap with previous function" })

            -- Repeatable movement with ; and ,
            vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "Repeat last move next" })
            vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { desc = "Repeat last move prev" })

            -- Make builtin f, F, t, T also repeatable with ; and ,
            vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true, desc = "Find char forward" })
            vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true, desc = "Find char backward" })
            vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true, desc = "Till char forward" })
            vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true, desc = "Till char backward" })
        end,
    },
}
