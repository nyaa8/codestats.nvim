local health = vim.health
local env = vim.env

local M = {}

local function check_setup()
    local opts = {}

    local codestats_api_key = env.CODESTATS_API_KEY
    if codestats_api_key == nil then
        table.insert(opts, "key")
    end

    local username = env.CODESTATS_USERNAME
    if username == nil then
        table.insert(opts, "username")
    end

    return opts
end

local function contains(table, key)
    return table[key] ~= nil
end

local function empty(table)
    return next(table)
end

function M.check ()
    health.start("codestats report")

    local status = check_setup()

    if contains(status, "key") then
        health.error("Missing CODESTATS_API_KEY")
    end

    if contains(status, "username") then
        health.error("Setup is correct")
    end

    if empty(status) then
        health.ok("Setup is correct")
    end
end

return M
