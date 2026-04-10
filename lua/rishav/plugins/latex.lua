---@module "rishav.plugins.latex"
---VimTeX: LaTeX editing, compilation, and live preview
---
--- NOTE: This plugin is lazy-loaded on TeX filetypes to avoid startup warnings
--- when LaTeX is not installed. VimTeX globals are set in init() which runs
--- before the plugin loads.
---
--- NOTE: LaTeX must be installed separately. On Arch Linux:
---   sudo pacman -S texlive-most texlive-binextra
--- Or for a minimal install:
---   sudo pacman -S texlive-basic texlive-latexextra texlive-fontsextra
return {
    "lervag/vimtex",
    ft = { "tex", "latex", "bib", "plaintex" },
    init = function()
        -- Note: maplocalleader is set in init.lua before lazy loads
        -- (backslash '\' is used to avoid conflicts)

        -- Check if latexmk is available
        local has_latexmk = vim.fn.executable("latexmk") == 1

        -- ── Compiler ──────────────────────────────────────────────────────
        if has_latexmk then
            vim.g.vimtex_compiler_method = "latexmk"

            vim.g.vimtex_compiler_latexmk = {
                aux_dir = ".aux",
                out_dir = "",
                callback = 1,
                continuous = 1, -- latexmk -pvc: recompile on every save
                executable = "latexmk",
                hooks = {},
                options = {
                    "-pdf",
                    "-pdflatex",
                    "-verbose",
                    "-file-line-error",
                    "-synctex=1", -- required for forward/inverse search
                    "-interaction=nonstopmode",
                },
            }
        else
            -- Disable compiler if latexmk not found (warning shown only when opening TeX files)
            vim.g.vimtex_compiler_method = ""
            vim.g.vimtex_compiler_enabled = 0
        end

        -- ── Viewer (Okular) ────────────────────────────────────────────────
        -- Use Okular with SyncTeX support for forward/inverse search
        -- Keybindings: \lv to view PDF, \ll to compile
        vim.g.vimtex_view_method = "general"
        vim.g.vimtex_view_general_viewer = "okular"
        vim.g.vimtex_view_general_options = "--unique @pdf"

        -- ── Quickfix / Diagnostics ────────────────────────────────────────
        -- 0 = don't auto-open quickfix; show only on explicit :VimtexErrors
        vim.g.vimtex_quickfix_mode = 0

        -- Suppress low-value warnings from quickfix
        vim.g.vimtex_quickfix_ignore_filters = {
            "Underfull",
            "Overfull",
            "specifier changed to",
            "Token not allowed in a PDF string",
            "Package hyperref Warning",
        }

        -- ── Syntax / Concealment ──────────────────────────────────────────
        -- VimTeX ships a mature Vimscript syntax engine; let it handle TeX
        -- highlighting (treesitter 'latex' parser is disabled for highlight).
        vim.g.vimtex_syntax_enabled = 1
        vim.g.vimtex_syntax_conceal_disable = 0 -- enable concealment

        -- ── Snippet engine compatibility ───────────────────────────────────
        -- Disable VimTeX's built-in insert-mode mappings; LuaSnip handles
        -- all snippet expansion.
        vim.g.vimtex_imaps_enabled = 0

        -- ── Miscellaneous ─────────────────────────────────────────────────
        -- Don't open a quickfix window on warnings (only on errors)
        vim.g.vimtex_quickfix_open_on_warning = 0

        -- Enable fold expressions provided by VimTeX
        vim.g.vimtex_fold_enabled = 1

        -- Close VimTeX viewers when Nvim closes
        vim.g.vimtex_view_automatic = 1
    end,
    config = function()
        -- Show warning only when actually opening a TeX file without LaTeX installed
        if vim.fn.executable("latexmk") ~= 1 then
            vim.notify(
                "LaTeX not found. Compilation disabled.\nInstall with: sudo pacman -S texlive-most texlive-binextra",
                vim.log.levels.WARN
            )
        end
    end,
}
