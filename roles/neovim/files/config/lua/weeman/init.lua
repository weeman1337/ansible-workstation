local project = require("weeman.project")

project.project_config.before_plugins()
require('weeman.plugins')

require('weeman.settings')
project.project_config.after_settings()
