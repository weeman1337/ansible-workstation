local M = {}

M.packer_setup = function (use)

  use {
    "phpactor/phpactor",
    ft = { "php" },
    branch = "master",
    run = "composer install --no-dev -o"
  }

end


M.lspconfig = function (lspconfig, capabilities)

  lspconfig.phpactor.setup{
    capabilities = capabilities,
    cmd = {
      "php8.1",
      os.getenv("HOME") .. "/.local/share/nvim/site/pack/packer/opt/phpactor/bin/phpactor",
      "language-server"
    }
  }

end

return M
