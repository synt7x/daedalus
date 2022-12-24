-- Update date: 12/22/2022

local NAME    = 'daedalus'
local OPTIONS = {}
local MODEL   = nil
local DEBUG   = false
local VERSION = '2.0.0'

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServerScriptService = game:GetService('ServerScriptService')

-- daedalus v2.0.0 (https://github.com/synt7x/daedalus)
-- Precompiled using clamp, optimized manually
-- Request github access: Syntax#9930

<include "src/utils/debug.lua">
<include "src/utils/logs.lua">

<include "src/library.lua">

function Main(Model, Options)
    -- Pass parameters to global scope
    OPTIONS = Options or {}
    MODEL = validate(Model, 'Model')

    -- Provide access to classes and library
    return AI.new(), Assets.new(), Library
end

return Main