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
                    dismiss = "<C-]>",
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
            -- Check if nvim-cmp menu is visible first
            local cmp_ok, cmp = pcall(require, "cmp")
            if cmp_ok and cmp.visible() then
                cmp.select_next_item()
                return
            end

            -- Check for luasnip
            local luasnip_ok, luasnip = pcall(require, "luasnip")
            if luasnip_ok and luasnip.locally_jumpable(1) then
                luasnip.jump(1)
                return
            end

            -- Check if Copilot has a suggestion
            local copilot = require("copilot.suggestion")
            local ok, is_visible = pcall(copilot.is_visible)

            if ok and is_visible then
                copilot.accept()
            else
                -- Fallback to default Tab behavior
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
            end
        end, { desc = "Accept Copilot suggestion or use cmp/snippet/tab" })
    end,
}
