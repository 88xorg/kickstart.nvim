-- TEST COMMENT: This is a test change for the review workflow
-- Leader key (must be before plugins)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load config files
local config_path = vim.fn.stdpath 'config'
dofile(config_path .. '/options.lua')
dofile(config_path .. '/keymaps.lua')
dofile(config_path .. '/plugins.lua')
