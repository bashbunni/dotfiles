-- vim.g.mapleader = " "
-- vim.g.glow_binary_path = vim.env.HOME .. "/bin"
-- vim.g.glow_use_pager = true
-- vim.g.glow_border = "shadow"


local globals = {
	mapleader = " ",
    glow_binary_path = vim.env.HOME .. "/bin",
    glow_use_pager = true,
    glow_border = "shadow",
}

for k, v in pairs(globals) do
	vim.g[k] = v
end

-- Aesthetic
-- pcall catches errors if the plugin doesn't load
local ok, catppuccin = pcall(require, "catppuccin")
if not ok then return end
vim.g.catppuccin_flavour = "macchiato"
catppuccin.setup()
vim.cmd[[colorscheme catppuccin]]

require('me.options')
require('me.lualine')
require('me.lsp')
require('me.telescope')

local keymap = function(tbl)
	local opts = { noremap = true, silent = true }
	local mode = tbl['mode']
	tbl['mode'] = nil
	local bufnr = tbl['bufnr']
	tbl['bufnr'] = nil

	for k, v in pairs(tbl) do
		if tonumber(k) == nil then
			opts[k] = v
		end
	end

	if bufnr ~= nil then
		vim.api.nvim_buf_set_keymap(bufnr, mode, tbl[1], tbl[2], opts)
	else
		vim.api.nvim_set_keymap(mode, tbl[1], tbl[2], opts)
	end
end

nmap = function(tbl)
	tbl['mode'] = 'n'
	keymap(tbl)
end

imap = function(tbl)
	tbl['mode'] = 'i'
	keymap(tbl)
end


local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not ok then return end
treesitter.setup { ensure_installed = "all", highlight = { enable = true } }

-- keymaps
vim.keymap.set("n", "<leader>p", "<cmd>Glow<cr>")
nmap{"<C-f>", "<cmd>Telescope current_buffer_fuzzy_find sorting_strategy=ascending prompt_position=top<CR>"}
nmap{"<leader>lg", "<cmd>Telescope live_grep<CR>"}
nmap{"<leader>dl", "<cmd>Telescope diagnostics<cr>"}

-- navigation
nmap{"L", "<cmd>bnext<cr>"}
nmap{"H", "<cmd>bprevious<cr>"}
nmap{"F", "<cmd>HopPattern<cr>"}
