local languages = require("codestats.languages")
local curl = require("codestats.curl")

CODESTATS_VERSION = "0.2.0"
CODESTATS_API_URL = vim.env.CODESTATS_API_URL or "https://codestats.net/api"
CODESTATS_API_KEY = vim.env.CODESTATS_API_KEY

local xp_table = {}

local function gather_xp(filetype, xp_amount)
	if filetype:gsub("%s+","") == "" then
		filetype = "plain_text"
	end

	xp_table[filetype] = (xp_table[filetype] or 0) + xp_amount
end

local function pulse()
	if #CODESTATS_API_KEY == 0 then
		vim.cmd('echo "codestats.nvim: Please set $CODESTATS_API_KEY environment variable!"')
		return
	end

	if next(xp_table) == nil then
		return
	end

	local time = os.date("%Y-%m-%dT%T%z")
	local payload = '{ "coded_at": "' .. time .. '", "xps": ['
	local xp_t = '{ "language": "%s", "xp": %d },'
	local payload_end = ']}'


	for filetype,xp in pairs(xp_table) do
		payload = payload .. string.format(xp_t, languages[filetype] or filetype, xp)
	end

	payload = payload:sub(1, -2) .. payload_end

	local response = curl(payload)

	if response:sub(1,1) == "2" then
		xp_table = {}
	end
end

return {
	pulse = pulse,
	gather_xp = gather_xp,
	CODESTATS_VERSION = CODESTATS_VERSION,
	CODESTATS_API_URL = CODESTATS_API_URL,
	CODESTATS_API_KEY = CODESTATS_API_KEY,
}
