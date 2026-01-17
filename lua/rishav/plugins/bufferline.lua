return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    event = "VeryLazy",
    keys = {
        { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
        { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
        { "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Pick buffer" },
        { "<leader>bP", "<cmd>BufferLinePickClose<CR>", desc = "Pick close" },
        { "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", desc = "Close others" },
        { "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", desc = "Close left" },
        { "<leader>br", "<cmd>BufferLineCloseRight<CR>", desc = "Close right" },
        { "<leader>bs", "<cmd>BufferLineTogglePin<CR>", desc = "Pin buffer" },
        { "<leader>bS", "<cmd>BufferLineSortByDirectory<CR>", desc = "Sort by dir" },
    },
    opts = {
        options = {
            mode = "buffers",
            themable = true,
            numbers = "none",

            -- Icons
            buffer_close_icon = "󰅙",
            modified_icon = "●",
            close_icon = "󰅙",
            left_trunc_marker = "",
            right_trunc_marker = "",

            -- Indicator
            indicator = {
                icon = "▎",
                style = "icon",
            },

            -- Mouse actions
            close_command = "bdelete! %d",
            right_mouse_command = "bdelete! %d",
            left_mouse_command = "buffer %d",
            middle_mouse_command = "bdelete! %d",

            -- Sizing
            max_name_length = 18,
            tab_size = 18,
            truncate_names = true,

            -- LSP diagnostics
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(count, level)
                local icon = level:match("error") and " " or " "
                return icon .. count
            end,

            -- NvimTree offset
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "Explorer",
                    text_align = "center",
                    separator = true,
                },
            },

            -- Appearance
            color_icons = true,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_close_icon = false,
            show_tab_indicators = true,
            show_duplicate_prefix = true,
            separator_style = "thin",
            always_show_bufferline = true,

            -- Sorting
            sort_by = "insert_after_current",
        },
    },
}
