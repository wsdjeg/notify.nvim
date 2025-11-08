local M = {}

local previewer = require('picker.previewer.buffer')

function M.get()
  local notifys = require('notify').get_history()

  local items = {}
  for _, nt in ipairs(notifys) do
      -- what the fuck, why can not use unpack
      --
    local msg = nt[1]
    local opts = nt[2]
    local color
    if type(opts) == 'string' then
      color = opts
    else
      color = opts.color or 'Normal'
    end
    local item = {}
    if type(msg) == 'table' then
      item.str = msg[1]
      item.context = msg
    else
      item.str = msg
      item.context = { msg }
    end
    table.insert(items, {
      value = item,
      str = item.str,
      highlight = {{
        0,
        #item.str,
        color,
      }
      },
    })
  end

  return items
end

function M.default_action(item) end

M.preview_win = true

---@field item PickerItem
function M.preview(item, win, buf)
  previewer.buflines = item.value.context
  previewer.filetype = nil
  previewer.preview(1, win, buf, true)
end

return M
