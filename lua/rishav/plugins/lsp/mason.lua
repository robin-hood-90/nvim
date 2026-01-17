---@module "rishav.plugins.lsp.mason"
---Mason and LSP server management
local icons = require("rishav.core.icons")

return {
    -- Mason LSP Config
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {
                "williamboman/mason.nvim",
                cmd = "Mason",
                build = ":MasonUpdate",
                opts = {
                    ui = {
                        border = "rounded",
                        icons = icons.mason,
                        height = 0.8,
                    },
                    max_concurrent_installers = 4,
                },
            },
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                -- Web
                "ts_ls",
                "html",
                "cssls",
                "tailwindcss",
                "svelte",
                "emmet_ls",
                "eslint",
                "graphql",
                -- Languages
                "lua_ls",
                "pyright",
                "gopls",
                "clangd",
                -- NOTE: jdtls removed - handled by nvim-jdtls in ftplugin/java.lua
                -- jdtls package installation is managed by mason-tool-installer
            },
            automatic_installation = true,
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)

            -- Servers that require external tools to be installed
            local conditional_servers = {
                rust_analyzer = "cargo", -- Requires Rust toolchain
            }

            -- Enable all installed servers except jdtls (handled by nvim-jdtls)
            -- and servers that require unavailable external tools
            vim.schedule(function()
                local servers = require("mason-lspconfig").get_installed_servers()
                for _, server in ipairs(servers) do
                    if server == "jdtls" then
                        -- Skip jdtls - handled by nvim-jdtls
                    elseif conditional_servers[server] then
                        -- Check if required tool is available
                        local required_tool = conditional_servers[server]
                        if vim.fn.executable(required_tool) == 1 then
                            vim.lsp.enable(server)
                        end
                    else
                        vim.lsp.enable(server)
                    end
                end
            end)
        end,
    },

    -- Mason Tool Installer (formatters, linters, debuggers)
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                -- Formatters
                "prettier",
                "stylua",
                "isort",
                "black",
                "xmlformatter",
                -- Linters
                "pylint",
                "eslint_d",
                -- Language servers/tools
                "rust-analyzer",
                "jdtls",
                -- Debuggers
                "java-debug-adapter",
                "java-test",
            },
            auto_update = false,
            run_on_start = true,
            start_delay = 50, -- Delay to not block startup
        },
    },
}
