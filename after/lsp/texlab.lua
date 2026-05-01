---@module "after.lsp.texlab"
---texlab LSP configuration (LaTeX/BibTeX)
---
--- texlab provides: completions (\cite, \ref, commands, file names),
--- diagnostics from latexmk build logs, inlay hints for labels/refs,
--- hover math-symbol previews, formatting via latexindent, and
--- SyncTeX forward/inverse search integration.
---
--- Forward search is handled by VimTeX (<localleader>lv). texlab's
--- build.onSave is disabled because VimTeX runs latexmk -pvc in
--- continuous mode instead, and both are configured for Okular.
---
--- NOTE: texlab requires LaTeX to be installed. If not available,
--- this LSP will not start.

-- Check if texlab is available
if vim.fn.executable("texlab") ~= 1 then
    return nil
end

return {
    cmd = { "texlab" },
    filetypes = { "tex", "plaintex", "bib" },
    root_markers = { ".latexmkrc", "latexmkrc", ".texlabroot", ".git" },
    settings = {
        texlab = {
            -- ── Build ────────────────────────────────────────────────────
            -- onSave = false: VimTeX's continuous latexmk handles this.
            build = {
                executable = "latexmk",
                args = {
                    "-pdf",
                    "-pdflatex",
                    "-interaction=nonstopmode",
                    "-synctex=1",
                    "%f",
                },
                onSave = false,
                forwardSearchAfter = false,
            },

            -- ── Forward search (Nvim → Okular) ───────────────────────────
            -- VimTeX's <localleader>lv uses Okular via vimtex_view_method.
            -- texlab's forwardSearch is used by texlab LSP clients; we configure
            -- it here so it works if triggered via LSP as well.
            forwardSearch = {
                executable = "okular",
                args = { "--unique", "file:%p#src:%l%f" },
            },

            -- ── Chktex ───────────────────────────────────────────────────
            -- Disabled: latexmk provides superior error reporting.
            -- Enable if you want style linting on top of compiler errors.
            chktex = {
                onOpenAndSave = false,
                onEdit = false,
            },

            -- ── Diagnostics ───────────────────────────────────────────────
            diagnosticsDelay = 300,
            diagnostics = {
                ignoredPatterns = {
                    "^Underfull",
                    "^Overfull",
                },
            },

            -- ── Formatter ────────────────────────────────────────────────
            latexFormatter = "latexindent",
            latexindent = {
                ["local"] = nil, -- use default latexindent config
                modifyLineBreaks = false,
            },
            bibtexFormatter = "texlab",
            formatterLineLength = 80,

            -- ── Completion ───────────────────────────────────────────────
            completion = {
                matcher = "fuzzy-ignore-case",
            },

            -- ── Inlay hints ───────────────────────────────────────────────
            -- Shows resolved label numbers next to \ref, and label text
            -- next to \label definitions.
            inlayHints = {
                labelDefinitions = true,
                labelReferences = true,
                maxLength = 60,
            },

            -- ── Hover ────────────────────────────────────────────────────
            hover = {
                symbols = "image",
            },

            -- ── Experimental ─────────────────────────────────────────────
            experimental = {
                followPackageLinks = false,
                mathEnvironments = { "align*", "gather*", "multline*", "equation*" },
                verbatimEnvironments = { "minted", "lstlisting", "verbatim" },
            },
        },
    },
}
