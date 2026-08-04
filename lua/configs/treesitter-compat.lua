-- Compatibility shim for nvim-treesitter (archived `master` branch) on Neovim 0.12.
--
-- Since Neovim 0.10 a query match maps a capture id to a *list* of TSNodes,
-- but the directives shipped by nvim-treesitter master still treat
-- `match[capture_id]` as a single TSNode. On 0.12 that surfaces as:
--
--   vim/treesitter.lua:197: attempt to call method 'range' (a nil value)
--
-- which fires for every markdown buffer containing a fenced code block,
-- because queries/markdown/injections.scm uses `#set-lang-from-info-string!`.
--
-- TODO: remove this once nvim-treesitter is migrated to the `main` branch.

local query = vim.treesitter.query

local opts = { force = true, all = false }

---Return the first TSNode for a capture, tolerating both the old (single node)
---and new (list of nodes) match representations.
---@param match table
---@param capture_id integer|string
---@return TSNode|nil
local function first_node(match, capture_id)
	local value = match[capture_id]
	if type(value) == "table" then
		return value[#value]
	end
	return value
end

-- Mirrors nvim-treesitter's markdown info-string -> parser aliases.
local markdown_aliases = {
	["c++"] = "cpp",
	["cc"] = "cpp",
	["h"] = "c",
	["hpp"] = "cpp",
	["js"] = "javascript",
	["jsx"] = "javascript",
	["py"] = "python",
	["rs"] = "rust",
	["sh"] = "bash",
	["shell"] = "bash",
	["ts"] = "typescript",
	["tsx"] = "typescript",
	["yml"] = "yaml",
}

query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
	local node = first_node(match, pred[2])
	if not node then
		return
	end
	local alias = vim.treesitter.get_node_text(node, bufnr):lower()
	metadata["injection.language"] = markdown_aliases[alias] or alias
end, opts)

query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
	local node = first_node(match, pred[2])
	if not node then
		return
	end
	local mimetype = vim.treesitter.get_node_text(node, bufnr)
	local parts = vim.split(mimetype, "/", {})
	metadata["injection.language"] = parts[#parts]
end, opts)

query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
	local id = pred[2]
	local node = first_node(match, id)
	if not node then
		return
	end
	local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
	metadata[id] = metadata[id] or {}
	metadata[id].text = text:lower()
end, opts)
