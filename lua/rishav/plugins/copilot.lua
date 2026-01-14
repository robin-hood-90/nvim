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
                    require("CopilotChat").ask(
                        input,
                        ---@diagnostic disable-next-line: deprecated
                        { selection = require("CopilotChat.select").buffer }
                    )
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
        local select = require("CopilotChat.select")

        chat.setup({
            debug = false,
            temperature = 0.1,

            window = {
                layout = "vertical",
                width = 0.3,
                height = 0.6,
                border = "rounded",
                title = "Copilot Chat",
            },

            show_help = true,
            auto_follow_cursor = true,
            auto_insert_mode = true,
            clear_chat_on_new_prompt = false,

            context = nil,

            highlight_selection = true,
            highlight_headers = false,

            prompts = {
                Explain = {
                    prompt = "/COPILOT_EXPLAIN Write a clear, detailed explanation of the selected code.",
                    description = "Explain how the code works",
                },
                Fix = {
                    prompt = "/COPILOT_FIX Identify and fix any bugs in the code.",
                    description = "Fix bugs in the code",
                },
                Optimize = {
                    prompt = "/COPILOT_OPTIMIZE Optimize performance and readability.",
                    description = "Optimize code",
                },
                Tests = {
                    prompt = "/COPILOT_TESTS Generate unit tests with edge cases.",
                    description = "Generate tests",
                },
                Docs = {
                    prompt = "/COPILOT_DOCS Write documentation comments.",
                    description = "Generate docs",
                },
                Review = {
                    prompt = "/COPILOT_REVIEW Perform a full code review.",
                    description = "Review code",
                },
                Commit = {
                    prompt = "Write a commit message using commitizen convention.",
                    description = "Commit message",
                    ---@diagnostic disable-next-line: deprecated
                    selection = select.gitdiff,
                },
                CommitStaged = {
                    prompt = "Write a commit message for staged changes.",
                    description = "Commit staged",
                    ---@diagnostic disable-next-line: deprecated
                    selection = function(source)
                        return select.gitdiff(source, true)
                    end,
                },
            },

            mappings = {
                complete = {
                    insert = "<Tab>",
                    callback = function() end,
                },
                close = {
                    normal = "q",
                    insert = "<C-c>",
                    callback = function() end,
                },
                reset = {
                    normal = "<C-r>",
                    insert = "<C-r>",
                    callback = function() end,
                },
                accept_diff = {
                    normal = "<C-y>",
                    insert = "<C-y>",
                    callback = function() end,
                },
                yank_diff = {
                    normal = "gy",
                    callback = function() end,
                },
                show_diff = {
                    normal = "gd",
                    callback = function() end,
                },
                show_system_prompt = {
                    normal = "gp",
                    callback = function() end,
                },
                show_user_selection = {
                    normal = "gs",
                    callback = function() end,
                },
            },
        })

        local ok, render_markdown = pcall(require, "render-markdown")
        if ok then
            render_markdown.setup({
                file_types = { "markdown", "copilot-chat" },
            })
        end
    end,
}
