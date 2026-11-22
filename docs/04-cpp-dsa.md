# 4. C++ for DSA / Competitive Programming

## What you get

| Feature | Tool | Notes |
|---------|------|-------|
| Errors as you type, completion, go-to-definition, docs on `K` | **clangd** | uses C++20 for single files, `bits/stdc++.h` works |
| Format on save | **clang-format** | 2-space indent, 100-column lines (unless the folder has a `.clang-format`) |
| Syntax highlighting | Treesitter `cpp` parser | |
| Compile and run with one key | code_runner, `<leader>rr` | C++20, `-O2`, warnings, sanitizers, auto `input.txt` |
| Snippets | friendly-snippets | type `for`, `while`, `if`, `cout`, ... and pick from the menu |

## The everyday workflow

```
dsa/
├── two-sum.cpp
├── input.txt      ← the sample input for the current problem
└── ...
```

1. `cd ~/dsa && nvim` (or open the folder and press `Space e e`).
2. Create a file: in the explorer press `a` and type `two-sum.cpp`. Or run `:e two-sum.cpp`.
3. Write your solution.
4. Paste the sample input into `input.txt` in the **same folder**.
5. Press **`<leader>rr`** (`Space r r`). The program compiles and runs, and the output appears in a split.
6. `<leader>rc` closes the output. Edit and repeat.

**No `input.txt`?** The program reads from the keyboard. Click into the output split (or press `Ctrl-j` to move there), press `i`, type the input, and press `Ctrl-d` to signal end of input.

### A starter template

```cpp
#include <bits/stdc++.h>
using namespace std;

#ifdef LOCAL
#define dbg(x) cerr << #x << " = " << (x) << '\n'
#else
#define dbg(x)
#endif

void solve() {
  int n;
  cin >> n;
  vector<int> a(n);
  for (auto &x : a) cin >> x;

  dbg(n);  // printed only when you run locally
  cout << *max_element(a.begin(), a.end()) << '\n';
}

int main() {
  ios::sync_with_stdio(false);
  cin.tie(nullptr);
  int t = 1;
  // cin >> t;
  while (t--) solve();
}
```

`<leader>rr` compiles with `-DLOCAL`, so `dbg(...)` prints to stderr on your machine but disappears when you submit to an online judge.

## What the compile flags do for you

| Flag | Why it helps in DSA |
|------|---------------------|
| `-std=c++20` | modern features: `ranges::sort`, structured bindings `auto [a, b]`, `contains()`, etc. |
| `-O2` | same optimization level as most online judges |
| `-Wall -Wextra -Wshadow` | warns about unused variables, signed/unsigned comparisons, and a variable hiding another one (a classic bug) |
| `-fsanitize=address,undefined` | **catches out-of-bounds array access, use-after-free, and integer overflow at runtime**, with the exact line number, instead of silently giving a wrong answer |
| `-DLOCAL` | defines `LOCAL` so your debug-only code runs |

The binary is written to `/tmp/<name>`, so your folder stays clean.

**About sanitizers:** a program built with them runs about 2–3× slower and uses more memory. That's fine for samples. If a big stress test is too slow, compile it yourself in a terminal without them:

```bash
g++ -std=c++20 -O2 sol.cpp -o sol && ./sol < input.txt
```

### Reading a sanitizer error

```
sol.cpp:12:15: runtime error: index 5 out of bounds for type 'int [5]'
```

or

```
ERROR: AddressSanitizer: heap-buffer-overflow ...
    #0 in solve() sol.cpp:12
```

Go to that line (`:12`). You're reading past the end of an array or vector.

## Useful editor features while solving

| Want to... | Do |
|------------|----|
| see what a function or STL method takes | put the cursor on it and press `K` |
| see parameters while typing a call | `Ctrl-s` in Insert mode |
| jump to the next error | `]d`, then `<leader>d` to read it in full |
| rename a variable everywhere | `<leader>rn` |
| change everything inside `()` / `{}` | `ci(` / `ci{` |
| comment out a block | select with `V` + `j`... then `gc` |
| jump between matching brackets | `%` |
| compare against expected output | `<leader>sv` and open `expected.txt` beside your file |

## Per-folder settings (optional)

Want a different C++ standard or extra include paths for clangd? Put a `compile_flags.txt` in the folder, one flag per line:

```
-std=c++17
-Wall
```

Want a different formatting style? Put a `.clang-format` in the folder (or any parent folder):

```yaml
BasedOnStyle: Google
IndentWidth: 4
```

For CMake projects, clangd reads `build/compile_commands.json` automatically. Generate it with `cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`. The `programming/` folder in this repo is an example of that.

## Troubleshooting C++

| Problem | Fix |
|---------|-----|
| `'bits/stdc++.h' file not found` | check that `g++` is installed (`g++ --version`), then `<leader>rs` to restart clangd |
| red errors for valid C++20 code | a `compile_flags.txt` or `compile_commands.json` may be forcing an older standard |
| formatting does nothing | `:ConformInfo` shows whether clang-format is found. Install it with `:MasonInstall clang-format` |
| no completion or `K` docs | `:checkhealth vim.lsp` should list `clangd` as attached |
