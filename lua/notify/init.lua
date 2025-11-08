local M = {}

local util = require('notify.util')

local empty = function(expr)
  return vim.fn.empty(expr) == 1
end

local extend = function(t1, t2) -- {{{
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

local easing = require('notify.easing')
local fps = 120
local total_time = 300
local step = 0
local easing_func = 'linear'

local notifications = {}
M.message = {}
M.notification_width = 1
M.notify_max_width = 0
M.winid = -1
M.bufnr = -1
M.title = ''
M.winblend = 0
M.timeout = 3000
M.hashkey = ''
M.config = {}
M.notification_color = 'Normal'
M.winhighlight = 'NormalFloat:Normal,FloatBorder:WinSeparator,Search:None,CurSearch:None'

local NT = {}

---@param msg string|table<string> notification messages
---@param opts table notify options
---  - title: string, the notify title
function NT.notify(msg, ...) -- {{{
  local opts = select(1, ...) or {}
  if M.is_list_of_string(msg) then
    extend(M.message, msg)
  elseif type(msg) == 'string' then
    table.insert(M.message, msg)
  end
  if M.notify_max_width == 0 then
    M.notify_max_width = vim.o.columns * 0.30
  end
  if type(opts) == 'string' then
    M.notification_color = opts
  elseif type(opts) == 'table' then
    M.notification_color = opts.color or 'Normal'
  end
  if empty(M.hashkey) then
    M.hashkey = util.generate_simple(10)
  end
  if opts.easing then
    fps = opts.easing.fps or 60
    total_time = opts.easing.time or 300
    easing_func = opts.easing.func or 'linear'
  end
  M.redraw_windows()
  vim.fn.setbufvar(M.bufnr, '&number', 0)
  vim.fn.setbufvar(M.bufnr, '&relativenumber', 0)
  vim.fn.setbufvar(M.bufnr, '&cursorline', 0)
  vim.fn.setbufvar(M.bufnr, '&bufhidden', 'wipe')
  notifications[M.hashkey] = M
  M.increase_window()
  if type(msg) == 'table' then
    vim.fn.timer_start(M.timeout, M.close, { ['repeat'] = #msg })
  else
    vim.fn.timer_start(M.timeout, M.close, { ['repeat'] = 1 })
  end
end
---@param msg table<string> # a string message list
---@return number
local function msg_real_len(msg)
  local l = 0
  for _, m in pairs(msg) do
    l = l + #vim.split(m, '\n')
  end
  return l
end

function M.close_all() -- {{{
  M.message = {}

  if M.win_is_open then
    vim.api.nvim_win_close(M.winid, true)
  end

  if notifications[M.hashkey] then
    notifications[M.hashkey] = nil
  end
  M.notification_width = 1
  step = 0
  easing_func = ''
end
-- }}}

function M.win_is_open()
  if M.winid > 0 then
    return vim.api.nvim_win_is_valid(M.winid)
  else
    return false
  end
end
-- }}}

function M.is_list_of_string(t) -- {{{
  if type(t) == 'table' then
    for _, v in pairs(t) do
      if type(v) ~= 'string' then
        return false
      end
    end
    return true
  end
  return false
end
-- }}}

local function message_body(m) -- {{{
  local b = {}
  for _, v in pairs(m) do
    extend(b, vim.split(v, '\n'))
  end
  return b
end
-- }}}

function M.redraw_windows()
  if empty(M.message) then
    return
  end
  M.begin_row = 2
  -- detached plugin no need to read shared notifys
  local ok, viml_notify = pcall(vim.fn['SpaceVim#api#notify#shared_notifys'])
  if ok then
    for hashkey, _ in pairs(viml_notify) do
      M.begin_row = M.begin_row + msg_real_len(viml_notify[hashkey].message) + 2
    end
  end
  for hashkey, _ in pairs(notifications) do
    if hashkey ~= M.hashkey then
      M.begin_row = M.begin_row + msg_real_len(notifications[hashkey].message) + 2
    else
      break
    end
  end
  if M.win_is_open() then
    vim.api.nvim_win_set_config(M.winid, {
      relative = 'editor',
      width = M.notification_width,
      height = msg_real_len(M.message),
      row = M.begin_row + 1,
      focusable = false,
      border = 'rounded',
      col = vim.o.columns - M.notification_width - 1,
    })
  else
    if vim.fn.bufexists(M.bufnr) ~= 1 then
      M.bufnr = vim.api.nvim_create_buf(false, true)
    end
    M.winid = vim.api.nvim_open_win(M.bufnr, false, {
      relative = 'editor',
      width = M.notification_width,
      height = msg_real_len(M.message),
      row = M.begin_row + 1,
      col = vim.o.columns - M.notification_width - 1,
      border = 'rounded',
      focusable = false,
      noautocmd = true,
    })
    vim.api.nvim_win_set_option(M.winid, 'winhighlight', M.winhighlight)
    vim.fn.matchadd(M.notification_color, '.*', 10, -1, {
      window = M.winid,
    })
    if
      M.winblend > 0
      and vim.fn.exists('&winblend') == 1
      and vim.fn.exists('*nvim_win_set_option') == 1
    then
      vim.api.nvim_win_set_option(M.winid, 'winblend', M.winblend)
    end
  end
  vim.api.nvim_buf_set_lines(M.bufnr, 0, -1, false, message_body(M.message))
  vim.api.nvim_win_set_cursor(M.winid, { 1, 0 })
end

function M.increase_window()
  if M.notification_width <= M.notify_max_width and M.win_is_open() then
    step = step + 1
    if easing[easing_func] then
      M.notification_width = math.floor(
        easing[easing_func](
          math.floor(1000 / fps + 0.5) * step,
          1,
          M.notify_max_width - 1,
          total_time
        ) + 0.5
      )
    else
      M.notification_width = math.floor(
        easing.linear(math.floor(1000 / fps + 0.5) * step, 1, M.notify_max_width - 1, total_time)
          + 0.5
      )
    end
    M.redraw_windows()
    vim.fn.timer_start(math.floor(1000 / fps + 0.5), M.increase_window, { ['repeat'] = 1 })
  end
end

function M.close(...) -- {{{
  if not empty(M.message) then
    table.remove(M.message, 1)
  end
  if #M.message == 0 then
    if M.win_is_open() then
      local ei = vim.o.eventignore
      vim.o.eventignore = 'all'
      vim.api.nvim_win_close(M.winid, true)
      vim.o.eventignore = ei
    end
    if notifications[M.hashkey] then
      notifications[M.hashkey] = nil
    end
    M.notification_width = 1
    step = 0
    easing_func = ''
  end
  for hashkey, _ in pairs(notifications) do
    notifications[hashkey].redraw_windows()
  end
end
-- }}}

function NT.setup(opt)
  opt = opt or {}

  if opt.easing_func and type(opt.easing_func) == 'string' and easing[opt.easing_func] then
    easing_func = opt.easing_func
  end
  M.timeout = opt.timeout or M.timeout
end

return NT
