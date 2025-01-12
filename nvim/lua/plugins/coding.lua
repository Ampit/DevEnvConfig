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
		"echasnovski/mini.bracketed",
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
		-- optional: provides snippets for the snippet source
		dependencies = "rafamadriz/friendly-snippets",
		-- use a release tag to download pre-built binaries
		version = "*",
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = { preset = "default" },

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
				default = { "lsp", "path", "snippets", "buffer" },
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
}
