Assets.Sounds = {}

-- Scripts Object
local Sounds = {}

-- Create a new sound object that has various utility
-- functions for handling sounds.
-- Takes a `Sound` instance as an argument.
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

-- Set the sound reference,
-- generally an internal function.
function Sounds:Set(Sound)
    self.Reference = Sound
    return self
end

-- Get the sound reference,
-- this is generally an internal function.
function Sounds:Get()
    return self.Reference
end

-- Play the sound on a specific object,
-- this will clone the sound and play it on the object.
-- Takes an `Object` instance as an argument.
-- Returns the cloned sound instance.
-- The sound will automatically be destroyed when it ends.
function Sounds:PlayOn(Object)
    local Sound = self.Reference:Clone()
    Sound.Parent = Object
    Sound.Ended:Connect(function()
        Sound:Destroy()
    end)

    Sound:Play()
    return Sound
end

-- Play the sound
function Sounds:Play()
    self.Reference:Play()
    return self
end

-- Alter the pitch of the sound,
-- takes a `Pitch` which determines the octave of the effect.
function Sounds:Pitch(Pitch)
    local Pitch = self.Reference:FindFirstChildOfClass('PitchShiftSoundEffect')

    if not Pitch then
        Pitch = CreateProp('PitchShiftSoundEffect', 'Pitch', self.Reference)
    end

    Pitch.Octave = Pitch
    return self
end

-- Alter the volume of the sound,
-- takes a `Volume` which determines the volume.
function Sounds:Volume(Volume)
    self.Reference.Volume = Volume
    return self
end


-- Wait for the sound to be loaded,
-- this is useful for ensuring that the sound
-- is properly synced before playing.
function Sounds:Sync()
    self.Reference:Pause()

    repeat
        task.wait()
    until self.Reference.IsLoaded

    if not self.Reference.IsPlaying then
        self.Reference:Resume()
    end

    return self
end

-- Initialize the sounds system with a specified `Folder`.
function Assets.Sounds:Initialize(Folder)
    if not Folder then return end
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

-- Create a new sound that has various utility
-- functions for handling sounds.
-- Takes a `Sound` instance as an argument.
function Assets.Sounds:CreateSound(Sound)
    return Sounds.new(Sound)
end