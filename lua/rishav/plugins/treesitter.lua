---@module "rishav.plugins.treesitter"
---Treesitter syntax highlighting and related features
return {
    -- Treesitter installer + queries.
    --
    -- NOTE: Neovim 0.12+ requires nvim-treesitter's `main` branch.
    -- The old `master` branch is archived and breaks with 0.12 (node:range API).
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = function()
            if vim.fn.executable("tree-sitter") == 1 then
                vim.cmd("TSUpdate")
            else
                vim.notify(
                    "Skipping :TSUpdate (tree-sitter-cli not installed)",
                    vim.log.levels.WARN
                )
            end
        end,
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
            local ok, ts = pcall(require, "nvim-treesitter")
            if ok then
                -- New (0.12+) API: this plugin only manages parsers/queries.
                -- Highlighting/folds are provided by Neovim and must be enabled per filetype.
                ts.setup({})
            end

            -- Neovim 0.12 ships builtin parsers + queries for a set of languages.
            -- If you previously used nvim-treesitter's archived branch, it likely left behind
            -- parser .so files under the plugin directory (e.g. .../lazy/nvim-treesitter/parser).
            -- Those can be older than Neovim's runtime queries, causing query field mismatches.
            -- Prefer the builtin parser when available.
            local function prefer_builtin_parser(lang)
                if vim._ts_has_language and vim._ts_has_language(lang) then
                    return
                end

                local files = vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", true)
                if #files == 0 then
                    return
                end

                local data = vim.fn.stdpath("data")
                local lazy_parser_prefix = data .. "/lazy/nvim-treesitter/parser/"

                local chosen

                -- First: prefer Neovim's bundled parser path.
                for _, f in ipairs(files) do
                    if f:find("/lib/nvim/parser/", 1, true) then
                        chosen = f
                        break
                    end
                end

                -- Second: any parser that isn't the stale lazy/nvim-treesitter one.
                if not chosen then
                    for _, f in ipairs(files) do
                        if not f:find(lazy_parser_prefix, 1, true) then
                            chosen = f
                            break
                        end
                    end
                end

                if chosen then
                    pcall(vim.treesitter.language.add, lang, { path = chosen })
                end
            end

            -- Lua ftplugin in 0.12 calls vim.treesitter.start() unconditionally.
            -- Ensure it loads a compatible parser.
            prefer_builtin_parser("lua")

            -- Neovim ships `vim`/`vimdoc` queries and parsers too. If an older parser is found
            -- earlier on runtimepath, Neovim's queries can fail to compile (e.g. "tab").
            prefer_builtin_parser("vim")
            prefer_builtin_parser("vimdoc")

            -- Setup autotag (independent of nvim-treesitter API changes)
            pcall(function()
                require("nvim-ts-autotag").setup()
            end)

            -- Use bash parser for zsh files
            pcall(function()
                vim.treesitter.language.register("bash", "zsh")
            end)

            -- Enable treesitter features for selected filetypes.
            -- This replaces the old `highlight = { enable = true }` behavior from the archived branch.
            local group = vim.api.nvim_create_augroup("rishav_treesitter", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = {
                    "bash",
                    "c",
                    "cpp",
                    "css",
                    "dockerfile",
                    "gitignore",
                    "go",
                    "graphql",
                    "html",
                    "java",
                    "javascript",
                    "javascriptreact",
                    "json",
                    "lua",
                    "markdown",
                    "prisma",
                    "python",
                    "query",
                    "regex",
                    "rust",
                    "sh",
                    "svelte",
                    "typescript",
                    "typescriptreact",
                    "typst",
                    "vim",
                    "vimdoc",
                    "yaml",
                    "zsh",
                },
                callback = function(args)
                    -- Highlighting (Neovim)
                    pcall(vim.treesitter.start, args.buf)

                    -- Folds (Neovim)
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo.foldmethod = "expr"

                    -- Indentation (nvim-treesitter)
                    if ok then
                        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })

            -- If `tree-sitter` CLI is missing, parser installs/updates will fail.
            -- Keep startup quiet, but surface a single warning to avoid confusion.
            if vim.fn.executable("tree-sitter") == 0 and not vim.g.rishav_warned_tree_sitter_cli then
                vim.g.rishav_warned_tree_sitter_cli = true
                vim.schedule(function()
                    vim.notify(
                        "tree-sitter-cli not found: install it to use :TSInstall/:TSUpdate",
                        vim.log.levels.WARN
                    )
                end)
            end
        end,
    },
}
