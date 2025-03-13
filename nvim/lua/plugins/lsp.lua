-- Disable LSP inlay hints (virtual type annotations)
vim.lsp.handlers["textDocument/inlayHint"] = function(_, _, _)
  return nil
end

return {

  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "typescript-language-server",
        "vtsls",
        "css-lsp",
      })
    end,
  },
}
