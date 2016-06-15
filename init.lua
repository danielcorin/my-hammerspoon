-- Config
hs.window.animationDuration = 0
require('sizeup')
local CTRL = "⌃"
local ALT = "⌥"
local CMD = "⌘"
local SHIFT = "⇧"
local all = {CTRL, ALT, CMD}
local right_2 = {ALT, CMD}
local left_2 = {CTRL, ALT}
local split = {CTRL, CMD}
local hyper = {CMD, ALT, CTRL, SHIFT}

-- Config reload
function reloadConfig(files)
    -- Kill wifi watcher
    if wifiWatcher then
      wifiWatcher:stop()
    end
    -- Kill caffeine
    if caffeine then
      caffeine:delete()
    end
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


local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
    local result
    if state then
        result = caffeine:setIcon("caffeine-on.pdf")
    else
        result = caffeine:setIcon("caffeine-off.pdf")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- Caffine hotkey toggle
hs.hotkey.bind(all, 'C', function ()
	caffeineClicked()
end)


-------------------------------------------------------------------------------------
-- Network connection and disconnection
-------------------------------------------------------------------------------------
local wifiWatcher = nil
function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()
    if newSSID then
      hs.alert.show("Network connected: " .. newSSID)
    else
      hs.alert.show("Network lost")
    end
end
wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()


-- Toggle an application between being the frontmost app, and being hidden
function toggle_application(_app)
    local app = hs.appfinder.appFromName(_app)
    if not app then
        -- this seems to be unstable for Firefox
        hs.application.launchOrFocus(_app)
        return
    end
    local mainwin = app:mainWindow()
    if mainwin then
        if mainwin == hs.window.focusedWindow() then
            mainwin:application():hide()
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
        end
    end
end

-- Application hotkeys
hs.hotkey.bind(all, 't', function() toggle_application("Terminal") end)
hs.hotkey.bind(all, 'i', function() toggle_application("Sublime Text") end)
hs.hotkey.bind(all, 'o', function() toggle_application("Google Chrome") end)
hs.hotkey.bind(all, '0', function() toggle_application("HipChat") end)
hs.hotkey.bind(all, 'r', function() toggle_application("Radiant Player") end)
hs.hotkey.bind(all, 'p', function() toggle_application("Mail") end)
hs.hotkey.bind(all, '=', function() toggle_application("FromScratch") end)

function mouseHighlight()
  if mouseCircle then
    mouseCircle:delete()
    if mouseCircleTimer then
      mouseCircleTimer:stop()
    end
  end
  mousepoint = hs.mouse.getAbsolutePosition()
  mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
  mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
  mouseCircle:setFill(false)
  mouseCircle:setStrokeWidth(3)
  mouseCircle:bringToFront(true)
  mouseCircle:show()

  mouseCircleTimer = hs.timer.doAfter(1, function() mouseCircle:delete() end)
end

hs.hotkey.bind(all, "'", function() mouseHighlight() end)

-- Show config
hs.hotkey.bind(all, 'E', function ()
  io.popen('open ~/.hammerspoon/init.lua')
end)


hs.hotkey.bind(all, 'w', function ()
  hs.alert.show("WiFi Reset")
  io.popen('wf -d 1')
end)

-- Screensaver
hs.hotkey.bind(all, '\\', function ()
  io.popen('open /System/Library/Frameworks/ScreenSaver.framework/Versions/Current/Resources/ScreenSaverEngine.app/')
end)
