vim.o.runtimepath = '~/.local/share/nvim/lazy/baleia.nvim/,' .. vim.o.runtimepath
require('baleia').setup({})

vim.o.runtimepath = '~/.local/share/nvim/lazy/onedarkpro.nvim/,' .. vim.o.runtimepath
require('onedarkpro').setup({})

vim.o.clipboard = 'unnamedplus'

vim.wo.number = true
vim.wo.relativenumber = true

vim.wo.wrap = false

vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.cursorline = true


-- hide command and statusline

vim.o.cmdheight = 0
vim.o.laststatus = 0


-- colours

local color = require("onedarkpro.helpers")
require("onedarkpro").setup({
  colors = {
    bg = "#f8f8f8",
    fg = "#2a2b33",
    black = "#2a2b33",
    gray = "#333333",
    red = "#de3d35",
    green = "#3e953a",
    yellow = "#a16207",
    blue = "#2f5af3",
    magenta = "#950095",
    cyan = "#0e7490",
    orange = "#c2410c",
    purple = "#6b21a8",
  },
  highlights = {
    DiagnosticUnderlineError = { sp = "${red}", style = "undercurl" },
    DiagnosticUnderlineWarn = { sp = "${yellow}", style = "undercurl" },
    DiagnosticUnderlineInfo = { sp = "${blue}", style = "undercurl" },
    DiagnosticUnderlineHint = { sp = "${cyan}", style = "undercurl" },
    GitSignsAdd = { fg = "${green}" },
    GitSignsChange = { fg = "${blue}" },
    GitSignsDelete = { fg = "${red}" },
    LineNr = { fg = color.lighten("#2a2b33", 40) },
    diffAdded = { fg = "${green}" },
    diffChanged = { fg = "${blue}" },
    diffRemoved = { fg = "${red}" },
    TelescopePreviewLine = { bg = color.lighten("#2a2b33", 66)},
    IblIndent = { fg = color.lighten("#000", 80) },
  },
  options = {
    cursorline = true,
  }
})

vim.o.background = "light"
vim.cmd 'colorscheme onelight'
