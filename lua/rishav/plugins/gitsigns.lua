---@module "rishav.plugins.gitsigns"
---Git integration for buffers
local icons = require("rishav.core.icons")

return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add = { text = icons.ui.vertical_bar },
            change = { text = icons.ui.vertical_bar },
            delete = { text = "▁" },
            topdelete = { text = "▔" },
            changedelete = { text = icons.ui.vertical_bar },
            untracked = { text = icons.ui.vertical_bar },
        },
        signs_staged = {
            add = { text = icons.ui.vertical_bar },
            change = { text = icons.ui.vertical_bar },
            delete = { text = "▁" },
            topdelete = { text = "▔" },
            changedelete = { text = icons.ui.vertical_bar },
        },
        current_line_blame = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 500,
        },
        preview_config = {
            border = "rounded",
        },
        on_attach = function(bufnr)
            local gs = require("gitsigns")

            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc, silent = true })
            end

            -- Navigation
            map("n", "]h", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "]c", bang = true })
                else
                    gs.nav_hunk("next")
                end
            end, "Next hunk")

            map("n", "[h", function()
                if vim.wo.diff then
                    vim.cmd.normal({ "[c", bang = true })
                else
                    gs.nav_hunk("prev")
                end
            end, "Previous hunk")

            -- Actions
            map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
            map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
            map("v", "<leader>hs", function()
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Stage hunk")
            map("v", "<leader>hr", function()
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, "Reset hunk")
            map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
            map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
            map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
            map("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk inline")
            map("n", "<leader>hP", gs.preview_hunk, "Preview hunk")
            map("n", "<leader>hb", function()
                gs.blame_line({ full = true })
            end, "Blame line (full)")
            map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")
            map("n", "<leader>hd", gs.diffthis, "Diff this")
            map("n", "<leader>hD", function()
                gs.diffthis("~")
            end, "Diff this ~")

            -- Text object
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
        end,
    },
}
