local request = require("codestats.curl")
local languages = require("codestats.languages")

local M = {}

local xp_table = {}
local curr_xp = 0

local base = {
    version = "0.3.0",
    url = "https://codestats.net/api",
}

M.gather_xp = function(filetype, xp_amount)
    if filetype:gsub("%s+", "") == "" then
        filetype = "plain_text"
    end

    xp_table[filetype] = (xp_table[filetype] or 0) + xp_amount
    curr_xp = xp_table[filetype]
end

M.pulse = function(quit)
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

    if quit then
        request.curl(M.config.key, M.config.version, M.config.url, payload)
        return
    end

    local response = request.curl(M.config.key, M.config.version, M.config.url, payload)

    if response:sub(1, 1) == "2" then
        xp_table = {}
        curr_xp = 0
    end
end

M.current_xp = function()
    return curr_xp
end

M.current_xp_formatted = function()
    return "CS::" .. tostring(curr_xp)
end

M.setup = function(options)
    local codestats_api_key = vim.env.CODESTATS_API_KEY or options.key
    if codestats_api_key == nil then
        vim.cmd('echo "codestats.nvim: Please set $CODESTATS_API_KEY environment variable or set it in the config!"')
        return
    end
    local username = vim.env.CODESTATS_USERNAME or options.username
    if username == nil then
        vim.cmd('echo "codestats.nvim: Please set $CODESTATS_USERNAME environment variable or set it in the config!"')
        return
    end

    local opts = {
        key = codestats_api_key,
        username = username,
    }

    M.config = vim.tbl_extend("force", base, opts)

    M.startup()
end

M.print = function()
    for filetype, xp in pairs(xp_table) do
        print(filetype, xp)
    end
end

M.fetch = function()
    curl.fetch(M.config.version, M.config.url, M.config.username)
end

M.startup = function()
    local codestats_group = vim.api.nvim_create_augroup("codestats", { clear = true })

    vim.api.nvim_create_autocmd("VimLeavePre", {
        group = codestats_group,
        callback = function()
            M.pulse(true)
        end,
    })

    vim.api.nvim_create_autocmd({ "InsertCharPre", "TextChanged" }, {
        group = codestats_group,
        callback = function()
            M.gather_xp(vim.api.nvim_buf_get_option(0, "filetype"), 1)
        end,
    })
    -- Not sure if needed
    --    vim.api.nvim_create_autocmd({ "BufWrite", "BufLeave" }, {
    --        group = codestats_group,
    --        callback = function()
    --            M.pulse(false)
    --        end,
    --    })
end

return M
