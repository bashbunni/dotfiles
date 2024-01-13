local options = {
  ma = true,
  mouse = "a",
  cursorline = false,
  tabstop = 4,
  shiftwidth = 4,
  softtabstop = 4,
  expandtab = true,
  autoread = true,
  nu = true,
  foldlevelstart = 99,
  scrolloff = 7,
  backup = false,
  writebackup = false,
  swapfile = false,
  clipboard = "unnamedplus",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
