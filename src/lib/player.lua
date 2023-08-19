Library.Player = {}

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

function Library.Player:Kill()
    if self.Humanoid then
        self.Humanoid.Health = 0
    else
        self:Destroy()
    end
end

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
    elseif Amount >= 100 then
        self:Kill()
        return Amount
    end

    return 0
end

function Library.Player:Kick(Message)
    if self.Player then
        self.Player:Kick(Message)
    end

    self:Destroy()
end

function Library.Player:Destroy()
    if self.Character then
        self.Character:Destroy()
    end
end

function Library.Player:IsAlive()
    return self.Humanoid and
           self.Humanoid.Health > 0 and
           self.HumanoidRootPart and
           self.Humanoid.Health ~= math.huge
end