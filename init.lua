-- ===== Leader key (must be before plugins) =====
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ===== Keybindings =====
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Insert mode
map('i', 'kj', '<Esc>', opts)
map('i', '<C-v>', '<C-r>+', opts)

-- Normal mode: buffer/window navigation
map('n', '<S-h>', ':bprevious<CR>', opts)
map('n', '<S-l>', ':bnext<CR>', opts)
map('n', '<leader>h', '<C-w>h', opts)
-- <leader>j is used for live grep (see below)
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

-- Terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ===== Editor options =====

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
vim.o.tabstop = 1
vim.o.shiftwidth = 1
vim.o.softtabstop = 1
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

-- ===== Autocommands =====
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- ===== Lazy.nvim bootstrap =====
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- ===== Plugins =====
require('lazy').setup({

  -- UI: colorscheme
  {
    'noahfrederick/vim-hemisu',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'hemisu'
    end,
    init = function()
      vim.cmd 'colorscheme hemisu'
    end,
  },

  -- UI: which-key
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {},
    },
  },

  -- UI: statusline, text objects, surround
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup {
        mappings = {
          add = 'gsa',
          delete = 'gsd',
          replace = 'gsr',
          find = 'gsf',
          find_left = 'gsF',
          highlight = 'gsh',
          update_n_lines = 'gsn',
        },
      }
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- UI: todo comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- UI: indent guides
  require 'kickstart.plugins.indent_line',

  -- Navigation: telescope
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      map('n', '<leader>sh', builtin.help_tags, { desc = 'Search Help' })
      map('n', '<leader>sk', builtin.keymaps, { desc = 'Search Keymaps' })
      map('n', '<leader>f', builtin.find_files, { desc = 'Search Files' })
      map('n', '<leader>ss', builtin.builtin, { desc = 'Search Telescope' })
      map('n', '<leader>sw', builtin.grep_string, { desc = 'Search Word' })
      map('n', '<leader>sg', builtin.live_grep, { desc = 'Search Grep' })
      map('n', '<leader>sd', builtin.diagnostics, { desc = 'Search Diagnostics' })
      map('n', '<leader>sr', builtin.resume, { desc = 'Search Resume' })
      map('n', '<leader>s.', builtin.oldfiles, { desc = 'Search Recent' })
      map('n', '<leader><leader>', builtin.buffers, { desc = 'Find buffers' })
      map('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = 'Search in buffer' })
      map('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = 'Search in Open Files' })
      map('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Search Neovim files' })
    end,
  },

  -- Navigation: file explorer
  require 'kickstart.plugins.neo-tree',

  -- Git: signs
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Editor: auto-detect indentation
  'NMAC427/guess-indent.nvim',

  -- LSP: Lua config support
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- LSP: configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local lspmap = function(keys, func, desc, mode)
            mode = mode or 'n'
            map(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          lspmap('grn', vim.lsp.buf.rename, 'Rename')
          lspmap('gra', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
          lspmap('grr', require('telescope.builtin').lsp_references, 'References')
          lspmap('gri', require('telescope.builtin').lsp_implementations, 'Implementation')
          lspmap('grd', require('telescope.builtin').lsp_definitions, 'Definition')
          lspmap('grD', vim.lsp.buf.declaration, 'Declaration')
          lspmap('gO', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
          lspmap('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')
          lspmap('grt', require('telescope.builtin').lsp_type_definitions, 'Type Definition')

          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { buffer = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            lspmap('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle Inlay Hints')
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            return diagnostic.message
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local servers = {
        ts_ls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { 'stylua' })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  -- Completion
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },

  -- Formatting
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },

  -- Syntax: treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },

  -- Custom plugins
  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
