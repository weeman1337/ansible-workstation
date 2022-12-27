local _M = {}

vim.g.vimspector_configurations = {
  ["jest current file"] = {
    adapter = "vscode-node",
    filetypes = { "javascript", "typescript" },
    configuration = {
      type = "node",
      request = "launch",
      name = "jest current file",
      program = "${cwd}/node_modules/.bin/jest",
      args = {
        "${fileBasenameNoExtension}",
      },
      console = "integratedTerminal",
    }
  }
}

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

return _M
