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

-- Normal mode: file navigation
map('n', 'gg', 'gg0', { noremap = true, silent = true, desc = 'Go to start of file and line' })
map('n', 'G', 'G$', { noremap = true, silent = true, desc = 'Go to end of file and line' })

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

-- Normal mode: jump between matching tags
map({ 'n', 'x', 'o' }, '<leader>t', '%', { desc = 'Jump to matching tag/bracket', remap = true })

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

-- Claude Review Workflow (git commit-based checkpoints)

-- Create checkpoint commit (stages all + commits)
map('n', '<leader>jc', function()
  local status = vim.fn.system('git status --porcelain')
  if status ~= '' then
    vim.fn.system('git add -A')
  end
  local logs = vim.fn.system('git log --oneline --grep="^checkpoint:" -n 100')
  local max = 0
  for num in logs:gmatch('checkpoint:%s*(%d+)') do
    max = math.max(max, tonumber(num))
  end
  local msg = 'checkpoint: ' .. (max + 1)
  vim.fn.system('git commit --allow-empty -m "' .. msg .. '"')
  if vim.v.shell_error == 0 then
    vim.notify(msg, vim.log.levels.INFO)
  else
    vim.notify('Checkpoint failed', vim.log.levels.WARN)
  end
end, { desc = 'Create checkpoint' })

-- List checkpoints and reset to selected
map('n', '<leader>jl', function()
  local logs = vim.fn.system('git log --oneline --grep="^checkpoint:" -n 20')
  if logs == '' then
    vim.notify('No checkpoints found', vim.log.levels.WARN)
    return
  end
  local items = {}
  for line in logs:gmatch('[^\n]+') do
    table.insert(items, line)
  end
  vim.ui.select(items, { prompt = 'Reset to checkpoint:' }, function(choice)
    if not choice then return end
    local hash = choice:match('^(%S+)')
    vim.ui.select({ 'Yes, reset', 'Cancel' }, { prompt = 'Discard changes since ' .. hash .. '?' }, function(confirm)
      if confirm == 'Yes, reset' then
        vim.fn.system('git reset --hard ' .. hash)
        vim.cmd('bufdo e!')
        vim.notify('Reset to ' .. hash, vim.log.levels.INFO)
      end
    end)
  end)
end, { desc = 'List/reset checkpoints' })

-- Accept changes (commit staged)
map('n', '<leader>ja', function()
  vim.fn.system('git diff --cached --quiet')
  if vim.v.shell_error == 0 then
    vim.notify('No staged changes', vim.log.levels.WARN)
    return
  end
  vim.ui.input({ prompt = 'Commit: ', default = 'Accept Claude changes' }, function(msg)
    if not msg then return end
    vim.fn.system('git commit -m "' .. msg:gsub('"', '\\"') .. '"')
    if vim.v.shell_error == 0 then
      vim.notify('Committed', vim.log.levels.INFO)
    else
      vim.notify('Commit failed', vim.log.levels.ERROR)
    end
  end)
end, { desc = 'Accept (commit)' })

-- Git status via telescope
map('n', '<leader>jj', function()
  require('telescope.builtin').git_status()
end, { desc = 'Git status' })
