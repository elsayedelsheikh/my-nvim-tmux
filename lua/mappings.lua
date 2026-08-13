require("nvchad.mappings")

local map = vim.keymap.set

-- General
map("n", ";", ":", { nowait = true, desc = "Command mode" })
map("x", "<Leader>p", [["_dP]], { desc = "Paste without replacing clipboard" })
map("n", "C-f", ":Format<CR>", { desc = "Format file" })
-- :ClangdSwitchSourceHeader comes from clangd_extensions.nvim, which is loaded
-- lazily from clangd's on_attach (configs/lsp/server-settings/clangd.lua), so
-- the command only exists once clangd has attached to the buffer.
map("n", "<Leader>s", ":ClangdSwitchSourceHeader<CR>", { desc = "Switch between header and source file" })

-- Telescope
map("n", "<C-p>", "<cmd>Telescope git_files<CR>", { desc = "Find files in version control" })
map("n", "<Leader>pf", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map(
	"n",
	"<Leader>pfa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "Find all files" }
)
map("n", "<Leader>pg", "<cmd>Telescope live_grep<CR>", { desc = "Grep files" })
map("n", "<Leader>fs", "<cmd>Telescope grep_string<CR>", { desc = "Grep word under cursor" })
map("n", "<Leader>pb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<Leader>ph", "<cmd>Telescope help_tags<CR>", { desc = "Help page" })
map("n", "<Leader>po", "<cmd>Telescope oldfiles<CR>", { desc = "Find oldfiles" })
map("n", "<Leader>pk", "<cmd>Telescope keymaps<CR>", { desc = "Show keymaps" })

-- Nvim DAP
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>d<space>", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
	"n",
	"<Leader>dd",
	"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- Terminal
map({ "n", "t" }, "<C-\\>", function()
	require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
end, { desc = "Terminal Toggle Floating term" })

-- File tree
map("n", "<C-a>", "<cmd>NvimTreeToggle<Cr>", { desc = "Toggle file tree" })

-- LSP config
map(
	"n",
	"gl",
	"<cmd>lua vim.diagnostic.open_float(0, { scope = 'line', border = 'single' })<CR>",
	{ desc = "Lsp show diagnostic" }
)
map("n", "<Leader>dF", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Go to previous diagnostic" })
map("n", "<Leader>df", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Go to next diagnostic" })
map("n", "<Leader>dt", "<cmd>Telescope diagnostics<CR>", { desc = "Telescope diagnostics" })
map("n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Lsp code action" })
map("n", "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Search Document Symbols" })

-- Conform
map("n", "<C-f>", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format current file [Conform]" })

-- Buffer delete
map("n", "<Leader>q", "<cmd>BufDel<CR>", { desc = "Close buffer" })
map("n", "<Leader>Q", "<cmd>BufDel!<CR>", { desc = "Close buffer ignore changes" })

-- Buffer line
-- map("n", "<TAB>", "<C-i>") -- Keep <C-i> for jump forward
map("n", "L", function()
	require("nvchad.tabufline").next()
end, { desc = "Go to next buffer" })
map("n", "H", function()
	require("nvchad.tabufline").prev()
end, { desc = "Go to previous buffer" })

-- Plenary
map("n", "<Leader>t", "<Plug>PlenaryTestFile", { desc = "Run plenary test on file" })

-- vim-tmux-navigator (override NvChad defaults)
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Navigate left (tmux/nvim)" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Navigate down (tmux/nvim)" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Navigate up (tmux/nvim)" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Navigate right (tmux/nvim)" })

-- smart-splits: hold Alt+hjkl to resize, or <Leader>r for resize mode (hjkl, Esc exits)
-- <A-h> shadows NvChad's horizontal-term toggle (still available on <leader>h)
map("n", "<A-h>", function()
	require("smart-splits").resize_left()
end, { desc = "Resize split left (tmux/nvim)" })
map("n", "<A-j>", function()
	require("smart-splits").resize_down()
end, { desc = "Resize split down (tmux/nvim)" })
map("n", "<A-k>", function()
	require("smart-splits").resize_up()
end, { desc = "Resize split up (tmux/nvim)" })
map("n", "<A-l>", function()
	require("smart-splits").resize_right()
end, { desc = "Resize split right (tmux/nvim)" })
-- Persistent resize mode: <Leader>r enters, then bare hjkl/arrows resize until Esc/q
require("submode").create("WinResize", {
	mode = "n",
	enter = "<Leader>r",
	leave = { "<Esc>", "q", "<C-c>" },
	hook = {
		on_enter = function()
			vim.notify("Resize mode: h/j/k/l or arrows to resize, Esc/q to exit")
		end,
		on_leave = function()
			vim.notify("")
		end,
	},
	default = function(register)
		register("h", require("smart-splits").resize_left, { desc = "Resize left" })
		register("j", require("smart-splits").resize_down, { desc = "Resize down" })
		register("k", require("smart-splits").resize_up, { desc = "Resize up" })
		register("l", require("smart-splits").resize_right, { desc = "Resize right" })
		register("<Left>", require("smart-splits").resize_left, { desc = "Resize left" })
		register("<Down>", require("smart-splits").resize_down, { desc = "Resize down" })
		register("<Up>", require("smart-splits").resize_up, { desc = "Resize up" })
		register("<Right>", require("smart-splits").resize_right, { desc = "Resize right" })
	end,
})

-- Diffview (git diff / Claude Code live review)
map("n", "<Leader>gd", function()
	local ok, lib = pcall(require, "diffview.lib")
	if ok and lib.get_current_view() then
		vim.cmd("DiffviewClose")
	else
		vim.cmd("DiffviewOpen")
	end
end, { desc = "Toggle Diffview" })
map("n", "<Leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "Diffview file history" })

-- Review this branch's own changes against the trunk (merge-base diff, so
-- commits the branch is merely behind by don't show up). Mirrors what a GitLab
-- MR shows. Trunk is origin/main.
map("n", "<Leader>gr", function()
	vim.cmd("DiffviewOpen origin/main...HEAD")
end, { desc = "Diffview: review branch vs trunk" })
-- Same merge-base review, but --imply-local puts the working-tree file on the
-- right instead of the HEAD blob, so the diff is editable (do/dp, line edits)
-- and the file panel can stage. Trade-off: with uncommitted changes the right
-- pane is no longer literally HEAD, so it can show work that isn't committed.
map("n", "<Leader>gR", function()
	vim.cmd("DiffviewOpen origin/main...HEAD --imply-local")
end, { desc = "Diffview: review branch vs trunk (editable)" })
map("n", "<Leader>gH", function()
	vim.cmd("DiffviewFileHistory --range=origin/main...HEAD")
end, { desc = "Diffview: branch commit history" })

-- CMake
map("n", "<Leader>cg", ":CMakeGenerate<CR>", { desc = "CMake Generate" })
map("n", "<Leader>cb", ":CMakeBuild<CR>", { desc = "CMake Build" })
map("n", "<Leader>cq", ":CMakeClose<CR>", { desc = "CMake Close" })
map("n", "<Leader>cc", ":CMakeClean<CR>", { desc = "CMake Clean" })

-- Toggle soft line wrap (VSCode's Alt+Z convention). Applies to every window in
-- the current tab so both panes of a diff flip together; the current window
-- decides the new state. Diff windows also need 'linebreak' off-by-default
-- behaviour left alone, so only 'wrap' is touched.
map("n", "<A-z>", function()
	local wrap = not vim.wo.wrap
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_config(win).relative == "" then
			vim.wo[win].wrap = wrap
		end
	end
	vim.notify("wrap " .. (wrap and "on" or "off"), vim.log.levels.INFO)
end, { desc = "Toggle line wrap (all panes in tab)" })

-- Shell quoting fixer. Deliberately a command rather than an entry in
-- conform's formatters_by_ft: format_on_save (configs/overrides.lua) is global,
-- and shellharden rewrites quoting across the entire file, which would fold
-- large unrelated diffs into ordinary saves of existing scripts. shellcheck
-- reports the same issues passively via nvim-lint (configs/lint.lua).
vim.api.nvim_create_user_command("Shellharden", function()
	require("conform").format({ formatters = { "shellharden" }, async = true, lsp_format = "never" })
end, { desc = "Harden shell quoting in current buffer" })

-- CodeCompanion (local ollama chat, see configs/codecompanion.lua)
-- <Leader>aa in visual mode sends the selection straight into a fresh chat;
-- <Leader>ac appends the selection to the chat already open, which is the one
-- to use when following up on a second block during the same conversation.
map({ "n", "v" }, "<Leader>aa", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "AI chat toggle" })
map("v", "<Leader>ac", "<cmd>CodeCompanionChat Add<CR>", { desc = "AI add selection to chat" })
map({ "n", "v" }, "<Leader>ap", "<cmd>CodeCompanionActions<CR>", { desc = "AI action palette" })

-- Transparency toggle (base46 built-in: full coverage, persists via chadrc,
-- and survives theme switching)
map("n", "<Leader>T", function()
  require("base46").toggle_transparency()
end, { desc = "Toggle transparent background" })
