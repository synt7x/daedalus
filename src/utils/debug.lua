-- Message to enable client debugging
local DebugCode = '+d'

local Remote = ReplicatedStorage:FindFirstChild('daedalus')
local Client = script:WaitForChild('Client')
local Users = Library.Players:GetPlayers()

local function BindDebug()
    -- Create the remote if it doesn't exist
    if not Remote then
        -- game.ReplicatedStorage.daedalus
        Remote = CreateReplicatedProp('RemoteEvent', 'daedalus')
    end

    -- Indicates an exploiter
    Remote.OnServerEvent:Connect(function(player)
        player:Kick('lol')
    end)

    for i, User in Library.Players:GetPlayers() do
        -- Get the player object from the user
        local Player = Library.Players:Unwrap(User)

        -- Insert the client script
        MoveProp(Client, Player.PlayerScripts)
    end

    -- Give client to all future players
    DropProp(Client, StarterPlayerScripts)

    -- TODO: Bind to cleanup and remove all player and default scripts

    -- Update the debug global
    DEBUG = true
end

-- Listen for chat messages
for i, User in Users do
    -- Get the player object from the user
    local Player = Library.Players:Unwrap(User)

    -- We only have to check for players from the current round
    Player.Chatted:Connect(function(message)
        -- Check for specific message
        if message == DebugCode then
            BindDebug()
        end
    end)

    -- TODO: Bind to cleanup and remove chatted event
end

-- Bind if debug mode is already enabled
if Remote or DEBUG then
    Bind(Remote)
end