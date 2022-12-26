-- Initialize AI class
local AI = {}

-- AI class constructor
function AI.new()
    -- Copy all values to create a new instance of the class
	local self = {}

	for name, value in AI do
		self[name] = value
	end

    -- Create values
    self.Model = MODEL
    self.Name = self.Model.Name
    self.Humanoid = self.Model:FindFirstChildOfClass("Humanoid")
    self.Events = {}

    self:CreateEvent('Initialize')
    self:CreateEvent('Tick')
    self:CreateEvent('Cleanup')
    self:CreateEvent('Ended')

    -- Initialize AI
    self.Initialize:Fire(Model, Humanoid)

	return self
end

-- Create an event
function AI:CreateEvent(Event)
    -- Don't overwrite existing values
    if self.Events[Event] or self[Event] then
        error("Event '" .. Event .. "' already exists!")
    else

        -- Create event
        self.Events[Event] = {
            Callbacks = {},
            Connect = function(Callback)
                table.insert(self.Events[Event].Callbacks, Callback)
            end,
            Fire = function(...)
                for i, Callback in self.Events[Event].Callbacks do
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