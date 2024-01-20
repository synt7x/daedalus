Assets.Graphics = {}

function Assets.Graphics:Initialize(Folder)
    self.Folder = Folder

    -- Process Folder
    for i, Gui in Folder:GetChildren() do
        if self[Gui.Name] then
            warn('Duplicate name in class with ' .. Gui.Name)
            continue
        end

        -- Create new instances of Class
        self[Gui.Name] = self:CreateGui(Gui)
    end

    Folder:Destroy()
    return self
end

function Assets.Graphics:CreateGui(Gui)
    return Graphics.new(Gui)
end

-- Graphics Object
local Graphics = {}

function Graphics.new(Gui)
    -- Copy all values to create a new instance of the class
	local self = {}

    for Key, Value in pairs(Graphics) do
        self[Key] = Value
    end

    -- Setup references
    self:Set(Gui)
    self.References = {}
    self.Connections = {}

    -- Destroy GUIs on removing
    AI.Cleanup:Connect(function()
        self:Hide()
    end)

    return self
end

function Graphics:Get()
    return self.Prop
end

function Graphics:Set(Gui)
    -- Hide prop from workspace
    self.Prop = HideProp(Gui)
    return self:Get()
end

function Graphics:Display()
    -- Display GUI until hidden
    table.insert(
        self.Connections,
        Players.PlayerAdded:Connect(function(Player)
            Player.CharacterAdded:Connect(function()
                self:ShowTo(Player)
            end)
        end)
    )

    self:Show()
end

function Graphics:Show()
    -- Show GUI to all players once
    for i, Player in Players:GetPlayers() do
        self:ShowTo(Player)
    end
end

function Graphics:ShowTo(Player)
    -- Show GUI to a single player once
    local Prop = self.Prop:Clone()
    MoveProp(Prop, Player.PlayerGui)

    -- Create a reference
    table.insert(References, Prop)
end

function Graphics:Hide()
    -- Remove all GUIs
    for i, Prop in self.References do
        Prop:Destroy()
    end

    -- Remove all bindings
    for i, Connection in self.Connections do
        Connection:Disconnect()
    end
end