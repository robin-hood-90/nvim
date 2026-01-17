---@module "rishav.plugins.which-key"
---Key binding hints and organization
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        delay = 300,
        icons = {
            breadcrumb = "»",
            separator = "➜",
            group = "+",
            mappings = true,
        },
        spec = {
            -- Leader groups (organized by function)
            { "<leader>b", group = "Buffer" },
            { "<leader>c", group = "Code/Copilot" },
            { "<leader>d", group = "Diagnostics" },
            { "<leader>D", group = "Debug" },
            { "<leader>e", group = "Explorer" },
            { "<leader>f", group = "Find/Files" },
            { "<leader>g", group = "Git" },
            { "<leader>h", group = "Harpoon/Hunk" },
            { "<leader>l", group = "LSP" },
            { "<leader>m", group = "Move/Manipulate" },
            { "<leader>n", group = "Notifications" },
            { "<leader>r", group = "Rename/Replace" },
            { "<leader>s", group = "Split/Window" },
            { "<leader>t", group = "Tab" },
            { "<leader>u", group = "UI/Toggle" },
            { "<leader>x", group = "Trouble/Quickfix" },

            -- Direct mappings with descriptions
            { "<leader>q", desc = "Quit" },
            { "<leader>Q", desc = "Force quit all" },
            { "<leader>w", desc = "Save" },
            { "<leader>W", desc = "Save all" },
            { "<leader>L", desc = "Lazy" },
            { "<leader>M", desc = "Mason" },
            { "<leader><Tab>", desc = "Alternate buffer" },
            { "<leader><leader>", desc = "Resume picker" },

            -- Harpoon quick access (number keys)
            { "<M-1>", desc = "Harpoon 1" },
            { "<M-2>", desc = "Harpoon 2" },
            { "<M-3>", desc = "Harpoon 3" },
            { "<M-4>", desc = "Harpoon 4" },
            { "<M-5>", desc = "Harpoon 5" },

            -- Bracket motions help
            { "[", group = "Prev" },
            { "]", group = "Next" },
            { "g", group = "Go to" },
        },
        win = {
            border = "rounded",
        },
    },
}
