-- Midnight Horrors Round API
Library.Round = {
    props = {},

    Classic = 1,
    Blackout = 2,
    DoubleTrouble = 3,
    Bloodbath = 4,
    Foggy = 5,
    Clones = 6,
    Ghost = 7,
    Moviestar = 8,
    Earthquake = 9,

    -- Helper Folders
    Bots = workspace:WaitForChild('bots'),
    Killers = workspace:WaitForChild('KillerStorage'),
    Objects = workspace:WaitForChild('PlacedObjects'),
    Spawned = workspace:WaitForChild('spawnedkillers'),
}

-- Round properties
Library.Round.props.type = ReplicatedStorage:WaitForChild('curroundtype')
Library.Round.props.disaster = ServerScriptService:WaitForChild('DisasterScript')
Library.Round.props.time = Library.Round.props.disaster:WaitForChild('props'):WaitForChild('RoundTime')


-- Check if the round is active, this is called in all helper functions
function Library.Round:IsActive()
    return self.props.type ~= 0
end

-- Force the current round to end
function Library.Round:End()
    -- Make sure that there is a round to end
    if not self:IsActive() then
        warn('Tried to force the round to end, but the round is already over!')
        return
    end

    self:SetTimer(0)
end

-- Set the round timer
function Library.Round:SetTimer(Time)
    -- Make sure that there is a round to set the timer for
    if not self:IsActive() then
        warn('Tried to set the round timer, but the round is over!')
        return
    end

    -- Set the round timer
    self.props.time.Changed:Wait()
    self.props.time.Value = Time
end

function Library.Round:GetTimer()
    -- Make sure that there is a round to get the timer for
    if not self:IsActive() then
        warn('Tried to get the round timer, but the round is over!')
        return 0
    end

    return self.props.time.Value
end


-- Get the current round type
function Library.Round:GetType()
    local RoundType = self.props.type.Value

    -- Return the round name and number
    if RoundType == 1 then
        return 'Classic', RoundType
    elseif RoundType == 2 then
        return 'Blackout', RoundType
    elseif RoundType == 3 then
        return 'Double Trouble', RoundType
    elseif RoundType == 4 then
        return 'Bloodbath', RoundType
    elseif RoundType == 5 then
        return 'Foggy', RoundType
    elseif RoundType == 6 then
        return 'Clones', RoundType
    elseif RoundType == 7 then
        return 'Ghost', RoundType
    elseif RoundType == 8 then
        return 'Moviestar', RoundType
    elseif RoundType == 9 then
        return 'Earthquake', RoundType
    end
end

-- Force the current round type to change, useful for moviestar and earthquake rounds
function Library.Round:ForceType(RoundNumber)
    -- Make sure that there is a round to change the type for
    if not self:IsActive() then
        warn('Tried to force the round type, but the round is over!')
        return
    end

    -- Make sure that the round number is valid
    if RoundNumber < 1 or RoundNumber > 9 then
        warn('Tried to force the round type, but the round number is invalid!')
        return
    end

    -- Force the round type
    self.props.type.Value = RoundNumber
end

-- Get the current map
function Library.Round:GetMap()
    local Map = workspace:FindFirstChild('map')
    
    -- Make sure that there is a map
    if not Map then
        return Map, nil
    end

    -- Return the map and map name
    local Name = Map:FindFirstChild('MapOrginalName')
    local OriginalName = Name and Name.Value or nil

    return Map, OriginalName
end