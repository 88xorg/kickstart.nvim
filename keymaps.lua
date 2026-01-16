local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Insert mode
map('i', 'kj', '<Esc>', opts)
map('i', '<C-v>', '<C-r>+', opts)

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

-- Normal mode: search
map('n', '<leader>r', '/', { desc = 'Search in current file' })

map('n', '<leader>j', function()
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

-- Normal mode: Emmet
map({ 'n', 'x' }, '<leader>t', function()
  if vim.fn.exists ':EmmetBalanceTag' == 2 then
    vim.cmd 'EmmetBalanceTag'
  else
    vim.notify('Emmet plugin not found', vim.log.levels.WARN)
  end
end, { desc = 'Match/balance tag' })

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
map('x', '<leader>c', function()
  require('Comment.api').toggle.linewise(vim.fn.visualmode())
end, { desc = 'Toggle comment' })

-- Buffer management
map('n', '<leader>Q', function()
  require('mini.bufremove').delete(0, true)
end, { desc = 'Force close buffer' })

map('n', '<leader>x', function()
  vim.cmd 'write'
  require('mini.bufremove').delete(0, false)
end, { desc = 'Save and close buffer' })

-- Terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Claude Review Workflow
vim.g.claude_checkpoint = nil

-- Create checkpoint (before running Claude prompt)
map('n', '<leader>vc', function()
  local head = vim.fn.system('git rev-parse HEAD'):gsub('%s+', '')
  if vim.v.shell_error ~= 0 then
    vim.notify('Not in a git repository', vim.log.levels.ERROR)
    return
  end
  vim.g.claude_checkpoint = head
  vim.notify('Checkpoint: ' .. head:sub(1, 8), vim.log.levels.INFO)
end, { desc = 'Create checkpoint' })

-- Accept prompt (commit staged changes)
map('n', '<leader>va', function())
  local staged = vim.fn.system 'git diff --cached --quiet'
  if vim.v.shell_error == 0 then
    vim.notify('No staged changes', vim.log.levels.WARN)
    return
  end
  vim.ui.input({ prompt = 'Commit message: ', default = 'Accept Claude changes' }, function(msg)
    if not msg then
      return
    end
    vim.fn.system('git commit -m "' .. msg:gsub('"', '\\"') .. '"')
    if vim.v.shell_error == 0 then
      vim.notify('Committed', vim.log.levels.INFO)
      vim.g.claude_checkpoint = nil
    else
      vim.notify('Commit failed', vim.log.levels.ERROR)
    end
  end)
end, { desc = 'Accept prompt (commit)' })

-- Reject prompt (hard reset to checkpoint)
map('n', '<leader>vx', function()
  if not vim.g.claude_checkpoint then
    vim.notify('No checkpoint set', vim.log.levels.ERROR)
    return
  end
  vim.ui.select({ 'Yes, discard all', 'Cancel' }, {
    prompt = 'Reset to ' .. vim.g.claude_checkpoint:sub(1, 8) .. '?',
  }, function(choice)
    if choice == 'Yes, discard all' then
      vim.fn.system('git reset --hard ' .. vim.g.claude_checkpoint)
      vim.cmd 'bufdo e!'
      vim.notify('Reset complete', vim.log.levels.INFO)
      vim.g.claude_checkpoint = nil
    end
  end)
end, { desc = 'Reject prompt (reset)' })

-- Git status via telescope
map('n', '<leader>vv', function()
  require('telescope.builtin').git_status()
end, { desc = 'Git status' })
