return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    accept = false,
                    accept_word = false,
                    accept_line = false,
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-e>",
                },
            },
            panel = { enabled = false },
            filetypes = {
                yaml = false,
                markdown = false,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
        })

        -- Custom Tab mapping with safety check
        vim.keymap.set("i", "<Tab>", function()
            local copilot = require("copilot.suggestion")

            -- Check if Copilot is initialized and has a visible suggestion
            local ok, is_visible = pcall(copilot.is_visible)

            if ok and is_visible then
                copilot.accept()
            else
                -- Fallback to default Tab behavior
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
            end
        end, { desc = "Accept Copilot suggestion or insert Tab" })
    end,
}
