local default_on_attach = require 'user.lsp.on-attach'
local status_ok, null_ls = pcall(require, 'null-ls')
if not status_ok then
  return vim.notify 'Module null-ls not installed'
end
local helpers = require 'null-ls.helpers'

null_ls.register {
  name = 'jenkinsfile',
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { 'Jenkinsfile' },
  generator = helpers.generator_factory {
    command = 'curl',
    dynamic_command = function(params)
      local handle = io.popen [[curl -s -w "%{http_code}" "http://localhost:41595/" -o /dev/null]]
      local result = handle:read '*a'
      if result == '200' then
        return params.command
      else
        io.popen 'start-jenkins-validate'
        return ''
      end
    end,
    args = {
      '-s',
      '-X',
      'POST',
      '-F',
      'jenkinsfile=<$FILENAME',
      'http://localhost:41595/pipeline-model-converter/validate',
    },
    to_stdin = false,
    to_temp_file = true,
    format = 'line',
    multiple_files = false,
    on_output = function(line, params)
      local msg, line_str, col_str = line:match 'WorkflowScript.+%d+: (.+) @ line (%d+), column (%d+).'
      if line_str and col_str then
        local line_n = tonumber(line_str)
        local col = tonumber(col_str)
        return {
          col = col,
          row = line_n,
          message = msg,
          source = 'jenkinsfile',
        }
      end
    end,
    check_exit_code = function(code)
      if code ~= 0 then
        vim.schedule(function()
          vim.notify('Jenkins validate is not running yet', vim.log.levels.ERROR)
        end)
        return false
      else
        return true
      end
    end,
  },
}

-- null-ls
local sh_extra_fts = { 'bash', 'zsh' }
null_ls.setup {
  on_attach = function(client, bufnr)
    default_on_attach(client, bufnr)
    vim.keymap.set('n', '<leader>=', vim.lsp.buf.formatting, { noremap = true, buffer = bufnr })
  end,
  debug = true,
  sources = {
    -- null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.code_actions.refactoring,
    -- null_ls.builtins.diagnostics.eslint_d,
    -- null_ls.builtins.diagnostics.markdownlint,
    -- null_ls.builtins.diagnostics.write_good,
    -- null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.fixjson,
    -- null_ls.builtins.formatting.markdownlint,
    null_ls.builtins.code_actions.shellcheck.with {
      extra_filetypes = sh_extra_fts,
    },
    null_ls.builtins.diagnostics.ansiblelint,
    null_ls.builtins.diagnostics.hadolint,
    null_ls.builtins.diagnostics.pylint,
    null_ls.builtins.diagnostics.vint,
    null_ls.builtins.diagnostics.shellcheck.with {
      extra_filetypes = sh_extra_fts,
    },
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.stylua.with {
      extra_args = { '--config-path', vim.fn.expand '~' .. '/stylua.toml' },
    },
    null_ls.builtins.formatting.shfmt.with {
      extra_filetypes = sh_extra_fts,
    },
  },
}
