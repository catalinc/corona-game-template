--[[
    A handy manager for Corona "enterFrame" runtime event.

    This library registers a single 'enterFrame' listener to call all the other listeners.

    In addition it provides the delta time between frames and the timestamp of the last frame.
    These can be useful for sprite animation and/or game logic.

    Listeners can be functions or tables. A table listener must provide a "eachFrame" method
    in order to be called.

    Do not forget to remove a listener when is not needed anymore. In case the listener is a
    display object you can use Corona"s 'finalize' event to remove it.

    Usage:

    local eachframe = require("libs.eachframe")

    local sprite = display.newImageRect( [parent,], filename, [baseDir,], width, height )

    function sprite:eachFrame()
      sprite.x = sprite.x + 100 * eachframe.deltaTime
    end

    function sprite:finalize()
      eachframe.remove(sprite)
    end

    eachframe.register(sprite)
--]]

local M = {deltaTime = 0, lastFrameTime = 0}

local function enterFrame()
  local now = system.getTimer()
  M.deltaTime = now - M.lastFrameTime
  M.lastFrameTime = now

  for i = 1, #M.listeners do
    local listener = M.listeners[i]
    if type(listener) == 'function' then
      listener()
    elseif type(listener) == 'table' and type(listener.eachFrame) == 'function' then
      listener:eachFrame()
    end
  end
end

function M.register(listener)
  if not M.listeners then
    M.listeners = {}
    Runtime:addEventListener('enterFrame', enterFrame)
  end
  table.insert(M.listeners, listener)
end

function M.remove(listener)
  if not listener or not M.listeners then return end
  local index = table.indexOf(M.listeners, listener)
  if index then
    table.remove(M.listeners, index)
    if #M.listeners == 0 then
      Runtime:removeEventListener('enterFrame', enterFrame)
      M.listeners = nil
    end
  end
end

return M
