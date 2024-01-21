Assets.Scripts = {}

function Assets.Scripts:Initialize(Folder)
    self.Folder = Folder

    -- Process Folder
    for i, Script in Folder:GetChildren() do
        if self[Script.Name] then
            warn('Duplicate name in class with ' .. Script.Name)
            continue
        end

        -- Create new instances of Class
        self[Script.Name] = self:CreateScript(Script)
    end

    self.Folder:Destroy()
    return self
end

function Assets.Scripts:CreateScript(Script)
    return Scripts.new(Script)
end

-- Scripts Object
local Scripts = {}

function Scripts.new(Script)
    -- Copy all values to create a new instance of the class
    local self = {}

    for Key, Value in pairs(Scripts) do
        self[Key] = Value
    end

    -- Setup references
    self:Set(Script)
    self.References = {}
    self.Connections = {}

    -- Destroy GUIs on removing
    AI.Cleanup:Connect(function()
        self:Remove()
    end)

    return self
end

function Scripts:Get()
    return self.Prop
end

function Scripts:Set(Script)
    -- Hide prop from workspace
    self.Prop = HideProp(Script)
    return self:Get()
end

function Scripts:Activate()
    -- Activate Script until removed
    table.insert(
        self.Connections,
        Players.PlayerAdded:Connect(function(Player)
            Player.CharacterAdded:Connect(function()
                self:GiveTo(Player)
            end)
        end)
    )

    self:Give()
end

function Scripts:Give()
    -- Give Script to all players once
    for i, Player in Players:GetPlayers() do
        self:GiveTo(Player)
    end
end

function Scripts:GiveTo(Player)
    -- Show GUI to a single player once
    self:Enable(Player.Character)
end

function Scripts:Enable(Parent)
    local Prop = self.Prop:Clone()
    MoveProp(Prop, Parent)

    if not Prop.Enabled then
        Prop.Enabled = true
    end

    -- Create a reference
    table.insert(References, Prop)
end

function Scripts:Remove()
    -- Remove all GUIs
    for i, Prop in self.References do
        Prop:Destroy()
    end

    -- Remove all bindings
    for i, Connection in self.Connections do
        Connection:Disconnect()
    end
end