return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header to display "NISHANT"
		dashboard.section.header.val = {
			"                                                     ",
			"  ███╗   ██╗██╗███████╗██╗  ██╗ █████╗ ███╗   ██╗████████╗",
			"  ████╗  ██║██║██╔════╝██║  ██║██╔══██╗████╗  ██║╚══██╔══╝",
			"  ██╔██╗ ██║██║███████╗███████║███████║██╔██╗ ██║   ██║   ",
			"  ██║╚██╗██║██║╚════██║██╔══██║██╔══██║██║╚██╗██║   ██║   ",
			"  ██║ ╚████║██║███████║██║  ██║██║  ██║██║ ╚████║   ██║   ",
			"  ╚═╝  ╚═══╝╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ",
			"                                                     ",
		}
		-- Apply color (red) to the header text using a highlight group
		-- dashboard.section.header.opts = {
		--   hl = "NishantHeader",
		-- }
		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
			dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
			dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Define the highlight group for "NISHANT" text (color red)
		-- vim.api.nvim_set_hl(0, "NishantHeader", { fg = "#ff0000" })  -- Red color

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
