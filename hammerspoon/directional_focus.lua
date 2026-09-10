local M = {}
local axes = {left = {-1, 0}, right = {1, 0}, up = {0, -1}, down = {0, 1}}

function M.choose(current, windows, direction)
  local axis = assert(axes[direction], 'Unknown direction')
  local cx, cy = current.x + current.w / 2, current.y + current.h / 2
  local best, bestScore, wrap, wrapPosition, wrapOffset
  for _, window in ipairs(windows) do
    if window.id ~= current.id then
      local x, y = window.x + window.w / 2, window.y + window.h / 2
      local dx, dy = x - cx, y - cy
      local forward = dx * axis[1] + dy * axis[2]
      local offset = math.abs(dx * axis[2] - dy * axis[1])
      if forward > 1 then
        local score = forward * forward + 4 * offset * offset
        if not bestScore or score < bestScore then best, bestScore = window, score end
      end
      local position = x * axis[1] + y * axis[2]
      if not wrapPosition or position < wrapPosition - 1
          or (math.abs(position - wrapPosition) <= 1 and offset < wrapOffset) then
        wrap, wrapPosition, wrapOffset = window, position, offset
      end
    end
  end
  return best or wrap
end

function M.exposed(windows)
  local result, covers = {}, {}
  for _, window in ipairs(windows) do
    local pieces = {window}
    for _, cover in ipairs(covers) do
      local nextPieces = {}
      for _, piece in ipairs(pieces) do
        local left, top = math.max(piece.x, cover.x), math.max(piece.y, cover.y)
        local right = math.min(piece.x + piece.w, cover.x + cover.w)
        local bottom = math.min(piece.y + piece.h, cover.y + cover.h)
        if right <= left or bottom <= top then
          nextPieces[#nextPieces + 1] = piece
        else
          local function add(x, y, w, h)
            if w > 0 and h > 0 then nextPieces[#nextPieces + 1] = {x=x,y=y,w=w,h=h} end
          end
          add(piece.x, piece.y, piece.w, top - piece.y)
          add(piece.x, bottom, piece.w, piece.y + piece.h - bottom)
          add(piece.x, top, left - piece.x, bottom - top)
          add(right, top, piece.x + piece.w - right, bottom - top)
        end
      end
      pieces = nextPieces
      if #pieces == 0 then break end
    end
    local area = 0
    for _, piece in ipairs(pieces) do area = area + piece.w * piece.h end
    if area >= math.max(100, window.w * window.h * 0.01) then result[#result + 1] = window end
    covers[#covers + 1] = window
  end
  return result
end

function M.focus(direction)
  local current = hs.window.frontmostWindow()
  if not current then return false end
  local candidates, byID = {}, {}
  for _, window in ipairs(hs.window.orderedWindows()) do
    if window:isStandard() and window:isVisible() and not window:isMinimized() then
      local frame = window:frame()
      candidates[#candidates + 1] = {id = window:id(), x = frame.x, y = frame.y, w = frame.w, h = frame.h}
      byID[window:id()] = window
    end
  end
  local frame = current:frame()
  local target = M.choose({id = current:id(), x = frame.x, y = frame.y, w = frame.w, h = frame.h}, M.exposed(candidates), direction)
  if not target then return false end
  byID[target.id]:focus()
  return target.id
end

return M
