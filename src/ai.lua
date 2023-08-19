-- AI class constructor
function AI.new()
    -- Copy all values to create a new instance of the class
	local self = {}

    for Key, Value in pairs(AI) do
        self[Key] = Value
    end

    -- Create values
    self.Model = MODEL
    self.Name = self.Model.Name
    self.Humanoid = self.Model:FindFirstChildOfClass('Humanoid')
    self.Events = {}

    self:CreateEvent('Initialize')
    self:CreateEvent('Tick')
    self:CreateEvent('Cleanup')
    self:CreateEvent('Ended')

    -- Initialize AI
    self.Initialize:Fire(self.Model, self.Humanoid)

    for i, Module in Library do
		if type(Module) == 'table' and Module.Initialize then
			Module:Initialize(self.Model, self.Humanoid)
		end
	end

    -- Initialize asynchronous, blocking loop
    task.spawn(function()
        while self.Model do
            -- Fetch all targets
            local Targets = Library.Players.Targets

            -- Fire the 'Tick' event, and pass targets
            self.Tick:Fire(Targets)
            task.wait()
        end
    end)

    -- Cleanup on death
    if self.Humanoid then
        self.Humanoid.Died:Connect(function()
            self.Cleanup:Fire()
            script.Disabled = true
        end)
    end

    -- Cleanup on deletion
    self.Model.AncestryChanged:Connect(function()
        if not self.Model:IsDescendantOf(game) then
            self.Cleanup:Fire()
            script.Disabled = true
        end
    end)

	return self
end

-- Create an event
function AI:CreateEvent(Event: string)
    -- Don't overwrite existing values
    if self.Events[Event] or self[Event] then
        error('Event "' .. Event .. '" already exists!')
    else
        -- Create event
        self.Events[Event] = {
			Callbacks = {},
			Connect = function(Event, Callback)
				table.insert(Event.Callbacks, Callback)
			end,
			Fire = function(Event, ...)
				for i, Callback in Event.Callbacks do
					-- Call the callback with the arguments
					Callback(...)
				end
			end
		}

        -- Allow it to be called on the class
        self[Event] = self.Events[Event]
    end

    -- Let the user fire the event after it's creation
    return self[Event]
end

-- Bind to the main event loop
function AI:Bind(Callback)
    -- Check that the 'Tick' event exists
    if not self.Events.Tick then
        error('AI:Bind() must be called after AI:CreateEvent(\'Tick\')!')
    else
        -- Connect to the 'Tick' event
        self.Events.Tick:Connect(Callback)
    end
end

-- Allow monkey-patching using modules
function AI:Patch(Module)
    -- Check that the module is a table
    if type(Module) ~= 'table' then
        error('AI:Patch() must be called with a table!')
    else
        -- Copy all values from the module
        for Key, Value in Module do
            self[Key] = Value
        end
    end
end