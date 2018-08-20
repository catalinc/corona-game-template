local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require("physics")
local settings = require("libs.settings")
local sounds = require("libs.sounds")
local eventbus = require("libs.eventbus")

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:create(event)
  -- Code here runs when the scene is first created but has not yet appeared on screen
  local sceneGroup = self.view
end

function scene:show(event)
  local phase = event.phase

  if phase == "will" then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
  elseif phase == "did" then
    -- Code here runs when the scene is entirely on screen
    physics.start()
  end
end

function scene:hide(event)
  local phase = event.phase

  if phase == "will" then
    -- Code here runs when the scene is on screen (but is about to go off screen)
    physics.pause()
  elseif phase == "did" then
    -- Code here runs immediately after the scene goes entirely off screen
  end
end

function scene:destroy(event)
  -- Code here runs prior to the removal of scene"s view
  physics.stop()
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
