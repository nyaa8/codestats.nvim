local curl = require("plenary.curl")

local M = {}

M.fetch = function(version, url, username)
    local res = curl.get(url .. "/users/" .. username, {
        accept = "application/json",
        headers = {
            ["Content-Type"] = "application/json",
        },
    })
    return vim.json.decode(res.body)
end

M.push = function(key, version, url, payload)
    local res = curl.post(url .. "/my/pulses", {
        accept = "application/json",
        headers = {
            ["Content-Type"] = "application/json",
            ["X-API-Token"] = key,
        },
        body = payload,
    })
    return vim.json.decode(res.body)
end

return M
