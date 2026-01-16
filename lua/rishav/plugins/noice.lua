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
                top_down = false,
            },
        },
    },
    opts = {
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
        presets = {
            bottom_search = false,
            command_palette = false,
            long_message_to_split = true,
            lsp_doc_border = true,
            inc_rename = true,
        },
        views = {
            cmdline_popup = {
                position = {
                    row = "40%",
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
                    row = "45%",
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
    },
    keys = {
        { "<leader>nd", "<cmd>NoiceDismiss<CR>", desc = "Dismiss notifications" },
        { "<leader>nl", function() require("noice").cmd("last") end, desc = "Last message" },
        { "<leader>nh", function() require("noice").cmd("history") end, desc = "Message history" },
        { "<leader>na", function() require("noice").cmd("all") end, desc = "All messages" },
    },
}
