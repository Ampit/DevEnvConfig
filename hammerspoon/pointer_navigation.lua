local M = {}
local keyboardUntil = 0
local warpPosition
local events = hs.eventtap.event.types

function M.keyboardSwitch()
  keyboardUntil = hs.timer.secondsSinceEpoch() + 2
end

M.input = hs.eventtap.new({events.keyDown, events.mouseMoved, events.leftMouseDown,
  events.rightMouseDown, events.otherMouseDown, events.leftMouseDragged,
  events.rightMouseDragged, events.otherMouseDragged, events.scrollWheel}, function(event)
  local kind = event:getType()
  if kind == events.keyDown then
    local flags = event:getFlags()
    keyboardUntil = (flags.cmd or flags.alt or flags.ctrl or flags.shift)
      and hs.timer.secondsSinceEpoch() + 2 or 0
    return false
  end
  local point = event:location()
  if kind == events.mouseMoved and warpPosition
      and math.abs(point.x - warpPosition.x) < 1 and math.abs(point.y - warpPosition.y) < 1 then
    warpPosition = nil
    return false
  end
  warpPosition = nil
  keyboardUntil = 0
  return false
end):start()

M.focus = hs.window.filter.new():subscribe(hs.window.filter.windowFocused, function(window)
  if hs.timer.secondsSinceEpoch() > keyboardUntil then return end
  if not window:isStandard() or not window:isVisible() then return end
  keyboardUntil = 0
  local frame = window:frame()
  warpPosition = {x = frame.x + frame.w / 2, y = frame.y + frame.h / 2}
  hs.mouse.absolutePosition(warpPosition)
end)

return M
