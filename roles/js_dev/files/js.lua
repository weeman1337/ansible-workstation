local M = {}

M.lazy_plugins = {}

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

vim.g.doge_javascript_settings = {
  omit_redundant_param_types = 1,
}

return M
