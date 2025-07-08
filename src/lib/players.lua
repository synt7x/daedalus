Library.Players = {
    Targets = {},
    Bots = workspace:FindFirstChild('bots')
}

-- Create a new player object
function Library.Players:RegisterCharacter(Character)
    self.Targets[Character] = Library.Player.new(Character)
    return self.Targets[Character]
end

-- Get all targets, which are players or bots that are alive
function Library.Players:GetTargets()
    return self.Targets
end

-- Check if a specific `Model` is a target,
-- returns the target if it is, otherwise returns false
function Library.Players:IsTarget(Model)
    for i, Target in self.Targets do
        if not Target:IsAlive() then continue end
        if Target.Character == Model then
            return Target
        end
    end

    return false
end

-- Get a specific target by its `Model`
function Library.Players:GetTarget(Model)
    return self:IsTarget(Model) or nil
end

-- Get the nearest target to the AI's position
function Library.Players:GetNearest()
    return Library.Players:GetNearestTo(AI:Position())
end

-- Get the nearest target to a specific `Vector3` position
function Library.Players:GetNearestTo(Position)
    local Distance = math.huge
    local Nearest = nil

    for i, Target in self.Targets do
        if not Target:IsAlive() then continue end

        local TargetPosition = Target.HumanoidRootPart.Position
        local TargetDistance = (Position - TargetPosition).Magnitude

        if TargetDistance < Distance then
            Distance = TargetDistance
            Nearest = Target
        end
    end

    return Nearest, Distance
end

-- Get all players in the game,
-- including bots if they are enabled
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

-- Unwrap a user object to get the player object
function Library.Players:Unwrap(User)
    if User.Humanoid then
        return User.Player
    end
end

-- General module initialization,
-- not to be called directly.
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