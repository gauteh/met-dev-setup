HOME = os.getenv("HOME")
vim.o.runtimepath = HOME .. "/.vim," .. vim.o.runtimepath .. "," .. HOME .. "/.vim/after"
vim.g.packpath = vim.o.runtimepath

-- Python3 must be set earlier to avoid virtual-env confusion
vim.g.python3_host_prog = HOME .. "/.mconda3/envs/neovim/bin/python3"
vim.g.path = HOME .. "/.mconda3/envs/neovim/bin"

-- Workaround for high cpu usage with LSPs (should be fixed at some point):
-- https://github.com/neovim/neovim/issues/23725#issuecomment-1561364086
local ok, wf = pcall(require, "vim.lsp._watchfiles")
if ok then
    -- disable lsp watcher. Too slow on linux
    wf._watchfunc = function()
      return function() end
    end
end

vim.cmd('source ~/.vim/vimrc')

require('mason').setup()
-- require("mason-lspconfig").setup({
--     ensure_installed = { "pyright", "rust_analyzer" }
-- })

-- Autocomplete
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false
    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' }, -- For ultisnips users.
    { name = 'path' }
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline('/', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })


local lsp_status = require('lsp-status')
lsp_status.config({
  indicator_errors = 'E',
  indicator_warnings = 'W',
  indicator_info = 'i',
  indicator_hint = '?',
  indicator_ok = '✓',
  status_symbol = 'lang:',
})

lsp_status.register_progress()


-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>o', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[a', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']a', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<space>q', function() vim.diagnostic.setloclist({workspace=true}) end, opts)
-- vim.keymap.set('n', '+f', vim.lsp.buf.format)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gR', vim.lsp.buf.references, bufopts)

  lsp_status.on_attach(client)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

vim.lsp.config('basedpyright', {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
      basedpyright = {
        analysis = {
          diagnosticSeverityOverrides = {
            reportUnknownMemberType = "none",
            reportUnknownVariableType = "none",
            reportUnknownArgumentType = "none",
            reportUnusedCallResult = "none",
            reportConstantRedefinition = "none",
            reportAny = "none",
          }
        }
      }
    }
})
vim.lsp.enable('basedpyright')
vim.lsp.config('clangd', {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities
})
vim.lsp.enable('clangd')
vim.lsp.config('texlab', {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities
})
vim.lsp.enable('texlab')

-- vim.lsp.config('ltex_plus', {
--     on_attach = on_attach,
--     flags = lsp_flags,
--     capabilities = capabilities
-- })
-- vim.lsp.enable('ltex_plus')

vim.lsp.config('rust_analyzer', {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          targetDir = true,
        },
            -- checkOnSave = {
            --         enable = true,
            --         command = "check",
            --         extraArgs = {  "--target-dir", "/tmp/rust-analyzer-check" },
            --},
        diagnostics = {
          refreshSupport = false,
          cargo = {
            features = "all",
          }
        }
      }
    }
})
vim.lsp.enable('rust_analyzer')
-- HACK: Works around <https://github.com/neovim/neovim/issues/30985>.
for _, method in ipairs { "textDocument/diagnostic", "workspace/diagnostic" } do
  local default_diagnostic_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, result, context, config)
    if err ~= nil and err.code == -32802 then return end
    return default_diagnostic_handler(err, result, context, config)
  end
end

-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  logging = true,
  log_level = vim.log.levels.DEBUG,
  filetype = {
    python = {
      function()
        return {
          exe = HOME .. "/.mconda3/envs/neovim/bin/yapf",
          stdin = true
        }
      end
    },
    rust = {
      require("formatter.filetypes.rust").rustfmt
      -- function()
      --   vim.lsp.buf.format()
      -- end
    },
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}

require('hover').config({
  --- List of modules names to load as providers.
  --- @type (string|Hover.Config.Provider)[]
  providers = {
    'hover.providers.lsp',
    'hover.providers.diagnostic',
    'hover.providers.dap',
    'hover.providers.man',
    -- 'hover.providers.dictionary',
    -- Optional, disabled by default:
    'hover.providers.gh',
    -- 'hover.providers.gh_user',
    -- 'hover.providers.jira',
    'hover.providers.fold_preview',
    -- 'hover.providers.highlight',
  },
  preview_opts = {
    border = 'single'
  },
  -- Whether the contents of a currently open hover window should be moved
  -- to a :h preview-window when pressing the hover keymap.
  preview_window = false,
  title = true,
  mouse_providers = {
    'hover.providers.lsp',
  },
  mouse_delay = 1000
})

-- Setup keymaps
vim.keymap.set('n', 'K', function()
  require('hover').open()
end, { desc = 'hover.nvim (open)' })

vim.keymap.set('n', 'gK', function()
  require('hover').enter()
end, { desc = 'hover.nvim (enter)' })

vim.keymap.set('n', '<C-p>', function()
    require('hover').switch('previous')
end, { desc = 'hover.nvim (previous source)' })

vim.keymap.set('n', '<C-n>', function()
    require('hover').switch('next')
end, { desc = 'hover.nvim (next source)' })

-- Mouse support
-- vim.keymap.set('n', '<MouseMove>', function()
--   require('hover').mouse()
-- end, { desc = 'hover.nvim (mouse)' })

-- vim.o.mousemoveevent = true


-- vim.keymap.set("n", "<leader>-", function()
--   require("yazi").yazi()
-- end)

-- local iron = require("iron.core")

-- iron.setup {
--   config = {
--     -- Whether a repl should be discarded or not
--     scratch_repl = true,
--     -- Your repl definitions come here
--     repl_definition = {
--       sh = {
--         -- Can be a table or a function that
--         -- returns a table (see below)
--         command = {"zsh"}
--       },
--       python = require("iron.fts.python").ipython
--     },
--     -- How the repl window will be displayed
--     -- See below for more information
--     repl_open_cmd = require('iron.view').split.vertical.botright(0.4),
--   },
--   -- Iron doesn't set keymaps by default anymore.
--   -- You can set them here or manually add keymaps to the functions in iron.core
--   keymaps = {
--     send_motion = "<space>sc",
--     visual_send = "<space>sc",
--     send_file = "<space>sf",
--     send_line = "<space>sl",
--     send_mark = "<space>sm",
--     mark_motion = "<space>mc",
--     mark_visual = "<space>mc",
--     remove_mark = "<space>md",
--     cr = "<space>s<cr>",
--     interrupt = "<space>s<space>",
--     exit = "<space>sq",
--     clear = "<space>cl",
--   },
--   -- If the highlight is on, you can change how it looks
--   -- For the available options, check nvim_set_hl
--   highlight = {
--     italic = true
--   },
--   ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
-- }

-- iron also has a list of commands, see :h iron-commands for all available commands
-- vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
-- vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
-- vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
-- vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')

-- vim.g.opencode_opts = {
--   -- Your configuration, if any; goto definition on the type or field for details
-- }

vim.o.autoread = true -- Required for `opts.events.reload`

-- Recommended/example keymaps
vim.keymap.set({ "n", "x" }, "+a", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
vim.keymap.set({ "n", "x" }, "+x", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "t" }, "+.", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

vim.keymap.set("n", "<S-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
vim.keymap.set("n", "<S-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })

-- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
-- vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
-- vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
