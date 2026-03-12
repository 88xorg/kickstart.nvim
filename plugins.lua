-- Lazy.nvim bootstrap
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

-- Plugin specifications
local map = vim.keymap.set

require('lazy').setup({

  -- UI: colorscheme
  {
    name = 'hacker-colorscheme',
    dir = vim.fn.stdpath('config') .. '/colors',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'hacker'
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
      require('mini.pairs').setup()
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
      require('mini.comment').setup()
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
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  -- UI: bufferline (tabs)
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      vim.opt.termguicolors = true
      vim.opt.showtabline = 2
      vim.o.tabline = ''
      require('bufferline').setup {
        options = {
          mode = 'buffers',
          always_show_bufferline = true,
          diagnostics = 'nvim_lsp',
          offsets = {
            { filetype = 'neo-tree', text = 'Explorer', highlight = 'Directory', separator = true },
          },
        },
      }
    end,
  },

  -- UI: scrollbar with diagnostics
  {
    'petertriho/nvim-scrollbar',
    event = 'BufReadPost',
    config = function()
      vim.api.nvim_set_hl(0, 'ScrollbarError', { fg = '#db4b4b' })
      vim.api.nvim_set_hl(0, 'ScrollbarWarn', { fg = '#e0af68' })
      vim.api.nvim_set_hl(0, 'ScrollbarInfo', { fg = '#0db9d7' })
      vim.api.nvim_set_hl(0, 'ScrollbarHint', { fg = '#10b981' })
      vim.api.nvim_set_hl(0, 'ScrollbarHandle', { bg = '#444444' })
      require('scrollbar').setup {
        show = true,
        handle = { highlight = 'ScrollbarHandle' },
        marks = {
          Error = { highlight = 'ScrollbarError' },
          Warn = { highlight = 'ScrollbarWarn' },
          Info = { highlight = 'ScrollbarInfo' },
          Hint = { highlight = 'ScrollbarHint' },
        },
        handlers = { diagnostic = true },
      }
      require('scrollbar.handlers.diagnostic').setup()
    end,
  },

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
        defaults = {
          file_ignore_patterns = {
            'node_modules/',
            'dist/',
            'build/',
            '.next/',
            '.nuxt/',
            '.output/',
            'coverage/',
            '.cache/',
            '.turbo/',
            '.vercel/',
            '.netlify/',
            '%.min%.js',
            '%.min%.css',
            '%.map',
            'package%-lock%.json',
            'yarn%.lock',
            'pnpm%-lock%.yaml',
            'bun%.lockb',
            'target/',
            'Cargo%.lock',
          },
        },
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
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    lazy = false,
    keys = {
      { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    opts = {
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true, -- keep parent dirs open after revealing
        },
        filtered_items = {
          visible = true, -- Show hidden files instead of grouping them
          hide_dotfiles = false,
          hide_gitignored = false,
          never_show = {},
        },
        window = {
          mappings = {
            ['\\'] = 'close_window',
            ['<CR>'] = { 'open', nowait = true },
            ['<Space>'] = 'none',
          },
        },
      },
      window = {
        mappings = {
          ['<CR>'] = { 'open', nowait = true },
          ['<Space>'] = 'none',
        },
      },
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
      event_handlers = {
        {
          event = 'file_opened',
          handler = function()
            require('neo-tree.command').execute { action = 'focus' }
          end,
        },
      },
    },
  },


  -- Editor: auto-detect indentation
  'NMAC427/guess-indent.nvim',

  -- Editor: multi-cursor (VS Code-like)
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
      vim.g.VM_maps = {
        ['Add Cursor At Pos'] = '<leader>m',
      }
    end,
  },

  -- Editor: search and replace (VSCode-like)
  {
    'nvim-pack/nvim-spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>pr', function() require('spectre').toggle() end, desc = 'Search & Replace (Spectre)' },
      { '<leader>pw', function() require('spectre').open_visual({ select_word = true }) end, desc = 'Search current word (Spectre)' },
      { '<leader>pf', function() require('spectre').open_file_search({ select_word = true }) end, desc = 'Search in current file (Spectre)' },
    },
    opts = {
      default = {
        find = {
          cmd = 'rg',
          options = {
            'ignore-case',
            'hidden',
          },
        },
      },
      find_engine = {
        rg = {
          cmd = 'rg',
          args = {
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--glob=!node_modules/**',
            '--glob=!dist/**',
            '--glob=!build/**',
            '--glob=!.git/**',
            '--glob=!*.min.js',
            '--glob=!*.min.css',
            '--glob=!package-lock.json',
            '--glob=!yarn.lock',
            '--glob=!pnpm-lock.yaml',
            '--glob=!*.map',
            '--glob=!.next/**',
            '--glob=!.nuxt/**',
            '--glob=!coverage/**',
            '--glob=!.cache/**',
            '--glob=!__pycache__/**',
            '--glob=!.venv/**',
            '--glob=!venv/**',
          },
        },
      },
    },
  },

  -- Editor: buffer management
  { 'echasnovski/mini.bufremove', version = '*' },

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
            lspmap('<leader>ih', function()
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
        astro = {},
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
        tailwindcss = {
          filetypes = { 'html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'astro', 'svelte', 'vue' },
        },
        emmet_ls = {
          filetypes = { 'html', 'css', 'javascriptreact', 'typescriptreact', 'astro' },
          init_options = {
            html = {
              options = {
                ['output.selfClosingStyle'] = 'xhtml',
              },
            },
            javascriptreact = {
              options = {
                ['jsx.enabled'] = true,
                ['markup.attributes'] = {
                  ['class'] = 'className',
                  ['for'] = 'htmlFor',
                },
              },
            },
            typescriptreact = {
              options = {
                ['jsx.enabled'] = true,
                ['markup.attributes'] = {
                  ['class'] = 'className',
                  ['for'] = 'htmlFor',
                },
              },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { 'stylua', 'emmet-ls', 'prettierd' })
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
      keymap = {
        preset = 'default',
        ['<Tab>'] = { 'select_and_accept', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
      },
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
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        astro = { 'prettier_astro' },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
      },
      formatters = {
        prettier_astro = {
          command = 'prettier',
          args = {
            '--plugin', '/usr/local/lib/node_modules/prettier-plugin-astro/dist/index.js',
            '--stdin-filepath', '$FILENAME',
          },
          stdin = true,
        },
      },
    },
  },

  -- Syntax: treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'astro', 'bash', 'c', 'css', 'diff', 'html', 'javascript', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'tsx', 'typescript', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      matchup = {
        enable = true, -- enables vim-matchup treesitter integration
      },
    },
  },

  -- Rainbow bracket pairs (parentheses only, no HTML tags)
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'BufReadPost',
    config = function()
      local rainbow = require 'rainbow-delimiters'
      require('rainbow-delimiters.setup').setup {
        strategy = {
          [''] = rainbow.strategy['global'],
          vim = rainbow.strategy['local'],
          html = rainbow.strategy['noop'],
          xml = rainbow.strategy['noop'],
          astro = rainbow.strategy['global'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
          tsx = 'rainbow-parens',
          jsx = 'rainbow-parens',
          javascript = 'rainbow-parens',
          typescript = 'rainbow-parens',
          astro = 'rainbow-parens',
        },
        priority = {
          [''] = 110,
          lua = 210,
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
  },

  -- Tag matching: jump between opening/closing tags with %
  {
    'andymass/vim-matchup',
    event = 'BufReadPost',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
      -- Disable matching of quotes/strings - only match brackets and tags
      vim.g.matchup_delim_noskips = 0
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_hi_surround_always = 0
    end,
  },

  -- Auto rename/close HTML tags
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
    },
  },

  -- Markdown preview
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = 'cd app && npm install',
    keys = {
      { '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>', desc = 'Toggle Markdown Preview' },
    },
    init = function()
      vim.g.mkdp_auto_close = 0 -- Don't auto-close preview when switching buffers
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
  },
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
