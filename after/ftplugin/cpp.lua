vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
-- Use hard tabs for C++; clang-format is configured to use 4-space tabs
-- (TabWidth = 4, UseTab = Always) as a fallback when no .clang-format exists.
vim.opt_local.expandtab = false
