Assets.Storage = {}

function Assets.Storage:Initialize(Folder)
    self.Folder = Folder

    -- Process Folder
    for i, Object in Folder:GetChildren() do
        if self[Object.Name] then
            warn('Duplicate name in class with ' .. Object.Name)
            continue
        end

        -- Create new instances of Class
        self[Object.Name] = self:CreateObject(Object)
    end

    self.Folder:Destroy()
    return self
end

function Assets.Storage:CreateObject(Object)
    local Asset = {
        Reference = HideProp(Object),
        References = {},
        Get = function(Object)
            return Object.Reference
        end,
        Set = function(Object, Reference)
            Object.Reference = Reference
            return Object:Get()
        end,
        Clone = function(Object)
            local Clone = Object.Reference:Clone()
            table.insert(self.References, Clone)

            return Clone
        end,
        Spawn = function(Object, Parent)
            return MoveProp(Object:Clone(), Parent)
        end,
        Cleanup = function(Object)
            for i, Reference in References do
                Reference:Destroy()
            end
        end
    }

    AI.Cleanup:Connect(function()
        Asset:Cleanup()
    end)

    return Asset
end