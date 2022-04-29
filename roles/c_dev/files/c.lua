local M = {}

M.lspconfig = function (lspconfig, _)

    lspconfig.clangd.setup{
      cmd = { "clangd", "--background-index" }
    }

end

return M
