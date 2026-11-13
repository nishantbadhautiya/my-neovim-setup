return {
	"CRAG666/code_runner.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("code_runner").setup({
			-- commands by filetype
			filetype = {
				java = "cd $dir && javac $fileName && java $fileNameWithoutExt", -- Compiling and running Java
				python = "python3 -u $file", -- Running Python scripts
				typescript = "node $file", -- Node 22.18+/23.6+ runs .ts natively (type stripping)
				javascript = "node $file", -- Running Node.js for JavaScript
				c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt", -- C compilation and execution
				-- C++ (DSA): C++20, warnings + sanitizers for catching bugs; reads input.txt if present
				cpp = "cd $dir && g++ -std=c++20 -O2 -Wall -Wextra -Wshadow -DLOCAL -fsanitize=address,undefined $fileName -o /tmp/$fileNameWithoutExt"
					.. " && if [ -f input.txt ]; then /tmp/$fileNameWithoutExt < input.txt; else /tmp/$fileNameWithoutExt; fi",
				sh = "bash $file", -- Running Bash scripts
				rust = "cd $dir && rustc $fileName && ./$fileNameWithoutExt", -- Rust support
			},
		})

		-- Add keymaps for running the code
		local keymap = vim.keymap.set
		keymap("n", "<leader>rr", ":RunCode<CR>", { desc = "Run the current file" })
		keymap("n", "<leader>rf", ":RunFile<CR>", { desc = "Run current file" })
		keymap("n", "<leader>rft", ":RunFile tab<CR>", { desc = "Run current file in a new tab" })
		keymap("n", "<leader>rp", ":RunProject<CR>", { desc = "Run project" })
		keymap("n", "<leader>rc", ":RunClose<CR>", { desc = "Close the running output" })
	end,
}
