---@module "rishav.plugins.treesitter"
---Treesitter syntax highlighting and related features
return {
    -- Main treesitter config
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- Use latest
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        dependencies = {
            "windwp/nvim-ts-autotag",
            {
                "nvim-treesitter/nvim-treesitter-context",
                opts = {
                    enable = true,
                    mode = "topline",
                    line_numbers = true,
                    multiwindow = true,
                    max_lines = 3,
                    min_window_height = 20,
                },
            },
        },
        config = function()
            require("nvim-ts-autotag").setup()

            require("nvim-treesitter").setup({
                -- Installed parsers
                ensure_installed = {
                    -- Web
                    "html",
                    "css",
                    "javascript",
                    "typescript",
                    "tsx",
                    "json",
                    "jsonc",
                    "yaml",
                    "svelte",
                    "graphql",
                    "prisma",
                    -- Languages
                    "lua",
                    "python",
                    "rust",
                    "go",
                    "c",
                    "cpp",
                    "java",
                    -- Markup
                    "markdown",
                    "markdown_inline",
                    -- DevOps
                    "bash",
                    "dockerfile",
                    "gitignore",
                    -- Vim
                    "vim",
                    "vimdoc",
                    "query",
                    "regex",
                },
            })

            -- Enable treesitter-based highlighting
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })

            -- Use bash parser for zsh files
            vim.treesitter.language.register("bash", "zsh")
        end,
    },
}
