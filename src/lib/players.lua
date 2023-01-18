Library.Players = {
    Targets = {}

    Bots = workspace:FindFirstChild('bots')
}



function Library.Players:GetTargets()

end

AI.Initialize:Connect(function()
    Players.PlayerAdded:Connect(function(Player)
        Player.CharacterAdded:Connect(function(Character)

        end)

        Player.CharacterRemoved:Connect(function(Character)
        
        end)
    end)

    Players.PlayerRemoved:Connect(function(Player)
        
    end)

    Bots.ChildAdded:Connect(function(Bot)

    end)

    Bots.ChildRemoved:Connect(function(Bot)
    
    end)
end)