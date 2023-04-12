local _M = {}

vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
  },
  callback = function ()
    vim.b.splitjoin_trailing_comma = 1;
  end
})

_M.other_mappings = {
  {
    pattern = "/src/(.*).ts(x?)",
    target = "/test/%1-test.ts%2",
    context = "test",
  },
  {
    pattern = "/test/(.*)-test.ts(x?)",
    target = "/src/%1%.ts%2",
    context = "source",
  },
}

_M.format_on_save = {
  javascript = true,
  javascriptreact = true,
  markdown = true,
  typescript = true,
  typescriptreact = true,
}

vim.g.vimspector_configurations = {
  ["Jest current file"] = {
    adapter = "vscode-node",
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    configuration = {
      name = "Jest current file",
      type = "node",
      request = "launch",
      program = "${workspaceFolder}/node_modules/.bin/jest",
      args = { "${fileBasenameNoExtension}" }
    },
  },
}

return _M
