-- Beginning
hs.window.animationDuration = 0
local CTRL = "ctrl"
local ALT = "alt"
local CMD = "cmd"
local all = {CTRL, ALT, CMD}
local right_2 = {ALT, CMD}
local left_2 = {CTRL, ALT}
local split = {CTRL, CMD}

-- Window resizing

hs.hotkey.bind(all, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:fullFrame()

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
  local max = screen:fullFrame()

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
  local max = screen:fullFrame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)

-- Multi monitor
hs.hotkey.bind(all, 'N', hs.grid.pushWindowNextScreen)
hs.hotkey.bind(all, 'P', hs.grid.pushWindowPrevScreen)

-- local caffeine = hs.menubar.new()
-- function setCaffeineDisplay(state)
--     if state then
--         caffeine:setTitle("AWAKE")
--     else
--         caffeine:setTitle("SLEEPY")
--     end
-- end

-- function caffeineClicked()
--     setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
-- end

-- if caffeine then
--     caffeine:setClickCallback(caffeineClicked)
--     setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
-- end

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

-- Show config
hs.hotkey.bind(all, 'E', function ()
  io.popen('open ~/.hammerspoon/init.lua')
end)

-- Config reload
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

