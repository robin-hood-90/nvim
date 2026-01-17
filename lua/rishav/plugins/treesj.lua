return {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
        -- Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
        use_default_keymaps = false,
        -- Node with syntax error will not be formatted
        check_syntax_error = true,
        -- If line after join will be longer than max value, node will not be formatted
        max_join_length = 120,
        -- Cursor behavior: 'hold', 'start', 'end'
        cursor_behavior = "hold",
        -- Notify about possible problems or not
        notify = true,
        -- Use `dot` for repeat action
        dot_repeat = true,
        -- Callback for treesj error handler
        on_error = nil,
    },
    -- stylua: ignore
    keys = {
        { "<leader>m", function() require("treesj").toggle() end, desc = "Toggle Split/Join" },
        { "<leader>j", function() require("treesj").join() end, desc = "Join Lines" },
        { "<leader>s", function() require("treesj").split() end, desc = "Split Lines" },
        { "<leader>M", function() require("treesj").toggle({ split = { recursive = true } }) end, desc = "Toggle Split/Join (Recursive)" },
    },
}
