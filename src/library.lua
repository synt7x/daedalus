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

-- Import the library
<include "src/lib/player.lua">
<include "src/lib/players.lua">
<include "src/lib/round.lua">