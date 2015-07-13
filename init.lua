-- Beginning
hs.window.animationDuration = 0
local all = {"cmd", "alt", "ctrl"}

-- Window resizing

hs.hotkey.bind(all, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind(all, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind(all, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)

-- Multi monitor
hs.hotkey.bind(all, 'N', hs.grid.pushWindowNextScreen)
hs.hotkey.bind(all, 'P', hs.grid.pushWindowPrevScreen)

-- Caffeine
hs.hotkey.bind(all, 'C', function ()
	hs.caffeinate.toggle('displayIdle')
	caffeine_status()
end)

function caffeine_status()
	local status = hs.caffeinate.get('displayIdle') and 'on' or 'off'
	hs.alert.show('Caffeine: ' .. status)
end

-- Status
hs.hotkey.bind(all, 'S', function ()
	caffeine_status()
end)

-- Config reload
hs.hotkey.bind(all, "R", function()
  hs.reload()
end)
hs.alert.show("Config loaded")

