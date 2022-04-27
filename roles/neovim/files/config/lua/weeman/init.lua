vim.o.runtimepath = vim.o.runtimepath .. ',' .. os.getenv("HOME") .. '/.config/nvim_local'

require('weeman.plugins')
require('weeman.settings')

local Path = require('plenary.path')

local function setup_shadafile()
  local project_shada_dir = Path:new({ vim.g.wee_project_dir, 'shada' })
  project_shada_dir:mkdir({parents = true})
  local project_shada_file = Path:new({ project_shada_dir, 'main.shada' })
  vim.o.shadafile = project_shada_file:absolute()
end

local function include_project_init()
  local project_init_file = Path:new({ vim.g.wee_project_dir, "init.lua" })
  if (project_init_file:exists()) then
    dofile(project_init_file:absolute())
  end
end

local project_dir = Path:new({ vim.fn.stdpath("data"), "projects", string.gsub(vim.fn.getcwd(), "/", "_") .. "" })
project_dir:mkdir({parents = true})
vim.g.wee_project_dir = project_dir:absolute()
vim.g.wee_has_project_dir = true

setup_shadafile()
include_project_init()
