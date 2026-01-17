-- Minimalist bufferline config following josean-dev's approach
-- Uses tabs mode: bufferline shows TABS, not buffers
-- This makes tabs behave like browser tabs (different workspaces)
return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
        options = {
            mode = "tabs", -- Show tabs, not buffers (minimalist approach)
            separator_style = "slant",
        },
    },
}
