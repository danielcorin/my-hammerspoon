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


-- Replace Caffeine.app with 18 lines of Lua :D
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
hs.hotkey.bind({CMD}, '1', function() toggle_application("Terminal") end)
hs.hotkey.bind({CMD}, '2', function() toggle_application("Sublime Text") end)
hs.hotkey.bind({CMD}, '3', function() toggle_application("Google Chrome") end)


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


function usbDeviceCallback(data)
  print("usbDeviceCallback: "..hs.inspect(data))
  -- if data.eventType == "added" then
  --   keys = hs.eventtap.checkKeyboardModifiers()
  --   if not keys.shift then
  --     hs.caffeinate.lockScreen()
  --   end
  -- end
end

usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()

-- Show config
hs.hotkey.bind(all, 'E', function ()
  io.popen('open ~/.hammerspoon/init.lua')
end)

-- Screensaver
hs.hotkey.bind(all, '\\', function ()
  io.popen('open /System/Library/Frameworks/ScreenSaver.framework/Versions/Current/Resources/ScreenSaverEngine.app/')
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
