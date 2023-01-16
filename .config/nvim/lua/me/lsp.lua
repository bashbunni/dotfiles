-- Native LSP Setup
require("me.keymap")
-- Global setup.
local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<CR>'] = function(fallback)
      if cmp.visible() then
        cmp.confirm()
      else
        fallback()
      end
    end
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client, bufnr)

  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- leaving only what I actually use...
  nmap { "K", "<cmd>Lspsaga hover_doc<CR>", opts }
  -- nmap { "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts }
  nmap { "gd", "<cmd>Telescope lsp_definitions<CR>", opts }
  nmap { "gr", "<cmd>Telescope lsp_references<CR>", opts }
  nmap { "<C-j>", "<cmd>Telescope lsp_document_symbols<CR>", opts }
  nmap { "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts }

  nmap { "gi", "<cmd>Telescope lsp_implementations<CR>", opts }
  nmap { "<leader>D", "<cmd>Telescope lsp_type_definitions<CR>", opts }
  nmap { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts }
  nmap { '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts }
  nmap { "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts }
  nmap { "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts }
  nmap { "<leader>dj", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts }
  nmap { "<leader>dk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts }
  nmap { "<leader>r", "<cmd>Lspsada rename<CR>", opts }

  vim.cmd([[
            augroup formatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
                autocmd BufWritePre <buffer> lua OrganizeImports(1000)
            augroup END
        ]])

  -- Set autocommands conditional on server_capabilities
  vim.cmd([[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]])
end

-- organize imports
-- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-902680058
function OrganizeImports(timeoutms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeoutms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

local lspconfig = require('lspconfig')
lspconfig.gopls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      gofumpt = true,
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
}

lspconfig.sumneko_lua.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.hls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.golangci_lint_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      gofumpt = true,
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
}

lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = {
    "rustup", "run", "stable", "rust-analyzer",
  }
}
