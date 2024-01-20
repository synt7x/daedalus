Assets.Sounds = {}

function Assets.Sounds:Initialize()

end

function Assets.Sounds:CreateSound()

end

-- Scripts Object
local Sounds = {}

function Sounds.new(Sound)
    -- Copy all values to create a new instance of the class
    local self = {}

    for Key, Value in pairs(Sounds) do
        self[Key] = Value
    end

    -- Setup references
    self:Set(Sound)
    self.References = {}
    self.Connections = {}

    -- Destroy GUIs on removing
    AI.Cleanup:Connect(function()
        self:Remove()
    end)

    return self
end