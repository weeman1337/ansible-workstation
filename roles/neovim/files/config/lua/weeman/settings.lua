local Path = require('plenary.path')

local project = require("weeman.project")
local h = require("weeman.helpers")
local keymap = vim.keymap

vim.o.clipboard = 'unnamedplus'
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.wrap = false


-- Keep clipboard when pasting into visual selection

keymap.set("v", "p", "P")


-- save

vim.o.autowriteall = true
--vim.api.nvim_exec([[
    --au BufLeave * silent! wall
--]], false)


-- grep

vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"


-- tabs

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true


-- filetype aliases

vim.g.do_filetype_lua = 1

vim.filetype.add({
  extension = {
    hbs = "html",
    twig = "html.twig",
    pcss = "scss",
  },
  filename = {
    ["composer.lock"] = "json",
  },
  pattern = {
    [".-%.xml%.%a-"] = "xml",
    [".-%.php%.%a-"] = "php",
    [".-ansible.-/.-%.yml"] = "yaml.ansible",
  }
})


-- yoink

-- vim.g.yoinkSyncNumberedRegisters = 1
-- vim.g.yoinkIncludeDeleteOperations = 1


-- jump to last known cursor position on reopening a file

vim.api.nvim_command([[au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]])


-- divergent tab styles

local tab_sizes = {
  lua = 2,
  yaml = 2,
  NvimTree = 2,
}

tab_sizes = vim.tbl_extend(
  "force",
  tab_sizes,
  project.project_config.tab_sizes
)

for file_type, tab_size in pairs(tab_sizes) do
  vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = file_type,
    callback = function ()
      vim.opt_local.tabstop = tab_size
      vim.opt_local.softtabstop = tab_size
      vim.opt_local.shiftwidth = tab_size
    end
  })
end


-- trim whitespaces

local trim_whitespace_for = {
  css = true,
  javacript = true,
  javacriptreact = true,
  html = true,
  lua = true,
  php = true,
  python = true,
  scss = true,
  sh = true,
  typescript = true,
  typescriptreact = true,
  xml = true,
  yaml = true,
  ["yaml.ansible"] = true,
}

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function (opts)
    -- only trim whitespaces for filetypes in list
    if trim_whitespace_for[vim.bo[opts.buf].filetype] == nil then return end

    vim.api.nvim_command("%s/\\s\\+$//e")
  end
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {
    "*.twig",
  },
  command = "%s/\\s\\+$//e",
})


-- search

vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.splitbelow = true
vim.o.splitright = true

vim.g.mapleader = " "

vim.o.updatetime = 500
vim.o.shortmess = vim.o.shortmess .. "c"

vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.o.colorcolumn = "120"

vim.o.termguicolors = true

vim.o.undofile = true
local undodir = Path:new({ project.cache_dir, "undo" })
undodir:mkdir({ parents = true })
vim.o.undodir = undodir:absolute()

vim.o.comuleteopt = "menuone,noselect"


-- autosave

vim.api.nvim_create_autocmd({"FocusLost", "BufLeave"}, {
  pattern = "*",
  callback = function (args)
    -- do not auto save an empty buffer
    if (vim.fn.bufname(args.buf)) == "" then return end

    -- do not auto save readonly buffers
    if (vim.api.nvim_buf_get_option(args.buf, 'readonly')) then return end

    -- do not auto save non-modified buffers
    if (not vim.api.nvim_buf_get_option(args.buf, 'modified')) then return end

    -- only autosave in normal mode
    if vim.api.nvim_get_mode().mode ~= "n" then return end

    vim.api.nvim_command("w")
  end,
  nested = true,
})


-- help

vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = "help",
  callback = function ()
    keymap.set("n", "<CR>", "<C-]>", {buffer = true})
  end
})


-- vsnip

vim.g.vsnip_namespace = "snip"
vim.g.vsnip_filetypes = {
  ["html.twig.js.css"] = {
    "twig",
  },
  ["html.twig"] = {
    "twig",
  },
  ["twig"] = {
    "twig",
  },
  typescriptreact = {
    "js_test",
    "matrix_licence",
    "typescript",
  },
  typescript = {
    "js_test",
    "matrix_licence",
    "typescript",
  }
}
vim.g.vsnip_snippet_dirs = {
  os.getenv("HOME") .. "/.config/nvim/vsnip"
}


-- set title to cwd

vim.o.title = true
vim.o.titlestring = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")


-- terminal

keymap.set("t", "<C-w><C-n>", [[<C-\><C-n>]])


-- yank

keymap.set("n", "<leader>yfr", ':let @+ = fnamemodify(expand("%"), ":~:.")<CR>', {silent = true})


-- git

keymap.set("n", "<leader>gb", ":Git blame<CR>")
keymap.set("n", "<leader>gj", ":GitGutterNextHunk<CR>zz")
keymap.set("n", "<leader>gk", ":GitGutterPrevHunk<CR>zz")
keymap.set("n", "<leader>gp", ":GitGutterPreviewHunk<CR>")
keymap.set("n", "<leader>gq", ":GitGutterQuickFix<CR>")
keymap.set("n", "<leader>gs", ":Telescope git_status<CR>")
keymap.set("n", "<leader>gS", ":Git<CR> 20<C-w>_")
keymap.set("n", "<leader>gu", ":GitGutterUndoHunk<CR>")
keymap.set("n", "<leader>gy", ":.GBrowse!<CR>")
keymap.set("x", "<leader>gy", ":'<'>GBrowse!<CR>")


-- cut

keymap.set("n", "<leader>xs", "d")
keymap.set("x", "<leader>xs", "d")
keymap.set("n", "<leader>xx", "dd")
keymap.set("x", "<leader>xx", "dd")
keymap.set("n", "<leader>X", "D")


-- file browser

keymap.set("n", "<leader>sf", ":NvimTreeToggle<CR>")
keymap.set("n", "<leader>jf", ":NvimTreeFindFile<CR>zz")
keymap.set("n", "<leader>jo", ":Other<CR>")


-- quickfix navigation

keymap.set("n", "<C-j>", ":cnext<CR>zz")
keymap.set("n", "<C-k>", ":cprev<CR>zz")


-- run


-- location list navigation

keymap.set("n", "<C-S-j>", ":lnext<CR>zz")
keymap.set("n", "<C-S-k>", ":lprev<CR>zz")


-- tools

keymap.set("n", "<leader>tc", ":Coverage<CR>")
keymap.set("n", "<leader>tp", ":lua require('weeman.preview').toggle()<CR>")
keymap.set("n", "<leader>ts", "Vi{:sort<CR>")


-- sidebars

vim.g.mundo_right = 1
keymap.set("n", "<leader>su", ":Vista!<CR> :MundoToggle<CR>")
keymap.set("n", "<leader>ss", ":MundoHide<CR> :Vista!!<CR>")
keymap.set("n", "<leader>sc", ":Vista!<CR> :MundoHide<CR> :NvimTreeClose<CR>")


-- diagnostics

local sw = {
  min = vim.diagnostic.severity.WARN,
  max = vim.diagnostic.severity.ERROR,
}

keymap.set("n", "<leader>dq", function ()
  vim.diagnostic.setqflist({
    severity = sw,
  })
end);
keymap.set("n", "<leader>dj", function ()
  vim.diagnostic.goto_next({
    severity = sw,
    float = false,
  })
  vim.cmd(":normal! zz")
end)
keymap.set("n", "<leader>dk", function ()
  vim.diagnostic.goto_prev({
    severity = sw,
    float = false,
  })
  vim.cmd(":normal! zz")
end)
keymap.set("n", "<leader>ds", function ()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

  local diagnostics = vim.diagnostic.get(0, {
    lnum = lnum,
  })

  local messages = {}

  for index, diagnostic in ipairs(diagnostics) do
    table.insert(messages, { index .. ": " .. diagnostic.message .. "\n" })
  end

  vim.api.nvim_echo(messages, false, {})

  -- https://git.sr.ht/~whynothugo/lsp_lines.nvim
  --vim.diagnostic.open_float({
    --severity_sort = true,
  --})
end)

vim.api.nvim_create_autocmd({"BufReadPost"}, {
  pattern = "quickfix",
  callback = function ()
    vim.opt_local.wrap = true
  end
})


-- Tabs

keymap.set("n", "<M-t>", ":tabnew<CR>")
keymap.set("n", "<M-Left>", ":tabp<CR>")
keymap.set("n", "<M-Right>", ":tabn<CR>")


-- Vimspector

vim.g.vimspector_sign_priority = {
    vimspectorBP = 13,
    vimspectorBPCond = 12,
    vimspectorBPDisabled = 11,
}

vim.g.vimspector_sidebar_width = 75

keymap.set("n", "<leader>deb", "<Plug>VimspectorToggleBreakpoint")
keymap.set("n", "<leader>dec", "<Plug>VimspectorRunToCursor")
keymap.set("n", "<leader>dee", ":VimspectorReset<CR>")
keymap.set("n", "<leader>des", "<Plug>VimspectorContinue")
keymap.set("n", "<F7>", "<Plug>VimspectorStepInto")
keymap.set("n", "<F8>", "<Plug>VimspectorStepOver")
keymap.set("n", "<S-F8>", "<Plug>VimspectorStepOut")
keymap.set("n", "<F9>", "<Plug>VimspectorContinue")


-- center

--keymap.set("n", "<C>-i", "<C>-izz")
--keymap.set("n", "<C>-o", "<C>-ozz")

-- find

local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

keymap.set("n", "<leader>fb", ":Telescope buffers show_all_buffers=true<CR>")
keymap.set("n", "<leader>fc", ":Telescope commands<CR>")
keymap.set("n", "<leader>ff", ":Telescope find_files hidden=true<CR>")
keymap.set("n", "<leader>faf", ":Telescope find_files find_command=fd,--hidden,--no-ignore-vcs<CR>")
keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args({})<CR>")
keymap.set("n", "<leader>fG", live_grep_args_shortcuts.grep_word_under_cursor)
keymap.set("v", "<leader>fG", live_grep_args_shortcuts.grep_visual_selection)
keymap.set("n", "<leader>fh", ":Telescope oldfiles cwd_only=true<CR>")
keymap.set("n", "<leader>fi", ":Telescope current_buffer_fuzzy_find<CR>")
keymap.set("n", "<leader>fm", ":Telescope marks<CR>")
keymap.set("n", "<leader>fp", ":Telescope command_history<CR>")
keymap.set("n", "<leader>fr", ":lua require'telescope.builtin'.resume()<CR>")
keymap.set("n", "<leader>fsf", ":lua require('weeman.scratches').telescope_find()<CR>")
keymap.set("n", "<leader>fsg", ":lua require('weeman.scratches').telescope_live_grep()<CR>")


-- lsp

keymap.set("n", "<leader>la", vim.lsp.buf.code_action)
keymap.set("n", "<leader>ld", ":Telescope diagnostics<CR>")
keymap.set("n", "<leader>lf", function () vim.lsp.buf.format({ async = false, timeout_ms = 5000 }) end)
keymap.set("n", "<leader>lr", ":lua vim.lsp.buf.rename()<CR>")
keymap.set("n", "<leader>jd", ":lua vim.lsp.buf.definition()<CR>")

keymap.set("n", "<leader>lfd", ":Telescope lsp_document_symbols<CR>")
keymap.set("n", "<leader>lfi", ":Telescope lsp_implementations<CR>")
keymap.set("n", "<leader>lfr", ":Telescope lsp_references<CR>")
keymap.set("n", "<leader>lfw", ":Telescope lsp_dynamic_workspace_symbols<CR>")

-- signature help experiment

-- monkey patch nvim to prevent auto commands for floating popups
-- https://github.com/neovim/neovim/issues/15300
-- https://github.com/neovim/neovim/pull/15981
local util = require("vim.lsp.util")
local orig = util.make_floating_popup_options;
util.make_floating_popup_options = function (width, height, opts)
  local orig_opts = orig(width, height, opts)
  orig_opts.noautocmd = true
  return orig_opts
end

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {
    border = "single",
    focusable = false,
  }
)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function (opts)
    local client_id = (opts.data or {}).client_id
    local client = vim.lsp.get_client_by_id(client_id)

    if client == nil then
      return
    end

    -- print(vim.inspect(client.server_capabilities))

    if client.server_capabilities.definitionProvider then
      keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
    end

    if client.server_capabilities.signatureHelpProvider then
      vim.api.nvim_create_autocmd("CursorHoldI", {
        buffer = opts.buf,
        callback = function ()
          vim.lsp.buf.signature_help()
        end
      })
    end
  end
})


-- Control C = ESC

keymap.set("i", "<C-c>", "<ESC>")


vim.api.nvim_exec(
[[
    imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
    smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
]], false)


-- vim-test

vim.g["test#enabled_runners"] = { "php#phpunit" }


-- Ultest

vim.g.ultest_deprecation_notice = false
vim.api.nvim_set_hl(0, "UltestPass", {
  ctermfg = "DarkGreen",
})


-- PHP

vim.g.PHP_noArrowMatching = 1


-- SQL

-- disable weird keyboard shortcut
vim.g.ftplugin_sql_omni_key = '<Plug>DisableSqlOmni'
