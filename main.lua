local composer = require("composer")
local settings = require("libs.settings")

settings({isSoundOn = true, isMusicOn = true,})

display.setStatusBar(display.HiddenStatusBar)
display.setDefault("background", 0.0353, 0.0902, 0.1608)

local platform = system.getInfo('platformName')
if platform == 'Android' then
  native.setProperty("androidSystemUiVisibility", "immersiveSticky")
  Runtime:addEventListener('key',
    function(event)
      if event.phase == 'down' and event.keyName == 'back' then
        local scene = composer.getScene(composer.getSceneName('current'))
        if scene then
          if type(scene.gotoPreviousScene) == 'function' then
            scene:gotoPreviousScene()
            return true
          elseif type(scene.gotoPreviousScene) == 'string' then
            composer.gotoScene(scene.gotoPreviousScene, {time = 500, effect = 'slideRight'})
            return true
          end
        end
      end
    end
  )
end

composer.recycleOnSceneChange = true
composer.gotoScene("scenes.menu")
