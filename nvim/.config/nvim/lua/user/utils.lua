local M = {}

---Creates an augroup while clearing previous
---@param name string The name of the augroup.
---@return number id The augroup id
function M.augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Helper functions
vim.cmd [[
function! GetVisualSelection() abort
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection ==? 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  let entire_selection = join(lines, "\n")
  return entire_selection
endfunction

function! GetMotion(motion)
  let saved_register = getreg('a')
  defer setreg('a', saved_register)

  exe 'normal! ' .. a:motion .. '"ay'
  return @a
endfunction

function! ReplaceMotion(motion, text)
  let saved_register = getreg('a')
  defer setreg('a', saved_register)

  let @a = a:text

  exe 'normal! ' .. a:motion .. '"ap'
endfunction
]]

-- Cache commonly used vim.fn calls
local getpos = vim.fn.getpos
local getregion = vim.fn.getregion
local getcwd = vim.fn.getcwd

-- Consolidated VimL functions into Lua
function M.get_visual_selection()
  local mode = vim.api.nvim_get_mode().mode
  -- \22 is an escaped version of <c-v>
  if mode == 'v' or mode == 'V' or mode == '\22' then
    return getregion(getpos 'v', getpos '.', { type = mode })
  end
  return getregion(getpos 'v', getpos '.')
end

function M.get_os_command_output(cmd, cwd)
  if type(cmd) ~= 'table' then
    M.pretty_print('cmd has to be a table', vim.log.levels.ERROR, '🖥️')
    return '', -1, ''
  end

  local Job = require 'plenary.job'
  local command = table.remove(cmd, 1)
  local stderr = {}

  ---@diagnostic disable-next-line: missing-fields
  local stdout, ret = Job:new({
    command = command,
    args = cmd,
    cwd = cwd or getcwd(),
    on_stderr = function(_, data)
      table.insert(stderr, data)
    end,
  }):sync()

  return stdout, ret, stderr
end

---Pretty print using vim.notify
---@param message string The message to print
---@param title? string The title of the notification
---@param icon? string The icon of the notification
---@param level? number The log level of the notification
---@param timeout? number The timeout of the notification
function M.pretty_print(message, title, icon, level, timeout)
  vim.notify(message, level or vim.log.levels.INFO, {
    title = title or 'Neovim',
    icon = icon or '',
    timeout = timeout or 3000,
  })
end

-- Precompute byte offsets for country code conversion
local COUNTRY_CODE_OFFSET = 127397

---Converts country code to emoji of the country flag
---@param country_iso string The country code in 2 uppercase letters
---@return string emoji of the country flag
function M.country_os_to_emoji(country_iso)
  local flag_icon = {}
  for i = 1, #country_iso do
    local code_point = country_iso:byte(i) + COUNTRY_CODE_OFFSET
    if code_point <= 0x7F then
      table.insert(flag_icon, string.char(code_point))
    elseif code_point <= 0x7FF then
      table.insert(flag_icon, string.char(0xC0 + math.floor(code_point / 0x40), 0x80 + code_point % 0x40))
    elseif code_point <= 0xFFFF then
      table.insert(flag_icon, string.char(0xE0 + math.floor(code_point / 0x1000), 0x80 + math.floor((code_point % 0x1000) / 0x40), 0x80 + code_point % 0x40))
    elseif code_point <= 0x10FFFF then
      table.insert(
        flag_icon,
        string.char(
          0xF0 + math.floor(code_point / 0x40000),
          0x80 + math.floor((code_point % 0x40000) / 0x1000),
          0x80 + math.floor((code_point % 0x1000) / 0x40),
          0x80 + code_point % 0x40
        )
      )
    end
  end
  return table.concat(flag_icon)
end

---Get the next index in a table after the current element
---@param tbl table The table to search in
---@param cur any The current element to find
---@return number index The next index in the table (loops back to 1)
function M.tbl_get_next(tbl, cur)
  for i, v in ipairs(tbl) do
    if v == cur then
      return i % #tbl + 1
    end
  end
  return 1
end

-- Static mappings
M.filetype_to_extension = {
  bash = 'sh',
  javascript = 'js',
  javascriptreact = 'jsx',
  kotlin = 'kt',
  markdown = 'md',
  perl = 'pl',
  python = 'py',
  ruby = 'rb',
  rust = 'rs',
  terraform = 'tf',
  typescript = 'ts',
  typescriptreact = 'tsx',
  zsh = 'sh',
}

M.filetype_to_command = {
  javascript = 'node',
  typescript = 'node',
  typescriptreact = 'node',
  python = 'python3',
  html = 'open',
  sh = 'bash',
  zsh = 'zsh',
  go = 'go',
  yaml = 'yq',
  json = 'jq',
}

-- Cache emojis table
local EMOJIS = {
  '🤩',
  '👻',
  '😈',
  '✨',
  '👰',
  '👑',
  '💯',
  '💖',
  '🌒',
  '🇮🇱',
  '★',
  '⚓️',
  '🙉',
  '☘️',
  '🌍',
  '🥨',
  '🔥',
  '🚀',
}

function M.random_emoji()
  return EMOJIS[math.random(#EMOJIS)]
end

return M
