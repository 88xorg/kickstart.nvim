-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { -- Scrollbar with diagnostics
    'petertriho/nvim-scrollbar',
    event = 'BufReadPost',
    dependencies = { 'lewis6991/gitsigns.nvim' },
    config = function()
      -- Define highlight groups for scrollbar marks
      vim.api.nvim_set_hl(0, 'ScrollbarError', { fg = '#db4b4b' })
      vim.api.nvim_set_hl(0, 'ScrollbarWarn', { fg = '#e0af68' })
      vim.api.nvim_set_hl(0, 'ScrollbarInfo', { fg = '#0db9d7' })
      vim.api.nvim_set_hl(0, 'ScrollbarHint', { fg = '#10b981' })
      vim.api.nvim_set_hl(0, 'ScrollbarHandle', { bg = '#444444' })

      require('scrollbar').setup {
        show = true,
        handle = {
          highlight = 'ScrollbarHandle',
        },
        marks = {
          Error = { highlight = 'ScrollbarError' },
          Warn = { highlight = 'ScrollbarWarn' },
          Info = { highlight = 'ScrollbarInfo' },
          Hint = { highlight = 'ScrollbarHint' },
        },
        handlers = {
          diagnostic = true,
          gitsigns = true,
        },
      }

      -- Connect diagnostics to the scrollbar
      require('scrollbar.handlers.diagnostic').setup()

      -- Connect gitsigns to the scrollbar
      require('scrollbar.handlers.gitsigns').setup()
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      vim.opt.termguicolors = true
      vim.opt.showtabline = 2 -- always show top bar
      vim.o.tabline = '' -- ensure nothing else owns the tabline

      require('bufferline').setup {
        options = {
          mode = 'buffers', -- show open files, not tabs
          always_show_bufferline = true,
          diagnostics = 'nvim_lsp', -- optional
          offsets = {
            { filetype = 'neo-tree', text = 'Explorer', highlight = 'Directory', separator = true },
          },
        },
      }

      -- Navigate buffers
      vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { desc = 'Prev buffer' })
      vim.keymap.set('n', '<S-l>', ':bnext<CR>', { desc = 'Next buffer' })
    end,
  },
  {
    'echasnovski/mini.bufremove',
    version = '*',
    config = function()
      vim.keymap.set('n', '<leader>Q', function()
        require('mini.bufremove').delete(0, true) -- force close buffer without saving
      end, { desc = 'Close buffer (no save)' })

      vim.keymap.set('n', '<leader>Q', function()
        require('mini.bufremove').delete(0, true) -- force close buffer
      end, { desc = 'Force close buffer' })

      vim.keymap.set('n', '<leader>x', function()
        vim.cmd 'write' -- save first
        require('mini.bufremove').delete(0, false) -- then close buffer
      end, { desc = 'Save and close buffer' })
    end,
  },
}
