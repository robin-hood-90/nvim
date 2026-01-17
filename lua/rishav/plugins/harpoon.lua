---@module "rishav.plugins.harpoon"
---Harpoon - Quick file navigation
return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
        local harpoon = require("harpoon")

        -- REQUIRED: Setup harpoon with settings
        harpoon:setup({
            settings = {
                save_on_toggle = true, -- Save when closing the menu
                sync_on_ui_close = true, -- Sync to disk when closing UI
                key = function()
                    return vim.loop.cwd() -- Use current working directory as key
                end,
            },
        })

        -- Extend harpoon with additional keymaps in the UI menu
        harpoon:extend({
            UI_CREATE = function(cx)
                -- Open in vertical split
                vim.keymap.set("n", "<C-v>", function()
                    harpoon.ui:select_menu_item({ vsplit = true })
                end, { buffer = cx.bufnr, desc = "Open in vsplit" })

                -- Open in horizontal split
                vim.keymap.set("n", "<C-x>", function()
                    harpoon.ui:select_menu_item({ split = true })
                end, { buffer = cx.bufnr, desc = "Open in split" })

                -- Open in new tab
                vim.keymap.set("n", "<C-t>", function()
                    harpoon.ui:select_menu_item({ tabedit = true })
                end, { buffer = cx.bufnr, desc = "Open in new tab" })
            end,
        })

        -- Highlight current file in harpoon list
        local extensions = require("harpoon.extensions")
        harpoon:extend(extensions.builtins.highlight_current_file())

        -- ╭──────────────────────────────────────────────────────────╮
        -- │                        Keymaps                           │
        -- ╰──────────────────────────────────────────────────────────╯

        -- Add current file to harpoon
        vim.keymap.set("n", "<leader>ha", function()
            harpoon:list():add()
            vim.notify("Added to Harpoon", vim.log.levels.INFO, { title = "Harpoon" })
        end, { desc = "Harpoon: Add file" })

        -- Toggle harpoon quick menu
        vim.keymap.set("n", "<leader>hh", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Harpoon: Toggle menu" })

        -- Quick access to harpooned files (1-5)
        vim.keymap.set("n", "<leader>h1", function()
            harpoon:list():select(1)
        end, { desc = "Harpoon: File 1" })

        vim.keymap.set("n", "<leader>h2", function()
            harpoon:list():select(2)
        end, { desc = "Harpoon: File 2" })

        vim.keymap.set("n", "<leader>h3", function()
            harpoon:list():select(3)
        end, { desc = "Harpoon: File 3" })

        vim.keymap.set("n", "<leader>h4", function()
            harpoon:list():select(4)
        end, { desc = "Harpoon: File 4" })

        vim.keymap.set("n", "<leader>h5", function()
            harpoon:list():select(5)
        end, { desc = "Harpoon: File 5" })

        -- Navigate through harpoon list
        vim.keymap.set("n", "<leader>hp", function()
            harpoon:list():prev()
        end, { desc = "Harpoon: Previous file" })

        vim.keymap.set("n", "<leader>hn", function()
            harpoon:list():next()
        end, { desc = "Harpoon: Next file" })

        -- Remove current file from harpoon
        vim.keymap.set("n", "<leader>hr", function()
            local list = harpoon:list()
            local current_file = vim.fn.expand("%:p:.")
            for i, item in ipairs(list.items) do
                if item.value == current_file then
                    list:remove_at(i)
                    vim.notify("Removed from Harpoon", vim.log.levels.INFO, { title = "Harpoon" })
                    return
                end
            end
            vim.notify("File not in Harpoon list", vim.log.levels.WARN, { title = "Harpoon" })
        end, { desc = "Harpoon: Remove current file" })

        -- Clear all harpoon marks
        vim.keymap.set("n", "<leader>hc", function()
            harpoon:list():clear()
            vim.notify("Cleared all Harpoon marks", vim.log.levels.INFO, { title = "Harpoon" })
        end, { desc = "Harpoon: Clear all" })

        -- Alternative quick access keymaps (Alt + number)
        vim.keymap.set("n", "<M-1>", function()
            harpoon:list():select(1)
        end, { desc = "Harpoon: File 1" })

        vim.keymap.set("n", "<M-2>", function()
            harpoon:list():select(2)
        end, { desc = "Harpoon: File 2" })

        vim.keymap.set("n", "<M-3>", function()
            harpoon:list():select(3)
        end, { desc = "Harpoon: File 3" })

        vim.keymap.set("n", "<M-4>", function()
            harpoon:list():select(4)
        end, { desc = "Harpoon: File 4" })

        vim.keymap.set("n", "<M-5>", function()
            harpoon:list():select(5)
        end, { desc = "Harpoon: File 5" })
    end,
}
