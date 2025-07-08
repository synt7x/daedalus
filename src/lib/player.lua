Library.Player = {}

-- Create a new player object from a character model.
function Library.Player.new(Character)
    local self = {}

    for Key, Value in Library.Player do
        self[Key] = Value
    end

    -- Player validation
    self.Character = Validate(Character, 'Model')
    self.Player = Players:GetPlayerFromCharacter(Character)
    self.Humanoid = Character:FindFirstChildOfClass('Humanoid')
    self.HumanoidRootPart = Character:FindFirstChild('HumanoidRootPart')

    -- Make sure player is alive
    if not self:IsAlive() then return end
    return self
end

-- Robust method of killing a player.
function Library.Player:Kill()
    if self.Humanoid then
        self.Humanoid.Health = 0
    else
        self:Destroy()
    end
end

-- Robust method of giving damage to a player.
-- Optionally with a forcefield percentage,
-- which is the percentage of damage that is absorbed if
-- the player has a forcefield.
-- Returns the amount of damage dealt.
function Library.Player:TakeDamage(Amount, ForcefieldPercentage)
    ForcefieldPercentage = ForcefieldPercentage or 0

    if self.Humanoid then
        if self.Humanoid.Health <= Amount then
            self:Kill()
            return Amount
        end

        self.Humanoid:TakeDamage(Amount)

        if self.Character:FindFirstChildOfClass('Forcefield') then
            Amount = Amount * ForcefieldPercentage
            self.Humanoid.Health -= Amount

            return Amount
        end
    elseif Amount >= self.Humanoid.MaxHealth then
        self:Kill()
        return Amount
    end

    return 0
end

-- Kick the player from the game with a message.
function Library.Player:Kick(Message)
    if self.Player then
        self.Player:Kick(Message)
    end

    self:Destroy()
end

-- Destroy the player object
function Library.Player:Destroy()
    if self.Character then
        self.Character:Destroy()
    end
end

-- Check if the player is alive,
-- will also ignore players with KillerIgnore.
function Library.Player:IsAlive()
    return self.Humanoid and
           self.Humanoid.Health > 0 and
           self.HumanoidRootPart and
           self.Humanoid.Health ~= math.huge
end

-- Get the position of the player,
-- returns a Vector3 position.
function Library.Player:Position()
    if self.HumanoidRootPart then
        return self.HumanoidRootPart.Position
    end
end

-- Get the distance to a specific Vector3 `Position`.
function Library.Player:DistanceTo(Position)
    if not self.HumanoidRootPart then return math.huge end

    local PlayerPosition = self:Position()
    if not PlayerPosition then return math.huge end

    return (PlayerPosition - Position).Magnitude
end