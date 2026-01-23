-- TEST COMMENT: Another test change to review
-- Display
vim.g.have_nerd_font = false
vim.o.number = true
vim.o.cursorline = true
vim.o.showmode = false
vim.o.signcolumn = 'yes'
vim.o.showtabline = 2
vim.o.scrolloff = 10
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Indentation
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.breakindent = true

-- Search
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = 'split'

-- Windows/buffers
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.confirm = true

-- System integration
vim.o.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Performance
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Persistence
vim.o.undofile = true

-- Autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
