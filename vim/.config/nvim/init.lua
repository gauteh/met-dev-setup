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
require("mason-lspconfig").setup()
-- require("mason-lspconfig").setup({
--     ensure_installed = { "pyright", "rust_analyzer" }
-- })

-- Autocomplete
-- require('blink.cmp').setup({
--   keymap = { preset = 'default' },
--   appearance = {
--     nerd_font_variant = 'mono'
--   },
--   completion = {
--     documentation = { auto_show = false },
--     list = {
--       selection = {
--         preselect = true,
--       }
--     }
--   },
--   sources = {
--     default = { 'lsp', 'path', 'snippets', 'buffer' },
--   },
--   fuzzy = {
--     implementation = "prefer_rust_with_warning"
--   }
-- })


  -- Set up nvim-cmp.
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
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'ultisnips' }, -- For ultisnips users.
    }, {
      { name = 'buffer' },
    })
  })
})

local lspkind = require('lspkind')
cmp.setup {
  formatting = {
    fields = { 'abbr', 'icon', 'kind', 'menu' },
    format = lspkind.cmp_format({
      maxwidth = {
        -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        -- can also be a function to dynamically calculate max width such as
        -- menu = function() return math.floor(0.45 * vim.o.columns) end,
        menu = 50, -- leading text (labelDetails)
        abbr = 50, -- actual suggestion item
      },
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function (entry, vim_item)
        -- ...
        return vim_item
      end
    })
  }
}
  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]--

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })


-- lsp
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = true, desc = "Go to definition" })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = true, desc = "Go to declaration" })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = true })
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>o', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[a', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']a', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, { buffer = true })
vim.keymap.set('n', '<space>q', function() vim.diagnostic.setloclist({workspace=true}) end, opts)
vim.keymap.set('n', '+f', vim.lsp.buf.format)

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

vim.lsp.config('basedpyright', {
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

vim.lsp.config('rust_analyzer', {
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

-- -- Utilities for creating configurations
-- local util = require "formatter.util"

-- -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
-- require("formatter").setup {
--   logging = true,
--   log_level = vim.log.levels.DEBUG,
--   filetype = {
--     python = {
--       function()
--         return {
--           exe = HOME .. "/.mconda3/envs/neovim/bin/yapf",
--           stdin = true
--         }
--       end
--     },
--     rust = {
--       require("formatter.filetypes.rust").rustfmt
--       -- function()
--       --   vim.lsp.buf.format()
--       -- end
--     },
--     ["*"] = {
--       -- "formatter.filetypes.any" defines default configurations for any
--       -- filetype
--       require("formatter.filetypes.any").remove_trailing_whitespace
--     }
--   }
-- }


