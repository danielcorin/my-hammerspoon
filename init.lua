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

dofile("anycomplete.lua")

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
caffeineClicked()

function mute_audio(seconds)
	hs.alert.show('Muting temporarily')
	audio = hs.audiodevice.defaultOutputDevice()
	audio:setMuted(true)
	hs.timer.doAfter(seconds, function()
		audio:setMuted(false)
	end)
end

hs.hotkey.bind(split, 'M', function ()
	mute_audio(60)
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
hs.hotkey.bind(hyper, 'i', function() toggle_application("Sublime Text") end)
hs.hotkey.bind(hyper, 'o', function() toggle_application("Google Chrome") end)
hs.hotkey.bind(hyper, '2', function() toggle_application("Messages") end)
hs.hotkey.bind(hyper, '-', function() toggle_application("Whatsapp") end)
hs.hotkey.bind(hyper, 'r', function() toggle_application("Spotify") end)
hs.hotkey.bind(hyper, 'z', function() toggle_application("zoom.us") end)

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


-------------
--- Timer ---
-------------

-- local timerLength = 1200  -- 20 minutes
-- local timerBar = hs.menubar.new()

-- local secondsLeft = timerLength


-- function updateTimer()
--   local timeMin = math.floor( (secondsLeft / 60))
--   local timeSec = secondsLeft - (timeMin * 60)
--   local str = string.format("%02d", timeMin)
--   setMenu(timerBar, timeMin, timeSec)
--   hs.printf(str)
--   if secondsLeft == 0 then
--     hs.notify.new({
--         title="Take a break",
--         informativeText="20 minutes have passed",
--         alwaysPresent=true
--     }):send()
--     hs.alert(" Timer over ")
--   end
--   timerBar:setTitle(str)
-- end

-- function decrementTimer()
--   secondsLeft = secondsLeft - 1
--   updateTimer()
-- end


-- function startTimer()
--   if secondsLeft == 0 then
--     secondsLeft = timerLength
--   end
--   updateTimer()
--   hs.alert(" Timer started ")
--   hs.timer.doWhile(
--     function()
--       return secondsLeft > 0
--     end,
--     decrementTimer,
--     1
--   )
-- end

-- function resetTimer()
--   secondsLeft = 0
--   updateTimer()
-- end

-- function setMenu(timerBar, timeMin, timeSec)
--   timerBar:setMenu({
--     {
--       title = string.format("Time remaining: %02d:%02d", timeMin, timeSec),
--       disabled = true
--     },
--     {
--       title = "Start timer",
--       fn = startTimer
--     },
--     {
--       title = "Reset timer",
--       fn = resetTimer
--     }
--   })
-- end

-- updateTimer()


-- hs.hotkey.bind(all, 't', function ()
--   startTimer()
-- end)

-- hs.hotkey.bind(all, 'y', function ()
--   resetTimer()
-- end)


hs.hotkey.bind(all, "'", function() mouseHighlight() end)

-- Show config
hs.hotkey.bind(all, 'e', function ()
  io.popen('open ~/.hammerspoon/init.lua')
end)
