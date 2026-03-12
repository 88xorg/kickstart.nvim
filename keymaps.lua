local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Insert mode
map('i', 'kj', '<Esc>', opts)
map('i', '<C-v>', '<C-r>+', opts)
map('i', '<A-BS>', '<C-w>', { noremap = true, silent = true, desc = 'Delete word backward' })
map('i', '<D-BS>', '<C-u>', { noremap = true, silent = true, desc = 'Delete to start of line' })

-- Normal mode: buffer/window navigation
map('n', '<S-h>', ':bprevious<CR>', opts)
map('n', '<S-l>', ':bnext<CR>', opts)
map('n', '<leader>h', '<C-w>h', opts)
map('n', '<leader>k', '<C-w>k', opts)
map('n', '<leader>l', '<C-w>l', opts)
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus upper window' })
map({ 'n', 'x', 'o' }, '<leader>a', '^', opts)
map({ 'n', 'x', 'o' }, '<leader>g', '$', opts)

-- Normal mode: file navigation
map({ 'n', 'x' }, 'gg', 'gg0', { noremap = true, silent = true, desc = 'Go to start of file and line' })
map({ 'n', 'x' }, 'G', 'G$', { noremap = true, silent = true, desc = 'Go to end of file and line' })

-- Normal mode: editing
map('n', '<leader>w', ':w!<CR>', opts)
map('n', '<leader>v', ':vsplit<CR>', opts)
map('n', '<leader>q', '<C-w>c', { noremap = true, silent = true, desc = 'Close window/split' })
map('n', 'df', 'D', opts)
map('n', '<C-Down>', ':m .+1<CR>==', opts)
map('n', '<C-Up>', ':m .-2<CR>==', opts)
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Normal mode: LSP
map({ 'n', 'x' }, '<leader>c', vim.lsp.buf.code_action, opts)
map({ 'n', 'x' }, '<leader>p', function()
  if vim.lsp.buf.format then
    vim.lsp.buf.format { async = false }
  end
end, { desc = 'Format buffer' })
map('n', 'gH', vim.lsp.buf.hover, { desc = 'LSP Hover' })
map('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Diagnostic quickfix list' })

-- Go to definition (gd and Cmd+click)
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
map('n', '<D-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'Cmd+click go to definition' })

-- Smart hover: show diagnostic if present, otherwise show hover info (like VSCode)
map('n', 'gh', function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  if #diagnostics > 0 then
    vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' })
  else
    vim.lsp.buf.hover()
  end
end, { desc = 'Show error or hover info' })

-- Normal mode: search
map('n', '<leader>r', function()
  vim.ui.input({ prompt = 'Search: ' }, function(pattern)
    if not pattern or pattern == '' then return end
    vim.fn.setreg('/', '\\V' .. vim.fn.escape(pattern, '\\'))
    vim.opt.hlsearch = true
    vim.cmd('normal! n')
  end)
end, { desc = 'Search in current file' })

map('n', '<leader>k', function()
  local ok, builtin = pcall(require, 'telescope.builtin')
  if ok then
    builtin.live_grep()
  else
    vim.cmd 'grep'
  end
end, { desc = 'Live grep (project)' })

-- Normal mode: file explorer
map('n', '<leader>e', function()
  local ok, cmd = pcall(require, 'neo-tree.command')
  if ok then
    cmd.execute { toggle = true, position = 'left', dir = vim.loop.cwd() }
  else
    vim.notify('neo-tree not available', vim.log.levels.WARN)
  end
end, { desc = 'Explorer (Neo-tree)' })

-- Normal mode: jump between matching opening/closing tags
map({ 'n', 'x', 'o' }, '<leader>t', function()
  local node = vim.treesitter.get_node()
  if not node then
    vim.cmd('normal! %')
    return
  end

  -- Walk up to find the enclosing element
  local element = node
  while element do
    local t = element:type()
    if t == 'jsx_element' or t == 'element' then
      break
    end
    element = element:parent()
  end

  if not element then
    vim.cmd('normal! %')
    return
  end

  local open_tag, close_tag
  for child in element:iter_children() do
    local ct = child:type()
    if ct == 'jsx_opening_element' or ct == 'start_tag' then
      open_tag = child
    elseif ct == 'jsx_closing_element' or ct == 'end_tag' or ct == 'close_tag' then
      close_tag = child
    end
  end

  if not open_tag or not close_tag then
    vim.cmd('normal! %')
    return
  end

  local cursor_row = vim.fn.line('.') - 1
  local close_sr, close_sc = close_tag:start()
  local open_sr, open_sc = open_tag:start()

  -- If cursor is before the closing tag, jump to closing tag; otherwise jump to opening tag
  if cursor_row < close_sr or (cursor_row == close_sr and vim.fn.col('.') - 1 < close_sc) then
    vim.api.nvim_win_set_cursor(0, { close_sr + 1, close_sc })
  else
    vim.api.nvim_win_set_cursor(0, { open_sr + 1, open_sc })
  end
end, { desc = 'Jump to matching tag' })

-- Visual mode: indentation
map('x', '>', '>gv', opts)
map('x', '<', '<gv', opts)

-- Visual mode: line movement
map('x', 'J', ":m '>+1<CR>gv=gv", opts)
map('x', 'K', ":m '<-2<CR>gv=gv", opts)
map('x', '<C-Down>', ":m '>+1<CR>gv=gv", opts)
map('x', '<C-Up>', ":m '<-2<CR>gv=gv", opts)

-- Visual mode: misc
map('x', '<leader>a', '^', opts)
map('x', '<leader>g', '$', opts)
map('x', 'u', '<Nop>', opts)
map('x', 'U', '<Nop>', opts)
-- Toggle comment (Cmd+/ or Ctrl+/, works for all languages via mini.comment)
map({ 'n', 'i' }, '<C-/>', 'gcc', { remap = true, desc = 'Toggle comment' })
map({ 'n', 'i' }, '<C-_>', 'gcc', { remap = true, desc = 'Toggle comment' })
map('x', '<C-/>', 'gc', { remap = true, desc = 'Toggle comment' })
map('x', '<C-_>', 'gc', { remap = true, desc = 'Toggle comment' })
map({ 'n', 'i' }, '<D-/>', 'gcc', { remap = true, desc = 'Toggle comment' })
map('x', '<D-/>', 'gc', { remap = true, desc = 'Toggle comment' })

-- Buffer management
map('n', '<leader>Q', function()
  require('mini.bufremove').delete(0, true)
end, { desc = 'Force close buffer' })

map('n', '<leader>x', function()
  local bufname = vim.api.nvim_buf_get_name(0)
  local modified = vim.bo.modified
  -- Only save if buffer has a name and is modified
  if bufname ~= '' and modified then
    vim.cmd 'write'
  end
  -- Delete the buffer first
  require('mini.bufremove').delete(0, true)
  -- Close window if only empty buffers remain
  local remaining = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and vim.api.nvim_buf_get_name(b) ~= ''
  end, vim.api.nvim_list_bufs())
  if #remaining == 0 then
    vim.cmd 'quit'
  end
end, { desc = 'Save and close buffer' })

-- Terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Preview images/SVGs in default app
map('n', '<leader>pv', function()
  local file = vim.fn.expand '%:p'
  if file ~= '' then
    vim.fn.system { 'open', file }
  end
end, { desc = 'Preview file in default app' })

-- Auto-reload buffers when returning to Neovim (picks up external file edits)
vim.api.nvim_create_autocmd('FocusGained', {
  callback = function()
    vim.cmd('checktime')
  end,
})
