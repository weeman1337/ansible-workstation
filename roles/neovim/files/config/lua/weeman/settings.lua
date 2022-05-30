local h = require("weeman.helpers")
local keymap = vim.keymap

vim.o.clipboard = 'unnamedplus'
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.wrap = false


-- save

vim.o.autowriteall = true
--vim.api.nvim_exec([[
    --au BufLeave * silent! wall
--]], false)


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
    twig = "html",
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

local tab_styles = {
  {{"lua", "yaml", "NvimTree"}, 2}
}

for _, tabstyle in ipairs(tab_styles) do
  vim.api.nvim_create_autocmd({"FileType"}, {
    pattern = tabstyle[1],
    callback = function ()
      vim.opt_local.tabstop = tabstyle[2]
      vim.opt_local.softtabstop = tabstyle[2]
      vim.opt_local.shiftwidth = tabstyle[2]
    end
  })
end


-- trim whitespaces

vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {
    "*.js", "*.ts", "*.tsx", "*.vue",
   "*.html",
    "*.php", "*.php.*",
    "*.xml", "*.xml.*",
    "*.yml", "*.yaml",
    "*.sh",
    "*.py",
    "*.lua",
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
vim.o.undodir = os.getenv("HOME") .. "/.vim/undo"

--vim.o.completeopt = "menuone,noselect"


-- autosave

vim.api.nvim_create_autocmd({"FocusLost", "BufLeave"}, {
  pattern = "*",
  command = "wa",
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
keymap.set("n", "<leader>gj", ":GitGutterNextHunk<CR>")
keymap.set("n", "<leader>gk", ":GitGutterPrevHunk<CR>")
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


-- quickfix navigation

keymap.set("n", "<C-j>", ":cnext<CR>zz")
keymap.set("n", "<C-k>", ":cprev<CR>zz")


-- run

keymap.set("n", "<leader>rtn", ":w<CR> :UltestNearest<CR>")


-- location list navigation

keymap.set("n", "<C-S-j>", ":lnext<CR>zz")
keymap.set("n", "<C-S-k>", ":lprev<CR>zz")


-- tools

keymap.set("n", "<leader>tp", ":lua require('weeman.preview').toggle()<CR>")
keymap.set("n", "<leader>ts", "Vi{:sort<CR>")


-- sidebars

vim.g.mundo_right = 1
keymap.set("n", "<leader>su", ":Vista!<CR> :MundoToggle<CR>")
keymap.set("n", "<leader>ss", ":MundoHide<CR> :Vista!!<CR>")
keymap.set("n", "<leader>sc", ":Vista!<CR> :MundoHide<CR>")


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

keymap.set("n", "<leader>db", "<Plug>VimspectorToggleBreakpoint")
keymap.set("n", "<leader>dc", "<Plug>VimspectorRunToCursor")
keymap.set("n", "<leader>de", ":VimspectorReset<CR>")
keymap.set("n", "<leader>ds", "<Plug>VimspectorContinue")
keymap.set("n", "<F7>", "<Plug>VimspectorStepInto")
keymap.set("n", "<F8>", "<Plug>VimspectorStepOver")
keymap.set("n", "<S-F8>", "<Plug>VimspectorStepOut")
keymap.set("n", "<F9>", "<Plug>VimspectorContinue")


-- center

--keymap.set("n", "<C>-i", "<C>-izz")
--keymap.set("n", "<C>-o", "<C>-ozz")

-- find

keymap.set("n", "<leader>fb", ":Telescope buffers show_all_buffers=true<CR>")
keymap.set("n", "<leader>fc", ":Telescope commands<CR>")
keymap.set("n", "<leader>ff", ":Telescope find_files hidden=true<CR>")
keymap.set("n", "<leader>faf", ":Telescope find_files find_command=fd,--hidden,--no-ignore-vcs<CR>")
keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_raw.live_grep_raw({})<CR>")
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
keymap.set("n", "<leader>lf", ":lua vim.lsp.buf.formatting()<CR>")
keymap.set("n", "<leader>lr", ":lua vim.lsp.buf.rename()<CR>")
keymap.set("n", "<leader>jd", ":lua vim.lsp.buf.definition()<CR>")

keymap.set("n", "<leader>lfd", ":Telescope lsp_document_symbols<CR>")
keymap.set("n", "<leader>lfi", ":Telescope lsp_implementations<CR>")
keymap.set("n", "<leader>lfr", ":Telescope lsp_references<CR>")
keymap.set("n", "<leader>lfw", ":Telescope lsp_dynamic_workspace_symbols<CR>")


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

vim.api.nvim_set_hl(0, "UltestPass", {
  ctermfg = "DarkGreen",
})


-- PHP

vim.g.PHP_noArrowMatching = 1


-- SQL

-- disable weird keyboard shortcut
vim.g.ftplugin_sql_omni_key = '<Plug>DisableSqlOmni'
