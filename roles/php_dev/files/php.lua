local M = {}

M.lazy_plugins = {
  {
    "phpactor/phpactor",
    ft = { "php" },
    tag = "2023.01.21",
    build = "composer install --no-dev -o"
  },

  { "nelsyeung/twig.vim" }
}


M.lspconfig = function(lspconfig, capabilities)
  lspconfig.phpactor.setup {
    capabilities = capabilities,
    cmd = {
      "php8.1",
      os.getenv("HOME") .. "/.local/share/nvim/site/pack/packer/opt/phpactor/bin/phpactor",
      "language-server"
    }
  }
end

return M
