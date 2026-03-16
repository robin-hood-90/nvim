---@module "after.lsp.tinymist"
---tinymist LSP configuration (Typst)
---
--- tinymist is the actively maintained Typst LSP (replaces deprecated
--- typst-lsp). It provides: completions, go-to-definition, references,
--- hover docs, rename, inlay hints, code actions, color picker, document
--- outline, folding, and built-in formatting via typstyle.
---
--- PDF export is configured to compile on save for PDF reader preview.
--- For browser-based live preview, use typst-preview.nvim instead.
return {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    root_markers = { "typst.toml", ".git" },
    settings = {
        -- ── Formatter ────────────────────────────────────────────────────
        -- typstyle: opinionated, Prettier-like, fast (<5ms for 1000+ lines)
        -- typstfmt: less opinionated (legacy)
        formatterMode = "typstyle",
        formatterPrintWidth = 80,
        formatterIndentSize = 4,
        formatterProseWrap = true,

        -- ── PDF Export ───────────────────────────────────────────────────
        -- "onSave": compile to PDF on every :w (for PDF reader preview)
        -- "onType": compile on every keystroke (higher CPU usage)
        -- "never": disable auto-export (use preview-only workflow)
        exportPdf = "onSave",

        -- ── Semantic Tokens ───────────────────────────────────────────────
        -- Disable when using treesitter for highlighting (recommended)
        semanticTokens = "disable",

        -- ── Inlay Hints ───────────────────────────────────────────────────
        -- Shows parameter names and type info inline
        inlayHints = {
            enabled = true,
        },

        -- ── Experimental ─────────────────────────────────────────────────
        -- Auto-insert "///" when pressing Enter inside doc comments
        experimental = {
            onEnter = true,
        },
    },
}
