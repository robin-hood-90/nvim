return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status")

        -- Vibrant color palette
        local colors = {
            blue = "#61AFEF",
            cyan = "#56B6C2",
            green = "#98C379",
            violet = "#C678DD",
            magenta = "#E06C75",
            yellow = "#E5C07B",
            orange = "#D19A66",
            red = "#E86671",
            fg = "#ABB2BF",
            bg = "#1E222A",
            bg_light = "#2C323C",
            gray = "#5C6370",
        }

        -- Custom theme with smooth gradients
        local my_lualine_theme = {
            normal = {
                a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg_light, fg = colors.blue },
                c = { bg = colors.bg, fg = colors.fg },
            },
            insert = {
                a = { bg = colors.green, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg_light, fg = colors.green },
                c = { bg = colors.bg, fg = colors.fg },
            },
            visual = {
                a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg_light, fg = colors.violet },
                c = { bg = colors.bg, fg = colors.fg },
            },
            command = {
                a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg_light, fg = colors.yellow },
                c = { bg = colors.bg, fg = colors.fg },
            },
            replace = {
                a = { bg = colors.red, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg_light, fg = colors.red },
                c = { bg = colors.bg, fg = colors.fg },
            },
            inactive = {
                a = { bg = colors.bg_light, fg = colors.gray },
                b = { bg = colors.bg, fg = colors.gray },
                c = { bg = colors.bg, fg = colors.gray },
            },
        }

        -- Custom components for extra flair
        local mode_icons = {
            n = "󰋜 ",
            i = "󰏫 ",
            v = "󰈈 ",
            V = "󰈈 ",
            [""] = "󰈈 ",
            c = " ",
            R = "󰛔 ",
            t = " ",
        }

        local function mode_with_icon()
            local mode = vim.fn.mode()
            return (mode_icons[mode] or "󰋜 ") .. require("lualine.utils.mode").get_mode()
        end

        lualine.setup({
            options = {
                theme = my_lualine_theme,
                icons_enabled = true,
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                always_divide_middle = true,
                globalstatus = true,
            },
            sections = {
                lualine_a = {
                    {
                        mode_with_icon,
                        separator = { right = "" },
                        padding = { left = 1, right = 1 },
                    },
                },
                lualine_b = {
                    {
                        "branch",
                        icon = "",
                        color = { fg = colors.violet, gui = "bold" },
                    },
                    {
                        "diff",
                        symbols = { added = " ", modified = " ", removed = " " },
                        diff_color = {
                            added = { fg = colors.green },
                            modified = { fg = colors.orange },
                            removed = { fg = colors.red },
                        },
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
                        diagnostics_color = {
                            error = { fg = colors.red },
                            warn = { fg = colors.yellow },
                            info = { fg = colors.cyan },
                            hint = { fg = colors.violet },
                        },
                    },
                },
                lualine_c = {
                    {
                        "filename",
                        file_status = true,
                        path = 1,
                        symbols = {
                            modified = " 󰷥",
                            readonly = " ",
                            unnamed = " [No Name]",
                            newfile = " 󰎔",
                        },
                        color = { fg = colors.cyan, gui = "italic" },
                    },
                },
                lualine_x = {
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        icon = "󰚰 ",
                        color = { fg = colors.orange, gui = "bold" },
                    },
                    {
                        "encoding",
                        icon = "󰉿",
                        color = { fg = colors.gray },
                    },
                    {
                        "fileformat",
                        symbols = {
                            unix = "",
                            dos = "",
                            mac = "",
                        },
                        color = { fg = colors.gray },
                    },
                    {
                        "filetype",
                        icon_only = false,
                        colored = true,
                    },
                },
                lualine_y = {
                    {
                        "progress",
                        icon = "󰓎",
                        color = { fg = colors.violet },
                    },
                },
                lualine_z = {
                    {
                        "location",
                        icon = "󰆧",
                        separator = { left = "" },
                        padding = { left = 1, right = 1 },
                    },
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {
                    {
                        "filename",
                        file_status = true,
                        path = 1,
                        color = { fg = colors.gray },
                    },
                },
                lualine_x = { { "location", color = { fg = colors.gray } } },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            extensions = { "nvim-tree", "lazy", "mason" },
        })
    end,
}
