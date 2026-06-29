---@module "rishav.plugins.treesitter"
---Treesitter syntax highlighting and indentation
return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
        ensure_installed = {
            "json",
            "javascript",
            "typescript",
            "tsx",
            "yaml",
            "html",
            "css",
            "prisma",
            "markdown",
            "markdown_inline",
            "svelte",
            "graphql",
            "bash",
            "lua",
            "vim",
            "dockerfile",
            "gitignore",
            "query",
            "vimdoc",
            "c",
            -- User's additional languages
            "cpp",
            "go",
            "java",
            "python",
            "regex",
            "rust",
        },
    },
    config = function(_, opts)
        require("nvim-treesitter").setup(opts)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "json",
                "javascript",
                "typescript",
                "tsx",
                "yaml",
                "html",
                "css",
                "prisma",
                "markdown",
                "markdown_inline",
                "svelte",
                "graphql",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "gitignore",
                "query",
                "vimdoc",
                "c",
                "javascriptreact",
                "typescriptreact",
                "zsh",
                "cpp",
                "go",
                "java",
                "python",
                "regex",
                "rust",
            },
            callback = function()
                vim.treesitter.start()
            end,
        })
    end,
}
