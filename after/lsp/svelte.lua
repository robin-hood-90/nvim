return {
    on_attach = function(client, bufnr)
        local group = vim.api.nvim_create_augroup("rishav_svelte_js_ts_changes_" .. bufnr, { clear = true })

        vim.api.nvim_create_autocmd("BufWritePost", {
            group = group,
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
                client.notify("$/onDidChangeTsOrJsFile", { uri = vim.uri_from_fname(ctx.match) })
            end,
        })
    end,
}
