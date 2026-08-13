-- pyright ignores PYTHONPATH, so sourcing a ROS setup script is not enough: the
-- ROS python packages have to be handed over as `extraPaths`. Run this nvim
-- inside the `jazzy` distrobox (that is where /opt/ros/<distro> exists); the rest
-- of the search path comes straight out of the colcon workspace.
local capabilities = require("nvchad.configs.lspconfig").capabilities

local function glob(pattern)
	return vim.fn.glob(pattern, false, true)
end

local function strip_slash(path)
	return (path:gsub("/$", ""))
end

-- Colcon workspace search paths:
--  * install/*/lib/python3.*/site-packages -- generated interface packages
--    (cbot_interfaces, btcpp_ros2_interfaces, ...)
--  * <pkg>/ for every ament_python package -- these are develop-installed, so
--    install/ only holds an .egg-link and the real code stays in the source tree
local function workspace_paths(root)
	local paths = {}
	if not root then
		return paths
	end

	vim.list_extend(paths, glob(root .. "/install/*/lib/python3.*/site-packages"))

	for _, dir in ipairs(glob(root .. "/*/")) do
		local pkg = strip_slash(dir)
		local name = vim.fs.basename(pkg)
		if vim.uv.fs_stat(pkg .. "/" .. name .. "/__init__.py") then
			paths[#paths + 1] = pkg
		end
	end

	return paths
end

return {
	capabilities = capabilities,

	-- Prefer the repo root: every ament_python package ships a setup.cfg, which
	-- would otherwise anchor pyright inside a single package and hide the rest
	-- of the workspace.
	root_markers = { ".git", "pyrightconfig.json", "pyproject.toml", "setup.py", "setup.cfg" },

	-- Must be on_init, not before_init: pyright pulls its configuration from
	-- `client.settings` (workspace/configuration), and before_init only ever sees
	-- `config.settings`. Replacing that table there leaves client.settings behind
	-- and the extraPaths silently never reach the server.
	on_init = function(client)
		local root = client.root_dir and (vim.fs.root(client.root_dir, ".git") or client.root_dir)

		local paths = glob("/opt/ros/*/lib/python3.*/site-packages")
		vim.list_extend(paths, workspace_paths(root))

		client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
			python = { analysis = { extraPaths = paths } },
		})
		client:notify("workspace/didChangeConfiguration", { settings = client.settings })
	end,

	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
				typeCheckingMode = "basic",
			},
		},
	},
}
