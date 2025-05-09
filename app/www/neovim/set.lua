vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = '80'

-- Trying to change line numbers to be more visible
-- vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = 'white', })
-- vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = 'white', })

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.scrolloff = 8
vim.opt.termguicolors = true

-- automatically create folds based on indentation
vim.opt.foldmethod = 'indent'
vim.opt.foldcolumn = '4'
vim.opt.foldlevelstart = 2

-- disable virtual text because lsp_lines makes them redundant
vim.diagnostic.config({ virtual_text = false })
