return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        {
            "rcarriga/nvim-notify",
            opts = {
                timeout = 2500,
                max_height = function()
                    return math.floor(vim.o.lines * 0.5)
                end,
                max_width = function()
                    return math.floor(vim.o.columns * 0.5)
                end,
                render = "wrapped-compact",
                stages = "fade",
                top_down = true,
            },
        },
    },
    config = function()
        require("noice").setup({
            cmdline = {
                enabled = true,
                view = "cmdline_popup",
                format = {
                    cmdline = { pattern = "^:", icon = " ", lang = "vim" },
                    search_down = { kind = "search", pattern = "^/", icon = "  ", lang = "regex" },
                    search_up = { kind = "search", pattern = "^%?", icon = "  ", lang = "regex" },
                    filter = { pattern = "^:%s*!", icon = " $", lang = "bash" },
                    lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = " ", lang = "lua" },
                    help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖 " },
                },
            },
            messages = {
                enabled = true,
                view = "mini",
                view_error = "mini",
                view_warn = "mini",
            },
            popupmenu = {
                enabled = true,
                backend = "nui",
            },
            lsp = {
                progress = { enabled = true },
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                hover = { enabled = true },
                signature = { enabled = true },
            },
            routes = {
                -- Hide written messages
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                            { find = "fewer lines" },
                            { find = "more lines" },
                            { find = "^E486:" }, -- Pattern not found
                        },
                    },
                    opts = { skip = true },
                },
                -- Show macro recording
                {
                    view = "notify",
                    filter = { event = "msg_showmode" },
                },
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = 5,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = {
                        row = 8,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = 10,
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                },
                mini = {
                    win_options = {
                        winblend = 0,
                    },
                },
            },
        })

        -- Cmdline mode keymaps for popupmenu navigation
        -- <C-n>/<C-p> in cmdline with nvim-cmp trigger completion AND navigate
        vim.keymap.set("c", "<Tab>", "<C-n>", { desc = "Cmdline: next completion" })
        vim.keymap.set("c", "<S-Tab>", "<C-p>", { desc = "Cmdline: previous completion" })
        vim.keymap.set("c", "<C-j>", "<C-n>", { desc = "Next completion item" })
        vim.keymap.set("c", "<C-k>", "<C-p>", { desc = "Previous completion item" })

        -- LSP hover doc scrolling
        vim.keymap.set({ "n", "i", "s" }, "<C-f>", function()
            if not require("noice.lsp").scroll(4) then
                return "<C-f>"
            end
        end, { silent = true, expr = true, desc = "Scroll down in hover doc" })

        vim.keymap.set({ "n", "i", "s" }, "<C-b>", function()
            if not require("noice.lsp").scroll(-4) then
                return "<C-b>"
            end
        end, { silent = true, expr = true, desc = "Scroll up in hover doc" })
    end,
    keys = {
        { "<leader>nd", "<cmd>NoiceDismiss<CR>", desc = "Dismiss notifications" },
        {
            "<leader>nl",
            function()
                require("noice").cmd("last")
            end,
            desc = "Last message",
        },
        {
            "<leader>nh",
            function()
                require("noice").cmd("history")
            end,
            desc = "Message history",
        },
        {
            "<leader>na",
            function()
                require("noice").cmd("all")
            end,
            desc = "All messages",
        },
    },
}
