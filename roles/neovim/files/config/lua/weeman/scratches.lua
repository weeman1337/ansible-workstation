local Path = require('plenary.path')

local M = {}

local project_scratches_path = Path:new(vim.env.PWD, '.vim', 'scratches')
local absolute_project_scratches_path = project_scratches_path:absolute()

local global_scratches_path = Path:new({vim.fn.stdpath("data"), 'scratches'})
local absolute_global_scratches_path = global_scratches_path:absolute()

M.telescope_find = function()
    local opts = {
        search_dirs = {
            absolute_project_scratches_path,
            absolute_global_scratches_path
        },
    }

    require('telescope.builtin').find_files(opts)
end

M.telescope_live_grep = function()
    local opts = {
        search_dirs = {
            absolute_project_scratches_path,
            absolute_global_scratches_path
        },
    }

    require('telescope.builtin').live_grep(opts)
end

M.create = function(scope, name)
    local path

    if scope == "global" then path = absolute_global_scratches_path
    else path = absolute_project_scratches_path
    end

    local scratch_path = Path:new({ path, name })

    if not scratch_path:exists() then
        scratch_path:touch({ parents = true })
    end

    vim.api.nvim_command("e " .. scratch_path:absolute())
end

M.create_prompt = function(scope)
    local name = vim.fn.input("Name: ")
    M.create(scope, name)
end

M.create_global = function()
    M.create_prompt("global")
end

M.create_project = function()
    M.create_prompt("project")
end

return M
