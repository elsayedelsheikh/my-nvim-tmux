require("nvchad.options")

local options = {
	guicursor = "", -- disable cursor styling
	cursorline = false, -- disable cursor styling
	completeopt = { "menuone", "noselect" }, -- options for insert mode completion (for cmp plugin)
	conceallevel = 0, -- so that `` is visible in markdown files
	cmdheight = 2, -- number of of screen lines to use for the command line
	relativenumber = true, -- relative numbers from line cursor is on
	swapfile = false,
	hlsearch = true, -- highlight all matches of previous search pattern
	incsearch = true, -- highlight matches of current search pattern as it is typed
	scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor.
	-- smarttab = true,
	tabstop = 2, -- number of spaces to insert for a tab
	shiftwidth = 2, -- number of spaces inserted for each indentation
	undofile = true, -- keep undo history between sessions
	backup = false, -- Some servers have issues with backup files, see #649.
	writebackup = false,
	spell = true, -- enable spell checking
  -- treesitter folding,
  foldmethod = "expr",
  foldexpr = "v:lua.vim.treesitter.foldexpr()",
  foldlevel = 99,   -- Start with all folds open
  foldcolumn = "1", -- Shows fold indicators on the left
}

for key, value in pairs(options) do
	vim.opt[key] = value
end

-- Cleaner fold appearance (removes the dots/dashes)
-- vim.opt.fillchars = { fold = " ", foldopen = "", foldsep = " ", foldclose = "" }
vim.opt.shortmess:append("c") -- hide startup message
