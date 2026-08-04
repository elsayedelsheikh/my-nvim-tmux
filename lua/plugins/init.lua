local overrides = require("configs.overrides")

return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lsp")
		end,
	},

	-- override existing NvChad's plugins
	-- mason.nvim v2 has no `ensure_installed`, so the tool list is driven by
	-- mason-tool-installer instead (see overrides.mason_tools).
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		lazy = false,
		opts = {
			ensure_installed = overrides.mason_tools,
			run_on_start = true,
			start_delay = 2000,
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
			-- Must run after nvim-treesitter registers its own directives.
			require("configs.treesitter-compat")
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	{
		"nvim-telescope/telescope.nvim",
		opts = overrides.telescope,
	},

	-- add telescope-fzf-native
	{
		"telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			lazy = false,
			config = function()
				require("telescope").load_extension("fzf")
			end,
		},
	},

	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			opts = vim.tbl_deep_extend("force", opts, overrides.cmp)
			opts.sorting = opts.sorting or {}
			opts.sorting.comparators = opts.sorting.comparators or {}
			table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
			return opts
		end,
	},

	-- {
	-- 	"stevearc/conform.nvim",
	-- 	event = "BufWritePre", -- required for format on save
	-- 	opts = overrides.conform,
	-- },

	-- Additional plugins

	-- escape using key combo (currently set to jk)
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup()
		end,
		lazy = false,
	},

	{
		"mfussenegger/nvim-dap",
		config = function()
			require("configs.dap")
		end,
		lazy = false,
	},

	{
		"rcarriga/nvim-dap-ui",
		config = function()
			require("dapui").setup()
		end,
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	},

	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
		dependencies = { "mfussenegger/nvim-dap", "nvim-dap-ui" },
	},

	-- better bdelete, close buffers without closing windows
	{
		"ojroques/nvim-bufdel",
		lazy = false,
	},

	{
		"leoluz/nvim-dap-go",
		ft = "go",
		dependencies = "mfussenegger/nvim-dap",
		config = function(_, opts)
			require("dap-go").setup(opts)
		end,
	},

	{
		-- Setup happens in configs/server-settings/clangd.lua
		"p00f/clangd_extensions.nvim",
		lazy = true,
	},


  {
    "jghauser/fold-cycle.nvim",
		lazy = false,
    keys = {
      { "<Tab>", function() return require('fold-cycle').open() end, expr = true, desc = "Fold: open" },
      { "<S-Tab>", function() return require('fold-cycle').close() end, expr = true, desc = "Fold: close" },
    },
    opts = {},
  },

	-- Git diff viewer 
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		dependencies = { "nvim-lua/plenary.nvim" },
	},

  {
    "cdelledonne/vim-cmake",
    ft = {"c","cpp","cmake"},
    init = function()
      vim.g.cmake_build_dir_location = "build"
      vim.g.cmake_generate_options = {
        '-DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG=' .. vim.fn.getcwd() .. '/Debug',
        '-DCMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE=' .. vim.fn.getcwd() .. '/Release',
      }
    end,

  },

	{
		"ErickKramer/nvim-ros2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			-- Add any custom options here
			autocmds = true,
			telescope = true,
			treesitter = true,
		},
	},

	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},

	-- Directional split resizing across nvim splits and tmux panes
	-- (keymaps live in mappings.lua so they win over nvchad.mappings;
	-- submode.nvim provides the persistent resize mode on <Leader>r)
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		dependencies = { "pogyomo/submode.nvim" },
		opts = {
			default_amount = 3,
		},
	},

  {
    "rhysd/clever-f.vim",
    lazy = false,
  },

	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("configs.lint")
		end,
	},

  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascriptreact", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
}
