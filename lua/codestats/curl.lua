local function curl(payload)
    local cmd = {
        "curl",
        "--header",
        "Content-Type: application/json",
        "--header",
        "X-API-Token: " .. CODESTATS_API_KEY,
        "--user-agent",
        "codestats.nvim/" .. CODESTATS_VERSION,
        "--data",
        payload,
        "--request",
        "POST",
        "--silent",
        "--output",
        "/dev/null",
        "--write-out",
        "%{http_code}",
        CODESTATS_API_URL .. "/my/pulses",
    }

    return vim.fn.system(cmd)
end

return curl
