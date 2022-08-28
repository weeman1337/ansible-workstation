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

    use "puremourning/vimspector"

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
        "rcarriga/vim-ultest",
        requires = {"janko/vim-test"},
        run = ":UpdateRemotePlugins",
        config = function()
        end
    }

    use {
      "RRethy/vim-illuminate",
      config = function()
        vim.g.Illuminate_delay = 250
        vim.g.Illuminate_ftblacklist = {"nerdtree"}

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

    --use {
      --"nvim-treesitter/nvim-treesitter",
      --requires = {
        --"nvim-treesitter/playground",
      --},
      --run = ':TSUpdate',
      --config = function()
        --require'nvim-treesitter.configs'.setup {
          --ensure_installed = "all",
          --highlight = {
						--enable = true
					--},
          --playground = {
            --enable = true,
            --disable = {},
            --updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            --persist_queries = false, -- Whether the query persists across vim sessions
            --keybindings = {
              --toggle_query_editor = 'o',
              --toggle_hl_groups = 'i',
              --toggle_injected_languages = 't',
              --toggle_anonymous_nodes = 'a',
              --toggle_language_display = 'I',
              --focus_language = 'f',
              --unfocus_language = 'F',
              --update = 'R',
              --goto_node = '<cr>',
              --show_help = '?',
            --},
          --}
        --}
      --end
    --}

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip"
        },
        config = function()
            local cmp = require'cmp'
            cmp.setup({
                completion = {
                    completeopt = 'menu,menuone,noinsert',
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
                    { name = "nvim_lsp" },
                    {
                        name = "buffer",
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
                    { name = "path" },
                    { name = "vsnip" }
                }
            })
        end
    }

    use {
        'neovim/nvim-lspconfig',
        requires = {
          "ray-x/lsp_signature.nvim",
        },
        config = function ()
            local lspconfig = require("lspconfig")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local home = os.getenv("HOME")

            require "lsp_signature".setup({
              hint_enable = false,
            })

            capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

            --lspconfig.tlsp.setup{
                --capabilities = capabilities
            --}

            local lua_runtime_path = vim.split(package.path, ';')
            table.insert(lua_runtime_path, "lua/?.lua")
            table.insert(lua_runtime_path, "lua/?/init.lua")

            require'lspconfig'.ansiblels.setup{
              capabilities=capabilities,
            }

            require'lspconfig'.sumneko_lua.setup {
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
                            }

                        }
                    }
                }
            }

            lspconfig.dockerls.setup{
                capabilities = capabilities
            }

            lspconfig.html.setup {
              capabilities = capabilities,
              filetypes = { "hbs", "html", "phtml" }
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
         'glepnir/galaxyline.nvim',
         branch = "main",
         config = function() require'weeman.statusline' end,
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

        null_ls.setup({
          debounce = 1000,
          debug = true,
          sources = {
            wrap(null_ls.builtins.diagnostics.phpcs, "./vendor/bin/phpcs"),
            wrap(null_ls.builtins.diagnostics.stylelint, "./node_modules/.bin/stylelint"),
            wrap(null_ls.builtins.diagnostics.phpstan, "./vendor/bin/phpstan", {
              to_temp_file = false,
              method = DIAGNOSTICS_ON_SAVE,
            }),
            wrap(null_ls.builtins.diagnostics.eslint, "./node_modules/.bin/eslint"),
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
                "markdown",
                "php",
                "typescript",
              },
              diagnostics_postprocess = function(diagnostic)
                diagnostic.severity = vim.diagnostic.severity["INFO"]
              end
            }),
          }
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

            telescope.setup {
              defaults = {
                mappings = {
                  i = {
                    ["<CR>"] = actions.select_default + actions.center
                  },
                  n = {
                    ["<CR>"] = actions.select_default + actions.center
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

    use "preservim/nerdcommenter"

    use "Xuyuanp/nerdtree-git-plugin"

    use {
        'kyazdani42/nvim-tree.lua',
        commit = '3f4ed9b6c2598ab8304186486a05ae7a328b8d49',
        requires = {
          'kyazdani42/nvim-web-devicons',
        },
        config = function()
          require'nvim-tree'.setup {
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
        "tiagofumo/vim-nerdtree-syntax-highlight",
        config = function()
            vim.g.NERDTreeWinSize = 40
            vim.g.NERDTreeMinimalUI = 1
            vim.g.NERDTreeExtensionHighlightColor = {
                yml = "#888888"
            }
        end
    }

    use {
        "iamcco/markdown-preview.nvim",
        run = "cd app && yarn install"
    }

    use { "rodjek/vim-puppet" }

    for _, module in pairs(require("weeman.modules")) do
      if module.packer_setup ~= nil then module.packer_setup(use) end
    end

    if PACKER_BOOTSTRAP then
      require('packer').sync()
    end
end)
