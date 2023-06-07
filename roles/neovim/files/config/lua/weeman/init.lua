--project.project_config.before_plugins()

vim.o.termguicolors = true

require('weeman.plugins')

require('weeman.settings')

local project = require("weeman.project")
project.project_config.after_settings()
