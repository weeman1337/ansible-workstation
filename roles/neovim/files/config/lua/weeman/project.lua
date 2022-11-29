local Path = require('plenary.path')

local project_aliases = {
  ["_home_michaelw_git_element_matrix-react-sdk"] = "matrix-org_matrix-react-sdk",
  ["_home_weeman_git_element_matrix-react-sdk"] = "matrix-org_matrix-react-sdk",
  ["_home_weeman_git_nextcloud_server"] = "nextcloud_server",
  ["_home_weeman_git_nextcloud_server_apps-extra_deck"] = "nextcloud_server",
}

local project_name = string.gsub(vim.fn.getcwd(), "/", "_")
project_name = project_aliases[project_name] or project_name

local config_dir = Path:new({ vim.fn.stdpath("config"), "projects" })
config_dir:mkdir({parents = true})

local config_file = Path:new({ config_dir, project_name .. ".lua" })

local cache_dir = Path:new({ vim.fn.stdpath("cache"), "projects", project_name })
cache_dir:mkdir({parents = true})

-- set up shada file
local project_shada = Path:new({ cache_dir, "main.shada" })
vim.o.shadafile = project_shada:absolute()

local project_config = {
  before_plugins = function () end,
  after_settings = function () end,
  other_mappings = {},
}

-- include project config
if (config_file:exists()) then
  project_config = vim.tbl_extend(
    "force",
    project_config,
    dofile(config_file:absolute()) or {}
  )
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
  project_config = project_config,
}
