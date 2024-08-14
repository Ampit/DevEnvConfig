return {
  "folke/tokyonight.nvim",
  lazy = false,
  opts = {
    on_highlights = function(hl, c)
      -- hl.Normal = { bg = "NONE" }
      -- hl.NormalNC = { bg = "NONE" } -- Non-current window
      hl.NvimTreeNormal = { bg = "NONE" } -- Neotree/NvimTree background
      hl.NvimTreeNormalNC = { bg = "NONE" } -- Neotree/NvimTree non-current window
      -- hl.FloatBorder = { bg = "NONE" } -- Floating window borders
      -- hl.NormalFloat = { bg = "NONE" } -- Floating windows background
      hl.IndentBlanklineContextChar = { fg = c.dark5 }
      hl.TSConstructor = { fg = c.blue1 }
      hl.TSTagDelimiter = { fg = c.dark5 }
    end,
    style = "night", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
    transparent = true,
    terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
    styles = {
      -- Style to be applied to different syntax groups
      -- Value is any valid attr-list value for `:help nvim_set_hl`
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = "transparent", -- style for sidebars, see below
      floats = "dark", -- style for floating windows
    },
    -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
    sidebars = {
      "qf",
      "vista_kind",
      "terminal",
      "packer",
      "spectre_panel",
      "NeogitStatus",
      "help",
      "NeoTree",
    },
    day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
    hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
    dim_inactive = false, -- dims inactive windows
    lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
    use_background = true, -- can be light/dark/auto. When auto, background will be set to vim.o.background
  },
}
