vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.shell = "zsh"

-- Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Lazy Plugins
require("lazy").setup({
	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },
			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
			"jose-elias-alvarez/typescript.nvim",
		},
	},
	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind.nvim",
			"hrsh7th/cmp-buffer",
			"quangnguyen30192/cmp-nvim-ultisnips",
		},
	},
	-- Useful plugin to show you pending keybinds.
	{ "folke/which-key.nvim", opts = {} },
	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
				change = {
					hl = "GitSignsChange",
					text = "▎",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn",
				},
				delete = {
					hl = "GitSignsDelete",
					text = "▎",
					numhl = "GitSignsDeleteNr",
					linehl = "GitSignsDeleteLn",
				},
				topdelete = {
					hl = "GitSignsDelete",
					text = "▎",
					numhl = "GitSignsDeleteNr",
					linehl = "GitSignsDeleteLn",
				},
				changedelete = {
					hl = "GitSignsChange",
					text = "▎",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn",
				},
			},
		},
	},
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("tokyonight")
			vim.cmd("autocmd ColorScheme * highlight Normal guibg=NONE")
			vim.cmd("autocmd ColorScheme * highlight NotifyBackground guibg=#282c34")
		end,
	},
	{
		-- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				theme = "onedark",
				component_separators = "|",
				section_separators = "",
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons", opts = {} },
	},
	{
		-- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		opts = {
			char = "┊",
			show_trailing_blankline_indent = false,
		},
	},
	-- "gc" to comment visual regions/lines
	{
		"numToStr/Comment.nvim",
		opts = {},
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},
	-- Fuzzy Finder (files, lsp, etc)
	{ "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },
	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	},
	-- Harpoon , switch between multiple files quickly
	"theprimeagen/harpoon",
	-- Undotree
	{ "mbbill/undotree", config = function() end },
	-- not sure what this does yet.
	"christoomey/vim-tmux-navigator",
	-- Maximize window/tab
	"szw/vim-maximizer",
	-- Surround text helper plugin
	"tpope/vim-surround",
	-- Replace and keep the copied text in the buffer
	{ "vim-scripts/ReplaceWithRegister" },
	-- File explorer, see below for setup
	{ "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons", opts = {} } },
	-- friendly snippets
	"rafamadriz/friendly-snippets",
	-- Wakatime
	"wakatime/vim-wakatime",
	-- formatting and linting
	"jose-elias-alvarez/null-ls.nvim",
	"jayp0521/mason-null-ls.nvim",
	-- auto closing
	"windwp/nvim-autopairs",
	"windwp/nvim-ts-autotag",
	-- Copilot
	"github/copilot.vim",
	-- Project Management
	"ahmedkhalf/project.nvim",
	-- Highlight colors
	"brenoprata10/nvim-highlight-colors",
	-- Transparent Bg
	"xiyaowong/transparent.nvim",
	-- Tabs
	"nanozuki/tabby.nvim",
	-- Dashboard
	{
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				-- config
				theme = "hyper",
				config = {
					week_header = {
						enable = true,
					},
					shortcut = {
						{ desc = " Update", group = "@property", action = "Lazy update", key = "u" },
						{
							icon = " ",
							icon_hl = "@variable",
							desc = "Files",
							group = "Label",
							action = "Telescope find_files",
							key = "f",
						},
						{
							desc = " Apps",
							group = "DiagnosticHint",
							action = "Telescope app",
							key = "a",
						},
						{
							desc = " dotfiles",
							group = "Number",
							action = "Telescope dotfiles",
							key = "d",
						},
					},
				},
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
	-- Git Blame
	"f-person/git-blame.nvim",
	-- Diff View
	"sindrets/diffview.nvim",
	-- Smooth Scroll
	"karb94/neoscroll.nvim",
	-- Scrollbar
	"Xuyuanp/scrollbar.nvim",
	-- Telescope file browser
	"nvim-telescope/telescope-file-browser.nvim",
	-- Zen mode
	{ "folke/zen-mode.nvim", opts = {} },
	-- Bufferline
	"akinsho/bufferline.nvim",
	-- Peepsight
	"koenverburg/peepsight.nvim",
	-- Highlight words
	"Mr-LLLLL/interestingwords.nvim",
	-- Trouble
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	},
	-- IndentScope
	{ "echasnovski/mini.indentscope" },
	-- Noice
	{
		"folke/noice.nvim",
		config = function()
			require("noice").setup({
				routes = {
					{
						view = "notify",
						filter = { event = "msg_showmode" },
					},
				},
			})
		end,
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},

	-- Debugging
	{ "mfussenegger/nvim-dap" },
	{ "rcarriga/nvim-dap-ui", opts = {} },
	{ "theHamsta/nvim-dap-virtual-text" },
	{ "Pocco81/DAPInstall.nvim" },
	{ "nvim-telescope/telescope-dap.nvim" },
	{ "mxsdev/nvim-dap-vscode-js" },
	{ "microsoft/vscode-js-debug" },

	-- Pretty Fold
	{ "anuvyklack/pretty-fold.nvim", opts = {} },
	-- Fold Preview
	{
		"anuvyklack/fold-preview.nvim",
		dependencies = { "anuvyklack/keymap-amend.nvim" },
		opts = {},
	},
	-- Snippets
	"SirVer/ultisnips",
	"mlaursen/vim-react-snippets",
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true
-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
vim.o.t_Co = "256"

-- Custom options
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 8
vim.opt.incsearch = true
vim.opt.title = true
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.cmd("set guifont=FiraCode\\ Nerd\\ Font:h12")
vim.o.showtabline = 2
vim.opt.formatoptions:append({ "r" })
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1 -- Height of the command bar
vim.opt.laststatus = 2 -- Always display the status line
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" } -- skip backup for tmp files
vim.opt.inccommand = "split" -- show preview of the substitution
vim.opt.smarttab = true -- Insert indents automatically
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99

-- Set GitSigns colors
vim.cmd([[
  highlight GitSignsAdd    guifg=#81A1C1 guibg=NONE gui=NONE
  highlight GitSignsChange guifg=#EBCB8B guibg=NONE gui=NONE
  highlight GitSignsDelete guifg=#BF616A guibg=NONE gui=NONE
]])

-- UltiSnips configuration
vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
-- vim-react-snippets configuration
vim.g.snippets_directory = "~/.config/nvim/snippets"

-- Trouble Keymaps
vim.keymap.set(
	"n",
	"<leader>tt",
	"<cmd>TroubleToggle<cr>",
	{ silent = true, noremap = true, desc = "Toggle Trouble overview" }
)
vim.keymap.set(
	"n",
	"<leader>twd",
	"<cmd>TroubleToggle workspace_diagnostics<cr>",
	{ silent = true, noremap = true, desc = "Toggle workspace diagnostics in Trouble" }
)
vim.keymap.set(
	"n",
	"<leader>tdd",
	"<cmd>TroubleToggle document_diagnostics<cr>",
	{ silent = true, noremap = true, desc = "Toggle document diagnostics in Trouble" }
)
vim.keymap.set(
	"n",
	"<leader>tl",
	"<cmd>TroubleToggle loclist<cr>",
	{ silent = true, noremap = true, desc = "Toggle loclist in Trouble" }
)
vim.keymap.set(
	"n",
	"<leader>tq",
	"<cmd>TroubleToggle quickfix<cr>",
	{ silent = true, noremap = true, desc = "Toggle quickfix in Trouble" }
)
vim.keymap.set(
	"n",
	"<leader>tr",
	"<cmd>TroubleToggle lsp_references<cr>",
	{ silent = true, noremap = true, desc = "Toggle lsp_references in Trouble" }
)
vim.g.copilot_assume_mapped = true

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Tabbing and indent
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

-- line wrapping
vim.opt.wrap = false

-- cursor line
vim.opt.cursorline = true

-- appearance
vim.opt.background = "dark"

--backspace
vim.opt.backspace = "indent,eol,start"

-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.iskeyword:append("-")

-- CUSTOM Keymaps
vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
-- Prevent yanking when using 'x'
vim.api.nvim_set_keymap("n", "x", '"_x', { noremap = true })
-- Prevent yanking when using 'x' with other motions (e.g., 'xiw')
vim.api.nvim_set_keymap("o", "x", '"_x', { noremap = true })
-- Prevent yanking when using 'c'
vim.api.nvim_set_keymap("n", "c", '"_c', { noremap = true })
-- Prevent yanking when using 'c' with other motions (e.g., 'ciw')
vim.api.nvim_set_keymap("o", "c", '"_c', {}) -- Do no yank with c
vim.keymap.set("n", "<leader>+", "<C-a>")
vim.keymap.set("n", "<leader>-", "<C-x>")
vim.keymap.set("n", "<leader>dvo", ":DiffviewOpen<CR>")
vim.keymap.set("n", "<leader>dash", ":Dashboard<CR>")

-- split screen kaymaps
vim.keymap.set("n", "<C-w>|", "<C-w>v") -- split window vertically
vim.keymap.set("n", "<C-w>-", "<C-w>s") -- split window horizontally
vim.keymap.set("n", "<C-w>x", ":close<CR>") -- close curr

-- tab keymaps
vim.keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tabent split window

-- vim-maximizer
vim.keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")

-- nvim-tree
vim.keymap.set("n", "<leader>fe", ":NvimTreeToggle<CR>")

-- Harpoon config
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>ha", mark.add_file)
vim.keymap.set("n", "<leader>hp", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>h1", function()
	ui.nav_file(1)
end)
vim.keymap.set("n", "<leader>h2", function()
	ui.nav_file(2)
end)
vim.keymap.set("n", "<leader>h3", function()
	ui.nav_file(3)
end)
vim.keymap.set("n", "<leader>h4", function()
	ui.nav_file(4)
end)
vim.keymap.set("n", "<leader>p", '"_dP')

vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { silent = true })
-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

local fb_actions = require("telescope").extensions.file_browser.actions
-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
	defaults = {
		file_sorter = require("telescope.sorters").get_fzy_sorter,
		prompt_prefix = "> ",
		color_devicons = true,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
			n = {
				["q"] = require("telescope.actions").close,
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		file_browser = {
			theme = "dropdown",
			-- disables netrw and use telescope-file-browser in its place
			hijack_netrw = true,
			mappings = {
				-- your custom insert mode mappings
				["i"] = {
					["<C-w>"] = function()
						vim.cmd("normal vbd")
					end,
				},
				["n"] = {
					-- your custom normal mode mappings
					["N"] = fb_actions.create,
					["h"] = fb_actions.goto_parent_dir,
					["/"] = function()
						vim.cmd("startinsert")
					end,
				},
			},
		},
	},
})

local function telescope_buffer_dir()
	return vim.fn.expand("%:p:h")
end
-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>saf", require("telescope.builtin").find_files, { desc = "[S]earch [A]ll [F]iles" })
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").git_files, { desc = "[S]earch Git [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>fb", function()
	require("telescope").extensions.file_browser.file_browser({
		path = "%:p:h",
		cwd = telescope_buffer_dir(),
		respect_gitignore = false,
		hidden = true,
		grouped = true,
		previewer = false,
		initial_mode = "normal",
		layout_config = { height = 40 },
	})
end, { desc = "[S]earch [F]ile Browser" })
-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = {
		"json",
		"javascript",
		"yaml",
		"lua",
		"python",
		"html",
		"css",
		"markdown",
		"svelte",
		"bash",
		"dockerfile",
		"gitignore",
		"rust",
		"tsx",
		"typescript",
		"vimdoc",
		"vim",
		"luadoc",
		"luap",
		"markdown_inline",
		"query",
		"regex",
		"vimdoc",
	},
	-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
	auto_install = true,
	highlight = { enable = true },
	indent = { enable = true, disable = { "python" } },
	autotag = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-space>",
			node_incremental = "<c-space>",
			scope_incremental = "<c-s>",
			node_decremental = "<M-space>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
	},
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	vim.api.nvim_set_keymap(
		"n",
		"gd",
		"<cmd>Telescope lsp_definitions<CR>",
		{ noremap = true, silent = true, desc = "[G]oto [D]efinition" }
	)
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format({ timeout_ms = 5000 })
	end, { desc = "Format current buffer with LSP" })
	-- Automatically format the buffer on save
	if _.supports_method("textDocument/formatting") then
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.cmd("Format")
			end,
		})
	end
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	rust_analyzer = {},
	tsserver = {},
	html = {},
	cssls = {},
	lua_ls = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		})
	end,
})

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

luasnip.config.setup({})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
			-- Expands UltiSnips snippets
			vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "ultisnips" }, -- Add UltiSnips as a source
		{ name = "buffer" },
		{ name = "path" },
	},
})

-- nvim-tree
local nvimtree = require("nvim-tree")

nvimtree.setup({
	-- change folder arrow icons
	renderer = {
		group_empty = true,
		icons = {
			glyphs = {
				folder = {
					arrow_closed = "➔", -- arrow when folder is closed
					arrow_open = "▼", -- arrow when folder is open
				},
			},
		},
	},
	-- disable window_picker for
	-- explorer to work well with
	-- window splits
	actions = {
		open_file = {
			window_picker = {
				enable = false,
			},
		},
	},
	-- 	git = {
	-- 		ignore = false,
	-- 	},
})

-- null ls config
local null_ls = require("null-ls")
local mason_null_ls = require("mason-null-ls")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	sources = {
		formatting.prettier,
		formatting.stylua,
		diagnostics.eslint_d.with({
			-- js/ts linter
			-- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
			condition = function(utils)
				return utils.root_has_file(".eslintrc.js") -- change file extension if you use something else
			end,
		}),
	},
	-- configure format on save
	on_attach = function(current_client, bufnr)
		-- semantic highlighting
		local caps = current_client.server_capabilities
		if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
			local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
			vim.api.nvim_create_autocmd("TextChanged", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.semantic_tokens_full()
				end,
			})
			-- fire it first time on load as well
			vim.lsp.buf.semantic_tokens_full()
		end
	end,
})

mason_null_ls.setup({
	ensure_installed = {
		"prettier",
		"stylua",
		"eslint_d",
	},
})

-- autopairs
local autopairs = require("nvim-autopairs")
-- import nvim-autopairs completion functionality safely
local cmp_autopairs_setup, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if not cmp_autopairs_setup then
	return
end

autopairs.setup({
	check_ts = true, -- enable treesitter
	ts_config = {
		lua = { "string" }, -- don't add pairs in lua string treesitter nodes
		javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
		java = false, -- don't check treesitter on java
	},
	disable_filetype = { "TelescopePrompt", "vim" }, -- don't check treesitter on these filetypes
})

-- make autopairs and completion work together
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

require("nvim-highlight-colors").turnOn()

-- Tabs Setup
local theme = {
	fill = "TabLineFill",
	-- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
	head = "TabLine",
	-- current_tab = 'TabLineSel',
	current_tab = { fg = "#F8FBF6", bg = "#5E81AC", style = "italic" },
	tab = "TabLine",
	win = "TabLine",
	tail = "TabLine",
}

require("tabby.tabline").set(function(line)
	return {
		{
			{ "  ", hl = theme.head },
			line.sep("", theme.head, theme.fill),
		},
		line.tabs().foreach(function(tab)
			local hl = tab.is_current() and theme.current_tab or theme.tab
			return {
				line.sep("", hl, theme.fill),
				tab.is_current() and "" or "",
				tab.number(),
				tab.name(),
				-- tab.close_btn(''), -- show a close button
				line.sep("", hl, theme.fill),
				hl = hl,
				margin = " ",
			}
		end),
		line.spacer(),
		-- shows list of windows in tab
		-- line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
		--   return {
		--     line.sep('', theme.win, theme.fill),
		--     win.is_current() and '' or '',
		--     win.buf_name(),
		--     line.sep('', theme.win, theme.fill),
		--     hl = theme.win,
		--     margin = ' ',
		--   }
		-- end),
		{
			line.sep("", theme.tail, theme.fill),
			{ "  ", hl = theme.tail },
		},
		hl = theme.fill,
	}
end)

-- Convert the Vimscript scrollbar autocmd block to Lua and execute it
vim.api.nvim_exec(
	[[
  augroup ScrollbarInit
    autocmd!
    autocmd WinScrolled,VimResized,QuitPre * silent! lua require('scrollbar').show()
    autocmd WinEnter,FocusGained           * silent! lua require('scrollbar').show()
    autocmd WinLeave,BufLeave,BufWinLeave,FocusLost            * silent! lua require('scrollbar').clear()
  augroup end
]],
	false
)

-- Transparent nvim config
require("transparent").setup({
	groups = {
		"Normal",
		"NormalNC",
		"Comment",
		"Constant",
		"Special",
		"Identifier",
		"Statement",
		"PreProc",
		"Type",
		"Underlined",
		"Todo",
		"String",
		"Function",
		"Conditional",
		"Repeat",
		"Operator",
		"Structure",
		"LineNr",
		"NonText",
		"SignColumn",
		"CursorLineNr",
		"EndOfBuffer",
		"NvimTreeNormal",
		"ExtraGroup",
	},
	extra_groups = {}, -- additional groups that should be cleared
	exclude_groups = {}, -- groups you don't want to clear
})

-- BufferLine
local bufferline = require("bufferline")

bufferline.setup({
	options = {
		mode = "tabs",
		separator_style = "slant",
		always_show_bufferline = false,
		show_buffer_close_icons = false,
		show_close_icon = false,
		color_icons = true,
	},
	highlights = {
		separator = {
			fg = "#073642",
			bg = "#002b36",
		},
		separator_selected = {
			fg = "#073642",
		},
		background = {
			fg = "#657b83",
			bg = "#002b36",
		},
		buffer_selected = {
			fg = "#fdf6e3",
			bold = true,
		},
		fill = {
			bg = "#073642",
		},
	},
})

vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {})
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {})

-- Peepsight Setup
require("peepsight").setup({
	-- typescript
	"class_declaration",
	"method_definition",
	"arrow_function",
	"function_declaration",
	"generator_function_declaration",
})

-- Automatically enable peepsight on load
vim.cmd("PeepsightEnable")

-- Interesting words setup
require("interestingwords").setup({
	colors = { "#aeee00", "#ff0000", "#0000ff", "#b88823", "#ffa724", "#ff2c4b" },
	search_count = true,
	navigation = true,
	search_key = "<leader>m",
	cancel_search_key = "<leader>M",
	color_key = "<leader>k",
	cancel_color_key = "<leader>K",
})

-- IndentScope
local indentScope = require("mini.indentscope")
indentScope.setup()

-- Debugging Config
vim.keymap.set("n", "<leader>dc", "<Cmd>lua require('dap').continue()<CR>", {})
vim.keymap.set("n", "<leader>db", "<Cmd>lua require('dap').toggle_breakpoint()<CR>", {})
vim.keymap.set(
	"n",
	"<leader>dB",
	"<Cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{}
)
vim.keymap.set(
	"n",
	"<leader>dl",
	"<Cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
	{}
)
vim.keymap.set("n", "<leader>dr", "<Cmd>lua require('dap').repl.open()<CR>", {})
vim.keymap.set("n", "<leader>dn", "<Cmd>lua require('dap').step_over()<CR>", {})
vim.keymap.set("n", "<leader>di", "<Cmd>lua require('dap').step_into()<CR>", {})
vim.keymap.set("n", "<leader>do", "<Cmd>lua require('dap').step_out()<CR>", {})
vim.keymap.set("n", "<leader>dp", "<Cmd>lua require('dap').pause.toggle()<CR>", {})
vim.keymap.set("n", "<leader>du", "<Cmd>lua require('dap').up()<CR>", {})
vim.keymap.set("n", "<leader>dU", "<Cmd>lua require('dap').down()<CR>", {})
vim.keymap.set("n", "<leader>de", "<Cmd>lua require('dap').set_exception_breakpoints({'all'})<CR>", {})
vim.keymap.set("n", "<leader>dE", "<Cmd>lua require('dap').set_exception_breakpoints({})<CR>", {})
vim.keymap.set("n", "<leader>dx", "<Cmd>lua require('dap').disconnect()<CR>", {})

-- Dap UI keymaps
vim.keymap.set("n", "<leader>dt", "<Cmd>lua require('dapui').toggle()<CR>", {})

-- AutoOpen Dap UI
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

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

vim.cmd("au BufLeave,FocusLost * lua format_save_current_buffer()")

-- AutoCommands
-- local api = vim.api
-- local M = {}
--
-- function M.nvim_create_augroups(definitions)
-- 	for group_name, definition in pairs(definitions) do
-- 		api.nvim_command("augroup " .. group_name)
-- 		api.nvim_command("autocmd!")
-- 		for _, def in ipairs(definition) do
-- 			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
-- 			api.nvim_command(command)
-- 		end
-- 		api.nvim_command("augroup END")
-- 	end
-- end
--
-- local autoCommands = {
-- other autocommands
-- }

-- M.nvim_create_augroups(autoCommands)
