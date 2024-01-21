Assets.Sounds = {}

function Assets.Sounds:Initialize(Folder)
    self.Folder = Folder

    -- Process Folder
    for i, Sound in Folder:GetChildren() do
        if self[Sound.Name] then
            warn('Duplicate name in class with ' .. Sound.Name)
            continue
        end

        -- Create new instances of Class
        self[Sound.Name] = self:CreateSound(Sound)
    end

    self.Folder:Destroy()
    return self
end

function Assets.Sounds:CreateSound(Sound)
    return Sounds.new(Sound)
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

function Sounds:Set(Sound)
    self.Reference = Sound
    return self
end

function Sounds:Get()
    return self.Reference
end

function Sounds:PlayOn(Object)
    local Sound = self.Reference:Clone()
    Sound.Parent = Object
    Sound.Ended:Connect(function()
        Sound:Destroy()
    end)

    Sound:Play()
    return Sound
end

function Sounds:Play()
    self.Reference:Play()
    return self
end

function Sounds:Pitch(Pitch)
    local Pitch = self.Reference:FindFirstChildOfClass('PitchShiftSoundEffect')

    if not Pitch then
        Pitch = CreateProp('PitchShiftSoundEffect', 'Pitch', self.Reference)
    end

    Pitch.Octave = Pitch
    return self
end

function Sounds:Volume(Volume)
    self.Reference.Volume = Volume
    return self
end

function Sounds:Sync()
    self.Reference:Pause()

    repeat
        task.wait()
    until self.Reference.IsLoaded

    if self.Reference.IsPlaying then
        self.Reference:Resume()
    end

    return self
end