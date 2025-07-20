require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "ruff_format" },
        typescript = { "prettier" },
        markdown = { "vale_ls" }
    },
    formatters = {
        ruff_format = {
            append_args = {
                "--config",
                "line-length = 100",
                "max-nested-blocks = 5",
                "docstring-quotes = 'single'",
                "inline-quotes = 'double'"
            },
        },
    },
    format_on_save = {
        timeout_ms = 5000,
        async = false,
        quiet = false,
        lsp_format = "fallback"
    },
})
