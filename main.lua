'strict'

-- Version 2.0.0-INDEV-NONWORKING
-- Update date: 7/20/2023
-- Author(s): Syntax#9930

-- Management
local NAME    = 'daedalus'
local VERSION = '2.0.0'
local DEBUG   = false

-- Storage
local OPTIONS = {}
local PROPS   = {}

-- References
local MODEL   = nil

-- Services
local Players = game:GetService('Players')
local StarterPlayer = game:GetService('StarterPlayer')
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts
local StarterCharacterScripts = StarterPlayer.StarterCharacterScripts
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService('ServerScriptService')

-- daedalus v2.0.0 (https://github.com/synt7x/daedalus)
-- Precompiled using clamp and LuaNext, optimized manually
-- Request github access: Syntax#9930

<include "src/utils/props.lua">
<include "src/utils/debug.lua">
<include "src/utils/logs.lua">

<include "src/library.lua">
<include "src/ai.lua">

-- Entrypoint
local function Main(Model, Options)
    -- Pass parameters to global scope
    OPTIONS = Options or {}
    MODEL = Validate(Model, 'Model')

    if not MODEL then return end

    -- Store classes into global scope
    PROPS = {
        AI = AI.new(),
        Assets = Assets.new(),
        Library = Library,
    }

    -- Provide access to classes and library
    return PROPS.AI, PROPS.Assets, PROPS.Library
end

-- Export the main entrypoint
return Main