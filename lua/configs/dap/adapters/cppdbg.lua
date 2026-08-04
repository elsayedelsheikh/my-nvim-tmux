-- This adapter seems to work better with nvim-dap-ui
--
-- cpptools is installed by mason (see overrides.mason_tools), which is the
-- preferred source. The manual install below is kept as a fallback:
-- mkdir -p ~/.local/share/cpptools
-- cd ~/.local/share/cpptools
-- wget https://github.com/microsoft/vscode-cpptools/releases/download/1.25.3/cpptools-linux-X64.vsix
-- unzip cpptools-linux.vsix -d cpptools
-- chmod +x cpptools/extension/debugAdapters/bin/OpenDebugAD7

local M = {}

local home = os.getenv("HOME")

local candidates = {
  vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
  home .. "/.local/share/cpptools/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
}

local command = candidates[1]
for _, path in ipairs(candidates) do
  if vim.fn.executable(path) == 1 then
    command = path
    break
  end
end

M.adapter = {
  id = 'cppdbg',
  type = 'executable',
  command = command,
}

M.config = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    setupCommands = {
      {
        text = '-enable-pretty-printing',
        description = 'Enable pretty printing',
        ignoreFailures = false
      },
    },
  },
  {
    name = "Attach to gdbserver :1234",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to local executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    miMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',  -- gdbserver address
    miDebuggerPath = '/usr/bin/gdb',
    stopOnEntry = false,
    setupCommands = {
      {
        text = '-enable-pretty-printing',
        description = 'Enable pretty printing',
        ignoreFailures = false
      },
    },
  },
}

return M
