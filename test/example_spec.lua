-- test/example_spec.lua
-- Example test file demonstrating the test pattern for notify.nvim

local lu = require('luaunit')
local notify = require('notify')

TestNotify = {}

function TestNotify:setUp()
  notify.setup({
    easing_func = 'linear',
    timeout = 100,
  })
end

function TestNotify:tearDown()
  notify.close_all()
end

function TestNotify:test_setup_returns_notify_table()
  lu.assertNotNil(notify)
  lu.assertEquals(type(notify.setup), 'function')
  lu.assertEquals(type(notify.notify), 'function')
  lu.assertEquals(type(notify.get_history), 'function')
  lu.assertEquals(type(notify.close_all), 'function')
end

function TestNotify:test_get_history_returns_table()
  local history = notify.get_history()
  lu.assertEquals(type(history), 'table')
end

TestEasing = {}

function TestEasing:test_easing_module_exists()
  local easing = require('notify.easing')
  lu.assertNotNil(easing)
end

function TestEasing:test_linear_function()
  local easing = require('notify.easing')
  lu.assertNotNil(easing.linear)
  lu.assertEquals(type(easing.linear), 'function')
  -- linear(0, 0, 100, 100) should be 0
  lu.assertEquals(easing.linear(0, 0, 100, 100), 0)
  -- linear(50, 0, 100, 100) should be 50
  lu.assertEquals(easing.linear(50, 0, 100, 100), 50)
  -- linear(100, 0, 100, 100) should be 100
  lu.assertEquals(easing.linear(100, 0, 100, 100), 100)
end

function TestEasing:test_all_easing_functions_exist()
  local easing = require('notify.easing')
  local expected = {
    'linear',
    'inQuad',
    'outQuad',
    'inOutQuad',
    'outInQuad',
    'inCubic',
    'outCubic',
    'inOutCubic',
    'outInCubic',
    'inQuart',
    'outQuart',
    'inOutQuart',
    'outInQuart',
    'inQuint',
    'outQuint',
    'inOutQuint',
    'outInQuint',
    'inSine',
    'outSine',
    'inOutSine',
    'outInSine',
    'inExpo',
    'outExpo',
    'inOutExpo',
    'outInExpo',
    'inCirc',
    'outCirc',
    'inOutCirc',
    'outInCirc',
    'inElastic',
    'outElastic',
    'inOutElastic',
    'outInElastic',
    'inBack',
    'outBack',
    'inOutBack',
    'outInBack',
    'inBounce',
    'outBounce',
    'inOutBounce',
    'outInBounce',
  }
  for _, name in ipairs(expected) do
    lu.assertNotNil(easing[name], 'Missing easing function: ' .. name)
    lu.assertEquals(type(easing[name]), 'function', 'Not a function: ' .. name)
  end
end

TestUtil = {}

function TestUtil:test_util_module_exists()
  local util = require('notify.util')
  lu.assertNotNil(util)
end

function TestUtil:test_generate_simple()
  local util = require('notify.util')
  lu.assertNotNil(util.generate_simple)
  lu.assertEquals(type(util.generate_simple), 'function')
  local result = util.generate_simple(10)
  lu.assertEquals(#result, 10)
  local result2 = util.generate_simple(5)
  lu.assertEquals(#result2, 5)
end

return TestNotify

