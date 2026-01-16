---@module "rishav.plugins.treesitter"
---Treesitter syntax highlighting and related features
return {
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
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        require("nvim-ts-autotag").setup()

        ---@type TSConfig
        require("nvim-treesitter.configs").setup({
            -- Required fields
            modules = {},
            sync_install = false,
            ignore_install = {},
            auto_install = true,

            -- Syntax highlighting
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
                disable = function(_, buf)
                    -- Disable for large files
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },

            -- Indentation
            indent = {
                enable = true,
                disable = { "javascript", "typescript", "tsx", "javascriptreact", "typescriptreact" },
            },

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

            -- Incremental selection
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<BS>",
                },
            },

            -- Text objects
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = { query = "@function.outer", desc = "Select outer function" },
                        ["if"] = { query = "@function.inner", desc = "Select inner function" },
                        ["ac"] = { query = "@class.outer", desc = "Select outer class" },
                        ["ic"] = { query = "@class.inner", desc = "Select inner class" },
                        ["aa"] = { query = "@parameter.outer", desc = "Select outer argument" },
                        ["ia"] = { query = "@parameter.inner", desc = "Select inner argument" },
                        ["ai"] = { query = "@conditional.outer", desc = "Select outer conditional" },
                        ["ii"] = { query = "@conditional.inner", desc = "Select inner conditional" },
                        ["al"] = { query = "@loop.outer", desc = "Select outer loop" },
                        ["il"] = { query = "@loop.inner", desc = "Select inner loop" },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = { query = "@function.outer", desc = "Next function start" },
                        ["]c"] = { query = "@class.outer", desc = "Next class start" },
                        ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
                    },
                    goto_next_end = {
                        ["]F"] = { query = "@function.outer", desc = "Next function end" },
                        ["]C"] = { query = "@class.outer", desc = "Next class end" },
                    },
                    goto_previous_start = {
                        ["[f"] = { query = "@function.outer", desc = "Previous function start" },
                        ["[c"] = { query = "@class.outer", desc = "Previous class start" },
                        ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
                    },
                    goto_previous_end = {
                        ["[F"] = { query = "@function.outer", desc = "Previous function end" },
                        ["[C"] = { query = "@class.outer", desc = "Previous class end" },
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>a"] = { query = "@parameter.inner", desc = "Swap with next argument" },
                    },
                    swap_previous = {
                        ["<leader>A"] = { query = "@parameter.inner", desc = "Swap with previous argument" },
                    },
                },
            },
        })

        -- Use bash parser for zsh files
        vim.treesitter.language.register("bash", "zsh")
    end,
}
