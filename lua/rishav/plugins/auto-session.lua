return {
    "rmagatti/auto-session",
    keys = {
        {
            "<leader>wr",
            function()
                vim.cmd.AutoSession("restore")
            end,
            desc = "Restore session for cwd",
        },
        {
            "<leader>ws",
            function()
                vim.cmd.AutoSession("save")
            end,
            desc = "Save session",
        },
    },
    config = function()
        require("auto-session").setup({
            auto_restore_enabled = false,
            auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
        })
    end,
}
