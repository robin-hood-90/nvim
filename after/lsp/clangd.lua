return {
    cmd = {
        "clangd",
        "--compile-commands-dir=./",
        "--background-index",
        "--pch-storage=memory",
        "--all-scopes-completion",
        "--pretty",
        "--header-insertion=never",
        "-j=4",
        "--inlay-hints",
        "--header-insertion-decorators",
        "--function-arg-placeholders",
        "--completion-style=detailed",
    },
    filetypes = { "c", "cpp", "objc", "objcpp" },
}
