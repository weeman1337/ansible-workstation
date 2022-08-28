local M = {}

M.packer_setup = function (use)
end

M.lspconfig = function (lspconfig, capabilities)
  lspconfig.tsserver.setup{
    capabilities = capabilities
  }
end

return M
