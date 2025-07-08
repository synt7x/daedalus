"strict" -- Version 2.0.0

-- Management
local NAME    = 'daedalus'
local VERSION = '2.0.0'
local DEBUG   = false

-- Storage
local OPTIONS = {}
local PROPS   = {}

-- References
local MODEL   = nil
local SCOPE   = nil
local ROOT    = nil

-- Services
local Players = game:GetService('Players')
local StarterGui = game:GetService('StarterGui')
local StarterPlayer = game:GetService('StarterPlayer')
local PathfindingService = game:GetService('PathfindingService')
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts
local StarterCharacterScripts = StarterPlayer.StarterCharacterScripts
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService('ServerScriptService')

-- Remote used for debugging purposes,
-- you should NOT create it youself unless you know what you're doing!
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

<include 'src/utils/props.lua'>
<include 'src/utils/logs.lua'>

<include 'src/assets.lua'>
<include 'src/library.lua'>
<include 'src/ai.lua'>

-- Create a new AI instance,
-- takes a `Model` instance, `Root` part, `Scope` instance (generally the script's parent).
-- Returns the `AI` library, `Assets` library, and `Library` library in the form `local AI, Assets, Library = Framework()`.
local function Main(Model, Root, Scope, Options)
    -- Pass parameters to global scope
    OPTIONS = Options or {}
    MODEL = Validate(Model, 'Model')
    ROOT = Model:FindFirstChild('HumanoidRootPart') or Model:FindFirstChild('Handle') or Validate(Root, 'BasePart')
    SCOPE = Scope or script.Parent

    if not MODEL then return end
    if not ROOT then return end

    -- Store classes into global scope
    PROPS = {
        AI = AI.new(),
        Assets = Assets.new(),
        Library = Library,
    }

    -- Propagate new class
    AI = PROPS.AI

    -- Activate parallel execution
    if SCOPE:FindFirstAncestorOfClass('Actor') then
        task.desyncronize()
    end

    -- Hide from workspace
    if script:IsDescendantOf(workspace) then
        script:Destroy()
    end

    -- Provide access to classes and library
    return PROPS.AI, PROPS.Assets, PROPS.Library
end

-- Export the main entrypoint
return Main