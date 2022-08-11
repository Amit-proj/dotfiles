local wk = require 'which-key'
local show = wk.show
-- Allow <c-r> on telescope window
wk.show = function(keys, opts)
  if vim.bo.filetype == 'TelescopePrompt' then
    local map = '<c-r>'
    local key = vim.api.nvim_replace_termcodes(map, true, false, true)
    vim.api.nvim_feedkeys(key, 'i', true)
  end
  show(keys, opts)
end
local opts = {
  mode = 'n', -- NORMAL mode
  prefix = '',
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}

local mappings = {
  ['<C-P>'] = { 'Find files' },
  ['<C-H>'] = { 'Go to left window' },
  ['<C-L>'] = { 'Go to right window' },
  ['<C-J>'] = { 'Go to below window' },
  ['<C-K>'] = { 'Go to above window' },
  ['<C-B>'] = { 'Active Buffers' },
  ['<C-O>'] = { 'Open NerdTree' },
  ['<C-E>'] = { 'Window Resize' },
  ['<C-F>'] = { 'Project wide search' },
  ['<C-T>'] = { 'Go back from definiton' },
  ['<C-]>'] = { 'Go to definiton' },
  ['<C-U>'] = { 'Scroll Up' },
  ['<C-D>'] = { 'Scroll Down' },
  ['<C-R>'] = { 'Redo' },
  ['<F5>'] = { 'Execute the file as a script' },
  ['<F4>'] = { 'Choose Git Branch' },
  ['<F6>'] = { 'Toggle floating terminal' },
  ['<F7>'] = { 'Open a new floating terminal' },
  ['<F8>'] = { 'Switch floating terminal window' },
  ['<TAB>'] = { 'Jump to next window' },
  ['['] = {
    name = '+Previous',
    c = { 'Previous git hunk' },
    g = { 'Previous diagnostic' },
    l = { 'Previous location entry' },
    q = { 'Previous quickfix entry' },
  },
  [']'] = {
    name = '+Next',
    c = { 'Next git hunk' },
    g = { 'Next diagnostic' },
    l = { 'Next location entry' },
    q = { 'Next quickfix entry' },
  },
  ['*'] = { 'Forward search word under cursor' },
  ['#'] = { 'Backward search word under cursor' },
  [','] = { 'Go to previous occurence of (t | f)' },
  [';'] = { 'Go to next occurence of (t | f)' },
  ['_'] = { 'Move Line Down' },
  ['-'] = { 'Move Line Up' },
  c = {
    i = {
      i = { 'Change indent size in current buffer' },
    },
  },
  g = {
    D = { 'Go to Declaration' },
    V = { 'Visually select last inserted text' },
    a = { 'Motion Pending Align' },
    c = { 'Motion Pending Comment' },
    d = { 'Go to Definition' },
    i = { 'Go to Implementation' },
    r = { 'Go to References' },
    y = { 'Go to Type Definition' },
  },
  K = { 'Show documentation under cursor' },
  N = { 'Previous match' },
  n = { 'Next match' },
  Q = { 'Run Macro' },
  S = { 'Search backaward 2 characters after' },
  s = { 'Search forward 2 characters after' },
  Y = { 'Copy buffer to clipboard' },
  ['<leader>'] = {
    c = {
      c = { 'Select YAML schema' },
      d = { 'Change directory to current file' },
      f = {
        name = '+Copy file path',
        a = { 'Copy full file path' },
        p = { 'Copy file path' },
      },
      p = { 'Copy [n] lines and paste below' },
      t = {
        ['<SPACE'] = { 'Convert tabs to spaces' },
      },
    },
    b = {
      name = '+Buffer',
      c = { 'Close' },
      d = { 'Delete' },
      n = { 'Next' },
      o = { 'Close all but current' },
    },
    d = {
      name = '+Diff',
      f = { 'Off' },
      g = { 'Get' },
      n = { 'On' },
      p = { 'Put' },
    },
    e = {
      name = '+Edit',
      c = { 'Plugin Configs file' },
      l = { 'LSP Config file' },
      m = { 'Mappings file' },
      p = { 'Plugins file' },
      v = { 'Options file' },
    },
    f = {
      name = '+Fold',
      c = { 'Close All' },
      f = { 'Fold' },
      l = { 'Open level folds' },
      o = { 'Open All' },
    },
    g = {
      name = '+Git',
      b = { 'Paste branch name' },
      c = { 'CD to root' },
      f = { 'Focus on Git window' },
      g = { 'Status' },
      h = { 'History (current file)' },
      l = { 'Pull' },
      m = { 'Actions Menu' },
      p = { 'Push' },
    },
    h = { name = '+Hunks' },
    J = { 'Open AnyJump window' },
    l = {
      name = '+LSP',
      a = { 'Code Actions' },
      d = { 'Show line diagnostics' },
      e = { 'Open Diagnostics Float' },
      k = { 'Signature Help' },
      p = { 'Format Document' },
      q = { 'Open Diagnostics on QuickFix' },
      r = {
        f = { 'Show references' },
        n = { 'Rename symbol' },
      },
      s = { 'Create a file in temp dir' },
      t = { 'Create a temporary file' },
      w = {
        name = '+Workspace',
        a = { 'Add workspace dir' },
        r = { 'Remove workspace dir' },
        l = { 'Print workspace dirs' },
      },
      x = { 'Run CodeLens' },
    },
    m = {
      name = '+Mouse',
      a = { 'All modes' },
      v = { 'Visual mode' },
    },
    q = {
      name = '+Quit',
      q = { 'Close all buffers and quit' },
    },
    r = { 'Search and Replace Word Under Cursor' },
    S = { 'Spectre Search and Replace' },
    sa = { 'Visually select all' },
    t = {
      name = '+Toggle',
      b = { 'Toggle blame line' },
    },
    v = { 'Show current file on NerdTree' },
    x = {
      name = '+Trouble',
      d = { 'Diagnostics' },
      l = { 'Location list' },
      q = { 'Quickfix' },
      w = { 'Workspace Diagnostics' },
      x = { 'Trouble' },
    },
    ['('] = 'Split param line',
    ['\\'] = 'Split bash line',
    ['<CR>'] = { 'Change \\n to new lines' },
    ['<SPACE>'] = { 'Change buffer' },
    ['='] = { 'Underline with equals (=)' },
  },
}
wk.register(mappings, opts)
