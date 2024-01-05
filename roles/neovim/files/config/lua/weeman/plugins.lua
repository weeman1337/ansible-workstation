local h = require("weeman.helpers")

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { 'nvim-lua/plenary.nvim' },

  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end
  },

  "simnalamburt/vim-mundo",

  {
    "tpope/vim-fugitive",
    dependencies = {
      { "tpope/vim-rhubarb" },
    }
  },

  "tpope/vim-abolish",

  {
    "puremourning/vimspector",
    config = function()
      vim.g.vimspector_configurations = {
        ["jest current file"] = {
          adapter = "vscode-node",
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
          configuration = {
            type = "node",
            request = "launch",
            name = "jest current file",
            program = "${cwd}/node_modules/.bin/jest",
            args = {
              "${fileBasenameNoExtension}",
            },
            console = "integratedTerminal",
          }
        }
      }
    end
  },

  "mechatroner/rainbow_csv",

  "svermeulen/vim-cutlass",

  "alvan/vim-closetag",

  --    use "svermeulen/vim-yoink"

  "maxmellon/vim-jsx-pretty",

  {
    "leafOfTree/vim-vue-plugin",
    config = function()
      vim.g.vim_vue_plugin_config = {
        syntax = {
          template = { "html" },
          script = { "javascript" },
          style = { "css", "scss", "sass" },
        },
        full_syntax = {},
        initial_indent = {},
        attribute = 0,
        keyword = 0,
        foldexpr = 0,
        debug = 0
      }
    end
  },

  "tpope/vim-surround",

  {
    "kkoomen/vim-doge",
    build = ":call doge#install()",
    config = function()
      vim.g.doge_mapping = "<leader>gd"
      vim.g.doge_php_settings = {
        resolve_fqn = 0
      }
    end
  },

  {
    "liuchengxu/vista.vim",
    config = function()
      vim.g.vista_default_executive = "nvim_lsp"
    end
  },

  {
    "RRethy/vim-illuminate",
    config = function()
      vim.g.Illuminate_delay = 250
      vim.g.Illuminate_ftblacklist = { "NvimTree" }

      vim.api.nvim_exec([[
          augroup illuminate_augroup
              autocmd!
              autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline
          augroup END
        ]], false)
    end
  },

  { "olimorris/onedarkpro.nvim" },

  "sindrets/diffview.nvim",

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        on_attach = function (bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', 'äc', function()
            if vim.wo.diff then return end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          map('n', 'öc', function()
            if vim.wo.diff then return end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          map('n', '<leader>gp', gs.preview_hunk)
          map('n', '<leader>gu', gs.reset_hunk)
        end
      })
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ':TSUpdate',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = {
          "bash",
          "css",
          "dockerfile",
          "gitattributes",
          "gitignore",
          "go",
          "javascript",
          "jsdoc",
          "json",
          "html",
          "ledger",
          "lua",
          "make",
          "markdown",
          "php",
          "python",
          "rust",
          "twig",
          "typescript",
          "scss",
          "vue",
          "yaml",
        },
        highlight = {
          enable = false,
        },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
            },
          },
        },
      }
    end
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "rasulomaroff/cmp-bufname",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      local cmp = require 'cmp'
      cmp.setup({
        completion = {
          completeopt = 'menuone,noinsert',
        },
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
          })
        }),
        sources = {
          {
            name = "nvim_lsp",
          },
          {
            name = "buffer",
            keyword_length = 3,
            option = {
              get_bufnrs = function()
                local buffers = vim.api.nvim_list_bufs()
                local retbufs = {}

                for key, bufno in pairs(buffers) do
                  local bufname = vim.api.nvim_buf_get_name(bufno)

                  if string.find(bufname, "NvimTree") then goto skip_buf end

                  -- skip files larger than 1 MiB
                  local byte_size = vim.api.nvim_buf_get_offset(bufno, vim.api.nvim_buf_line_count(bufno))
                  if byte_size > 1024 * 1024 then goto skip_buf end

                  table.insert(retbufs, bufno)

                  ::skip_buf::
                end

                return retbufs
              end
            }
          },
          {
            name = 'bufname'
          },
          {
            name = "path",
          },
          {
            name = "vsnip",
          },
          { name = 'nvim_lsp_signature_help' },
        }
      })

      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
        {
          { name = 'path' }
        },
        {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' }
            }
          }
        })
      })
    end
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neodev.nvim",
    },
    --dependencies = {
    --"ray-x/lsp_signature.nvim",
    --},
    config = function()
      require("neodev").setup()

      local lspconfig = require("lspconfig")
      local home = os.getenv("HOME")

      --require "lsp_signature".setup({
      --hint_enable = false,
      --})

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.completion = cmp_capabilities.textDocument.completion

      --lspconfig.tlsp.setup{
      --capabilities = capabilities
      --}

      local lua_runtime_path = vim.split(package.path, ';')
      table.insert(lua_runtime_path, "lua/?.lua")
      table.insert(lua_runtime_path, "lua/?/init.lua")

      require 'lspconfig'.ansiblels.setup {
        capabilities = capabilities,
      }

      require 'lspconfig'.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
              -- Setup your lua path
              path = lua_runtime_path,
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        }
      }

      lspconfig.pylsp.setup {
        capabilities = capabilities,
      }

      lspconfig.jsonls.setup {
        capabilities = capabilities,
        settings = {
          json = {
            schemas = {
              {
                fileMatch = { "composer.json" },
                url = "file://" .. home .. "/.local/share/json_schemas/composer.json"
              },
              {
                fileMatch = { "package.json" },
                url = "file://" .. home .. "/.local/share/json_schemas/package.json"
              },
              {
                fileMatch = { "tsconfig.json" },
                url = "file://" .. home .. "/.local/share/json_schemas/tsconfig.json"
              },
            },
          },
        },
      }

      lspconfig.yamlls.setup {
        capabilities = capabilities,
        settings = {
          json = {
            schemas = {
              ["file://" .. home .. "/.local/share/json_schemas/gitlab-ci.json"] = "*.gitlab-ci.yml",
            },
          },
        },
      }

      lspconfig.dockerls.setup {
        capabilities = capabilities
      }

      lspconfig.html.setup {
        capabilities = capabilities,
        filetypes = { "hbs", "html", "phtml", "html.twig", "htmldjango" }
      }

      lspconfig.cssls.setup {
        capabilities = capabilities
      }

      lspconfig.gopls.setup({
        capabilities = capabilities
      })

      for _, module in pairs(require("weeman.modules")) do
        if module.lspconfig ~= nil then module.lspconfig(lspconfig, capabilities) end
      end
    end
  },

  {
    "kyazdani42/nvim-web-devicons",
  },

  {
    "nvim-lualine/lualine.nvim",
    commit = "84ffb80e452d95e2c46fa29a98ea11a240f7843e",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("lualine").setup {
        options = {
          icons_enabled = true,
          -- theme = "onedark",
          component_separators = "|",
          section_separators = "",
        },
      }
    end
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      local null_ls = require("null-ls")
      local methods = require("null-ls.methods")
      local DIAGNOSTICS_ON_SAVE = methods.internal.DIAGNOSTICS_ON_SAVE

      local wrap = function(builtin, command, extra_opts)
        extra_opts = extra_opts or {}

        local opts = {
          command = command,
          condition = function()
            return vim.fn.executable(command) > 0
          end
        }

        for k, v in pairs(extra_opts) do opts[k] = v end

        return builtin.with(opts)
      end

      local home = os.getenv("HOME")
      local lsp_formatting_autogroup = vim.api.nvim_create_augroup("LspFormatting", {})

      null_ls.setup({
        debounce = 1000,
        debug = false,
        sources = {
          wrap(null_ls.builtins.diagnostics.phpcs, "./vendor/bin/phpcs"),
          wrap(null_ls.builtins.diagnostics.luacheck, "~/.luarocks/bin/luacheck"),
          wrap(null_ls.builtins.diagnostics.stylelint, "./node_modules/.bin/stylelint"),
          -- wrap(null_ls.builtins.diagnostics.phpstan, "./vendor/bin/phpstan", {
          --   to_temp_file = false,
          --   method = DIAGNOSTICS_ON_SAVE,
          -- }),
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.formatting.eslint_d,
          null_ls.builtins.formatting.phpcbf,
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.diagnostics.cspell.with({
            args = function(params)
              return {
                "--config",
                home .. "/.config/cspell/cspell.yml",
                "--language-id",
                params.ft,
                "stdin",
              }
            end,
            filetypes = {
              "javascript",
              "javascriptreact",
              "markdown",
              "php",
              "typescript",
              "typescriptreact",
              "yaml",
            },
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity["INFO"]
            end
          }),
        },
        on_attach = function(client, bufnr)
          local project_config = require("weeman.project").project_config
          if project_config.format_on_save[vim.bo[bufnr].filetype] and client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = lsp_formatting_autogroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = lsp_formatting_autogroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false, bufnr = bufnr })
              end,
            })
          end
        end,
      })
    end
  },

  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make' ,
  },

  {
    "andythigpen/nvim-coverage",
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      require("coverage").setup({
        signs = {
          covered = {
            hl = "CoverageCovered",
            text = "█",
            priority = 100,
          },
          partial = {
            hl = "CoveragePartial",
            text = "█",
            priority = 100,
          },
          uncovered = {
            hl = "CoverageUncovered",
            text = "█",
            priority = 100,
          },
        },
      })
    end
  },


  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim' },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        version = "^1.0.0",
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local lga_actions = require("telescope-live-grep-args.actions")

      telescope.setup {
        defaults = {
          path_display = { "truncate" },
          mappings = {
            i = {
              ["<CR>"] = actions.select_default + actions.center
            },
            n = {
              ["<CR>"] = actions.select_default + actions.center
            },
          },
        },
        extensions = {
          live_grep_args = {
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
              },
            },
          },
        },
      }

      telescope.load_extension("live_grep_args")
      telescope.load_extension("fzf")
    end
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require 'colorizer'.setup({
        scss = {
          rgb_fn = true,
        },
      })
    end
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    dependencies = { "onedarkpro.nvim" },
    config = function()
      require("ibl").setup( {
        indent = {
          char = "▏",
        },
        scope = {
          enabled = false,
        },
      })

      local hooks = require "ibl.hooks"
      hooks.register(
        hooks.type.WHITESPACE,
        hooks.builtin.hide_first_space_indent_level
      )
    end
  },

  {
    'm00qek/baleia.nvim',
    config = function()
      require('baleia').setup({})
    end
  },

  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  {
    'kyazdani42/nvim-tree.lua',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require 'nvim-tree'.setup {
        hijack_netrw = true,
        disable_netrw = false,
        view = {
          width = 40,
          number = true,
          relativenumber = true
        },
        git = {
          ignore = false
        }
      }
    end
  },

  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install"
  },

  { "rodjek/vim-puppet" },
  { "AndrewRadev/splitjoin.vim" },
  {
    "hkupty/iron.nvim",
    config = function()
      local iron = require("iron.core")
      iron.setup({
        config = {},
      })
    end
  },

  {
    "rgroli/other.nvim",
    config = function()
      local project_config = require("weeman.project").project_config
      require("other-nvim").setup({
        mappings = h.table_concat(
          project_config.other_mappings,
          {
            {
              pattern = "(.*)%.[jt]sx$",
              target = "%1.module.scss",
              context = "css",
            },
            {
              pattern = "(.*)%.module%.s?css$",
              target = "%1.tsx",
              context = "css",
            },
          }
        )
      })
    end
  },
}

for _, module in pairs(require("weeman.modules")) do
  if module.lazy_plugins ~= nil then
    for _, v in pairs(module.lazy_plugins) do
      table.insert(plugins, v);
    end
  end
end

return require("lazy").setup(plugins)
