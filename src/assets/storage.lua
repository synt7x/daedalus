Assets.Storage = {}

-- Initialize the storage system with a specified `Folder`,
-- generally, this is an internal function that is called
-- when the AI is created.
function Assets.Storage:Initialize(Folder)
    if not Folder then return end
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

-- Create a new object that has various utility
-- functions for handling assets.
-- Assets create with this function will not
-- be visible on the client until they are spawned.
function Assets.Storage:CreateObject(Object)
    local Asset = {
        Reference = HideProp(Object),
        References = {},

        -- Get the reference to the asset
        Get = function(Object)
            return Object.Reference
        end,

        -- Update the reference of the asset,
        -- drops the old reference.
        Set = function(Object, Reference)
            Object.Reference = Reference
            return Object:Get()
        end,

        -- Get a new clone of the asset
        Clone = function(Object)
            local Clone = Object.Reference:Clone()
            table.insert(self.References, Clone)

            return Clone
        end,

        -- Move the asset to a new parent,
        -- takes the `Parent` as an argument.
        Spawn = function(Object, Parent)
            return MoveProp(Object:Clone(), Parent)
        end,

        -- Drop the asset, this will be called
        -- automatically when the AI is cleaned up.
        Cleanup = function(Object)
            for i, Reference in Object.References do
                Reference:Destroy()
            end
        end
    }

    AI.Cleanup:Connect(function()
        Asset:Cleanup()
    end)

    return Asset
end