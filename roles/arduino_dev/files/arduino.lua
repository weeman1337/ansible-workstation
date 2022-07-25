local M = {}

M.lspconfig = function (lspconfig, capabilities)

    lspconfig.arduino_language_server.setup{
      capabilities = capabilities,
      cmd = {
        "arduino-language-server",
        "-clangd",
        "clangd",
        "-fqbn",
        "arduino:avr:nano",
        "-cli", "arduino-cli",
        "-cli-config", os.getenv("HOME") .. "/.arduino15/arduino-cli.yaml"
      }
    }

end

return M
