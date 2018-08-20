--[[
  Utility class for displaying a health bar (green on red) for game objects.

  When using this class keep in mind that health bar position must be updated each frame.
--]]

local M = {}

function M.new(options)
  local x = options.x or 0
  local y = options.y or 0
  local width = options.width or 50
  local height = options.height or 5
  local maxValue = options.maxValue or 100
  local value = options.value or maxValue

  local bar = display.newGroup()
  bar.anchorX = 0
  bar.anchorY = 0
  bar.anchorChildren = true

  local red = display.newRect(0, 0, width, height)
  red.anchorX = 0
  red.anchorY = 0
  red:setFillColor(255, 0, 0)
  bar:insert(red)

  local green = display.newRect(0, 0, width, height)
  green.anchorX = 0
  green.anchorY = 0
  green:setFillColor(0, 255, 0)
  bar:insert(green)

  function bar:setValue(value)
    local percent = value / maxValue
    if percent <= 0 then percent = 0.01 end
    green.xScale = percent
  end

  if options.parent then parent:insert(bar) end
  bar.x = x
  bar.y = y

  return bar
end

return M
