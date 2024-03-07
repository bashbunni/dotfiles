-- a must: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- Native LSP Setup
require("me.keymap")
vim.lsp.set_log_level("debug")

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
  nmap { "cd", "<cmd>Telescope lsp_definitions<CR>", opts }
  nmap { "cr", "<cmd>Telescope lsp_references<CR>", opts }
  nmap { "<C-j>", "<cmd>Telescope lsp_document_symbols<CR>", opts }
  nmap { "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts }

  nmap { "<leader>ci", "<cmd>Telescope lsp_implementations<CR>", opts }
  nmap { "<leader>D", "<cmd>Telescope lsp_type_definitions<CR>", opts }
  nmap { "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts }
  nmap { '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts }
  nmap { "<leader>ck", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts }
  nmap { "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts }
  nmap { "<leader>cp", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts }
  nmap { "<leader>cn", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts }
  nmap { "<leader>cl", "<cmd>Telescope diagnostics<CR>", opts }

  if client.server_capabilities.documentFormattingProvider then
    vim.cmd([[
            augroup formatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
            augroup END
        ]])
  end

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]])
  end
end

-- organize imports
-- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-902680058
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go" },
  callback = function()
    local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
    params.context = { only = { "source.organizeImports" } }

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end,
})

local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

local servers = {
  elmls = {},
  rust_analyzer = {
    cmd = {
      "rustup", "run", "stable", "rust-analyzer",
    }
  },
  ltex = {
    diagnostics = { disable = { 'missing-fields' } },
  },
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
        },
      },
    }
  },
  hls = {
    settings = {
      haskell = {
        cabalFormattingProvider = "cabalfmt",
        formattingProvider = "ormolu"
      }
    },
    single_file_support = true,
  },
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
      },
    },
    flags = {
      debounce_text_changes = 150,
    },
  },

  golangci_lint_ls = {},
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        workspace = {
          checkThirdParty = false,
          -- Tells lua_ls where to find all the Lua files that you have loaded
          -- for your neovim configuration.
          library = {
            '${3rd}/luv/library',
            unpack(vim.api.nvim_get_runtime_file('', true)),
          },
        },
      },
    },
  }
}

local ensureinstalled = vim.tbl_keys(servers)

require('mason-lspconfig').setup {
  ensure_installed = ensureinstalled,
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      require('lspconfig')[server_name].setup {
        cmd = server.cmd,
        settings = server.settings,
        filetypes = server.filetypes,
        flags = server.flags,
        root_dir = server.root_dir,
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for tsserver)
        capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {}),
        on_attach = on_attach,
      }
    end,
  },
}
