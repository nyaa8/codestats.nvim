local curl = require'plenary.curl'

local M = {}

M.fetch = function(version, url, username)

	local res = 	curl.get(        url .. "/users/" .. username,{
		accept = "application/json",
		headers = {
["Content-Type"]= "application/json"
		}
	})
return vim.json.decode(res.body)
end

M.curl = function(key, version, url, payload)
    local cmd = {
        "curl",
        "--header", "Content-Type: application/json",
        "--header", "X-API-Token: " .. key,
        "--user-agent", "codestats.nvim/" .. version,
        "--data", payload,
        "--request", "POST",
        "--silent",
        "--output", "/dev/null",
        "--write-out", "%{http_code}",
        url .. "/my/pulses",
    }

    return vim.fn.system(cmd)
end

return M




