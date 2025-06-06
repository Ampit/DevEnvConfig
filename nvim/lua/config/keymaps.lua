-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- local discipline = require("config.discipline")
--
-- discipline.cowboy()
local keymap = vim.keymap
local opts = {
  noremap = true,
  silent = true,
}

keymap.set("n", "x", '"_x')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
-- vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- New tab
keymap.set("n", "te", ":tabedit<Return>")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
keymap.set("n", "tx", ":tabclose<Return>")

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Diagnostic keymaps
keymap.set("n", "[d", vim.diagnostic.goto_prev, {
  desc = "Go to previous diagnostic message",
})
keymap.set("n", "]d", vim.diagnostic.goto_next, {
  desc = "Go to next diagnostic message",
})
keymap.set("n", "<leader>fd", vim.diagnostic.open_float, {
  desc = "Open floating diagnostic message",
})
keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, {
  desc = "Open diagnostics list",
})

-- DiffviewOpen
keymap.set("n", "<leader>dvo", ":DiffviewOpen<CR>", {
  desc = "Open Diffview",
})
keymap.set("n", "<leader>dvc", ":DiffviewClose<CR>", {
  desc = "Close Diffview",
})
-- Undo Tree
keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, {
  desc = "Undo Tree",
})

-- Additional key mappings for multiple terminals
keymap.set("n", "<leader>2", "<cmd>2ToggleTerm<CR>", {
  noremap = true,
  silent = true,
})
keymap.set("n", "<leader>3", "<cmd>3ToggleTerm<CR>", {
  noremap = true,
  silent = true,
})
keymap.set("n", "<leader>ts", "<cmd>TermSelect<CR>", {
  noremap = true,
  silent = true,
})
keymap.set("n", "<leader>ta", "<cmd>ToggleTermToggleAll<CR>", {
  noremap = true,
  silent = true,
})

-- Swift-specific keymaps
keymap.set("n", "<leader>sr", ":!swift run<CR>", {
  buffer = true,
  desc = "Swift Run",
})
keymap.set("n", "<leader>sb", ":!swift build<CR>", {
  buffer = true,
  desc = "Swift Build",
})

-- Set Ctrl n to forward jump list
keymap.set("n", "<C-n>", "<C-i>", {
  noremap = true,
  silent = true,
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
