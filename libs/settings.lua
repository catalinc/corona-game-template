--[[
    A handy manager for application settings.

    This module loads and saves settings to "settings.json" file inside Documents directory.

    Saving data is automatic on key update (e.g. Settings.someKey = value).

    Calling this module with a table parameter will set default settings.

    Usage:

    local settings = require("libs.settings")

    -- Set default values for some of the settings
    settings({isSoundOn = true, isMusicOn = true})

    -- This will automatically save the level setting in the settings.json file
    settings.level = 10
--]]

local json = require('json')

local M = {}

local settings = {}
local defaultSettings = {}
local storagePath = system.pathForFile('settings.json', system.DocumentsDirectory)

local function shallowCopy(t)
  local copy
  if type(t) == 'table' then
    copy = {}
    for k, v in pairs(t) do
      copy[k] = v
    end
  else
    copy = t
  end
  return copy
end

local function saveData()
  local file = io.open(storagePath, 'w')
  if file then
    file:write(json.encode(settings))
    io.close(file)
  end
end

local function loadData()
  local file = io.open(storagePath, 'r')
  if file then
    settings = json.decode(file:read('*a'))
    io.close(file)
  else
    settings = shallowCopy(defaultSettings)
    saveData()
  end
end

local mt = {
  __index = function(t, k)
    return settings[k]
  end,
  __newindex = function(t, k, value)
    settings[k] = value
    saveData()
  end,
  __call = function(t, value)
    if type(value) == 'table' then
      defaultSettings = shallowCopy(value)
    end
    loadData()
  end
}

return setmetatable(M, mt)
