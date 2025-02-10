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
vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:block,o:hor50"
vim.opt.signcolumn = "yes:1"

vim.g.editorconfig = true
vim.api.nvim_create_autocmd("BufRead", {
  callback = function()
    if vim.b.editorconfig and vim.b.editorconfig.max_line_length then
      local max_length = tonumber(vim.b.editorconfig.max_line_length) + 1
      if max_length then
        vim.opt_local.colorcolumn = tostring(max_length)
      end
    end
  end,
})

vim.cmd[[
  autocmd BufEnter * :syntax sync fromstart
  autocmd InsertLeave * :syntax sync fromstart
]]
