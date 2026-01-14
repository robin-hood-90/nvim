return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",

    dependencies = {
        "windwp/nvim-ts-autotag",
        {
            "nvim-treesitter/nvim-treesitter-context",
            opts = {
                enable = true,
                mode = "topline",
                line_numbers = true,
                multiwindow = true,
            },
        },
    },

    config = function()
        local treesitter = require("nvim-treesitter.configs")

        -- autotag setup
        require("nvim-ts-autotag").setup()

        ---@type TSConfig
        treesitter.setup({
            -- REQUIRED FIELDS (for lua_ls)
            modules = {},
            sync_install = false,
            ignore_install = {},
            auto_install = true,

            -- SYNTAX HIGHLIGHTING
            highlight = {
                enable = true,
            },

            -- INDENTATION
            indent = {
                enable = true,
                disable = {
                    "javascript",
                    "typescript",
                    "tsx",
                    "javascriptreact",
                    "typescriptreact",
                },
            },

            -- INSTALLED PARSERS
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
                "cpp",
                "rust",
                "go",
                "c",
                "java",
            },

            -- INCREMENTAL SELECTION
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })

        -- Use bash parser for zsh files
        vim.treesitter.language.register("bash", "zsh")
    end,
}
