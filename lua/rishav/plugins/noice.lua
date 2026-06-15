-- noice.nvim — full config with keybinds
return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        {
            "rcarriga/nvim-notify",
            opts = {
                background_colour = nil,
                fps = 60,
                render = "wrapped-compact",
                timeout = 3000,
                max_width = 60,
                stages = "fade", -- "fade" | "slide" | "fade_in_slide_out" | "static"
                top_down = false, -- notifications stack from bottom-right up
                icons = {
                    ERROR = "",
                    WARN = "",
                    INFO = "",
                    DEBUG = "",
                    TRACE = "✎",
                },
            },
        },
    },

    opts = {
        -- ── LSP ──────────────────────────────────────────────────────────────
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,

                ["cmp.entry.get_documentation"] = true,
            },
            progress = {
                enabled = true,
                format = "lsp_progress",
                format_done = "lsp_progress_done",
                throttle = 1000 / 30,
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

        -- ── Cmdline ───────────────────────────────────────────────────────────
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

        -- ── Messages ──────────────────────────────────────────────────────────
        messages = {
            enabled = true,
            view = "notify",
            view_error = "notify",
            view_warn = "notify",
            view_history = "messages",
            view_search = "virtualtext",
        },

        -- ── Popupmenu ─────────────────────────────────────────────────────────
        popupmenu = {
            enabled = true,
            backend = "cmp",
        },

        -- ── Redirect ──────────────────────────────────────────────────────────
        redirect = {
            view = "popup",
            filter = { event = "msg_show" },
        },

        -- ── Notify backend ───────────────────────────────────────────────────
        notify = {
            enabled = true,
            view = "notify",
        },

        -- ── Presets ───────────────────────────────────────────────────────────
        presets = {
            bottom_search = false,
            command_palette = true,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = true,
        },

        -- ── Routes ────────────────────────────────────────────────────────────
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
                        { find = "^Hunk %d+ of %d+" },
                    },
                },
                opts = { skip = true },
            },
            {
                filter = { event = "msg_show", min_height = 12 },
                view = "split",
            },
            {
                filter = { event = "msg_show", kind = "emsg" },
                opts = { title = "Error" },
                view = "notify",
            },
        },

        -- ── Views ─────────────────────────────────────────────────────────────
        views = {
            cmdline_popup = {
                border = { style = "rounded" },
                position = { row = "40%", col = "50%" },
                size = { width = 60, height = "auto" },
            },
            popupmenu = {
                relative = "editor",
                position = { row = 8, col = "50%" },
                size = { width = 60, height = 10 },
                border = { style = "rounded", padding = { 0, 1 } },
                win_options = { winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" } },
            },
            mini = {
                win_options = { winblend = 0 },
                position = { row = -2, col = "100%" },
            },
            notify = {
                merge = false,
                replace = false,
            },
        },
    },

    -- ── Keymaps ───────────────────────────────────────────────────────────────
    keys = {
        {
            "<C-f>",
            function()
                if not require("noice.lsp").scroll(4) then
                    return "<C-f>"
                end
            end,
            silent = true,
            expr = true,
            mode = { "i", "n", "s" },
            desc = "Scroll forward (noice/doc)",
        },
        {
            "<C-b>",
            function()
                if not require("noice.lsp").scroll(-4) then
                    return "<C-b>"
                end
            end,
            silent = true,
            expr = true,
            mode = { "i", "n", "s" },
            desc = "Scroll backward (noice/doc)",
        },
        { "<leader>nl", "<cmd>Noice last<cr>", desc = "Noice: last message" },
        { "<leader>nh", "<cmd>Noice history<cr>", desc = "Noice: message history" },
        { "<leader>na", "<cmd>Noice all<cr>", desc = "Noice: all messages" },
        { "<leader>nd", "<cmd>Noice dismiss<cr>", desc = "Noice: dismiss notifications" },
        { "<leader>nt", "<cmd>Noice toggle<cr>", desc = "Noice: toggle" },
        { "<leader>fn", "<cmd>Noice telescope<cr>", desc = "Telescope: noice messages" },
        { "<leader>ne", "<cmd>Noice enable<cr>", desc = "Noice: enable" },
        { "<leader>nx", "<cmd>Noice disable<cr>", desc = "Noice: disable" },

    },
}
