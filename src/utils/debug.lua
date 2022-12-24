-- Message to enable client debugging
local DebugCode = '+d'

local Remote = ReplicatedStorage:FindFirstChild('daedalus')
local Players = Library.Players:GetPlayers()

local function Bind()
    -- Create the remote if it doesn't exist
    if not Remote then
        -- game.ReplicatedStorage.daedalus
        Remote = CreateReplicatedProp('RemoteEvent', 'daedalus')
    end

    -- Indicates an exploiter
    Remote.OnServerEvent:Connect(function(player)
        player:Kick('lol')
    end)

    -- Update the debug global
    DEBUG = true
end

-- Listen for chat messages
for i, User in Players do
    -- Get the player object from the user
    local Player = Library.Players:Unwrap(User)
    
    Player.Chatted:Connect(function(message)
        -- Check for specific message
        if message = DebugCode then
            Bind()
        end
    end)
end

-- Bind if debug mode is already enabled
if Remote or DEBUG then
    Bind(Remote)
end