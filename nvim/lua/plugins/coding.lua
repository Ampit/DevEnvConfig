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
		"hrsh7th/nvim-cmp",
		enabled = true,
		version = false, -- last release is way too old
		event = "InsertEnter", -- Load during insert mode
		priority = 1000, -- Make sure it loads early
		dependencies = {
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				sources = {
					{ name = "emoji" },
					-- other sources...
				},
			})

			-- Emit CmpReady event
			vim.schedule(function()
				vim.api.nvim_exec_autocmds("User", { pattern = "CmpReady" })
			end)
		end,
	},
	{
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		event = "InsertEnter",
		config = false,
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "CmpReady",
				callback = function()
					require("codeium").setup({})

					local cmp = require("cmp")
					local config = cmp.get_config()
					table.insert(config.sources, 1, { name = "codeium", priority = 1000 })
					cmp.setup(config)
				end,
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
		},
	},
}
