local Path = require('plenary.path')

local project_name = string.gsub(vim.fn.getcwd(), "/", "_")

local config_dir = Path:new({ vim.fn.stdpath("config"), "projects" })
config_dir:mkdir({parents = true})

local config_file = Path:new({ config_dir, project_name .. ".lua" })

local cache_dir = Path:new({ vim.fn.stdpath("cache"), "projects", project_name })
cache_dir:mkdir({parents = true})

-- set up shada file
local project_shada = Path:new({ cache_dir, "main.shada" })
vim.o.shadafile = project_shada:absolute()

-- include project config
if (config_file:exists()) then
  dofile(config_file:absolute())
end

-- define edit command
 vim.api.nvim_create_user_command(
    'EditProjectConfig',
    function()
      vim.api.nvim_command("e " .. config_file:absolute())
    end,
    { nargs = 0 }
)

return {
  config_dir = config_dir,
  config_file = config_file,
  cache_dir = cache_dir,
  before_plugins = function() end,
  after_settings = function() end,
}
