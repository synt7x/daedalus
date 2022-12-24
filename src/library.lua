-- Build the library table
local Library = {
    Raycasting = {},
    Pathfinding = {},
    Players = {},
    Round = {},
    Client = {},
    Hitbox = {},
}

-- Call this to extract the values on a single line
function Library:Extract()
    -- Try to order this by how often it's used
    return self.Players,
           self.Hitbox,
           self.Round,
           self.Raycasting,
           self.Client,
           self.Pathfinding,
end