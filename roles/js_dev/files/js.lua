local M = {}

M.packer_setup = function (use)
end

M.lspconfig = function (lspconfig, capabilities)
  lspconfig.tsserver.setup{
    capabilities = capabilities,
    on_attach = function (client, bufnr)
      if client.name == "tsserver" then
        client.server_capabilities.documentFormattingProvider = false
      end
    end
  }
end

return M
