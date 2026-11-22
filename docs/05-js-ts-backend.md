# 5. JavaScript / TypeScript (Node.js backend)

## What you get

| Feature | Tool | Works when... |
|---------|------|---------------|
| Type checking, completion, go-to-definition, rename, auto-imports | **ts_ls** (typescript-language-server) | always, best with a `tsconfig.json` or `jsconfig.json` |
| Lint errors in the editor and fixes via `<leader>ca` | **eslint** language server | the project has an ESLint config **and** `eslint` in `node_modules` |
| Format on save | **prettier** | always (uses the project's `.prettierrc` if present) |
| JSON validation and completion (package.json, tsconfig...) | **jsonls** | always |
| Syntax highlighting | Treesitter: javascript, typescript, tsx, jsdoc, json, yaml, dockerfile | always |
| Run the current file | `<leader>rr` → `node file` | |

## Setting up a new backend project

```bash
mkdir my-api && cd my-api
npm init -y
npm pkg set type=module                # use import/export syntax
npm i express
npm i -D typescript @types/node @types/express
npx tsc --init                         # creates tsconfig.json
nvim .
```

**Install `@types/node`.** Without it, TypeScript reports errors like `Cannot find name 'process'` or `Cannot find module 'node:fs'`.

### Recommended `tsconfig.json` for modern Node

```json
{
  "compilerOptions": {
    "target": "es2022",
    "module": "nodenext",
    "moduleResolution": "nodenext",
    "strict": true,
    "noEmit": true,
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "erasableSyntaxOnly": true,
    "skipLibCheck": true
  },
  "include": ["src"]
}
```

This setup lets Node run your `.ts` files directly, with no build step.

### Prettier (optional `.prettierrc`)

Prettier's defaults already match this config: 2 spaces, double quotes, semicolons. Add a `.prettierrc` only to change them:

```json
{ "singleQuote": true, "semi": true, "trailingComma": "all", "printWidth": 100 }
```

### ESLint (optional)

```bash
npm init @eslint/config@latest
```

After that, lint problems appear in the editor like type errors. `<leader>ca` on a problem offers fixes such as "Fix all auto-fixable problems".

## Running code

| Situation | How |
|-----------|-----|
| a quick script / one file | `<leader>rr` (runs `node file.js` / `node file.ts`) |
| your server with auto-restart | in a terminal: `node --watch src/server.ts`, or `npm run dev` |
| inside Neovim | `:term` opens a terminal (`i` to type, `Ctrl-\ Ctrl-n` to leave). Or `<leader>sv` then `:term` for a side terminal |
| with tmux | run the server in another pane. `Ctrl-h/j/k/l` moves between Neovim splits **and** tmux panes |

Example `package.json` scripts:

```json
"scripts": {
  "dev": "node --watch src/server.ts",
  "start": "node src/server.ts",
  "typecheck": "tsc"
}
```

### Running `.ts` directly with Node: the rules

Node 22.18+ / 23.6+ runs TypeScript by **stripping the types**. It does not type-check. Rules:

1. **Write the `.ts` extension in imports:** `import { db } from "./db.ts"`.
2. **Use only "erasable" TypeScript:** no `enum`, no `namespace`, no constructor parameter properties (`constructor(private x: number)`). Use `as const` objects instead of enums. The `erasableSyntaxOnly` option above makes the editor warn you about these.
3. Type errors **don't stop the program**. The editor shows them, and `npm run typecheck` (`tsc`) checks the whole project.

Need enums or decorators? Use `npx tsx src/server.ts` instead of `node`.

## Everyday editing

| Want to... | Do |
|------------|----|
| see a variable's type | `K` |
| jump to a function's definition (even in `node_modules`) | `gd`, back with `Ctrl-o` |
| find every usage of a function | `gR` |
| rename a function across files | `<leader>rn` |
| add a missing import | cursor on the red name, `<leader>ca` → "Add import from ..." |
| fix all ESLint problems | `<leader>ca` → "Fix all auto-fixable problems" |
| see all errors in the project | `<leader>xw` |
| search for a route like `"/users"` across the project | `<leader>fs` and type it |
| open a file by name | `<leader>ff` |
| change a function body | `ci{` |
| change arguments | `ci(` |
| wrap something in quotes / backticks | `ysiw"` / `` ysiw` `` |
| change `'` quotes to `"` | `cs'"` |
| comment out a route | `V`, select lines, `gc` |
| copy an import from another file | `yy` there, `p` here (works across files) |

## Troubleshooting JS/TS

| Problem | Fix |
|---------|-----|
| `Cannot find name 'process'`, `require`, or `node:fs` | `npm i -D @types/node` |
| errors still show after fixing tsconfig or installing packages | `<leader>rs` (restart LSP) |
| ESLint shows nothing | the project needs an ESLint config **and** a local install (`npm i -D eslint`). Check `:checkhealth vim.lsp` |
| formatting changed my quotes or indent | that's Prettier. Add a `.prettierrc` to change its rules |
| want to save **without** formatting | `:noautocmd w` |
| `ERR_UNKNOWN_FILE_EXTENSION ".ts"` | your Node is too old (check `node --version`, need 22.18+). Or use `npx tsx` |
| `ERR_MODULE_NOT_FOUND` for `./utils` | add the extension: `./utils.ts` (or `./utils.js` in JS) |
