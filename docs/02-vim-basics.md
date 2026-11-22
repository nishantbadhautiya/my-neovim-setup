# 2. Vim Basics

Vim is a **modal** editor: keys do different things depending on the current mode. Learn this page first. Everything else builds on it.

> Fastest way to learn: run `:Tutor` inside Neovim, then come back here as a reference.

## Modes

| Mode | How to enter | What it's for | Shown in statusline |
|------|--------------|---------------|---------------------|
| **Normal** | `Esc` or `jk` | moving around and running commands (the default) | `NORMAL` (blue) |
| **Insert** | `i`, `a`, `o`, ... | typing text | `INSERT` (green) |
| **Visual** | `v`, `V`, `Ctrl-v` | selecting text | `VISUAL` (pink) |
| **Command** | `:` | commands like `:w` or `:q` | `COMMAND` (yellow) |
| **Terminal** | `:term`, code runner output | a shell inside Neovim | `TERMINAL` |

**Rule of thumb:** you spend most of your time in Normal mode. Enter Insert mode only to type, then press `Esc` (or `jk`).

## Save and quit

| Command | Action |
|---------|--------|
| `:w` | save (also formats the file) |
| `:q` | quit the current window |
| `:wq` or `:x` | save and quit |
| `:q!` | quit and **discard** changes |
| `:qa` | quit everything |
| `:wa` | save all files |
| `:e path/to/file` | open a file |

## Entering Insert mode

| Key | Starts typing... |
|-----|------------------|
| `i` | before the cursor |
| `a` | after the cursor |
| `I` | at the start of the line |
| `A` | at the end of the line |
| `o` | on a new line below |
| `O` | on a new line above |

## Moving (Normal mode)

| Key | Moves to |
|-----|----------|
| `h` `j` `k` `l` | left, down, up, right (arrow keys also work) |
| `w` / `b` | next / previous word |
| `e` | end of word |
| `0` / `^` / `$` | start of line / first non-blank character / end of line |
| `gg` / `G` | top / bottom of file |
| `42G` or `:42` | line 42 |
| `%` | the matching bracket `(` `)` `{` `}` `[` `]` |
| `f{char}` / `t{char}` | onto / just before the next `{char}` on the line (`;` repeats) |
| `Ctrl-d` / `Ctrl-u` | half a page down / up |
| `zz` | scroll so the cursor line is in the middle |
| `Ctrl-o` / `Ctrl-i` | jump back / forward (for example after `gd`) |

**Counts:** put a number before a motion to repeat it. `5j` moves 5 lines down, `3w` moves 3 words forward. Line numbers are **relative**, so the number shown next to each line is exactly the count you need for `j` or `k`.

## Editing: operator + motion

Vim editing reads like a sentence: **operator** + **motion/text object**.

| Operator | Meaning |
|----------|---------|
| `d` | delete (cut) |
| `c` | change (delete, then enter Insert mode) |
| `y` | yank (copy) |
| `>` / `<` | indent / unindent |
| `=` | auto-indent |
| `gc` | comment / uncomment |

Examples:

| Keys | Does |
|------|------|
| `dw` | delete to the next word |
| `d$` or `D` | delete to the end of the line |
| `cw` | change a word |
| `yy` | copy the whole line |
| `>>` / `<<` | indent / unindent the line |
| `gg=G` | re-indent the whole file |
| `p` / `P` | paste after / before the cursor |
| `u` | undo |
| `Ctrl-r` | redo |
| `.` | **repeat the last change** (very useful) |

### Text objects: the most useful part

Use these after `d`, `c`, `y`, or `v`. `i` means **inside**, `a` means **around** (including the brackets or quotes).

| Keys | Acts on |
|------|---------|
| `ciw` | change the word under the cursor |
| `ci"` | change the text inside `"..."` |
| `ci(` or `cib` | change the text inside `(...)`, like function arguments |
| `ci{` or `ciB` | change the body inside `{...}` |
| `da(` | delete `(...)` including the parentheses |
| `yi{` | copy the body of a block |
| `vip` | select a paragraph (a block of lines without blank lines) |
| `dit` / `cit` | delete / change inside an HTML tag |

The cursor only needs to be somewhere inside the brackets or quotes.

## Visual mode (selecting)

| Key | Selects |
|-----|---------|
| `v` | characters |
| `V` | whole lines |
| `Ctrl-v` | a rectangular block (column editing) |

After selecting: `d` delete, `y` copy, `>` / `<` indent, `gc` comment, `S"` wrap in quotes (see the surround section in the cheat sheet).

**Edit several lines at once:** `Ctrl-v`, move down with `j`, press `I`, type the text, then press `Esc`. The text appears on every selected line.

## Search and replace

| Keys | Action |
|------|--------|
| `/text` then `Enter` | search forward |
| `?text` | search backward |
| `n` / `N` | next / previous match |
| `*` | search for the word under the cursor |
| `<leader>nh` | clear the search highlight |
| `:%s/old/new/g` | replace every `old` with `new` in the file |
| `:%s/old/new/gc` | same, but ask before each one (`y`/`n`/`a`/`q`) |

Search ignores case unless your search contains a capital letter (`smartcase`).

## Windows (splits) and tabs

These are covered in the [cheat sheet](03-keymaps.md#windows-splits). Short version:

- `<leader>sv` splits vertically, `<leader>sh` splits horizontally, `<leader>sx` closes a split.
- `Ctrl-h` / `Ctrl-j` / `Ctrl-k` / `Ctrl-l` move between splits.
- `<leader>to` opens a new tab, `<leader>tn` / `<leader>tp` go to the next / previous tab.

## Registers (clipboard), briefly

- This config uses the **system clipboard**: anything you yank with `y` can be pasted in your browser, and the other way round.
- `x` and `dd` **do not** copy anything. See [Gotchas](07-gotchas.md).
- `:reg` shows every register. `"0p` pastes the last thing you **yanked** (not deleted).
