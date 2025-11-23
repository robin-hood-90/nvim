return {
  "vague-theme/vague.nvim",
  lazy = false, -- load during startup
  priority = 1000, -- ensure it loads before other plugins
  config = function()
    -- Load vague colorscheme
    require("vague").setup({})
    vim.cmd("colorscheme vague")

    -- Transparent background setup
    local transparent_groups = {
      "Normal",
      "NormalNC",
      "NormalFloat",
      "FloatBorder",
      "SignColumn",
      "MsgArea",
      "NvimTreeNormal",
      "NvimTreeNormalNC",
      "StatusLine",
      "StatusLineNC",
      "TelescopeNormal",
      "TelescopeBorder",
      "Pmenu",
      "PmenuSel",
    }

    for _, group in ipairs(transparent_groups) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end

    -- Set up nvim-notify with transparent background
    local ok, notify = pcall(require, "notify")
    if ok then
      notify.setup({
        background_colour = "#000000", -- no warning, full transparency
      })
    end
  end,
}
