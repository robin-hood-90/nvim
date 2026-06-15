# AGENTS.md — Neovim Configuration

- **Neovim**: 0.12.1
- **Plugin manager**: lazy.nvim (folke/lazy.nvim)
- **Namespace**: `lua/rishav/`
- **Author**: Rishav

## Verify & Format

```bash
nvim --headless -c "lua print('OK')" -c "qa"       # validate config loads
nvim --headless "+checkhealth" "+qa"                # full health check
stylua lua/                                         # format all lua (4-space indent)
```

## Key Architecture Decisions

### Treesitter: Neovim 0.12 built-in only
**No `nvim-treesitter` plugin.** It was dropped because nvim-treesitter does not officially support Neovim 0.12. Highlighting and folding use Neovim's core `vim.treesitter` API directly. Parsers and queries live under `lua/rishav/core/treesitter.lua`. The only treesitter-related plugin kept is `nvim-ts-autotag`. `nvim-treesitter-context` was also dropped.

### LSP: `vim.lsp.config` + `after/lsp/` (Neovim 0.11+)
- Server configs are **plain tables** returned from `after/lsp/[server].lua`
- Global capabilities set via `vim.lsp.config("*", ...)` in `lua/rishav/plugins/lsp/lsp.lua`
- Servers are enabled automatically by `mason-lspconfig` with `automatic_enable = true` (excluding jdtls)
- **Never use `on_attach` callback** in `after/lsp/` — use the `LspAttach` autocmd in `lua/rishav/lsp.lua` instead
- **Never call `require('lspconfig')[server].setup({})`** — that pattern is deprecated and will be deleted

### LSP commands (Neovim 0.12 native)
Uses `:lsp restart` and `:checkhealth vim.lsp`, **not** the legacy `:LspRestart` / `:LspInfo` from nvim-lspconfig.

### jdtls is special
Managed by `nvim-jdtls` via `jdtls.start_or_attach()` in `after/ftplugin/java.lua`. Capabilities, DAP, lombok, and bundles are all handled there. Codelens uses the generic `LspAttach` handler in `lsp.lua`.

### Cmdline completion
Handled by **noice.nvim** (cmdline popup with format highlighting). `cmp.setup.cmdline` is deliberately disabled. There is no `CmdlineChanged` autocmd triggering completion.

### nvim-notify background
Must be `background_colour = "#1a1b26"` (cyberdream background). `nil` causes a warning because the `NormalFloat` highlight group has `bg = "NONE"`.

## Directory Structure

```
init.lua                           # Entry: loads core → lazy → lsp
lua/rishav/
├── lazy.lua                       # lazy.nvim bootstrap, defaults, spec imports
├── lsp.lua                        # LspAttach autocmd, keymaps, inlay hints, codelens, diagnostics
├── core/
│   ├── init.lua                   # Module loader (options → treesitter → keymaps → autocmds → terminal)
│   ├── options.lua                # vim.opt settings, vim.diagnostic.config
│   ├── treesitter.lua             # Highlighting, folding, parser install, language aliases
│   ├── keymaps.lua                # Global keybindings
│   ├── autocmds.lua               # Yank highlight, auto-resize, terminal opts, file checks, etc.
│   ├── terminal.lua               # Floating + bottom terminal management
│   ├── utils.lua                  # map, augroup, autocmd, debounce, throttle, safe_require, get_root
│   └── icons.lua                  # All Nerdfont icons + get_diagnostic_signs() helper
├── plugins/
│   ├── init.lua                   # Base plugins: plenary, nvim-jdtls, fidget
│   ├── lsp/
│   │   ├── lsp.lua                # nvim-lspconfig: global capabilities via vim.lsp.config("*")
│   │   └── mason.lua              # mason + mason-lspconfig + mason-tool-installer
│   └── [plugin].lua               # One file per plugin, lazy.nvim spec format
after/
├── lsp/[server].lua               # Per-server tables (no on_attach, no setup() call)
└── ftplugin/[filetype].lua        # Filetype settings + jdtls startup
```

## Conventions

- **`opts = {}`** pattern preferred over `config()` in lazy specs; use `config()` only for imperative setup
- **`keys` field** in lazy specs auto-creates keymaps; don't duplicate with `vim.keymap.set` in `config()`
- **`fillchars`**: use `vim.opt.fillchars:append()` to add fold chars — never raw `vim.o.fillchars =` which overwrites values from `options.lua`
- **Lazy triggers**: every plugin has one (`event`, `keys`, `cmd`, `ft`). `lazy = false` is avoided unless forced (colorscheme)
- **pcall** for all optional requires; `vim.schedule()` for deferred work
- **Keymaps** use `desc` field; `utils.map()` sets `silent = true` by default
- **Augroups** prefixed with `rishav_`; created via `utils.augroup(name)` with `clear = true`

## Gotchas

1. **Do not edit `lazy-lock.json`** — auto-generated
2. **Do not add `on_attach`** to `after/lsp/` tables — use `LspAttach` in `lsp.lua`
3. **Do not use deprecated `require('lspconfig')` setup pattern** — use `vim.lsp.config` + `vim.lsp.enable`
4. **Do not add nvim-treesitter or nvim-treesitter-context** — both dropped for 0.12 built-in TS
5. **svelte server**: TS/JS change notifications handled in `lsp.lua` LspAttach, gated by `client.name == "svelte"`
6. **java codelens**: handled generically by `LspAttach` — no java-specific autocmd needed
