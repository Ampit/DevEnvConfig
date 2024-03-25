-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- local discipline = require("config.discipline")

-- discipline.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-n>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit<Return>")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
keymap.set("n", "tx", ":tabclose<Return>")

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Diagnostic keymaps
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
keymap.set("n", "<leader>fd", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- DiffviewOpen
keymap.set("n", "dv", ":DiffviewOpen<CR>", { desc = "Open Diffview" })

-- Undo Tree
keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo Tree" })

-- VISUAL mode mappings
-- s, x, v modes are handled the same way by which_key
require("which-key").register({
  -- ...
  ["<C-g>"] = {
    c = { ":<C-u>'<,'>GpChatNew<cr>", "Visual Chat New" },
    p = { ":<C-u>'<,'>GpChatPaste<cr>", "Visual Chat Paste" },
    t = { ":<C-u>'<,'>GpChatToggle<cr>", "Visual Toggle Chat" },

    ["<C-x>"] = { ":<C-u>'<,'>GpChatNew split<cr>", "Visual Chat New split" },
    ["<C-v>"] = { ":<C-u>'<,'>GpChatNew vsplit<cr>", "Visual Chat New vsplit" },
    ["<C-t>"] = { ":<C-u>'<,'>GpChatNew tabnew<cr>", "Visual Chat New tabnew" },

    r = { ":<C-u>'<,'>GpRewrite<cr>", "Visual Rewrite" },
    a = { ":<C-u>'<,'>GpAppend<cr>", "Visual Append (after)" },
    b = { ":<C-u>'<,'>GpPrepend<cr>", "Visual Prepend (before)" },
    i = { ":<C-u>'<,'>GpImplement<cr>", "Implement selection" },

    g = {
      name = "generate into new ..",
      p = { ":<C-u>'<,'>GpPopup<cr>", "Visual Popup" },
      e = { ":<C-u>'<,'>GpEnew<cr>", "Visual GpEnew" },
      n = { ":<C-u>'<,'>GpNew<cr>", "Visual GpNew" },
      v = { ":<C-u>'<,'>GpVnew<cr>", "Visual GpVnew" },
      t = { ":<C-u>'<,'>GpTabnew<cr>", "Visual GpTabnew" },
    },

    n = { "<cmd>GpNextAgent<cr>", "Next Agent" },
    s = { "<cmd>GpStop<cr>", "GpStop" },
    x = { ":<C-u>'<,'>GpContext<cr>", "Visual GpContext" },

    w = {
      name = "Whisper",
      w = { ":<C-u>'<,'>GpWhisper<cr>", "Whisper" },
      r = { ":<C-u>'<,'>GpWhisperRewrite<cr>", "Whisper Rewrite" },
      a = { ":<C-u>'<,'>GpWhisperAppend<cr>", "Whisper Append (after)" },
      b = { ":<C-u>'<,'>GpWhisperPrepend<cr>", "Whisper Prepend (before)" },
      p = { ":<C-u>'<,'>GpWhisperPopup<cr>", "Whisper Popup" },
      e = { ":<C-u>'<,'>GpWhisperEnew<cr>", "Whisper Enew" },
      n = { ":<C-u>'<,'>GpWhisperNew<cr>", "Whisper New" },
      v = { ":<C-u>'<,'>GpWhisperVnew<cr>", "Whisper Vnew" },
      t = { ":<C-u>'<,'>GpWhisperTabnew<cr>", "Whisper Tabnew" },
    },
  },
  -- ...
}, {
  mode = "v", -- VISUAL mode
  prefix = "",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
})

-- NORMAL mode mappings
require("which-key").register({
  -- ...
  ["<C-g>"] = {
    c = { "<cmd>GpChatNew<cr>", "New Chat" },
    t = { "<cmd>GpChatToggle<cr>", "Toggle Chat" },
    f = { "<cmd>GpChatFinder<cr>", "Chat Finder" },

    ["<C-x>"] = { "<cmd>GpChatNew split<cr>", "New Chat split" },
    ["<C-v>"] = { "<cmd>GpChatNew vsplit<cr>", "New Chat vsplit" },
    ["<C-t>"] = { "<cmd>GpChatNew tabnew<cr>", "New Chat tabnew" },

    r = { "<cmd>GpRewrite<cr>", "Inline Rewrite" },
    a = { "<cmd>GpAppend<cr>", "Append (after)" },
    b = { "<cmd>GpPrepend<cr>", "Prepend (before)" },

    g = {
      name = "generate into new ..",
      p = { "<cmd>GpPopup<cr>", "Popup" },
      e = { "<cmd>GpEnew<cr>", "GpEnew" },
      n = { "<cmd>GpNew<cr>", "GpNew" },
      v = { "<cmd>GpVnew<cr>", "GpVnew" },
      t = { "<cmd>GpTabnew<cr>", "GpTabnew" },
    },

    n = { "<cmd>GpNextAgent<cr>", "Next Agent" },
    s = { "<cmd>GpStop<cr>", "GpStop" },
    x = { "<cmd>GpContext<cr>", "Toggle GpContext" },

    w = {
      name = "Whisper",
      w = { "<cmd>GpWhisper<cr>", "Whisper" },
      r = { "<cmd>GpWhisperRewrite<cr>", "Whisper Inline Rewrite" },
      a = { "<cmd>GpWhisperAppend<cr>", "Whisper Append (after)" },
      b = { "<cmd>GpWhisperPrepend<cr>", "Whisper Prepend (before)" },
      p = { "<cmd>GpWhisperPopup<cr>", "Whisper Popup" },
      e = { "<cmd>GpWhisperEnew<cr>", "Whisper Enew" },
      n = { "<cmd>GpWhisperNew<cr>", "Whisper New" },
      v = { "<cmd>GpWhisperVnew<cr>", "Whisper Vnew" },
      t = { "<cmd>GpWhisperTabnew<cr>", "Whisper Tabnew" },
    },
  },
  -- ...
}, {
  mode = "n", -- NORMAL mode
  prefix = "",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
})

-- INSERT mode mappings
require("which-key").register({
  -- ...
  ["<C-g>"] = {
    c = { "<cmd>GpChatNew<cr>", "New Chat" },
    t = { "<cmd>GpChatToggle<cr>", "Toggle Chat" },
    f = { "<cmd>GpChatFinder<cr>", "Chat Finder" },

    ["<C-x>"] = { "<cmd>GpChatNew split<cr>", "New Chat split" },
    ["<C-v>"] = { "<cmd>GpChatNew vsplit<cr>", "New Chat vsplit" },
    ["<C-t>"] = { "<cmd>GpChatNew tabnew<cr>", "New Chat tabnew" },

    r = { "<cmd>GpRewrite<cr>", "Inline Rewrite" },
    a = { "<cmd>GpAppend<cr>", "Append (after)" },
    b = { "<cmd>GpPrepend<cr>", "Prepend (before)" },

    g = {
      name = "generate into new ..",
      p = { "<cmd>GpPopup<cr>", "Popup" },
      e = { "<cmd>GpEnew<cr>", "GpEnew" },
      n = { "<cmd>GpNew<cr>", "GpNew" },
      v = { "<cmd>GpVnew<cr>", "GpVnew" },
      t = { "<cmd>GpTabnew<cr>", "GpTabnew" },
    },

    x = { "<cmd>GpContext<cr>", "Toggle GpContext" },
    s = { "<cmd>GpStop<cr>", "GpStop" },
    n = { "<cmd>GpNextAgent<cr>", "Next Agent" },

    w = {
      name = "Whisper",
      w = { "<cmd>GpWhisper<cr>", "Whisper" },
      r = { "<cmd>GpWhisperRewrite<cr>", "Whisper Inline Rewrite" },
      a = { "<cmd>GpWhisperAppend<cr>", "Whisper Append (after)" },
      b = { "<cmd>GpWhisperPrepend<cr>", "Whisper Prepend (before)" },
      p = { "<cmd>GpWhisperPopup<cr>", "Whisper Popup" },
      e = { "<cmd>GpWhisperEnew<cr>", "Whisper Enew" },
      n = { "<cmd>GpWhisperNew<cr>", "Whisper New" },
      v = { "<cmd>GpWhisperVnew<cr>", "Whisper Vnew" },
      t = { "<cmd>GpWhisperTabnew<cr>", "Whisper Tabnew" },
    },
  },
  -- ...
}, {
  mode = "i", -- INSERT mode
  prefix = "",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
})
