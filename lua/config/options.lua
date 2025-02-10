vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.errorbells = false
vim.opt.visualbell = true
vim.opt.mouse = ''
vim.opt.timeoutlen = 1500
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.wrap = false
vim.opt.hlsearch = true
vim.opt.modeline = true
vim.opt.modelines = 5
vim.opt.inccommand = 'nosplit'

vim.cmd[[
  autocmd BufEnter * :syntax sync fromstart
  autocmd InsertLeave * :syntax sync fromstart
]]
