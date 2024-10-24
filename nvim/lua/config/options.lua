-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
vim.opt.wrap = true
vim.opt.linebreak = true

-- Swift-specific settings
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

-- Show whitespace for fillchars
vim.opt.fillchars:append("diff: ")

