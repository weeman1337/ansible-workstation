local M = {}

M.lazy_plugins = {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
  }
}

M.lspconfig = function(lspconfig, capabilities)
  require("typescript-tools").setup({
    settings = {
      tsserver_plugins = {
        "typescript-plugin-css-modules",
      },
    },
    capabilities = capabilities,
    on_attach = function(client)
    end,
  });
end

vim.g.doge_javascript_settings = {
  omit_redundant_param_types = 1,
}

return M
