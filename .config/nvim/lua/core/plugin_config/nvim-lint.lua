require('lint').linters_by_ft = {
    python = { 'ruff', 'mypy' },
    typescript = { 'ts_ls', 'eslint' },
    go = {}
}



vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
