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
        "MeanderingProgrammer/render-markdown.nvim", -- For markdown rendering
    },
    keys = {
        -- Toggle chat window
        { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat Toggle" },
        { "<leader>co", "<cmd>CopilotChatOpen<cr>", desc = "Copilot Chat Open" },

        -- Quick actions
        { "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Copilot Explain" },
        { "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Copilot Fix" },
        { "<leader>cp", "<cmd>CopilotChatOptimize<cr>", mode = { "n", "v" }, desc = "Copilot Optimize" },
        { "<leader>ct", "<cmd>CopilotChatTests<cr>", mode = { "n", "v" }, desc = "Copilot Tests" },
        { "<leader>cd", "<cmd>CopilotChatDocs<cr>", mode = { "n", "v" }, desc = "Copilot Docs" },
        { "<leader>cr", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "Copilot Review" },

        -- Custom prompt
        {
            "<leader>cq",
            function()
                local input = vim.fn.input("Ask Copilot: ")
                if input ~= "" then
                    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
                end
            end,
            desc = "Copilot Quick Chat",
        },

        -- Model selection
        { "<leader>cm", "<cmd>CopilotChatModels<cr>", desc = "Copilot Select Model" },

        -- View current model
        { "<leader>cv", "<cmd>CopilotChatModel<cr>", desc = "Copilot View Model" },

        -- Reset chat
        { "<leader>cx", "<cmd>CopilotChatReset<cr>", desc = "Copilot Reset Chat" },
    },
    config = function()
        local chat = require("CopilotChat")
        local select = require("CopilotChat.select")

        chat.setup({
            debug = false,
            temperature = 0.1,

            -- Window configuration
            window = {
                layout = "vertical",
                width = 0.3,
                height = 0.6,
                border = "rounded",
                title = "Copilot Chat",
            },

            -- Show help actions with mappings
            show_help = true,

            -- Automatically show user messages in chat
            auto_follow_cursor = true,
            auto_insert_mode = true,
            clear_chat_on_new_prompt = false,

            -- Context configuration
            context = nil,

            -- Highlighting - disabled for markdown rendering
            highlight_selection = true,
            highlight_headers = false, -- Disable for better markdown rendering

            -- Custom prompts
            prompts = {
                Explain = {
                    prompt = "/COPILOT_EXPLAIN Write a clear, detailed explanation of the selected code.",
                    description = "Explain how the code works",
                },
                Fix = {
                    prompt = "/COPILOT_FIX Identify and fix any bugs in the code. Explain what was wrong and how you fixed it.",
                    description = "Fix bugs in the code",
                },
                Optimize = {
                    prompt = "/COPILOT_OPTIMIZE Analyze and optimize the code for better performance and readability without changing its behavior.",
                    description = "Optimize code performance",
                },
                Tests = {
                    prompt = "/COPILOT_TESTS Generate comprehensive unit tests with edge cases and proper assertions.",
                    description = "Generate unit tests",
                },
                Docs = {
                    prompt = "/COPILOT_DOCS Write clear, professional documentation comments following best practices for this language.",
                    description = "Write documentation",
                },
                Review = {
                    prompt = "/COPILOT_REVIEW Perform a thorough code review checking for bugs, security issues, performance problems, and best practices.",
                    description = "Review code quality",
                },
                Commit = {
                    prompt = "Write a commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
                    description = "Generate commit message",
                    selection = select.gitdiff,
                },
                CommitStaged = {
                    prompt = "Write a commit message for the staged changes with commitizen convention.",
                    description = "Generate commit message for staged changes",
                    selection = function(source)
                        return select.gitdiff(source, true)
                    end,
                },
            },

            -- Mappings within the chat window
            mappings = {
                complete = {
                    detail = "Use @<Tab> or /<Tab> for options.",
                    insert = "<Tab>",
                },
                close = {
                    normal = "q",
                    insert = "<C-c>",
                },
                reset = {
                    normal = "<C-r>",
                    insert = "<C-r>",
                },
                submit_prompt = {
                    normal = "<CR>",
                    insert = "<C-s>",
                },
                accept_diff = {
                    normal = "<C-y>",
                    insert = "<C-y>",
                },
                yank_diff = {
                    normal = "gy",
                },
                show_diff = {
                    normal = "gd",
                },
                show_system_prompt = {
                    normal = "gp",
                },
                show_user_selection = {
                    normal = "gs",
                },
            },
        })

        -- Setup markdown rendering for copilot-chat buffers
        local ok, render_markdown = pcall(require, "render-markdown")
        if ok then
            render_markdown.setup({
                file_types = { "markdown", "copilot-chat" },
            })
        end

        -- Set window options for copilot-chat buffers
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "copilot-chat",
            callback = function()
                -- Get the window containing this buffer
                local win = vim.api.nvim_get_current_win()
                vim.wo[win].conceallevel = 2
                vim.wo[win].concealcursor = "nc"

                -- Add resize keymaps for this buffer
                local opts = { buffer = true, noremap = true, silent = true }

                -- Ctrl+Left: decrease width
                vim.keymap.set("n", "<C-Left>", function()
                    vim.cmd("vertical resize -5")
                end, opts)

                -- Ctrl+Right: increase width
                vim.keymap.set("n", "<C-Right>", function()
                    vim.cmd("vertical resize +5")
                end, opts)
            end,
        })

        -- Check Copilot status on startup
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                vim.defer_fn(function()
                    local copilot_status = vim.fn.exists(":Copilot") == 2
                    if copilot_status then
                        vim.cmd("Copilot status")
                    end
                end, 1000)
            end,
        })

        -- Create command to check Copilot account
        vim.api.nvim_create_user_command("CopilotAccount", function()
            vim.cmd("Copilot status")
        end, {})

        -- Show current model on command
        vim.api.nvim_create_user_command("CopilotChatCurrentModel", function()
            vim.cmd("CopilotChatModel")
        end, {})
    end,
}
