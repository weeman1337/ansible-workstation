local h = require("weeman.helpers")

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function (use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup{}
      end
    }

    use "simnalamburt/vim-mundo"

    use {
      "tpope/vim-fugitive",
      requires = {
        { "tpope/vim-rhubarb" },
      }
    }

    use "tpope/vim-abolish"

    use {
      "puremourning/vimspector",
      config = function ()
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
    }

    use "mechatroner/rainbow_csv"

    use "svermeulen/vim-cutlass"

    use "alvan/vim-closetag"

--    use "svermeulen/vim-yoink"

    use "maxmellon/vim-jsx-pretty"

    use {
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
    }

    use "tpope/vim-surround"

    use {
        "kkoomen/vim-doge",
        run = ":call doge#install()",
        config = function()
            vim.g.doge_mapping = "<leader>gd"
            vim.g.doge_php_settings = {
                resolve_fqn = 0
            }
        end
    }

    use {
        "liuchengxu/vista.vim",
        config = function()
            vim.g.vista_default_executive = "nvim_lsp"
        end
    }

    use {
      "RRethy/vim-illuminate",
      config = function()
        vim.g.Illuminate_delay = 250
        vim.g.Illuminate_ftblacklist = {"NvimTree"}

        vim.api.nvim_exec([[
          augroup illuminate_augroup
              autocmd!
              autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline
          augroup END
        ]], false)
      end
    }

    use {
        "Th3Whit3Wolf/one-nvim",
        rtp = "vim/",
        config = function()
            vim.cmd 'colorscheme one-nvim'
            vim.o.background = "light"
            vim.api.nvim_exec(
            [[
                highlight CmpItemAbbr guifg=#555555
                highlight link LspSignatureActiveParameter Search
            ]], false)
        end
    }

    use {
        "airblade/vim-gitgutter",
        config = function()
            vim.api.nvim_exec(
            [[
                highlight clear SignColumn
                highlight GitGutterAdd    guifg=#009900 ctermfg=2
                highlight GitGutterChange guifg=#bbbb00 ctermfg=3
                highlight GitGutterDelete guifg=#ff2222 ctermfg=1
            ]], false)

            vim.g.gitgutter_sign_removed = "-"
        end
    }

    use {
      "nvim-treesitter/nvim-treesitter",
      requires = {
        "nvim-treesitter/playground",
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
      run = ':TSUpdate',
      config = function()
        require'nvim-treesitter.configs'.setup {
          ensure_installed = {
            "javascript",
            "lua",
            "markdown",
            "typescript",
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
    }

    use {
        "hrsh7th/nvim-cmp",
        requires = {
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-vsnip",
          "hrsh7th/vim-vsnip",
        },
        config = function()
            local cmp = require'cmp'
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
                      max_item_count = 10,
                    },
                    {
                      name = "buffer",
                      max_item_count = 10,
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
                      name = "path",
                      max_item_count = 10,
                    },
                    {
                      name = "vsnip",
                      max_item_count = 10,
                    },
                    { name = 'nvim_lsp_signature_help' },
                }
            })
        end
    }

    use {
        'neovim/nvim-lspconfig',
        --requires = {
          --"ray-x/lsp_signature.nvim",
        --},
        config = function ()
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

            require'lspconfig'.ansiblels.setup{
              capabilities=capabilities,
            }

            require'lspconfig'.lua_ls.setup {
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
                    globals = {'vim'},
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

            lspconfig.pylsp.setup{
                capabilities = capabilities
            }

            lspconfig.jsonls.setup{
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
                        }
                    }
                }
            }

            lspconfig.dockerls.setup{
                capabilities = capabilities
            }

            lspconfig.html.setup {
              capabilities = capabilities,
              filetypes = { "hbs", "html", "phtml", "html.twig" }
            }

            lspconfig.cssls.setup {
                capabilities = capabilities
            }

            for _, module in pairs(require("weeman.modules")) do
              if module.lspconfig ~= nil then module.lspconfig(lspconfig, capabilities) end
            end
        end
    }

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      config = function ()
        require('lualine').setup {
          options = {
            icons_enabled = true,
            theme = 'onedark',
            component_separators = '|',
            section_separators = '',
          },
        }
      end
    }

    use {
      "jose-elias-alvarez/null-ls.nvim",
      requires = {
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

          for k,v in pairs(extra_opts) do opts[k] = v end

          return builtin.with(opts)
        end

        local home = os.getenv("HOME")
        local lsp_formatting_autogroup = vim.api.nvim_create_augroup("LspFormatting", {})

        null_ls.setup({
          debounce = 1000,
          debug = false,
          sources = {
            wrap(null_ls.builtins.diagnostics.phpcs, "./vendor/bin/phpcs"),
            wrap(null_ls.builtins.diagnostics.stylelint, "./node_modules/.bin/stylelint"),
            wrap(null_ls.builtins.diagnostics.phpstan, "./vendor/bin/phpstan", {
              to_temp_file = false,
              method = DIAGNOSTICS_ON_SAVE,
            }),
            null_ls.builtins.diagnostics.eslint_d,
            null_ls.builtins.formatting.eslint_d,
            null_ls.builtins.formatting.prettierd,
            null_ls.builtins.diagnostics.cspell.with({
              args = function(params) return {
                "--config",
                home .. "/.config/cspell/cspell.yml",
                "--language-id",
                params.ft,
                "stdin",
              }
            end,
              filetypes = {
                "javascript",
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
    }

    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    use {
      "andythigpen/nvim-coverage",
      requires = {
        { 'nvim-lua/plenary.nvim' },
      },
      config = function ()
        require("coverage").setup({
          signs = {
            covered = {
              hl = "CoverageCovered", text = "█",
              priority = 100,
            },
            partial = {
              hl = "CoveragePartial", text = "█",
              priority = 100,
            },
            uncovered = {
              hl = "CoverageUncovered", text = "█",
              priority = 100,
            },
          },
        })
      end
    }


    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-lua/popup.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim' },
        { "nvim-telescope/telescope-live-grep-args.nvim" },
      },
      config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local lga_actions = require("telescope-live-grep-args.actions")

        telescope.setup {
          defaults = {
            path_display = {"truncate"},
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
  }

    use {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require'colorizer'.setup()
        end
    }

    use {
        "lukas-reineke/indent-blankline.nvim",
        after="one-nvim",
        config = function()
            vim.g.indent_blankline_char = "▏"
            vim.g.indent_blankline_show_first_indent_level = false
        end
    }

    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end
    }

    use {
      'kyazdani42/nvim-tree.lua',
      requires = {
        'kyazdani42/nvim-web-devicons',
      },
      config = function()
        require'nvim-tree'.setup {
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
    }

    use {
        "iamcco/markdown-preview.nvim",
        run = "cd app && yarn install"
    }

    use { "rodjek/vim-puppet" }
    use { "AndrewRadev/splitjoin.vim" }

    use {
      "rgroli/other.nvim",
      config = function ()
        local project_config = require("weeman.project").project_config
        require("other-nvim").setup({
          mappings = project_config.other_mappings,
        })
      end
    }

    for _, module in pairs(require("weeman.modules")) do
      if module.packer_setup ~= nil then module.packer_setup(use) end
    end

    if PACKER_BOOTSTRAP then
      require('packer').sync()
    end
  end)
