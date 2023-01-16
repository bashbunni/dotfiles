local globals = {
    mapleader = " ",
    glow_binary_path = vim.env.HOME .. "/bin",
    glow_use_pager = true,
    glow_border = "shadow",
}

for k, v in pairs(globals) do
    vim.g[k] = v
end
