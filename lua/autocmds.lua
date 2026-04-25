require("nvchad.autocmds")

vim.filetype.add({
	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
		["compose.yaml"] = "yaml.docker-compose",
	},
})

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- git commit header 50 chars and wrap body message lines at 72 characters
vim.api.nvim_create_autocmd("FileType", {
	pattern = "gitcommit",
	group = vim.api.nvim_create_augroup("GitCommitSetup", { clear = true }),
	callback = function()
		-- Create a buffer-local autocmd (note the buffer = 0)
		-- This ensures the expensive CursorMoved check ONLY runs in this specific window
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = 0,
			callback = function()
				-- If on line 1, width is 50. Otherwise, it's 72.
				vim.opt_local.textwidth = vim.fn.line(".") == 1 and 50 or 72
			end,
		})
	end,
})

local enable_providers = {
	"python3_provider",
	-- and so on
}

for _, plugin in pairs(enable_providers) do
	vim.g["loaded_" .. plugin] = nil
	vim.cmd("runtime " .. plugin)
end

vim.g.python3_host_prog = "/bin/python3"

-- Hot-reload: pick up file changes made outside Neovim (e.g. by Claude Code)
local reload_group = vim.api.nvim_create_augroup("HotReload", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
	group = reload_group,
	desc = "Reload buffers changed outside Neovim",
	callback = function()
		if vim.fn.getcmdwintype() == "" then
			vim.cmd("checktime")
		end
	end,
})

-- Refresh diffview file panel when .git/index changes (tracks staged/unstaged state)
vim.api.nvim_create_autocmd("VimEnter", {
	group = reload_group,
	once = true,
	desc = "Watch .git/index and refresh diffview panel on changes",
	callback = function()
		local git_index = vim.fn.getcwd() .. "/.git/index"
		if vim.fn.filereadable(git_index) ~= 1 then
			return
		end
		local uv = vim.uv or vim.loop
		local w = uv.new_fs_event()
		w:start(git_index, {}, vim.schedule_wrap(function()
			local ok, lib = pcall(require, "diffview.lib")
			if not ok then return end
			local view = lib.get_current_view()
			if view and view.update_files then
				view:update_files()
			end
		end))
	end,
})
