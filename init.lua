-- Config
hs.window.animationDuration = 0
require('sizeup')
local CTRL = "ctrl"
local ALT = "alt"
local CMD = "cmd"
local all = {CTRL, ALT, CMD}
local right_2 = {ALT, CMD}
local left_2 = {CTRL, ALT}
local split = {CTRL, CMD}
local hyper = {"⌘", "⌥", "⌃", "⇧"}


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
        -- FIXME: This should really launch _app
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
hs.hotkey.bind(all, 'b', function() toggle_application("Google Chrome") end)
hs.hotkey.bind(all, 's', function() toggle_application("Sublime Text") end)

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
