-- base
vim.opt.showcmd = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- tabs and sp	aces
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- keymap
vim.g.mapleader = " "


-- color
vim.pack.add({ "https://github.com/darkvoid-theme/darkvoid.nvim" })
function ColorVim(color)
    color = color or "darkvoid"
    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "none" })
end

ColorVim()

-- hide annoing shit
local isLspHintsEnable = true
vim.api.nvim_create_user_command("Hints", function()
    isLspHintsEnable = not isLspHintsEnable
    vim.diagnostic.config({
        virtual_text = isLspHintsEnable,
        underline = isLspHintsEnable
    })
end, {})
