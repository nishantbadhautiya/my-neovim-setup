-- VSCode-like hover: rest the mouse on a word and the LSP hover (type + docs)
-- pops up next to the pointer. Moving the mouse off the word closes it.
-- To read a long popup: scroll it with the mouse wheel, or click into it / press K
-- to put the cursor inside (then move with j/k, Ctrl-d/u; close with q or Esc).
local M = {}

local DELAY_MS = 400 -- how long the mouse must rest before the popup shows
local OPTS = {
	relative = "mouse",
	border = "rounded",
	max_width = 80,
	max_height = 20,
	focusable = true,
	focus = false,
	focus_id = "textDocument/hover", -- same id as K, so K jumps into this popup
	-- Neovim itself closes the popup when you leave to any window other than the popup
	close_events = { "CursorMoved", "CursorMovedI", "InsertEnter" },
}

local timer = assert(vim.uv.new_timer())
local float_win = nil -- the open hover window
local float_key = nil -- which word it belongs to: "buf:line:startcol"

local function in_float()
	return vim.api.nvim_win_get_config(0).relative ~= ""
end

-- forget a popup that was closed some other way (q, Esc, cursor moved...)
local function forget_closed()
	if float_win and not vim.api.nvim_win_is_valid(float_win) then
		float_win, float_key = nil, nil
	end
end

local function close()
	if float_win and vim.api.nvim_win_is_valid(float_win) then
		pcall(vim.api.nvim_win_close, float_win, true)
	end
	float_win, float_key = nil, nil
end

-- Put the popup next to the mouse pointer, fully on screen: below the pointer when
-- there is room, otherwise above it. (Neovim's own mouse placement measures the
-- space using the file line number instead of the screen row, so popups near the
-- bottom of the screen got cut off.)
local function place(win, mouse)
	local border = 2
	local top = vim.o.showtabline == 2 and 1 or 0 -- tab bar row
	local bottom = vim.o.lines - vim.o.cmdheight - (vim.o.laststatus > 0 and 1 or 0)
	local below = bottom - mouse.screenrow -- free rows under the pointer
	local above = mouse.screenrow - 1 - top -- free rows over the pointer
	local want = math.min(vim.api.nvim_win_text_height(win, {}).all, OPTS.max_height)

	local cfg = { relative = "editor", height = want }
	if below >= want + border or below >= above then
		cfg.anchor, cfg.row = "NW", mouse.screenrow -- 0-based: the row just under the pointer
		cfg.height = math.max(1, math.min(want, below - border))
	else
		cfg.anchor, cfg.row = "SW", mouse.screenrow - 1 -- the row just over the pointer
		cfg.height = math.max(1, math.min(want, above - border))
	end
	local width = vim.api.nvim_win_get_width(win)
	cfg.col = math.max(0, math.min(mouse.screencol - 1, vim.o.columns - width - border))
	vim.api.nvim_win_set_config(win, cfg)
end

-- Describe the word under the mouse, or nil if the mouse isn't over code.
local function word_under_mouse()
	local pos = vim.fn.getmousepos()
	if pos.winid == 0 or pos.line == 0 then
		return nil, pos
	end
	if pos.winid == float_win then
		return "float", pos
	end
	if vim.api.nvim_win_get_config(pos.winid).relative ~= "" then
		return nil, pos -- some other floating window
	end
	local buf = vim.api.nvim_win_get_buf(pos.winid)
	local text = vim.api.nvim_buf_get_lines(buf, pos.line - 1, pos.line, false)[1] or ""
	local col = pos.column - 1 -- 0-based byte index
	if col >= #text or not text:sub(col + 1, col + 1):match("[%w_]") then
		return nil, pos -- whitespace, punctuation, or past the end of the line
	end
	local start = col
	while start > 0 and text:sub(start, start):match("[%w_]") do
		start = start - 1
	end
	return { key = ("%d:%d:%d"):format(buf, pos.line, start), buf = buf, text = text, line = pos.line - 1, col = col },
		pos
end

local function show()
	if in_float() then
		return -- cursor is inside a popup: leave it alone
	end
	forget_closed()
	local word = word_under_mouse()
	if type(word) ~= "table" or word.key == float_key then
		return
	end
	if #vim.lsp.get_clients({ bufnr = word.buf, method = "textDocument/hover" }) == 0 then
		return
	end

	vim.lsp.buf_request_all(word.buf, "textDocument/hover", function(client)
		return {
			textDocument = { uri = vim.uri_from_bufnr(word.buf) },
			position = {
				line = word.line,
				character = vim.str_utfindex(word.text, client.offset_encoding, word.col, false),
			},
		}
	end, function(results)
		-- the mouse may have moved on while the server was answering
		local now = word_under_mouse()
		if type(now) ~= "table" or now.key ~= word.key then
			return
		end
		local lines = {}
		for _, res in pairs(results) do
			if res.result and res.result.contents then
				local md = vim.lsp.util.convert_input_to_markdown_lines(res.result.contents)
				if #md > 0 and not (#md == 1 and md[1] == "") then
					if #lines > 0 then
						table.insert(lines, "---")
					end
					vim.list_extend(lines, md)
				end
			end
		end
		if #lines == 0 then
			return
		end
		close()
		local buf, win = vim.lsp.util.open_floating_preview(lines, "markdown", OPTS)
		float_win, float_key = win, word.key
		pcall(place, win, vim.fn.getmousepos())
		vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, nowait = true, desc = "Close hover" })
	end)
end

local function on_mouse_move()
	if in_float() then
		timer:stop()
		return -- reading a popup: don't close it or open new ones
	end
	forget_closed()
	local word = word_under_mouse()
	-- close right away when the mouse leaves the hovered word (but not onto the popup)
	if float_win and word ~= "float" and (type(word) ~= "table" or word.key ~= float_key) then
		close()
	end
	timer:stop()
	if type(word) == "table" then
		timer:start(DELAY_MS, 0, vim.schedule_wrap(show))
	end
end

function M.setup()
	vim.o.mousemoveevent = true -- ask the terminal to report mouse movement
	vim.keymap.set("n", "<MouseMove>", on_mouse_move, { desc = "LSP hover under mouse" })
end

return M
