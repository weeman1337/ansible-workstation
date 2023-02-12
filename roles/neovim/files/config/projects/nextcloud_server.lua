local _M = {}

_M.after_settings = function ()
	-- force tabs everywhere
	vim.o.expandtab = false
	vim.api.nvim_create_autocmd({"FileType"}, {
		pattern = "*",
		callback = function ()
			vim.o.expandtab = false
		end
	});
end

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

return _M
