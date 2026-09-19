local M = {}
local keyboardUntil = 0
local warpPosition
local events = hs.eventtap.event.types

local function cancelHover()
  if M.hoverTimer then M.hoverTimer:stop(); M.hoverTimer = nil end
end

function M.keyboardSwitch()
  cancelHover()
  keyboardUntil = hs.timer.secondsSinceEpoch() + 2
end

local function focusUnderPointer()
  M.hoverTimer = nil
  if next(hs.mouse.getButtons()) then return end
  local point = hs.mouse.absolutePosition()
  for _, window in ipairs(hs.window.orderedWindows()) do
    if window:isStandard() and window:isVisible() and not window:isMinimized() then
      local frame = window:frame()
      if point.x >= frame.x and point.x < frame.x + frame.w
          and point.y >= frame.y and point.y < frame.y + frame.h then
        local current = hs.window.frontmostWindow()
        if not current or current:id() ~= window:id() then window:focus() end
        return
      end
    end
  end
end

M.input = hs.eventtap.new({events.keyDown, events.mouseMoved, events.leftMouseDown,
  events.rightMouseDown, events.otherMouseDown, events.leftMouseDragged,
  events.rightMouseDragged, events.otherMouseDragged, events.scrollWheel}, function(event)
  local kind = event:getType()
  if kind == events.keyDown then
    cancelHover()
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
  cancelHover()
  if kind == events.mouseMoved then M.hoverTimer = hs.timer.doAfter(0.15, focusUnderPointer) end
  return false
end):start()

M.focus = hs.window.filter.new():subscribe(hs.window.filter.windowFocused, function(window)
  if hs.timer.secondsSinceEpoch() > keyboardUntil then return end
  if not window:isStandard() or not window:isVisible() then return end
  keyboardUntil = 0
  cancelHover()
  local frame = window:frame()
  warpPosition = {x = frame.x + frame.w / 2, y = frame.y + frame.h / 2}
  hs.mouse.absolutePosition(warpPosition)
end)

return M
