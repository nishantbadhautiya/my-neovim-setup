# 1. Installation

## Requirements

| Tool | Why | Arch Linux package |
|------|-----|--------------------|
| Neovim **0.11+** (tested on 0.12) | the editor; the LSP setup uses 0.11+ APIs | `neovim` |
| git | downloads plugins | `git` |
| make, gcc/g++ | builds telescope-fzf and LuaSnip; compiles your C++ | `base-devel` |
| Node.js + npm | runs JS/TS and installs several language servers | `nodejs npm` (or fnm/nvm) |
| python3 | installs the `black`/`isort` Python formatters | `python` |
| ripgrep | text search across files (`<leader>fs`) | `ripgrep` |
| fd | faster file finding (optional) | `fd` |
| unzip, curl | Mason downloads | `unzip curl` |
| wl-clipboard (Wayland) or xclip (X11) | system clipboard | `wl-clipboard` |
| A **Nerd Font** set in your terminal | file and diagnostic icons | `ttf-jetbrains-mono-nerd` |

If you see boxes or `?` instead of icons, your terminal is not using a Nerd Font.

## Install on a new machine

```bash
# 1. back up any existing config
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null

# 2. clone
git clone git@github-nishant:nishantbadhautiya/my-neovim-setup.git ~/.config/nvim

# 3. start neovim
nvim
```

## On first launch

1. **lazy.nvim** installs itself, then every plugin, at the versions in `lazy-lock.json`. A window shows progress. When it finishes, press `q`.
2. **Mason** installs the language servers and formatters in the background (clangd, typescript-language-server, prettier, and others). Messages such as `prettier: installing` appear at the bottom of the screen. **Leave Neovim open for a minute or two** until they report `successfully installed`.
3. **Treesitter** downloads syntax parsers the first time you open a file.
4. Quit (`:qa`) and start `nvim` again.

To check that everything worked:

```vim
:checkhealth
```

Some warnings are expected and safe to ignore. See [06-maintenance-and-troubleshooting.md](06-maintenance-and-troubleshooting.md#warnings-you-can-ignore).

## Install all tools in one go (optional)

Instead of waiting for the background installs, you can run this once:

```bash
nvim --headless -c "MasonInstall clangd clang-format typescript-language-server eslint-lsp json-lsp \
  html-lsp css-lsp tailwindcss-language-server emmet-ls lua-language-server pyright \
  prettier stylua isort black" -c qa
```
