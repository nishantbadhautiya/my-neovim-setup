# Neovim Setup Guide

A reference guide for this Neovim configuration. Start here if you are new to Neovim.

## What this setup is for

- **C++** for DSA and competitive programming: one `.cpp` file per problem, input read from `input.txt`.
- **JavaScript / TypeScript**, mostly Node.js backends.
- An editing feel close to **VSCode**: 2-space indent, auto-closing brackets, completion, format on save, a file tree, fuzzy file search, and the system clipboard.

## Read in this order

| # | File | What's inside |
|---|------|---------------|
| 1 | [01-installation.md](01-installation.md) | Install on a new machine, requirements, first launch |
| 2 | [02-vim-basics.md](02-vim-basics.md) | Modes, moving, editing, and searching: the core of Vim |
| 3 | [03-keymaps.md](03-keymaps.md) | **Cheat sheet** of every custom key combination in this config |
| 4 | [04-cpp-dsa.md](04-cpp-dsa.md) | C++ DSA workflow: write, run, debug |
| 5 | [05-js-ts-backend.md](05-js-ts-backend.md) | JS/TS backend workflow: projects, LSP, ESLint, Prettier, running |
| 6 | [06-maintenance-and-troubleshooting.md](06-maintenance-and-troubleshooting.md) | Updating plugins, adding languages, fixing problems |
| 7 | [07-gotchas.md](07-gotchas.md) | **Things you should know**: where this config differs from stock Vim |

## The 5 things to remember on day one

1. **The leader key is `Space`.** In this guide, `<leader>ff` means: press `Space`, then `f`, then `f`.
2. **Stuck or lost? Press `Esc`** (or type `jk` in insert mode) to get back to Normal mode.
3. **Forgot a key? Press `Space` and wait half a second.** A popup (which-key) lists every key that can follow.
4. **Save with `:w`, quit with `:q`, quit without saving with `:q!`.** Saving also formats the file.
5. **`Space e e` opens the file tree, `Space f f` finds a file by name.**

## Built-in help

- `:Tutor`: an interactive 30-minute Vim lesson. Do this once.
- `:help <topic>`: Neovim's manual, for example `:help motion` or `:help text-objects`.
- `Space` (then wait): which-key popup listing your custom keys.
- `:Telescope keymaps`: search every key mapping by name.

## Where things live

```
~/.config/nvim/
├── init.lua                     entry point: loads core settings, then plugins
├── lazy-lock.json               exact plugin versions (commit this after updating)
├── .stylua.toml                 formatting rules for this config's own Lua files
├── docs/                        this guide
└── lua/nishant/
    ├── core/
    │   ├── options.lua          editor settings (indent, line numbers, clipboard...)
    │   └── keymaps.lua          general key mappings
    ├── lazy.lua                 plugin manager (lazy.nvim) bootstrap
    └── plugins/                 one file per plugin
        ├── lsp/
        │   ├── mason.lua        which language servers and formatters get installed
        │   └── lspconfig.lua    LSP keymaps and per-server settings
        ├── nvim-cmp.lua         autocompletion
        ├── formatting.lua       format on save (prettier, clang-format...)
        ├── code_runner.lua      run the current file (<leader>rr)
        ├── telescope.lua        fuzzy finder
        ├── nvim-tree.lua        file explorer
        └── ...
```

Data that is **not** in this repo, and is rebuilt automatically:

- `~/.local/share/nvim/lazy/`: downloaded plugins
- `~/.local/share/nvim/mason/`: language servers and formatters
- `~/.local/state/nvim/`: undo history, sessions, logs
