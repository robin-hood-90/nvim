---@module "rishav.plugins.noice"
---Minimal noice.nvim: cmdline popup, LSP progress/hover/signature, routed messages
return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        {
            "rcarriga/nvim-notify",
            opts = {
                background_colour = "#1a1b26",
                timeout = 3000,
                max_width = 60,
                render = "wrapped-compact",
            },
        },
    },
    opts = {
        lsp = {
            progress = {
                enabled = true,
                view = "mini",
            },
            hover = {
                enabled = true,
                silent = true,
            },
            signature = {
                enabled = true,
                auto_open = {
                    enabled = true,
                    trigger = true,
                    luasnip = true,
                    throttle = 50,
                },
            },
        },
        cmdline = {
            enabled = true,
            view = "cmdline_popup",
            format = {
                cmdline = { pattern = "^:", icon = "", lang = "vim" },
                search_down = { kind = "search", icon = " ", lang = "regex" },
                search_up = { kind = "search", icon = " ", lang = "regex" },
                filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
                help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋗" },
                input = { view = "cmdline_input", icon = "󰥻 " },
            },
        },
        messages = {
            view_search = "virtualtext",
        },
        popupmenu = {
            backend = "cmp",
        },
        presets = {
            command_palette = true,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = true,
        },
        routes = {
            {
                filter = {
                    event = "msg_show",
                    any = {
                        { find = "%d+L, %d+B" },
                        { find = "; after #%d+" },
                        { find = "; before #%d+" },
                        { find = "%d+ fewer lines" },
                        { find = "%d+ more lines" },
                        { find = "%d+ lines yanked" },
                    },
                },
                opts = { skip = true },
            },
            {
                filter = { event = "msg_show", kind = "emsg" },
                view = "notify",
                opts = { title = "Error" },
            },
        },
        views = {
            cmdline_popup = { border = { style = "rounded" } },
            popupmenu = { border = { style = "rounded" } },
            mini = { win_options = { winblend = 0 } },
        },
    },
    keys = {
        { "<leader>nd", "<cmd>NoiceDismiss<cr>", desc = "Dismiss notifications" },
        { "<leader>nl", "<cmd>NoiceLast<cr>",  desc = "Last message" },
        { "<leader>nh", "<cmd>NoiceHistory<cr>", desc = "Message history" },
        { "<leader>na", "<cmd>NoiceAll<cr>",   desc = "All messages" },
    },
}

