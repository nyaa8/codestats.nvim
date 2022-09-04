local cmd = api.nvim_command

local languages = require("codestats.languages")
local curl = require("codestats.curl")

local codestats = {}

local opts = {
    version = "0.3.0",
    url = "https://codestats.net/api",
}

local xp_table = {}
local curr_xp = 0

function codestats.gather_xp(filetype, xp_amount)
    if filetype:gsub("%s+", "") == "" then
        filetype = "plain_text"
    end

    xp_table[filetype] = (xp_table[filetype] or 0) + xp_amount
    curr_xp = xp_table[filetype]
end

function codestats.pulse()
    if next(xp_table) == nil then
        return
    end

    local time = os.date("%Y-%m-%dT%T%z")
    local payload = '{ "coded_at": "' .. time .. '", "xps": ['
    local xp_t = '{ "language": "%s", "xp": %d },'
    local payload_end = "]}"

    for filetype, xp in pairs(xp_table) do
        payload = payload .. string.format(xp_t, languages[filetype] or filetype, xp)
    end

    payload = payload:sub(1, -2) .. payload_end

    local response = curl(M.config["key"], M.config["version"], M.config["url"], payload)

    if response:sub(1, 1) == "2" then
        xp_table = {}
        curr_xp = 0
    end
end

function codestats.current_xp()
    return curr_xp
end

function current_xp_formatted()
    return "CS::" .. tostring(curr_xp)
end

function codestats.setup(options)
    local codestats_api_key = vim.env.CODESTATS_API_KEY or options["key"]
    if codestats_api_key == nil then
        vim.cmd('echo "codestats.nvim: Please set $CODESTATS_API_KEY environment variable!"')
        return
    end
    local username = vim.env.CODESTATS_USERNAME or options["username"]
    if username == nil then
        vim.cmd('echo "codestats.nvim: Please set $CODESTATS_USERNAME environment variable or set it in the config!"')
        return
    end

    local set_opts = {
        key = codestats_api_key,
        username = username,
    }
    opts = vim.tbl_extend("force", opts, set_opts)
    cmd([[  augroup codestats ]])
    cmd([[  autocmd! ]])
    cmd([[  autocmd InsertCharPre,TextChanged : lua require('codestats').gather_xp() ]])
    cmd([[  autocmd VimLeavePre : lua require('codestats').pulse() ]])
    cmd([[  autocmd BufWrite,BufLeave : lua require('codestats').pulse() ]])
    cmd([[  augroup END ]])
end

return codestats
