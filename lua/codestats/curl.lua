local function curl(key, version, url,payload)
	local cmd = { 
		'curl',
		'--header', 'Content-Type: application/json',
		'--header', 'X-API-Token: ' .. key,
		'--user-agent', 'codestats.nvim/' .. verison,
		'--data', payload,
		'--request', 'POST',
		'--silent',
		'--output', '/dev/null',
		'--write-out', '%{http_code}',
		url .. '/my/pulses'
	}

	return vim.fn.system(cmd)
end

return curl
