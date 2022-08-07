local M = {}

M.lspconfig = function (lspconfig, capabilities)

    lspconfig.rust_analyzer.setup{
      capabilities = capabilities,
    }

end

return M
