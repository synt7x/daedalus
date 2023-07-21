Library.Players = {
    Targets = {}

    Bots = workspace:FindFirstChild('bots')
}

function Library.Players:RegisterCharacter(Character)
    self.Targets[Character] = Library.Player.new(Character)
    return self.Targets[Character]
end

function Library.Players:GetTargets()
    return self.Targets
end

AI.Initialize:Connect(function()
    Players.PlayerAdded:Connect(function(Player)
        Player.CharacterAdded:Connect(function(Character)
            local HumanoidRootPart = Character:WaitForChild('HumanoidRootPart')
            local Humanoid = Character:FindFirstChildOfClass('Humanoid')

            HumanoidRootPart = Validate(HumanoidRootPart, 'Part')
            
            if Humanoid then
                Humanoid.Died:Connect(function()
                    self.Targets[Character] = nil
                end)

                Humanoid.HealthChanged:Connect(function(Health)
                    if Health <= 0 then
                        self.Targets[Character] = nil
                    else
                        self:RegisterCharacter(Character)
                    end
                end)
            end

            self:RegisterCharacter(Character)
        end)

        Player.CharacterRemoved:Connect(function(Character)
            self.Targets[Character] = nil
        end)
    end)

    Bots.ChildAdded:Connect(function(Bot)
        self.Targets[Bot] = self:RegisterCharacter(Character)
    end)

    Bots.ChildRemoved:Connect(function(Bot)
        self.Targets[Bot] = nil
    end)
end)