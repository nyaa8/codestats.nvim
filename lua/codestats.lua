local curl = require('codestats.curl')
local languages  = require('codestats.languages')
local cmd = api.nvim_command

local M = {}

local opts = {
    version = "0.3.0",
    url = "https://codestats.net/api",
}

function M.setup(options)
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

for key, value in pairs(opts) do
print(key, value)	
end

    opts = vim.tbl_extend("force", opts, set_opts)
    cmd([[  augroup codestats ]])
    cmd([[  autocmd! ]])
    cmd([[  autocmd InsertCharPre,TextChanged : lua require('codestats').gather_xp() ]])
    cmd([[  autocmd VimLeavePre : lua require('codestats').pulse() ]])
    cmd([[  autocmd BufWrite,BufLeave : lua require('codestats').pulse() ]])
    cmd([[  augroup END ]])
end

return M
