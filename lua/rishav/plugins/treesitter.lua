---@module "rishav.plugins.treesitter"
---Treesitter syntax highlighting and related features for Neovim 0.12+
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
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
            -- ── 1. Core setup ────────────────────────────────────────────────────
            -- On the `main` branch, nvim-treesitter only manages parsers/queries.
            -- Highlighting, folding, and indentation are wired up separately below.
            -- setup() accepts install_dir and other meta options — NOT highlight/indent.
            local ok, ts = pcall(require, "nvim-treesitter")
            if not ok then
                vim.notify("[treesitter] Failed to load nvim-treesitter: " .. tostring(ts), vim.log.levels.ERROR)
                return
            end

            ts.setup({
                -- Optional: change where parsers are stored
                -- install_dir = vim.fn.stdpath("data") .. "/treesitter",
            })

            -- ── 2. Ensure parsers are installed (replaces `ensure_installed`) ────
            -- The new main branch dropped `ensure_installed` from setup().
            -- Instead, diff against already-installed parsers and install missing ones.
            local parsers_to_ensure = {
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
                "jsdoc",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "prisma",
                "python",
                "query",
                "regex",
                "rust",
                "svelte",
                "tsx",
                "typescript",
                "typst",
                "vim",
                "vimdoc",
                "yaml",
            }

            -- nvim-treesitter.config.get_installed() returns the list of already
            -- compiled parsers, so we only install what's actually missing.
            local ts_config_ok, ts_config = pcall(require, "nvim-treesitter.config")
            if ts_config_ok then
                local already_installed = ts_config.get_installed() or {}
                local missing = vim.iter(parsers_to_ensure)
                    :filter(function(p)
                        return not vim.tbl_contains(already_installed, p)
                    end)
                    :totable()
                if #missing > 0 then
                    ts.install(missing)
                end
            end

            -- ── 3. Prefer Neovim's bundled parsers over stale lazy/ ones ─────────
            -- Neovim 0.12 ships built-in parsers for lua, vim, vimdoc, etc.
            -- If the old master branch left behind parser .so files under
            -- lazy/nvim-treesitter/parser/, they may be stale and break queries.
            -- This function forces the built-in (or any non-lazy) parser to win.
            local function prefer_builtin_parser(lang)
                -- If Neovim already has the language registered, nothing to do.
                if vim.treesitter.language.inspect and pcall(vim.treesitter.language.inspect, lang) then
                    return
                end

                local data = vim.fn.stdpath("data")
                local lazy_parser_prefix = data .. "/lazy/nvim-treesitter/parser/"
                local files = vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", true)
                if #files == 0 then
                    return
                end

                local chosen
                -- Priority 1: Neovim's own bundled parser path.
                for _, f in ipairs(files) do
                    if f:find("/lib/nvim/parser/", 1, true) then
                        chosen = f
                        break
                    end
                end
                -- Priority 2: anything that isn't the stale lazy/ parser.
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

            -- These three are the ones most likely to have stale parsers from master.
            prefer_builtin_parser("lua")
            prefer_builtin_parser("vim")
            prefer_builtin_parser("vimdoc")

            -- ── 4. Language aliases ───────────────────────────────────────────────
            -- Register bash parser for zsh files (no separate zsh parser exists).
            pcall(vim.treesitter.language.register, "bash", "zsh")
            -- sh files also use the bash parser.
            pcall(vim.treesitter.language.register, "bash", "sh")

            -- ── 5. Enable TS features per filetype via autocmd ───────────────────
            -- On the new main branch, highlighting, folding, and indentation are
            -- NOT enabled by setup(). You must wire them up yourself.
            -- `vim.wo[0][0]` is the window-local scoping syntax for 0.12+ to avoid
            -- leaking options across windows sharing the same buffer.
            local group = vim.api.nvim_create_augroup("rishav_treesitter", { clear = true })

            -- Build patterns from the parser list + zsh (alias to bash).
            local ft_patterns = vim.deepcopy(parsers_to_ensure)
            -- Add filetypes that differ from parser name
            vim.list_extend(ft_patterns, {
                "javascriptreact", -- mapped to `javascript` parser by TS
                "typescriptreact", -- mapped to `tsx` parser
                "zsh", -- alias → bash
                "sh", -- alias → bash
            })

            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = ft_patterns,
                callback = function(args)
                    local buf = args.buf

                    -- Highlighting — provided by Neovim core (not the plugin).
                    -- pcall guards against missing/broken parsers gracefully.
                    pcall(vim.treesitter.start, buf)

                    -- Folding — provided by Neovim core.
                    -- Use the [0][0] double-index to scope to this window+buffer
                    -- combination only (Neovim 0.12 recommendation).
                    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo[0][0].foldmethod = "expr"
                    vim.wo[0][0].foldenable = false -- start with folds open

                    -- Indentation — provided by nvim-treesitter (experimental).
                    -- Only set if the plugin loaded successfully.
                    if ok then
                        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })

            -- ── 6. Warn once if tree-sitter CLI is missing ───────────────────────
            -- The new main branch requires the CLI to compile parsers.
            -- :TSInstall and :TSUpdate will silently fail without it.
            if vim.fn.executable("tree-sitter") == 0 and not vim.g.rishav_warned_tree_sitter_cli then
                vim.g.rishav_warned_tree_sitter_cli = true
                vim.schedule(function()
                    vim.notify(
                        "[treesitter] tree-sitter-cli not found.\n"
                            .. "Install it from your system package manager or cargo to use :TSInstall / :TSUpdate.\n"
                            .. "  cargo install tree-sitter-cli",
                        vim.log.levels.WARN
                    )
                end)
            end
        end,
    },
}
