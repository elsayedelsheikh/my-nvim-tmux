<div align="center">
	  <img src="https://raw.githubusercontent.com/neovim/neovim.github.io/master/logos/neovim-logo-300x87.png" alt="Neovim">
</div>
<div align="center">
<div>
Custom <a href="https://neovim.io/">Neovim</a> config using <a href="https://github.com/NvChad/NvChad">NvChad</a> as a base.
</div>
<p></p>
    	<a href="https://github.com/kelvin-van-vuuren/nvim/edit/main/.github/README.md#features-added-on-top-of-nvchad-base">Features</a>
  <span> • </span>
       	<a href="https://github.com/kelvin-van-vuuren/nvim/edit/main/.github/README.md#screenshots">Screenshots</a>
  <span> • </span>
	<a href="https://github.com/kelvin-van-vuuren/nvim/edit/main/.github/README.md#Install">Install</a>
  <span> • </span>
        <a href="https://nvchad.com/config/Walkthrough">Docs</a>
  <p></p>
</div> 

### Features (on top of [NvChad's](https://nvchad.com/#/docs/features))
* [**Clangd**](https://clangd.llvm.org/): language server for C/C++ development.
* [**Null-ls**](https://github.com/jose-elias-alvarez/null-ls.nvim): For diagnostics, formatting, code actions and more.
* [**Nvim-dap**](https://github.com/mfussenegger/nvim-dap) + [**nvim-dap-ui**](https://github.com/rcarriga/nvim-dap-ui): Debugger with [lldb](https://lldb.llvm.org/) debug adapter [config](https://github.com/kelvin-van-vuuren/nvim/blob/main/plugins/dap/adapters/lldb.lua) for C / C++ / Rust projects.
* [**Better-escape**](): quickly escape insert mode using ``jk``.  
* [**Git**](https://git-scm.com/): wrap header text at 50 chars, body text at 72.
* [And more...](https://github.com/kelvin-van-vuuren/nvim/commits/main)
### Screenshots
![2023-03-20-114710_3840x2160_scrot](https://user-images.githubusercontent.com/54939625/226331221-85b9630b-d065-4300-baa1-e0486f9db8d4.png)
![2023-03-20-114825_3840x2160_scrot](https://user-images.githubusercontent.com/54939625/226331697-05896bac-4d7c-4535-87d6-de364f7600c2.png)
![2023-03-20-114900_3840x2160_scrot](https://user-images.githubusercontent.com/54939625/226331802-58b50691-a218-4889-afac-d7058de89cde.png)

### Requirements

**Neovim 0.11+** (developed against 0.12). Everything below is a *system* prerequisite — the
language servers, linters, formatters and debug adapters themselves are installed automatically
by [mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) on first
launch (see [Install](#install)).

#### Required

| Tool | Why | Fedora |
| --- | --- | --- |
| `git` | plugin manager (lazy.nvim) and gitsigns | `sudo dnf install git` |
| `cc` / `gcc` | compiling treesitter parsers and `telescope-fzf-native` | `sudo dnf install gcc gcc-c++ make` |
| `node` + `npm` | runtime for the npm-based servers (pyright, ts_ls, yamlls, dockerls, bash, css/html) | `sudo dnf install nodejs npm` |
| `python3` | runtime for the pip-based tools (pylint, cpplint, clang-format, yamllint, cmake-language-server) | `sudo dnf install python3 python3-pip` |
| `ripgrep` | Telescope live grep (`vimgrep_arguments` in `configs/overrides.lua` calls `rg`) | `sudo dnf install ripgrep` |
| `unzip`, `tar`, `curl`/`wget` | mason downloads and extracts release archives | `sudo dnf install unzip tar curl wget` |

#### Optional

| Tool | Unlocks | Fedora |
| --- | --- | --- |
| `go` | `nvim-dap-go` (Go debugging). No Go language server is configured — if you want one, add `gopls` to `M.mason_tools` and to `servers` in `configs/lsp/init.lua`; mason cannot install it without a Go toolchain | `sudo dnf install golang` |
| `cargo` | `shellharden` — **mason cannot install it without a Rust toolchain** | `sudo dnf install cargo` |
| `gdb` | the `gdb` DAP adapter (`configs/dap/adapters/gdb.lua`) and `cppdbg`'s `miDebuggerPath` | `sudo dnf install gdb` |
| `xmllint` | the custom `xmllint` linter in `configs/lint.lua` | `sudo dnf install libxml2` |
| `java` (JRE 11+) | `lemminx` (XML language server) | `sudo dnf install java-latest-openjdk-headless` |
| `pynvim` | the Python 3 remote-plugin provider (`vim.g.python3_host_prog` is set in `autocmds.lua`); nothing in this config needs it, but `:checkhealth` reports an error without it | `sudo dnf install python3-neovim` |
| a Nerd Font | the devicons / lspkind glyphs in the statusline, nvim-tree and cmp menu | [nerdfonts.com](https://www.nerdfonts.com/) |

Verify everything with `:checkhealth` once Neovim is up.

### Install
Remove or backup ``~/.local/share/nvim``. This folder contains swap for open files, the [ShaDa](https://neovim.io/doc/user/starting.html#shada) (Shared Data) file, and the site directory for plugins from previous configurations.

Then clone this repo: ``git clone git@github.com:kelvin-van-vuuren/nvim.git ~/.config/nvim --depth 1 && nvim``

On first launch, lazy.nvim downloads the plugins and mason-tool-installer then installs every
package listed in ``M.mason_tools`` (`lua/configs/overrides.lua`) — LSP servers, DAP adapters,
linters and formatters. This takes a few minutes; watch it with ``:Mason``, or force a run with
``:MasonToolsUpdate``.

> **Note:** ``:MasonInstallAll`` no longer exists (NvChad v2.5 dropped it), and mason.nvim v2 has
> no ``ensure_installed`` option of its own — which is why the tool list is driven by
> mason-tool-installer instead.
