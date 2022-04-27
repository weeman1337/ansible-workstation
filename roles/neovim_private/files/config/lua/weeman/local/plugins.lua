local _M = {}

_M.setup = function (use)

  use {
    "phpactor/phpactor",
    ft = { "php" },
    branch = "master",
    run = "composer install --no-dev -o"
  }

end

_M.lsp = function (lspconfig, capabilities)

  lspconfig.phpactor.setup{
    capabilities = capabilities,
    cmd = {
      "php8.1",
      os.getenv("HOME") .. "/.local/share/nvim/site/pack/packer/opt/phpactor/bin/phpactor",
      "language-server"
    }
  }

    lspconfig.arduino_language_server.setup{
      capabilities = capabilities,
      cmd = {
        "arduino-language-server",
        "-clangd",
        "clangd",
        "-fqbn",
        "arduino:avr:uno",
        "-cli", os.getenv("HOME") .. "/Apps/arduino-cli",
        "-cli-config", os.getenv("HOME") .. "/.arduino15/arduino-cli.yaml"
      }
    }

    lspconfig.clangd.setup{
      cmd = { "clangd", "--background-index" }
    }

end

return _M
