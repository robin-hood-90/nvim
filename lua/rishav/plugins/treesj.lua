return {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
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
        -- Using gJ/gS for split/join (g prefix for "go" / transform operations)
        { "<leader>cj", function() require("treesj").toggle() end, desc = "Toggle split/join" },
    },
}
