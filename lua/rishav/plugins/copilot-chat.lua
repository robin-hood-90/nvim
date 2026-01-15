return {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = {
        "CopilotChat",
        "CopilotChatOpen",
        "CopilotChatClose",
        "CopilotChatToggle",
        "CopilotChatExplain",
        "CopilotChatFix",
        "CopilotChatOptimize",
        "CopilotChatTests",
        "CopilotChatDocs",
        "CopilotChatReview",
        "CopilotChatModels",
        "CopilotChatModel",
        "CopilotChatReset",
    },
    dependencies = {
        "zbirenbaum/copilot.lua",
        "nvim-lua/plenary.nvim",
        "MeanderingProgrammer/render-markdown.nvim",
    },

    keys = {
        { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat Toggle" },
        { "<leader>co", "<cmd>CopilotChatOpen<cr>", desc = "Copilot Chat Open" },

        { "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Copilot Explain" },
        { "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Copilot Fix" },
        { "<leader>cp", "<cmd>CopilotChatOptimize<cr>", mode = { "n", "v" }, desc = "Copilot Optimize" },
        { "<leader>ct", "<cmd>CopilotChatTests<cr>", mode = { "n", "v" }, desc = "Copilot Tests" },
        { "<leader>cd", "<cmd>CopilotChatDocs<cr>", mode = { "n", "v" }, desc = "Copilot Docs" },
        { "<leader>cr", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "Copilot Review" },

        {
            "<leader>cq",
            function()
                local input = vim.fn.input("Ask Copilot: ")
                if input ~= "" then
                    require("CopilotChat").ask(input)
                end
            end,
            desc = "Copilot Quick Chat",
        },

        { "<leader>cm", "<cmd>CopilotChatModels<cr>", desc = "Copilot Select Model" },
        { "<leader>cv", "<cmd>CopilotChatModel<cr>", desc = "Copilot View Model" },
        { "<leader>cx", "<cmd>CopilotChatReset<cr>", desc = "Copilot Reset Chat" },
    },

    config = function()
        local chat = require("CopilotChat")

        chat.setup({
            debug = false,
            temperature = 0.1,

            window = {
                layout = "vertical",
                width = 0.3,
                height = 0.6,
                title = "Copilot Chat",
            },
            separator = "-----------------------------",
            auto_fold = true,

            show_help = true,
            auto_follow_cursor = true,
            auto_insert_mode = false,
            clear_chat_on_new_prompt = false,

            highlight_selection = true,
            highlight_headers = false,
        })

        -- Render markdown nicely inside Copilot Chat buffers
        local ok, render_markdown = pcall(require, "render-markdown")
        if ok then
            render_markdown.setup({
                file_types = { "markdown", "copilot-chat" },
            })
        end
    end,
}
