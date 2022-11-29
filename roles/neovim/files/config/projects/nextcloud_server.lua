vim.o.expandtab = false

vim.g.vimspector_configurations = {
  ["Listen for XDebug"] = {
    adapter = "vscode-php-debug",
    filetypes = { "php" },
    configuration = {
      name = "Listen for XDebug",
      proxy = {
        key = "PHPSTORM",
      },
      type = "php",
      request = "launch",
      hostname = "192.168.21.1",
      port = 9003,
      stopOnEntry = false,
      pathMappings = {
        ["/var/www/html"] = vim.env.PWD,
      },
    },
  },
}
