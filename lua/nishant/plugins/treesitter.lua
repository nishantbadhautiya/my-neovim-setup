-- nvim-treesitter `main` branch (the rewrite for Neovim 0.12+).
-- The plugin only installs parsers and queries; highlighting itself is built into Neovim.
-- Requires the `tree-sitter` CLI (Arch: `sudo pacman -S tree-sitter-cli`) and a C compiler.
local parsers = {
	-- C++ (DSA)
	"c",
	"cpp",
	-- JS/TS backend
	"javascript",
	"typescript",
	"tsx",
	"jsdoc",
	"json",
	"yaml",
	"dockerfile",
	-- web
	"html",
	"css",
	-- misc
	"bash",
	"python",
	"lua",
	"luadoc",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline", -- also used to render LSP hover popups
	"gitignore",
	"regex",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- the main branch does not support lazy-loading
		build = ":TSUpdate",
		config = function()
			-- installs missing parsers in the background (no-op if already installed)
			require("nvim-treesitter").install(parsers)

			-- enable treesitter highlighting for every filetype that has a parser
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})

			-- Indentation intentionally uses Neovim's built-in filetype indenters
			-- (treesitter indent is still experimental on the main branch).

			-- Grow/shrink selection by syntax node, using Neovim 0.12's built-in `an` / `in`
			vim.keymap.set("n", "<C-space>", "van", { remap = true, desc = "Start selecting syntax nodes" })
			vim.keymap.set("x", "<C-space>", "an", { remap = true, desc = "Grow selection to parent node" })
			vim.keymap.set("x", "<BS>", "in", { remap = true, desc = "Shrink selection to child node" })
		end,
	},
	{
		"windwp/nvim-ts-autotag", -- auto close/rename html/jsx tags
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
}
