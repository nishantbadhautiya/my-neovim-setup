# 7. Things You Should Know (Gotchas)

Where this config behaves differently from stock Vim, from tutorials, or from what you might expect.

## Keys that were changed

### `dd` and `x` don't copy anything

`x` and `dd` delete into the "black hole" register, so they never overwrite your clipboard. Nice when you yank something, delete a few lines, and then paste.

**But it means `dd` can't be used to cut a line.** To **move** a line:

- `V` then `d` (visual delete still cuts), move, `p`.
- Or `yy` (copy), `dd` (delete), move, `p`.
- Or skip the clipboard: `:m +1` / `:m -2` moves the line down / up.

Other deletes **do** copy: `dw`, `D`, `d}`, `ci(`, visual `d`, and so on.

### `s` and `S` are replaced by substitute.nvim

In stock Vim, `s` deletes a character and enters Insert mode, and `S` replaces the line. Here they **replace text with the clipboard** (see [cheat sheet](03-keymaps.md#substitute-substitutenvim)).

The stock behaviour is still available: use `cl` instead of `s`, and `cc` instead of `S`.

### `jk` exits Insert mode

Typing `j` and then `k` quickly leaves Insert mode. If you ever need to type "jk" literally, pause briefly between the two letters.

### `gt` goes to type definition when a language server is attached

In stock Vim, `gt` goes to the next tab. In code files with LSP it means "go to type definition". Use `<leader>tn` / `<leader>tp` for tabs.

### `<leader>rf` waits half a second

`<leader>rf` (run file) and `<leader>rft` (run in tab) share a prefix. After `Space r f`, Neovim waits 500 ms to see if you'll press `t`. Use **`<leader>rr`** for an instant run.

### `Ctrl-h/j/k/l` move between splits

They work across **tmux panes** too (vim-tmux-navigator). For this to work inside tmux, tmux needs the matching config from <https://github.com/christoomey/vim-tmux-navigator#tmux>.

### `Ctrl-Space` does two things

- In **Insert** mode: open the completion menu.
- In **Normal / Visual** mode: select the code block under the cursor, growing with each press (`Backspace` shrinks).

## Clipboard

- `y`, `p`, and the cutting deletes (`dw`, visual `d`...) use the **system clipboard**. What you yank can be pasted in the browser with `Ctrl-v`, and what you copy in the browser can be pasted in Neovim with `p`.
- In Insert mode, `Ctrl-Shift-v` (the terminal's paste) also works.
- `"0p` pastes the last **yank**, even if you deleted things since.

## Indentation

- **2 spaces everywhere**, as spaces rather than tabs (like VSCode with Prettier).
- **Python uses 4 spaces** (Python's standard style, and `black` enforces it).
- Format on save may re-indent the file to match Prettier or clang-format. That's expected.
- A project's `.prettierrc`, `.editorconfig`, or `.clang-format` overrides these defaults when formatting.
- Re-indent a messy block: select it with `V`, then press `=`. For the whole file: `gg=G`.
- The Lua files of **this config** use tabs (stylua's default). Don't be surprised when you edit them.
- Auto-indent comes from Neovim's built-in indent rules, not Treesitter (Treesitter indent is still experimental). nvim-treesitter is on its `main` branch, which needs Neovim 0.12+. Its old `master` branch is archived and broken on 0.12: don't switch back to it.

## Saving formats the file

- Every `:w` runs the formatter (Prettier, clang-format, stylua, black).
- Save **without** formatting: `:noautocmd w`.
- Formatting has a 1-second limit. On a very large file it may skip with a timeout message.

## Completion and `Enter`

- `Enter` accepts a suggestion **only if you selected one** with `Ctrl-j` / `Ctrl-k`. Otherwise it inserts a new line, so you won't accept a random suggestion by accident.
- **Snippet placeholders:** after expanding a snippet (e.g. `for`), there are currently **no keys for jumping to the next placeholder**. `Tab` only works for snippets coming from the language server. Type over the placeholder, or move with normal motions.

## Sessions

- Neovim saves open files and splits per folder when you quit (except in `~`, `~/Downloads`, and similar folders).
- They **aren't restored automatically**. Press `<leader>wr` (or `SPC wr` on the start screen).

## Mouse hover

- Resting the mouse on a word shows its type, like VSCode. It only works in Normal mode, in files with a language server.
- To read a long popup, scroll it with the wheel, or click into it (or press `K`) and use `j`/`k`. `q` or `Esc` closes it. While the cursor is inside, moving the mouse won't close it.
- Your terminal has to report mouse movement (kitty, alacritty, foot, wezterm and GNOME Terminal do). Inside tmux, add `set -g mouse on` to `~/.tmux.conf`.
- Change the delay with `DELAY_MS` in `lua/nishant/core/mouse_hover.lua`.

## Language servers

- **The first time** you open a file type, its server may need a few seconds to start (clangd also indexes the project in the background).
- JS/TS projects need `@types/node` for Node APIs. Without it, imports like `node:fs` show as errors.
- ESLint is silent unless the project has an ESLint config and `eslint` installed locally.

## Plugins update themselves? No.

lazy.nvim **checks** for updates in the background (the orange number in the statusline), but never installs them by itself. You choose when to run `:Lazy update`. Commit `lazy-lock.json` afterwards.

## The `programming/` folder

`programming/` in this repo is a sample C++ CMake project (with a `compile_commands.json` for clangd). It isn't part of the config, and you can delete it or use it as a playground.
