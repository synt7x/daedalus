Library.Players = {
    Targets = {},
    Bots = workspace:FindFirstChild('bots')
}

function Library.Players:RegisterCharacter(Character)
    self.Targets[Character] = Library.Player.new(Character)
    return self.Targets[Character]
end

function Library.Players:GetTargets()
    return self.Targets
end

function Library.Players:IsTarget(Model)
    for i, Target in self.Targets do
        if not Target:IsAlive() then continue end
        if Target.Character == Model then
            return Target
        end
    end

    return false
end

function Library.Players:GetTarget(Model)
    return self:IsTarget(Model) or nil
end

function Library.Players:GetNearest()
    return Library.Players:GetNearestTo()
end

function Library.Players:GetNearestTo(Position)
    local Distance = math.huge
    local Nearest = nil

    for i, Target in self.Targets do
        if not Target:IsAlive() then continue end

        local TargetPosition = Target.HumanoidRootPart
        local TargetDistance = (Position - TargetPosition).Magnitude

        if TargetDistance < Distance then
            Distance = TargetDistance
            Nearest = Target
        end
    end

    return Nearest, Distance
end

function Library.Players:GetPlayers()
    local List = {}

    for i, Player in Players:GetPlayers() do
        local Character = Player.Character
        if Player.Character then
            table.insert(
                List,
                Library.Player.new(Player.Character)
            )
        end
    end

    return List
end

function Library.Players:Unwrap(User)
    if User.Humanoid then
        return User.Player
    end
end

function Library.Players:Initialize()
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

        Player.CharacterRemoving:Connect(function(Character)
            self.Targets[Character] = nil
        end)
    end)

    if not self.Bots then return end

    self.Bots.ChildAdded:Connect(function(Bot)
        local HumanoidRootPart = Bot:WaitForChild('HumanoidRootPart')
        local Humanoid = Bot:FindFirstChildOfClass('Humanoid')

        HumanoidRootPart = Validate(HumanoidRootPart, 'Part')
            
        if Humanoid then
            Humanoid.Died:Connect(function()
                self.Targets[Bot] = nil
            end)

            Humanoid.HealthChanged:Connect(function(Health)
                if Health <= 0 then
                    self.Targets[Bot] = nil
                else
                    self:RegisterCharacter(Bot)
                end
            end)
        end

       self:RegisterCharacter(Bot)
    end)

    self.Bots.ChildRemoved:Connect(function(Bot)
        self.Targets[Bot] = nil
    end)
end