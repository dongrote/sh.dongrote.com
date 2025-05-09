vim.g.mapleader = " "

-- split window
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "split window horizontally" })
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "split window vertically" })
-- switch windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

-- show full path
vim.keymap.set("n", "<leader>P", "1<C-g>", { desc = "show full file path" })

-- open file explorer
vim.keymap.set("n", "<leader>us", "<cmd>:setlocal spell<CR>", { desc = "Spellcheck On", })
vim.keymap.set("n", "<leader>uS", "<cmd>:setlocal nospell<CR>", { desc = "Spellcheck Off", })

-- open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.NvimTreeToggle, { desc = "File Tree Toggle", })

-- set executable bit on current file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- run custom test.sh script
-- vim.keymap.set("n", "<leader>t", "<cmd>!test.sh %<CR>", { desc = "Run Tests", })
-- vim.keymap.set("n", "<leader>b", "<cmd>!build.sh %<CR>", { desc = "Run Build", })

-- clear highlight
vim.keymap.set("n", "<ESC>", "<cmd>noh<CR>", { desc = "Clear Highlight", })

-- csharp (dotnet) shell commands
vim.keymap.set("n", "<leader>cst", "<cmd>!dotnet test<CR>", { desc = "Run C# Tests", })
vim.keymap.set("n", "<leader>csb", "<cmd>!dotnet build<CR>", { desc = "C# Build", })
vim.keymap.set("n", "<leader>csr", "<cmd>!dotnet restore<CR>", { desc = "C# Restore", })

-- nodejs shell commands
vim.keymap.set("n", "<leader>npmb", "<cmd>!npm run build<CR>")
vim.keymap.set("n", "<leader>npmt", "<cmd>!npm test<CR>")

-- lsp stuffs
vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<CR>")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format", })

-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration,  "Go to declaration")
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition,  "Go to definition")
-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation,  "Go to implementation")
-- vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help,  "Show signature help")
-- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,  "Add workspace folder")
-- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder,  "Remove workspace folder")

-- vim.keymap.set("n", "<leader>gd", "<cmd>lua require('omnisharp_extended').telescope_lsp_definition({ jump_type = 'vsplit' })<CR>")
-- navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Comment
vim.keymap.set("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
vim.keymap.set("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- telescope
vim.keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
vim.keymap.set("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "telescope find files" })
vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
vim.keymap.set("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
vim.keymap.set("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
vim.keymap.set("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
vim.keymap.set("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
