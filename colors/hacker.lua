-- Hacker colorscheme for Neovim
-- Based on https://github.com/brenix/vscode-hacker

vim.cmd 'hi clear'
if vim.fn.exists 'syntax_on' then
  vim.cmd 'syntax reset'
end

vim.g.colors_name = 'hacker'
vim.o.termguicolors = true

local colors = {
  bg = '#0a0b0a',
  fg = '#bbbbbb',
  fg_dark = '#858585',
  fg_light = '#e8e8e8',

  -- UI colors
  black = '#252525',
  gray = '#333333',
  gray_light = '#454545',

  -- Accent colors
  green = '#81b38c',
  green_light = '#a7ecb7',
  green_dark = '#507057',

  purple = '#7574a5',
  blue = '#87a1c5',
  blue_dark = '#5E81AC',
  cyan = '#8db9e2',

  red = '#c05776',
  yellow = '#a3be8c',

  none = 'NONE',
}

local function hi(group, opts)
  local cmd = 'highlight ' .. group
  if opts.fg then
    cmd = cmd .. ' guifg=' .. opts.fg
  end
  if opts.bg then
    cmd = cmd .. ' guibg=' .. opts.bg
  end
  if opts.sp then
    cmd = cmd .. ' guisp=' .. opts.sp
  end
  if opts.style then
    cmd = cmd .. ' gui=' .. opts.style
  end
  if opts.link then
    cmd = 'highlight! link ' .. group .. ' ' .. opts.link
  end
  vim.cmd(cmd)
end

-- Editor UI
hi('Normal', { fg = colors.fg, bg = colors.none })
hi('NormalFloat', { fg = colors.fg, bg = colors.none })
hi('FloatBorder', { fg = colors.black, bg = colors.none })
hi('ColorColumn', { bg = colors.gray })
hi('Cursor', { fg = colors.bg, bg = colors.fg })
hi('CursorLine', { bg = colors.gray })
hi('CursorLineNr', { fg = colors.fg, bg = colors.gray })
hi('LineNr', { fg = colors.fg_dark })
hi('SignColumn', { fg = colors.fg, bg = colors.none })
hi('VertSplit', { fg = colors.black, bg = colors.none })
hi('Folded', { fg = colors.fg_dark, bg = colors.gray })
hi('FoldColumn', { fg = colors.fg_dark, bg = colors.none })

-- Selection
hi('Visual', { bg = colors.gray })
hi('VisualNOS', { bg = colors.gray })
hi('Search', { fg = colors.bg, bg = colors.green })
hi('IncSearch', { fg = colors.bg, bg = colors.green })
hi('CurSearch', { fg = colors.bg, bg = colors.green })

-- Statusline
hi('StatusLine', { fg = colors.fg, bg = colors.black })
hi('StatusLineNC', { fg = colors.fg_dark, bg = colors.black })
hi('WildMenu', { fg = colors.bg, bg = colors.green })

-- Tabs
hi('TabLine', { fg = colors.fg_dark, bg = colors.bg })
hi('TabLineFill', { fg = colors.fg_dark, bg = colors.bg })
hi('TabLineSel', { fg = colors.fg, bg = colors.gray })

-- Pmenu (popup menu)
hi('Pmenu', { fg = colors.fg, bg = colors.bg })
hi('PmenuSel', { fg = colors.fg, bg = colors.gray })
hi('PmenuSbar', { bg = colors.gray })
hi('PmenuThumb', { bg = colors.gray_light })

-- Messages
hi('ErrorMsg', { fg = colors.red })
hi('WarningMsg', { fg = colors.blue })
hi('ModeMsg', { fg = colors.fg })
hi('MoreMsg', { fg = colors.green })
hi('Question', { fg = colors.green })

-- Diff
hi('DiffAdd', { fg = colors.green_light, bg = colors.bg })
hi('DiffChange', { fg = colors.blue, bg = colors.bg })
hi('DiffDelete', { fg = colors.red, bg = colors.bg })
hi('DiffText', { fg = colors.blue, bg = colors.gray })

-- Git signs
hi('GitSignsAdd', { fg = colors.green_light })
hi('GitSignsChange', { fg = colors.blue })
hi('GitSignsDelete', { fg = colors.red })

-- Spell
hi('SpellBad', { sp = colors.red, style = 'undercurl' })
hi('SpellCap', { sp = colors.blue, style = 'undercurl' })
hi('SpellLocal', { sp = colors.cyan, style = 'undercurl' })
hi('SpellRare', { sp = colors.purple, style = 'undercurl' })

-- Diagnostics
hi('DiagnosticError', { fg = colors.red })
hi('DiagnosticWarn', { fg = colors.blue })
hi('DiagnosticInfo', { fg = colors.green })
hi('DiagnosticHint', { fg = colors.purple })
hi('DiagnosticUnderlineError', { sp = colors.red, style = 'undercurl' })
hi('DiagnosticUnderlineWarn', { sp = colors.blue, style = 'undercurl' })
hi('DiagnosticUnderlineInfo', { sp = colors.green, style = 'undercurl' })
hi('DiagnosticUnderlineHint', { sp = colors.purple, style = 'undercurl' })

-- Syntax
hi('Comment', { fg = colors.fg_dark, style = 'italic' })
hi('Constant', { fg = colors.green })
hi('String', { fg = colors.green_light })
hi('Character', { fg = colors.blue })
hi('Number', { fg = colors.red })
hi('Boolean', { fg = colors.green })
hi('Float', { fg = colors.red })

hi('Identifier', { fg = colors.fg })
hi('Function', { fg = colors.purple })

hi('Statement', { fg = colors.green })
hi('Conditional', { fg = colors.green })
hi('Repeat', { fg = colors.green })
hi('Label', { fg = colors.green })
hi('Operator', { fg = colors.green })
hi('Keyword', { fg = colors.green })
hi('Exception', { fg = colors.green })

hi('PreProc', { fg = colors.blue_dark })
hi('Include', { fg = colors.purple })
hi('Define', { fg = colors.blue_dark })
hi('Macro', { fg = colors.blue_dark })
hi('PreCondit', { fg = colors.blue_dark })

hi('Type', { fg = colors.purple })
hi('StorageClass', { fg = colors.green })
hi('Structure', { fg = colors.purple })
hi('Typedef', { fg = colors.purple })

hi('Special', { fg = colors.green })
hi('SpecialChar', { fg = colors.blue })
hi('Tag', { fg = colors.green })
hi('Delimiter', { fg = colors.fg_light })
hi('SpecialComment', { fg = colors.fg_dark, style = 'italic' })
hi('Debug', { fg = colors.green_dark })

hi('Underlined', { style = 'underline' })
hi('Ignore', { fg = colors.fg_dark })
hi('Error', { fg = colors.red })
hi('Todo', { fg = colors.purple, style = 'bold' })

-- Treesitter
hi('@variable', { fg = colors.fg })
hi('@variable.builtin', { fg = colors.green })
hi('@variable.parameter', { fg = colors.fg })
hi('@variable.member', { fg = colors.fg })

hi('@constant', { fg = colors.green })
hi('@constant.builtin', { fg = colors.green })
hi('@constant.macro', { fg = colors.blue_dark })

hi('@string', { fg = colors.green_light })
hi('@string.escape', { fg = colors.blue })
hi('@string.regexp', { fg = colors.blue })

hi('@number', { fg = colors.red })
hi('@boolean', { fg = colors.green })
hi('@float', { fg = colors.red })

hi('@function', { fg = colors.purple })
hi('@function.builtin', { fg = colors.purple })
hi('@function.macro', { fg = colors.blue_dark })
hi('@function.method', { fg = colors.purple })

hi('@constructor', { fg = colors.purple })
hi('@parameter', { fg = colors.fg })

hi('@keyword', { fg = colors.green })
hi('@keyword.function', { fg = colors.green })
hi('@keyword.operator', { fg = colors.green })
hi('@keyword.return', { fg = colors.green })

hi('@conditional', { fg = colors.green })
hi('@repeat', { fg = colors.green })
hi('@label', { fg = colors.green })
hi('@operator', { fg = colors.green })
hi('@exception', { fg = colors.green })

hi('@type', { fg = colors.purple })
hi('@type.builtin', { fg = colors.green })
hi('@type.qualifier', { fg = colors.green })

hi('@structure', { fg = colors.purple })
hi('@include', { fg = colors.purple })

hi('@property', { fg = colors.fg })
hi('@field', { fg = colors.fg })

hi('@punctuation.delimiter', { fg = colors.fg_light })
hi('@punctuation.bracket', { fg = colors.fg_light })
hi('@punctuation.special', { fg = colors.green })

hi('@comment', { fg = colors.fg_dark, style = 'italic' })

hi('@tag', { fg = colors.green })
hi('@tag.attribute', { fg = colors.purple })
hi('@tag.delimiter', { fg = colors.green })

hi('@namespace', { fg = colors.purple })

hi('@text.strong', { style = 'bold' })
hi('@text.emphasis', { style = 'italic' })
hi('@text.underline', { style = 'underline' })
hi('@text.title', { fg = colors.green })
hi('@text.literal', { fg = colors.purple })
hi('@text.uri', { fg = colors.purple, style = 'underline' })

-- LSP
hi('LspReferenceText', { bg = colors.gray })
hi('LspReferenceRead', { bg = colors.gray })
hi('LspReferenceWrite', { bg = colors.gray })
hi('LspSignatureActiveParameter', { fg = colors.green, style = 'bold' })

-- Telescope
hi('TelescopeBorder', { fg = colors.black, bg = colors.bg })
hi('TelescopePromptBorder', { fg = colors.black, bg = colors.bg })
hi('TelescopeResultsBorder', { fg = colors.black, bg = colors.bg })
hi('TelescopePreviewBorder', { fg = colors.black, bg = colors.bg })
hi('TelescopeSelection', { fg = colors.fg, bg = colors.gray })
hi('TelescopeSelectionCaret', { fg = colors.green })
hi('TelescopeMatching', { fg = colors.green })

-- Neo-tree
hi('NeoTreeNormal', { fg = colors.fg, bg = colors.none })
hi('NeoTreeNormalNC', { fg = colors.fg, bg = colors.none })
hi('NeoTreeDirectoryIcon', { fg = colors.green })
hi('NeoTreeDirectoryName', { fg = colors.fg })
hi('NeoTreeFileName', { fg = colors.fg })
hi('NeoTreeFileNameOpened', { fg = colors.green })
hi('NeoTreeGitAdded', { fg = colors.blue })
hi('NeoTreeGitModified', { fg = colors.green_light })
hi('NeoTreeGitDeleted', { fg = colors.red })
hi('NeoTreeGitConflict', { fg = colors.purple })
hi('NeoTreeGitUntracked', { fg = colors.blue })
hi('NeoTreeIndentMarker', { fg = colors.gray })

-- GitSigns
hi('GitGutterAdd', { fg = colors.green_light })
hi('GitGutterChange', { fg = colors.blue })
hi('GitGutterDelete', { fg = colors.red })

-- Bufferline
hi('BufferLineFill', { bg = colors.bg })
hi('BufferLineBackground', { fg = colors.fg_dark, bg = colors.bg })
hi('BufferLineBufferSelected', { fg = colors.fg, bg = colors.gray, style = 'bold' })
hi('BufferLineBufferVisible', { fg = colors.fg_dark, bg = colors.bg })
hi('BufferLineModified', { fg = colors.blue, bg = colors.bg })
hi('BufferLineModifiedSelected', { fg = colors.green_light, bg = colors.gray })

-- Indent blankline
hi('IndentBlanklineChar', { fg = colors.gray })
hi('IndentBlanklineContextChar', { fg = colors.gray_light })

-- Which-key
hi('WhichKey', { fg = colors.green })
hi('WhichKeyGroup', { fg = colors.purple })
hi('WhichKeyDesc', { fg = colors.fg })
hi('WhichKeySeparator', { fg = colors.fg_dark })
hi('WhichKeyFloat', { bg = colors.bg })

-- Mini.nvim
hi('MiniStatuslineDevinfo', { fg = colors.fg, bg = colors.black })
hi('MiniStatuslineFileinfo', { fg = colors.fg, bg = colors.black })
hi('MiniStatuslineFilename', { fg = colors.fg, bg = colors.black })
hi('MiniStatuslineInactive', { fg = colors.fg_dark, bg = colors.black })
hi('MiniStatuslineModeCommand', { fg = colors.bg, bg = colors.green })
hi('MiniStatuslineModeInsert', { fg = colors.bg, bg = colors.green })
hi('MiniStatuslineModeNormal', { fg = colors.bg, bg = colors.green })
hi('MiniStatuslineModeOther', { fg = colors.bg, bg = colors.green })
hi('MiniStatuslineModeReplace', { fg = colors.bg, bg = colors.red })
hi('MiniStatuslineModeVisual', { fg = colors.bg, bg = colors.purple })

-- Rainbow delimiters
hi('RainbowDelimiterRed', { fg = colors.red })
hi('RainbowDelimiterYellow', { fg = colors.yellow })
hi('RainbowDelimiterBlue', { fg = colors.blue })
hi('RainbowDelimiterOrange', { fg = '#e0af68' })
hi('RainbowDelimiterGreen', { fg = colors.green })
hi('RainbowDelimiterViolet', { fg = colors.purple })
hi('RainbowDelimiterCyan', { fg = colors.cyan })
