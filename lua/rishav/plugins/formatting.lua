return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>l",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = { "n", "v" },
            desc = "Format file or range",
        },
        {
            "<leader>uf",
            function()
                vim.g.disable_autoformat = not vim.g.disable_autoformat
                vim.notify(
                    "Auto-format " .. (vim.g.disable_autoformat and "disabled" or "enabled"),
                    vim.log.levels.INFO
                )
            end,
            desc = "Toggle auto-format",
        },
    },
    opts = {
        formatters_by_ft = {
            javascript = { "prettier" },
            typescript = { "prettier" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },
            svelte = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            graphql = { "prettier" },
            liquid = { "prettier" },
            lua = { "stylua" },
            python = { "isort", "black" },
            go = { "gofmt" },
            xml = { "xmlformatter" },
            rust = { "rustfmt" },
            c = { "clang-format" },
            cpp = { "clang-format" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
        format_on_save = function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end
            -- Disable autoformat for large files
            local max_lines = 10000
            if vim.api.nvim_buf_line_count(bufnr) > max_lines then
                return
            end
            return {
                timeout_ms = 3000,
                lsp_format = "fallback",
            }
        end,
        notify_on_error = true,
    },
    init = function()
        -- Create commands to toggle format on save
        vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, { desc = "Disable autoformat-on-save", bang = true })

        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, { desc = "Re-enable autoformat-on-save" })
    end,
}
