require("hs.ipc")
if hs.ipc.cliStatus() == false then
  hs.ipc.cliInstall()
end

local hyper = {"cmd", "alt", "ctrl"}
local hyper2 = {"cmd", "ctrl"}
local my = require "hs.alert"
local alert = my.show

saved = {}
saved.win = {}
saved.winframe = {}

function pressKey(letter)
  hs.eventtap.event.newKeyEvent(letter, true):post()
  hs.eventtap.event.newKeyEvent(letter, false):post()
end

-- Hacky solution to include a code section when {{{ is typed (using an Alfred 4 )
function confluenceCode()
  hs.eventtap.event.newKeyEvent(hs.keycodes.map.shift, true):post()
  hs.eventtap.event.newKeyEvent("[", true):post()
  hs.eventtap.event.newKeyEvent("[", false):post()
  hs.eventtap.event.newKeyEvent(hs.keycodes.map.shift, false):post()
  pressKey("space")
  pressKey("c")
  pressKey("o")
  pressKey("d")
  pressKey("e")

  control_key_timer =
    hs.timer.delayed.new(
    0.25,
    function()
      pressKey("return")

      control_key_timer:stop()
      print("stopped")
    end
  )
  control_key_timer:start()
end

function typeChars(inputstr)
  sep = "."

  for str in string.gmatch(inputstr, "(.)") do
    pressKey(str)
  end
end
function returnLast()
  if (saved.win ~= {}) then
    saved.win:setFrame(saved.winframe)
  end
end

function nudgeRight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  saved.win = win
  saved.winframe = saved.win:frame()
  f.x = f.x + 20
  win:setFrame(f)
end

function nudgeLeft()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  saved.win = win
  saved.winframe = saved.win:frame()
  f.x = f.x - 20
  win:setFrame(f)
end

function getFrontMostApp()
  return hs.application.frontmostApplication():title()
end

function showOrActivate(activatedTitle)
  local frontTitle = getFrontMostApp()

  if frontTitle == activatedTitle then
    hs.application.frontmostApplication():hide()
  else
    hs.appfinder.appFromName(activatedTitle):activate()
  end
end

function showOrHide(activatedTitle)
  local frontTitle = getFrontMostApp()
  if frontTitle == activatedTitle then
    hs.application.frontmostApplication():hide()
  else
    hs.application.launchOrFocus(activatedTitle)
  end
end

caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
  if state then
    caffeine:setTitle("IM ON 🔥!")
  else
    caffeine:setTitle("I'm so ❄️")
  end
end

math.randomseed(os.time())

local charset = {}
-- qwertyuiopasdfghjklzxcvbnm1234567890
for i = 48, 57 do
  table.insert(charset, string.char(i))
end
for i = 97, 122 do
  table.insert(charset, string.char(i))
end

-- this is used only to see new console messages easily
function randomString(length)
  if length > 0 then
    return randomString(length - 1) .. charset[math.random(1, #charset)]
  else
    return ""
  end
end

function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
  caffeine:setClickCallback(caffeineClicked)
  setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- Focus the last used window.

local function focusLastFocused()
  local wf = hs.window.filter
  local lastFocused = wf.defaultCurrentSpace:getWindows(wf.sortByFocusedLast)
  if #lastFocused > 0 then
    lastFocused[1]:focus()
  end
end
-- On selection, copy the text and type it into the focused application.

local xsschooser =
  hs.chooser.new(
  function(choice)
    if not choice then
      focusLastFocused()
      return
    end
    hs.pasteboard.setContents(choice["subText"])
    focusLastFocused()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
  end
)

xsschooser:choices(
  {
    {
      ["text"] = "Polyglot #1\n",
      ["subText"] = "/*-/*`/*\\`/*'/*/**/(/* */oNcliCk=alert`` )//%0D%0A%0d%0a//</stYle/</titLe/</teXtarEa/</scRipt/--!>\\x3csVg/<sVg/oNloAd=alert``//>\\x3e"
    },
    {
      ["text"] = "Svg XSS\n",
      ["subText"] = '"><svg/onload=alert`5`>'
    }
  }
)

function xsshelper()
  xsschooser:show()
end

hs.hotkey.bind(
  {"ctrl", "shift"},
  "X",
  function()
    xsshelper()
  end
)
hs.hotkey.bind(
  {"cmd", "ctrl"},
  "O",
  function()
    showOrHide("Microsoft Outlook")
  end
)

hs.hotkey.bind(
  {"cmd", "ctrl"},
  "B",
  function()
    -- hs.application.launchOrFocus("Burp Suite Professional")
    --
    showOrActivate("Burp Suite Professional")
  end
)

hs.hotkey.bind(
  {"cmd", "ctrl"},
  "C",
  function()
    showOrActivate("Chromium")
  end
)
hs.hotkey.bind(
  {"cmd", "ctrl"},
  "K",
  function()
    showOrHide("KeePassXC")
  end
)
-- hs.hotkey.bind(
--   {"cmd"},
--   "V",
--   function()
--     alert(getFrontMostApp())
--     return false
--   end
-- )
hs.hotkey.bind(
  {"cmd", "ctrl"},
  "T",
  function()
    showOrActivate("Things")
  end
)

hs.hotkey.bind(
  {"cmd", "ctrl"},
  "W",
  function()
    showOrHide("WebStorm")
  end
)
hs.hotkey.bind(
  {"cmd", "ctrl"},
  "P",
  function()
    showOrHide("Preview")
  end
)

hs.hotkey.bind(
  {"cmd", "ctrl"},
  "M",
  function()
    showOrHide("Maetder")
  end
)

hs.hotkey.bind(
  {"ctrl", "shift"},
  "Z",
  function()
    local frontTitle = getFrontMostApp()

    if frontTitle == "Code" then
      hs.application.frontmostApplication():hide()
    else
      showOrActivate("Code")
      hs.applescript('do shell script "/usr/local/bin/code /Volumes/$(cat ~/.work)"')
      hs.applescript('do shell script "/usr/local/bin/code /Volumes/$(cat ~/.work)/scratchpad.md"')
    end
  end
)

hs.hotkey.bind(
  {"cmd", "ctrl"},
  "N",
  function()
    showOrHide("Notion")
  end
)

hs.hotkey.bind(
  {"cmd", "ctrl"},
  "R",
  function()
    showOrHide("Royal TSX")
  end
)

hs.hotkey.bind(
  hyper,
  "R",
  function()
    hs.reload()
  end
)
hs.notify.new({title = "Hammerspoon", informativeText = "Config loaded"}):send()

hs.hotkey.bind(
  {"ctrl", "shift"},
  "P",
  function()
    ok, result = hs.applescript('tell application "Finder" to get POSIX path of (insertion location as string)')
    pngstr = '"/usr/local/bin/pngpaste ' .. result .. randomString(10) .. '-scrn.png"'
    hs.applescript("do shell script " .. pngstr)
    alert("Image pasted to " .. result)
  end
)

hs.hotkey.bind(
  {"cmd", "alt", "ctrl"},
  "V",
  function()
    filename = randomString(10)
    ok, result = hs.applescript('do shell script "echo ~/.screenshots/"')
    pngstr = '"/usr/local/bin/pngpaste ' .. result .. filename .. '-scrn.png"'
    ha, result2 = hs.applescript("do shell script " .. pngstr)
    foobar = "![image](" .. result .. filename .. "-scrn.png)"
    pbstring = '"printf \'' .. foobar .. '\' |pbcopy"'
    hs.applescript("do shell script " .. pbstring)
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
  end
)

hs.hotkey.bind(
  {"cmd", "alt", "ctrl"},
  "K",
  function()
    hs.eventtap.keyStrokes(hs.pasteboard.getContents())
  end
)

hs.hotkey.bind(
  {"cmd", "alt", "ctrl"},
  "X",
  function()
    hs.eventtap.keyStrokes(hs.pasteboard.clearContents())
  end
)

-- Open finder to your engagement folder
hs.hotkey.bind(
  {"cmd", "alt", "ctrl"},
  "O",
  function()
    hs.applescript('do shell script "open /Volumes/$(cat ~/.work)"')
  end
)
