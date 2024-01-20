-- Build the library table
-- Call this to extract the values on a single line
function Library:Extract()
    -- Try to order this by how often it's used
    return self.Players,
           self.Hitbox,
           self.Round,
           self.Raycasting,
           self.Pathfinding,
           self.Client
end

function Library:Patch(Module)
    -- Check that the module is a table
    if type(Module) ~= 'table' then
        error('Library:Patch() must be called with a table!')
    else
        -- Copy all values from the module
        for Key, Value in Module do
            self[Key] = Value
        end
    end
end

-- Import the library
<include "src/lib/player.lua">
<include "src/lib/players.lua">
<include "src/lib/round.lua">
<include "src/lib/animate.lua">
<include "src/lib/raycast.lua">