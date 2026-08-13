require("nvchad.configs.lspconfig").defaults()

-- NvChad maps `gd` to vim.lsp.buf.definition, which dumps multiple results into
-- the quickfix list and leaves that pane open after you pick one. Telescope's
-- picker previews the candidates and closes itself on selection (and still
-- jumps straight through when there is only one location).
-- Registered after defaults() on purpose: NvChad sets its buffer-local `gd`
-- from its own LspAttach handler, so ours has to run later to win.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspMappings", { clear = true }),
	desc = "Use Telescope for go-to-definition (no lingering quickfix pane)",
	callback = function(args)
		vim.keymap.set("n", "gd", function()
			require("telescope.builtin").lsp_definitions()
		end, { buffer = args.buf, desc = "Go to definition (Telescope)" })
	end,
})

vim.lsp.log.set_level(vim.log.levels.WARN)

local servers = { "ts_ls", "clangd", "pyright", "dockerls", "docker_compose_language_service", "lemminx", "yamlls" }

for _, lsp in ipairs(servers) do
	local opts = {}
	local exists, settings = pcall(require, "configs.lsp.server-settings." .. lsp)
	if exists then
		opts = vim.tbl_deep_extend("force", settings, opts)
	end
	vim.lsp.config(lsp, opts)
	vim.lsp.enable(lsp)
end

local diagnostics_config = {
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
		-- this will set set the prefix to a function that returns the diagnostics icon based on the severity
		-- prefix = "icons",
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "single",
		source = "always",
	},
	inlay_hints = {
		enabled = true,
		exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
	},
}

vim.diagnostic.config(diagnostics_config)
