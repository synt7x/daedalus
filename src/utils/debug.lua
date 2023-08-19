-- Message to enable client debugging
local DebugCode = '+d'

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
        player:Kick('Disconnect.RemoteTamper')
    end)

    Client:SetAttribute('Debugger', true)

    for i, User in Library.Players:GetPlayers() do
        -- Get the player object from the user
        local Player = Library.Players:Unwrap(User)

        -- Insert the client script
        DropProp(Client, Player.PlayerGui)
    end

    -- Give client to all future players
    local Prop = MoveProp(Client, StarterGui)

    -- Bind to cleanup and remove all player and default scripts
    AI.Cleanup:Connect(function()
        Prop:Destroy()

        for i, Player in Players:GetPlayers() do
            local PlayerGui = Player.PlayerGui
            local Client = PlayerGui:FindFirstChild(Client.Name)
            
            if Client:GetAttribute('Debugger') then
                Client:Destroy()
            end
        end
    end)

    -- Update the debug global
    DEBUG = true
end

-- Listen for chat messages
for i, User in Users do
    -- Get the player object from the user
    local Player = Library.Players:Unwrap(User)

    -- We only have to check for players from the current round
    local Listener = Player.Chatted:Connect(function(message)
        -- Check for specific message
        if message == DebugCode then
            BindDebug()
        end
    end)

    -- Bind to cleanup and remove chatted event
    AI.Cleanup:Connect(function()
        Listener:Disconnect()
    end)
end

-- Bind if debug mode is already enabled
if Remote or DEBUG then
    BindDebug()
end