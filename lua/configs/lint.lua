local lint = require("lint")

lint.linters.xmllint = {
	cmd = "xmllint",
	args = { "--noout", "-" },
	stdin = true,
	stream = "stderr",
	ignore_exitcode = true,
	parser = require("lint.parser").from_pattern(
		"[^:]+:(%d+): ([^:]+) : (.+)",
		{ "lnum", "severity", "message" },
		{
			["parser error"] = vim.diagnostic.severity.ERROR,
			["parser warning"] = vim.diagnostic.severity.WARN,
		},
		{ source = "xmllint" }
	),
}

lint.linters_by_ft = {
	yaml = { "yamllint" },
	["yaml.docker-compose"] = { "yamllint" },
	xml = { "xmllint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
	callback = function()
		lint.try_lint(nil, { ignore_errors = true })
	end,
})
