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
	{
		"nvim-cmp",
		dependencies = { "hrsh7th/cmp-emoji" },
		opts = function(_, opts)
			table.insert(opts.sources, {
				name = "emoji",
			})
		end,
	},
	{ -- Wakatime
		"wakatime/vim-wakatime",
	},
	{
		-- Copilot
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		opts = {
			suggestion = {
				enabled = true,
			},
			panel = {
				enabled = true,
			},
			filetypes = {
				markdown = true,
				help = true,
				yaml = true,
			},
		},
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
}
