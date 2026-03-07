-- Disable LSP inlay hints (virtual type annotations)
vim.lsp.handlers["textDocument/inlayHint"] = function(_, _, _)
  return nil
end

return {

  -- tools
  {
    "mason-org/mason.nvim",
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

  -- Override markdownlint-cli2 to use a global config from nvim config dir
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local config_path = vim.fn.stdpath("config") .. "/.markdownlint.jsonc"
      local lint = require("lint")
      lint.linters["markdownlint-cli2"] = lint.linters["markdownlint-cli2"] or {}
      lint.linters["markdownlint-cli2"].args = {
        "--config",
        config_path,
      }
    end,
  },
}
