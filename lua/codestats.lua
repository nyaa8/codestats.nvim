local curl = require("codestats.curl")
local languages = require("codestats.languages")

local M = {}

local base = {
    version = "0.3.0",
    url = "https://codestats.net/api",
}

M.setup = function(options)
    local codestats_api_key = vim.env.CODESTATS_API_KEY or options.key
    if codestats_api_key == nil then
        vim.cmd('echo "codestats.nvim: Please set $CODESTATS_API_KEY environment variable!"')
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

    for key, value in pairs(M.config) do
        print(key, value)
    end

    M.startup()
    --d”, {
    --	desc = 'Open non-Vim-readable files in system default applications.’,
    --		pattern = '*.png, *.jpg, *.gif, *.pdf, *.xls*, *.ppt, *.doc*, *.rtf',
    --			command =
    --} cmd([[  augroup codestats ]])
    -- cmd([[  autocmd! ]])
    -- cmd([[  autocmd InsertCharPre,TextChanged : lua require('codestats').gather_xp() ]])
    -- cmd([[  autocmd VimLeavePre : lua require('codestats').pulse() ]])
    -- cmd([[  autocmd BufWrite,BufLeave : lua require('codestats').pulse() ]])
    -- cmd([[  augroup END ]])
end

M.startup = function()
    local codestats_group = vim.api.nvim_create_augroup("codestats", { clear = true })
    vim.api.nvim_create_autocmd("VimLeavePre", {
        command = "print('this is a remove')",
        group = codestats_group,
    })

    vim.api.nvim_create_autocmd({"InsertCharPre","TextChanged"}, {
        command = "print('this insert')",
        group = codestats_group,
    })

    vim.api.nvim_create_autocmd({ "BufWrite", "BufLeave" }, {
        command = "print('this is a bufwrite/leave')",
        group = codestats_group,
    })
end

return M
