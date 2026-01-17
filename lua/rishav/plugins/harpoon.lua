---@module "rishav.plugins.harpoon"
---Harpoon - Quick file navigation with ergonomic keybindings
---
--- Keybindings use number keys for intuitive file slots:
--- <leader>ha - Add file to harpoon
--- <leader>hm - Toggle harpoon menu
--- <leader>1-4 - Quick jump to file 1-4
--- [H / ]H - Navigate prev/next in list
return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>ha", desc = "Harpoon: Add file" },
        { "<leader>hh", desc = "Harpoon: Toggle menu" },
        { "<leader>1", desc = "Harpoon: File 1" },
        { "<leader>2", desc = "Harpoon: File 2" },
        { "<leader>3", desc = "Harpoon: File 3" },
        { "<leader>4", desc = "Harpoon: File 4" },
        { "<leader>5", desc = "Harpoon: File 5" },
        { "[H", desc = "Harpoon: Previous" },
        { "]H", desc = "Harpoon: Next" },
    },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = true,
                key = function()
                    return vim.loop.cwd()
                end,
            },
        })

        -- Extend UI with split options
        harpoon:extend({
            UI_CREATE = function(cx)
                vim.keymap.set("n", "<C-v>", function()
                    harpoon.ui:select_menu_item({ vsplit = true })
                end, { buffer = cx.bufnr, desc = "Open in vsplit" })

                vim.keymap.set("n", "<C-x>", function()
                    harpoon.ui:select_menu_item({ split = true })
                end, { buffer = cx.bufnr, desc = "Open in split" })

                vim.keymap.set("n", "<C-t>", function()
                    harpoon.ui:select_menu_item({ tabedit = true })
                end, { buffer = cx.bufnr, desc = "Open in new tab" })
            end,
        })

        -- Add/Menu (under <leader>h for harpoon group)
        vim.keymap.set("n", "<leader>ha", function()
            harpoon:list():add()
            vim.notify("Added to Harpoon", vim.log.levels.INFO)
        end, { desc = "Harpoon: Add file" })

        vim.keymap.set("n", "<leader>hm", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Harpoon: Toggle menu" })

        -- Quick select using number keys (very ergonomic!)
        vim.keymap.set("n", "<leader>1", function()
            harpoon:list():select(1)
        end, { desc = "Harpoon: File 1" })

        vim.keymap.set("n", "<leader>2", function()
            harpoon:list():select(2)
        end, { desc = "Harpoon: File 2" })

        vim.keymap.set("n", "<leader>3", function()
            harpoon:list():select(3)
        end, { desc = "Harpoon: File 3" })

        vim.keymap.set("n", "<leader>4", function()
            harpoon:list():select(4)
        end, { desc = "Harpoon: File 4" })

        vim.keymap.set("n", "<leader>5", function()
            harpoon:list():select(5)
        end, { desc = "Harpoon: File 5" })

        -- Bracket navigation (consistent with other [ ] motions)
        vim.keymap.set("n", "[H", function()
            harpoon:list():prev()
        end, { desc = "Harpoon: Previous" })

        vim.keymap.set("n", "]H", function()
            harpoon:list():next()
        end, { desc = "Harpoon: Next" })
    end,
}
