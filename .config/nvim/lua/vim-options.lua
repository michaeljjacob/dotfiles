vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.cmd("set relativenumber")

vim.opt.swapfile = false;

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<c-k>", ':wincmd k<CR>')
vim.keymap.set("n", "<c-j>", ':wincmd j<CR>')
vim.keymap.set("n", "<c-h>", ':wincmd h<CR>')
vim.keymap.set("n", "<c-l>", ':wincmd l<CR>')

vim.keymap.set("n", "<C-z>", '<Nop>', { silent = true })

vim.filetype.add({
  extension = {
    drift = "sql",
  },
})

vim.fn.setreg("l",  "yoconsole.log('pA:', pa);")
