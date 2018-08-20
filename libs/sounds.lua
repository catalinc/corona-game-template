--[[
  A handy manager for sound and music files.

  Automatically loads audio files and keeps a track of them.

  Keep in mind that a sound needs to be registered before it can be played.

  This libray integrates with settings to honor settings.isSoundOn and settings.isMusicOn switches.

  Usage:

    local sounds = require("libs.sounds")

    sounds.register("fire", "audio/fire.mp3")

    -- Play the sfx
    sounds.play("fire")

    -- When the sfx is not needed anymore (e.g. on scene:destroy)
    sounds.dispose("fire")
--]]

local settings = require("libs.settings")

local M = {}

audio.reserveChannels(2)
local audioChannel = 1
local otherAudioChannel = 2

local soundsTable = {}
local loadedSounds = {}
local activeStream

local function loadSound(name)
  if not loadedSounds[name] then
    loadedSounds[name] = audio.loadSound(soundsTable[name])
  end
  return loadedSounds[name]
end

local function loadStream(name)
  if not loadedSounds[name] then
    loadedSounds[name] = audio.loadStream(soundsTable[name])
  end
  return loadedSounds[name]
end

-- Register a new sound.
-- The sound will be loaded automatically when is played the first time.
function M.register(name, path)
  soundsTable[name] = path
end

-- Music files (e.g. background music)
function M.playStream(name)
  if not settings.isMusicOn then return end
  if not soundsTable[name] then return end
  if activeStream == name then return end

  audio.fadeOut({channel = audioChannel, time = 1000})
  audioChannel, otherAudioChannel = otherAudioChannel, audioChannel
  audio.setVolume(0.5, {channel = audioChannel})
  local musicStream = loadStream(name)
  audio.play(musicStream, {channel = audioChannel, loops = -1, fadein = 1000})
  activeStream = name
end

-- Short SFX (e.g. explosion)
function M.play(name, options)
  if not settings.isSoundOn then return end
  if not soundsTable[name] then return end
  return audio.play(loadSound(name), options)
end

-- Unregister and dispose the sound
function M.dispose(name)
  if not soundsTable[name] then return end
  soundsTable[name] = nil

  sound = loadedSounds[name]
  if not sound then return end

  loadedSounds[name] = nil
  if name == activeStream then activeStream = nil end

  return audio.dispose(sound)
end

function M.stop()
  activeStream = nil
  audio.stop()
end

return M
