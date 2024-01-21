local Assets = {}

function Assets.new()
    -- Copy all values to create a new instance of the class
	local self = {}

    for Key, Value in pairs(Assets) do
        self[Key] = Value
    end

    self.Root = SCOPE

    -- Get folders
    local SoundsFolder = self.Root:FindFirstChild('Sounds')
    local GraphicsFolder = self.Root:FindFirstChild('Graphics')
    local ScriptsFolder = self.Root:FindFirstChild('Scripts')
    local StorageFolder = self.Root:FindFirstChild('Storage')

    -- Initialize modules
    self.Sounds:Initialize(SoundsFolder)
    self.Graphics:Initialize(GraphicsFolder)
    self.Scripts:Initialize(ScriptsFolder)
    self.Storage:Initialize(StorageFolder)
    
    return self
end

-- Allow monkey-patching using modules
function Assets:Patch(Module)
    -- Check that the module is a table
    if type(Module) ~= 'table' then
        error('Assets:Patch() must be called with a table!')
    else
        -- Copy all values from the module
        for Key, Value in Module do
            self[Key] = Value
        end
    end
end

-- Import Asset Modules
<include 'src/assets/graphics.lua'>
<include 'src/assets/scripts.lua'>
<include 'src/assets/sounds.lua'>
<include 'src/assets/storage.lua'>