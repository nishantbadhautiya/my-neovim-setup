# 6. Maintenance and Troubleshooting

## The three managers

| Command | Manages | Key commands inside |
|---------|---------|---------------------|
| `:Lazy` | **plugins** | `U` update all, `S` sync (install + update + clean), `X` remove unused, `L` log, `?` help, `q` close |
| `:Mason` | **language servers and formatters** | `i` install, `X` uninstall, `u` update one, `U` update all, `/` filter, `g?` help |
| `:TSUpdate` | **Treesitter syntax parsers** | `:TSInstall <lang>` adds one, e.g. `:TSInstall go` |

An orange number in the statusline means plugin updates are available. Open `:Lazy` and press `U` when you have time.

## Updating safely

```vim
:Lazy update
```

Then test that things still work. If they do, commit the new versions so every machine gets the same ones:

```bash
cd ~/.config/nvim
git add lazy-lock.json
git commit -m "Update plugins"
git push
```

**If an update breaks something,** roll back to the versions in the lock file:

```bash
cd ~/.config/nvim
git checkout lazy-lock.json     # or: git checkout HEAD~1 -- lazy-lock.json
nvim -c "Lazy restore"
```

## Health checks

| Command | Checks |
|---------|--------|
| `:checkhealth` | everything (takes a few seconds) |
| `:checkhealth vim.lsp` | which language servers are attached to the current file |
| `:checkhealth vim.deprecated` | old APIs that will break in future Neovim versions |
| `:ConformInfo` | which formatter runs for the current file, and its logs |
| `:lsp restart` / `:lsp stop` | restart / stop the language servers of the current file |
| `:lua vim.cmd.tabnew(vim.lsp.log.get_filename())` | open the language server log |
| `:messages` | recent messages and errors you may have missed |
| `:Lazy` | plugins with errors are shown in red |

### Warnings you can ignore

- Mason: `cargo`, `Composer`, `PHP`, `Ruby`, `java`, `julia`, `luarocks`, `pip` not available (only needed for languages you don't use)
- `tree-sitter executable not found` (only needed for building parsers from grammar)
- `Unknown filetype 'ejs'`, `'jade'`, etc. under language servers (lists of optional filetypes)
- Provider warnings for `perl`, `ruby`, and the `neovim` npm package

## Adding a language

Example: Go.

1. **Language server:** add `"gopls"` to the `ensure_installed` list of `mason-lspconfig` in `lua/nishant/plugins/lsp/mason.lua`. Mason installs it, and it starts automatically for Go files.
   - Server names are listed at <https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md>.
   - For special settings, add `vim.lsp.config("gopls", { settings = { ... } })` in `lsp/lspconfig.lua`, next to the existing `clangd` and `lua_ls` blocks.
2. **Formatter:** add `go = { "gofmt" }` to `formatters_by_ft` in `lua/nishant/plugins/formatting.lua`. If it isn't installed on your system, add it to `mason-tool-installer`'s list.
3. **Syntax highlighting:** add `"go"` to `ensure_installed` in `lua/nishant/plugins/treesitter.lua`.
4. **Run with `<leader>rr`:** add `go = "go run $file",` to `lua/nishant/plugins/code_runner.lua`.
5. Restart Neovim.

## Adding a plugin

Create a new file in `lua/nishant/plugins/`, for example `lua/nishant/plugins/gitsigns.lua`:

```lua
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- load when a file is opened
  opts = {},                               -- calls require("gitsigns").setup({})
}
```

Restart Neovim and lazy.nvim installs it. To remove a plugin, delete its file, then run `:Lazy clean`.

## Changing settings

| Want to change | File |
|----------------|------|
| indent size, line numbers, clipboard, wrapping | `lua/nishant/core/options.lua` |
| general keymaps | `lua/nishant/core/keymaps.lua` |
| LSP keymaps | `lua/nishant/plugins/lsp/lspconfig.lua` (inside `LspAttach`) |
| colors | `lua/nishant/plugins/colorscheme.lua` |
| completion keys | `lua/nishant/plugins/nvim-cmp.lua` |
| how files are run | `lua/nishant/plugins/code_runner.lua` |

Example: map `Ctrl-s` to save in Normal and Insert mode. Add to `keymaps.lua`:

```lua
keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })
```

(This replaces the Insert-mode `Ctrl-s` that shows the function signature.)

## Common problems

| Symptom | Fix |
|---------|-----|
| icons show as boxes or `?` | set a Nerd Font in your terminal settings |
| no errors, completion, or `K` in a file | `:checkhealth vim.lsp`. Is a server attached? If not, is it installed in `:Mason`? |
| language server acting weird or stale | `<leader>rs` |
| Neovim slow to open one huge file | `:TSBufDisable highlight` for that buffer |
| something broke after an update | roll back (see "Updating safely" above) |
| startup errors after editing the config | read the error: it names the file and line. `nvim --clean` starts without your config |
| copy/paste doesn't reach other apps | is `wl-clipboard` installed? `:checkhealth provider` → Clipboard |
| everything is broken | `rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim`, then start `nvim` (reinstalls all plugins; your config is untouched) |
