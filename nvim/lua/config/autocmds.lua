-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

-- Auto save
function _G.format_save_current_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.buf_get_clients(bufnr)

  for _, client in ipairs(clients) do
    if client ~= nil and client.resolved_capabilities and client.resolved_capabilities.document_formatting then
      vim.cmd("silent! Format")
      break
    end
  end

  -- Check if the buffer is modifiable before saving
  if vim.api.nvim_buf_get_option(bufnr, "modifiable") then
    vim.cmd("silent! wa")
  end
end

-- vim.cmd("au BufLeave,FocusLost * lua format_save_current_buffer()")
