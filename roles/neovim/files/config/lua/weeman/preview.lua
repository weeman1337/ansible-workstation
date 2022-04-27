local M = {}

M.toggle = function()
    if vim.bo.filetype == 'markdown' then
        vim.api.nvim_command('MarkdownPreviewToggle')
    end
end

return M
