return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            svelte = { "eslint_d" },
            python = { "pylint" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        local function try_linting()
            local linters = lint.linters_by_ft[vim.bo.filetype]

            -- Only run eslint_d if eslint.config.js is found in the project
            if linters and vim.tbl_contains(linters, "eslint_d") then
                local eslint_config = vim.fs.find("eslint.config.js", {
                    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
                    upward = true,
                    stop = vim.env.HOME,
                })
                if #eslint_config == 0 then
                    lint.try_lint()
                    return
                end
            end

            lint.try_lint(linters)
        end

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                try_linting()
            end,
        })

        vim.keymap.set("n", "<leader>a", function()
            try_linting()
        end, { desc = "Trigger linting for current file" })
    end,
}
