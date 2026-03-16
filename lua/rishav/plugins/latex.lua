---@module "rishav.plugins.latex"
---VimTeX: LaTeX editing, compilation, and live preview
---
--- IMPORTANT: VimTeX must NOT be lazy-loaded. It is already filetype-lazy by
--- design. Forcing lazy loading breaks inverse-search (`:VimtexInverseSearch`
--- must be globally available before any TeX file is opened).
return {
    "lervag/vimtex",
    lazy = false,
    init = function()
        -- Note: maplocalleader is set in init.lua before lazy loads
        -- (backslash '\' is used to avoid conflicts)

        -- ── Compiler ──────────────────────────────────────────────────────
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

        -- ── Viewer (Zathura + SyncTeX) ────────────────────────────────────
        vim.g.vimtex_view_method = "zathura"

        -- Forward-search callback: jump Nvim → Zathura after compilation
        vim.g.vimtex_view_zathura_hook_callback = 0

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
        -- highlighting (treesitter 'latex' parser is disabled for highlight
        -- in treesitter.lua but still used for folds/textobjects).
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
}
