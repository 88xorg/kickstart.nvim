-- TEST COMMENT: This is a test change for the review workflow
-- Leader key (must be before plugins)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load config files
local config_path = vim.fn.stdpath 'config'
dofile(config_path .. '/options.lua')
dofile(config_path .. '/keymaps.lua')
dofile(config_path .. '/plugins.lua')

-- Clean up "No Name" buffers when opening a real file
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local current = vim.api.nvim_get_current_buf()
    -- Only clean if current buffer has a name
    if vim.api.nvim_buf_get_name(current) == '' then
      return
    end
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if buf ~= current and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
        local name = vim.api.nvim_buf_get_name(buf)
        local modified = vim.bo[buf].modified
        if name == '' and not modified then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end
  end,
})
