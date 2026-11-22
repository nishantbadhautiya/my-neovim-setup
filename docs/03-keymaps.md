# 3. Keymap Cheat Sheet

Every custom key combination in this config, grouped by task.

- **`<leader>` = `Space`.** `<leader>ff` means `Space`, `f`, `f`, pressed one after another (not held together).
- `Ctrl-x` means hold Ctrl and press x.
- Mode: **N** = Normal, **I** = Insert, **V** = Visual.
- Can't remember? Press `Space` and wait, or run `:Telescope keymaps`.

## General

| Keys | Mode | Action |
|------|------|--------|
| `jk` | I | exit Insert mode (same as `Esc`) |
| `<leader>nh` | N | clear search highlights |
| `<leader>+` / `<leader>-` | N | increment / decrement the number under the cursor |
| `x` | N | delete a character **without copying it** |
| `dd` | N | delete a line **without copying it** |

## Files: explorer and finder

### File explorer (nvim-tree)

| Keys | Action |
|------|--------|
| `<leader>ee` | toggle the file explorer |
| `<leader>ef` | open the explorer with the current file highlighted |
| `<leader>ec` | collapse all folders |
| `<leader>er` | refresh |

**Inside the explorer:**

| Key | Action |
|-----|--------|
| `Enter` or `o` | open file / expand folder |
| `a` | **create** a file (end the name with `/` to create a folder, e.g. `src/`) |
| `d` | delete |
| `r` | rename |
| `x` / `c` / `p` | cut / copy / paste |
| `Ctrl-v` / `Ctrl-x` / `Ctrl-t` | open in vertical split / horizontal split / new tab |
| `Tab` | preview the file without leaving the tree |
| `H` | show/hide dotfiles |
| `I` | show/hide git-ignored files |
| `y` / `Y` / `gy` | copy name / relative path / absolute path |
| `-` | go up to the parent directory |
| `R` | refresh |
| `g?` | **show all explorer keys** |
| `q` | close |

### Fuzzy finder (Telescope)

| Keys | Action |
|------|--------|
| `<leader>ff` | find files by name |
| `<leader>fr` | recently opened files |
| `<leader>fs` | **search text** across the whole project (live grep) |
| `<leader>fc` | search for the word under the cursor |
| `<leader>ft` | find TODO/FIXME comments |

**Inside Telescope:**

| Key | Action |
|-----|--------|
| type | filter results |
| `Ctrl-j` / `Ctrl-k` | next / previous result |
| `Enter` | open |
| `Ctrl-v` / `Ctrl-x` / `Ctrl-t` | open in vertical split / horizontal split / tab |
| `Ctrl-u` / `Ctrl-d` | scroll the preview |
| `Tab` | mark multiple results |
| `Ctrl-q` | send results to the quickfix list (use with `<leader>xq`) |
| `Esc` `Esc` or `Ctrl-c` | close |

Other useful Telescope commands: `:Telescope buffers` (open files), `:Telescope help_tags` (search help), `:Telescope keymaps`, `:Telescope` (list every picker).

## Code intelligence (LSP)

These work in files that have a language server (C++, JS/TS, JSON, Lua, Python, HTML, CSS...).

| Keys | Mode | Action |
|------|------|--------|
| `K` | N | **show documentation / type** of the thing under the cursor |
| `gd` | N | **go to definition** |
| `gD` | N | go to declaration |
| `gR` | N | show all references |
| `gi` | N | go to implementation |
| `gt` | N | go to type definition |
| `Ctrl-o` | N | jump back to where you were |
| `<leader>rn` | N | **rename** a variable/function everywhere |
| `<leader>ca` | N, V | **code actions**: quick fixes, add missing import, etc. |
| `<leader>d` | N | show the error on the current line in a popup |
| `<leader>D` | N | list all errors in this file |
| `]d` / `[d` | N | jump to next / previous error or warning |
| `<leader>rs` | N | restart the language server (if it acts weird) |
| `Ctrl-s` | I | show function signature / parameters while typing |

Gutter icons: error, warning, `󰠠` hint, info.

## Autocompletion (nvim-cmp)

A menu appears while you type in Insert mode.

| Keys | Action |
|------|--------|
| `Ctrl-j` / `Ctrl-k` | next / previous suggestion |
| `Enter` | accept the **selected** suggestion (if nothing is selected, Enter just makes a new line) |
| `Ctrl-Space` | open the menu manually |
| `Ctrl-e` | close the menu |
| `Ctrl-f` / `Ctrl-b` | scroll the documentation popup |

Suggestions come from the language server, snippets, words in the current file, and file paths (type `./`).

## Formatting

| Keys / action | What happens |
|---------------|--------------|
| `:w` (save) | **formats automatically** |
| `<leader>mp` | format now (in Visual mode: format only the selection) |

Formatters: **prettier** (JS/TS/JSON/YAML/HTML/CSS/Markdown), **clang-format** (C/C++), **stylua** (Lua), **isort + black** (Python).

## Running code (code_runner)

| Keys | Action |
|------|--------|
| `<leader>rr` | **run the current file** |
| `<leader>rf` | run the current file (same as `rr`, but waits ½ s, see Gotchas) |
| `<leader>rft` | run the current file in a new tab |
| `<leader>rp` | run project |
| `<leader>rc` | close the output window |

| Language | Command used |
|----------|--------------|
| C++ | `g++ -std=c++20 -O2 -Wall -Wextra -Wshadow -DLOCAL -fsanitize=address,undefined`; reads `input.txt` if present |
| C | `gcc file.c && ./file` |
| JavaScript / TypeScript | `node file` (Node 22.18+ runs `.ts` directly) |
| Python | `python3 -u file` |
| Bash | `bash file` |

The output opens in a terminal split. If the program waits for input, click into it (or move there with `Ctrl-j`), press `i`, and type. To leave terminal typing mode: `Ctrl-\` then `Ctrl-n`.

## Editing helpers

### Comments (Comment.nvim)

| Keys | Mode | Action |
|------|------|--------|
| `gcc` | N | toggle comment on the line |
| `gc` + motion | N | comment a range, e.g. `gcip` (paragraph), `gc5j` (5 lines down) |
| `gc` | V | toggle comment on the selection |
| `gbc` | N | toggle block comment `/* */` |

### Surround (nvim-surround)

| Keys | Before | After |
|------|--------|-------|
| `ysiw"` | `hello` | `"hello"` |
| `ysiw)` | `hello` | `(hello)` |
| `ysiw(` | `hello` | `( hello )`  (opening bracket adds spaces) |
| `yss}` | `return x` | `{return x}` (whole line) |
| `ds"` | `"hello"` | `hello` |
| `cs"'` | `"hello"` | `'hello'` |
| `cs)]` | `(a, b)` | `[a, b]` |
| `dst` | `<b>hi</b>` | `hi` |
| `S"` (Visual) | selection | `"selection"` |

Read `ys` as "you surround", `ds` as "delete surround", `cs` as "change surround".

### Substitute (substitute.nvim)

Replace text with what you last yanked, **without losing your yank**.

| Keys | Action |
|------|--------|
| `s` + motion | replace with the clipboard, e.g. `siw` replaces the word, `si"` the text inside quotes |
| `ss` | replace the whole line |
| `S` | replace to the end of the line |
| `s` (Visual) | replace the selection |

Typical use: `yiw` on a word, move to another word, `siw`, move to the next, `siw` again...

### Auto pairs

Typing `(` `[` `{` `"` `'` `` ` `` inserts the closing character. Pressing `Enter` between `{}` puts the cursor on an indented line in between. Typing the closing character when it's already next to the cursor just moves past it.

### Selecting code by structure (Treesitter)

| Keys | Mode | Action |
|------|------|--------|
| `Ctrl-Space` | N | start selecting the code node under the cursor |
| `Ctrl-Space` | V | grow the selection to the enclosing node (expression, then statement, then block, then function...) |
| `Backspace` | V | shrink the selection |

## Windows (splits)

| Keys | Action |
|------|--------|
| `<leader>sv` | split vertically (side by side) |
| `<leader>sh` | split horizontally (top/bottom) |
| `<leader>se` | make splits equal size |
| `<leader>sx` | close the current split |
| `<leader>sm` | maximize / restore the current split |
| `Ctrl-h` / `Ctrl-j` / `Ctrl-k` / `Ctrl-l` | move to the split left / below / above / right (also tmux panes) |

## Tabs

The tab bar at the top shows tabs (not buffers).

| Keys | Action |
|------|--------|
| `<leader>to` | open a new tab |
| `<leader>tx` | close the tab |
| `<leader>tn` / `<leader>tp` | next / previous tab |
| `<leader>tf` | open the current file in a new tab |
| `gt` / `gT` | next / previous tab (Vim default; `gt` is taken by LSP when a server is attached) |

## Diagnostics and TODO lists (Trouble)

| Keys | Action |
|------|--------|
| `<leader>xw` | all errors/warnings in the workspace |
| `<leader>xd` | errors/warnings in the current file |
| `<leader>xq` | quickfix list |
| `<leader>xl` | location list |
| `<leader>xt` | all TODO comments |
| `]t` / `[t` | jump to next / previous TODO comment |

In the Trouble window: `Enter` jumps to the item, `q` closes.

TODO comments are highlighted when written like `// TODO: ...`, `// FIXME: ...`, `// HACK: ...`, `// NOTE: ...`, `// PERF: ...`, `// WARN: ...`.

## Sessions (auto-session)

| Keys | Action |
|------|--------|
| `<leader>ws` | save the session (open files and splits) for this folder |
| `<leader>wr` | restore the session for this folder |

Sessions are saved automatically when you quit, except in `~`, `~/Dev`, `~/Downloads`, `~/Documents`, and `~/Desktop`. They are **not** restored automatically: press `<leader>wr` (or `SPC wr` on the start screen).

## Start screen (alpha)

Shown when you run `nvim` without a file:

| Key | Action |
|-----|--------|
| `e` | new file |
| `SPC ee` | file explorer |
| `SPC ff` | find file |
| `SPC fs` | find text |
| `SPC wr` | restore the last session for this folder |
| `q` | quit |
