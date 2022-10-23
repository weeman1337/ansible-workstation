local project = require("weeman.project")

project.before_plugins()
require('weeman.plugins')

require('weeman.settings')
project.after_settings()
