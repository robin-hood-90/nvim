---@module "rishav.plugins.treesitter"
---Treesitter syntax highlighting and related features
return {
    -- Main treesitter config (using master branch for stable parser installation)
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
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
                    max_lines = 3,
                    min_window_height = 20,
                },
            },
        },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "html",
                    "css",
                    "javascript",
                    "typescript",
                    "tsx",
                    "json",
                    "yaml",
                    "svelte",
                    "graphql",
                    "prisma",
                    "lua",
                    "python",
                    "rust",
                    "go",
                    "c",
                    "cpp",
                    "java",
                    "markdown",
                    "markdown_inline",
                    "bash",
                    "dockerfile",
                    "gitignore",
                    "vim",
                    "vimdoc",
                    "query",
                    "regex",
                    -- LaTeX: VimTeX handles highlighting; skip treesitter parsers
                    -- (latex parser requires tree-sitter CLI which may not be installed)
                    -- "latex",
                    -- "bibtex",
                    -- Typst
                    "typst",
                },
                sync_install = false,
                auto_install = false,
                highlight = {
                    enable = true,
                    -- Disable treesitter highlighting for LaTeX; VimTeX's mature
                    -- Vimscript syntax engine handles it better.
                    disable = { "latex" },
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
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

            -- Setup autotag
            require("nvim-ts-autotag").setup()

            -- Use bash parser for zsh files
            vim.treesitter.language.register("bash", "zsh")
        end,
    },
}
