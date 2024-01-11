-- Version 2.0.0-INDEV-0.0.0
-- Update date: 1/4/2024
-- Author(s): synt7x

-- Management
local NAME    = 'daedalus'
local VERSION = '2.0.0'
local DEBUG   = false

-- Storage
local OPTIONS = {}
local PROPS   = {}

-- References
local MODEL   = nil
local ROOT    = nil

-- Services
local Players = game:GetService('Players')
local StarterPlayer = game:GetService('StarterPlayer')
local StarterGui = game:GetService('StarterGui')
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts
local StarterCharacterScripts = StarterPlayer.StarterCharacterScripts
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService('ServerScriptService')

-- daedalus v2.0.0 (https://github.com/synt7x/daedalus)
-- Precompiled using clamp and LuaNext, optimized manually
-- Request github access: synt7x

local Remote = ReplicatedStorage:FindFirstChild('daedalus')

-- Initialize Classes
local AI = {}
local Library = {
    Raycasting = {},
    Pathfinding = {},
    Players = {},
    Round = {},
    Client = {},
    Hitbox = {},
}

<include "src/utils/props.lua">
<include "src/utils/logs.lua">

<include "src/assets.lua">
<include "src/library.lua">
<include "src/ai.lua">

-- Entrypoint
local function Main(Model, Root, Options)
    -- Pass parameters to global scope
    OPTIONS = Options or {}
    MODEL = Validate(Model, 'Model')
    ROOT = Root or script.Parent

    if not MODEL then return end

    -- Store classes into global scope
    PROPS = {
        AI = AI.new(),
        Assets = Assets.new(),
        Library = Library,
    }

    -- Propagate new class
    AI = PROPS.AI

    -- Hide from workspace
    if script:IsDescendantOf(workspace) then
        script:Destroy()
    end

    -- Provide access to classes and library
    return PROPS.AI, PROPS.Assets, PROPS.Library
end

-- Export the main entrypoint
return Main