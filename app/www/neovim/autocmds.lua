-- Define an autocommand group to organize your autocmds
local augroup = vim.api.nvim_create_augroup("BuildKeymapGroup", { clear = true })

-- Rust-specific keymap
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  group = augroup,
  callback = function()
    vim.keymap.set("n", "<leader>b", function()
      vim.cmd("!cargo b")
    end, { desc = "Run cargo build", buffer = true })
    vim.keymap.set("n", "<leader>B", function()
      vim.cmd("!cargo b -r")
    end, { desc = "Run cargo release build", buffer = true })
    vim.keymap.set("n", "<leader>t", function()
      vim.cmd("!cargo t")
    end, { desc = "Run cargo test", buffer = true })
  end,
})

-- C#-specific keymap
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  group = augroup,
  callback = function()
    vim.keymap.set("n", "<leader>b", function()
      vim.cmd("!dotnet build")
    end, { desc = "Run dotnet build", buffer = true })
    vim.keymap.set("n", "<leader>B", function()
      vim.cmd("!dotnet build -c Release")
    end, { desc = "Run dotnet release build", buffer = true })
    vim.keymap.set("n", "<leader>t", function()
      vim.cmd("!dotnet test")
    end, { desc = "Run dotnet test", buffer = true })
  end,
})
