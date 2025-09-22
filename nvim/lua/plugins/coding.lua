return {
  {
    -- Create annotations with one keybind, and jump your cursor in the inserted annotation
    "danymat/neogen",
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen Comment",
      },
    },
    opts = {
      snippet_engine = "luasnip",
    },
  },
  {
    -- Incremental rename
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },
  {
    -- Refactoring tool
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    opts = {},
  },
  {
    -- Go forward/backward with square brackets
    "nvim-mini/mini.bracketed",
    event = "BufReadPost",
    config = function()
      local bracketed = require("mini.bracketed")
      bracketed.setup({
        file = {
          suffix = "",
        },
        window = {
          suffix = "",
        },
        quickfix = {
          suffix = "",
        },
        yank = {
          suffix = "",
        },
        treesitter = {
          suffix = "n",
        },
      })
    end,
  },
  {
    -- Better increase/descrease
    "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {{
        "<C-a>",
        function()
            return require("dial.map").inc_normal()
        end,
        expr = true,
        desc = "Increment"
    }, {
        "<C-x>",
        function()
            return require("dial.map").dec_normal()
        end,
        expr = true,
        desc = "Decrement"
    }},
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({
            elements = { "let", "const" },
          }),
        },
      })
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    keys = { {
      "<leader>cs",
      "<cmd>SymbolsOutline<cr>",
      desc = "Symbols Outline",
    } },
    cmd = "SymbolsOutline",
    opts = {
      position = "right",
    },
  },
  { -- Wakatime
    "wakatime/vim-wakatime",
  },
  { -- Git Blame
    "f-person/git-blame.nvim",
  },
  { -- Diff View
    "sindrets/diffview.nvim",
  },
  { -- Smooth Scroll
    "karb94/neoscroll.nvim",
  },
  { -- Scrollbar
    "Xuyuanp/scrollbar.nvim",
  },
  {
    -- Undotree
    "mbbill/undotree",
    config = function() end,
  }, -- Peepsight
  { -- Highlight words
    "koenverburg/peepsight.nvim",
  },
  { -- Pretty Fold
    "Mr-LLLLL/interestingwords.nvim",
  },
  {
    -- Fold Preview
    "anuvyklack/fold-preview.nvim",
    dependencies = { "anuvyklack/keymap-amend.nvim" },
    opts = {},
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight", "TmuxNavigatePrevious" },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "giuxtaposition/blink-cmp-copilot",
      "Kaiser-Yang/blink-cmp-avante",
    },
    version = "*",
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = { preset = "enter" },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      signature = { enabled = true },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "copilot", "lsp", "path", "snippets", "buffer", "lazydev", "avante" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            kind = "Copilot",
            score_offset = 100,
            async = true,
          },
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {},
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = "*", -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = "openai",
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "4.1-mini", -- your desired model (or use gpt-4o, etc.)
          timeout = 30000, -- timeout in milliseconds
          extra_request_body = {
            temperature = 0.3, -- adjust if needed
          },
          max_tokens = 4096,
          -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-mini/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or nvim-mini/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
          render_modes = { "n", "c" },
          anti_conceal = {
            enabled = false,
          },
          latex = {
            enabled = false,
          },
          heading = {
            enabled = true,
            sign = false,
            position = "inline",
            icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
            signs = { "󰫎 " },
            width = "full",
            left_margin = 0,
            left_pad = 0,
            right_pad = 0,
            min_width = 0,
            border = false,
            border_prefix = false,
            above = "▄",
            below = "▀",
            backgrounds = {
              "RenderMarkdownH1Bg",
              "RenderMarkdownH2Bg",
              "RenderMarkdownH3Bg",
              "RenderMarkdownH4Bg",
              "RenderMarkdownH5Bg",
              "RenderMarkdownH6Bg",
            },
            foregrounds = {
              "RenderMarkdownH1",
              "RenderMarkdownH2",
              "RenderMarkdownH3",
              "RenderMarkdownH4",
              "RenderMarkdownH5",
              "RenderMarkdownH6",
            },
          },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
