---@module "rishav.plugins.lualine"
---Statusline configuration - minimal but informative
local icons = require("rishav.core.icons")

return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
        local lazy_status = require("lazy.status")

        -- Helper to show attached LSP clients
        local function lsp_clients()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
                return ""
            end
            local names = {}
            for _, client in ipairs(clients) do
                if client.name ~= "copilot" then -- Hide copilot from LSP list
                    table.insert(names, client.name)
                end
            end
            if #names == 0 then
                return ""
            end
            return " " .. table.concat(names, ", ")
        end

        return {
            options = {
                theme = "catppuccin",
                globalstatus = true,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = { "dashboard", "alpha", "starter", "lazy" },
                },
            },
            sections = {
                lualine_a = {
                    { "mode", icon = "" },
                },
                lualine_b = {
                    { "branch", icon = icons.git.branch },
                },
                lualine_c = {
                    {
                        "diagnostics",
                        symbols = {
                            error = icons.diagnostics.Error,
                            warn = icons.diagnostics.Warn,
                            info = icons.diagnostics.Info,
                            hint = icons.diagnostics.Hint,
                        },
                    },
                    { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    {
                        "filename",
                        path = 1, -- Relative path
                        symbols = { modified = "  ", readonly = " ", unnamed = "[No Name]" },
                    },
                },
                lualine_x = {
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        color = { fg = "#ff9e64" },
                    },
                    {
                        "diff",
                        symbols = {
                            added = icons.git.added,
                            modified = icons.git.modified,
                            removed = icons.git.removed,
                        },
                    },
                },
                lualine_y = {
                    { lsp_clients },
                    { "progress", separator = " ", padding = { left = 1, right = 0 } },
                    { "location", padding = { left = 0, right = 1 } },
                },
                lualine_z = {
                    {
                        function()
                            return " " .. os.date("%H:%M")
                        end,
                    },
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            extensions = { "neo-tree", "nvim-tree", "lazy", "mason", "trouble", "quickfix" },
        }
    end,
}
