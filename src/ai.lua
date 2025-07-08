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

    -- Movement State
    self.MoveID = 0
    self.Flags = 0

    self.Model.PrimaryPart:SetNetworkOwner()

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
            -- Fire the 'Tick' event
            self.Tick:Fire()
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
        if not SCOPE:IsDescendantOf(workspace) then
            self.Cleanup:Fire()
            script.Disabled = true
        end
    end)

	return self
end

-- Get AI Position
function AI:Position()
    return self:CFrame().Position
end

function AI:CFrame()
    return ROOT.CFrame
end

-- Teleport AI
function AI:TeleportTo(Vector)
    ROOT.CFrame = CFrame.new(Vector) * self:CFrame() - self:Position()
end

function AI:GoTo(Coordinate)
    ROOT.CFrame = Coordinate
end

-- Get AI LookDirection
function AI:LookVector()
    return self:CFrame().LookVector
end

-- Replacement MoveTo function
function AI:MoveTo(Vector, Cutoff)
    if not self.Humanoid then return warn('No result of MoveTo due to lack of Humanoid') end

    local ID = self:IncrementID()
    local Humanoid = self.Humanoid
    local Cutoff = Cutoff or 3 / 4

    task.delay(Cutoff, function()
        if ID == self:GetID() then
            self:Move(AI:LookVector(), -2)
        end
    end)

    Humanoid:MoveTo(Vector)
end

-- Replacement Move function
function AI:Move(Direction, Distance)
    if not self.Humanoid then return warn('No result of Move due to lack of Humanoid') end

    local ID = self:IncrementID()
    local Humanoid = self.Humanoid

    if Distance then
        local Delay = math.abs(Distance) / Humanoid.WalkSpeed

        task.delay(Delay, function()
            if ID == self:GetID() then
                self:Stop()
            end
        end)
    end

    Humanoid:Move(Direction * math.sign(Distance))
end

-- Stop all movement
function AI:Stop()
    self:IncrementID()
    return self.Humanoid:MoveTo(self:Position())
end

-- Increment MovementID
function AI:IncrementID()
    self.MoveID += 1

    return self:GetID()
end

-- Get MovementID
function AI:GetID()
    return self.MoveID
end

-- Check if current movement is optimized,
-- takes a list of `Waypoints` as an argument.
function AI:Unoptimized(Target, Waypoints)
    local Alternate = Library.Players:GetNearest()
    local Waypoints = self.Waypoints

    return not Alternate
        or #Waypoints == 0
        or Alternate.Character ~= Target.Character
        or Alternate:DistanceTo(Target:Position()) < Target:DistanceTo(Waypoints[#Waypoints].Position)
        or self.Raycast
end

-- Create an event with an `Event` name
-- This will create an event that can be connected to
-- and fired, with the `Connect` and `Fire` methods.
function AI:CreateEvent(Event)
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

-- Bind a `Callback` to the main event loop
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

-- Quickly create an AI instance
-- This is a convenience function to create an AI instance
-- Takes a function argument `Pathfinding` which handles pathfinding
-- along waypoints, with the type `(Target, Waypoint) -> !`.
-- Also takes a function argument `Raycasting` which handles
-- pathfinding along a straight line, with the type `(Target) -> !`.
function AI:API(Pathfinding, Raycasting)
    -- Handle targeting
    self:Targeting()

    -- Handle pathfinding
    self:Connect(function()
        if not self.Humanoid then return warn('AI is halted due to lack of Humanoid') end

        -- Get generated values
        local Target = self.Target
        local Raycast = self.Raycast
        local Waypoints = self.Waypoints

        -- Skip if there is no target
        if not Target then return AI:Stop() end

        if Raycast then
            if Raycasting(Target) then return end
        else
            for i, Waypoint in Waypoints do
                -- Skip unneccessary waypoints
                if i <= 2 then continue end
                if Pathfinding(Target, Waypoint) then return end
                if self:Unoptimized(Target, Waypoints) then return end
            end
        end
    end)
end

-- Have the AI handle targeting for you.
function AI:Targeting()
    -- Generate raycasting parameters
    Library.Raycasting:GetParameters(AI.Model)

    -- Generate pathfinding information
    self:Connect(function()
        if not self.Humanoid then return warn('Targeting is halted due to lack of Humanoid') end

        -- Get the current `Target` player
        local Target = Library.Players:GetNearest()

        -- Expose the target to the AI and reset the Raycast
        self.Target = Target
        self.Raycast = nil

        -- Don't continue if there is no target
        if not Target then return end

        -- Check if the target is visible
        local Raycast = Library.Raycasting:PlayerCast(
            self:Position(),
            Target:Position(),
            OPTIONS.MaxDistance or 1024,
            Library.Raycasting.
            Library.Raycasting.Parameters.Default
        )

        -- Update the Raycasting information
        self.Raycast = Raycast
        self.Waypoints = Library.Pathfinding:Calculate(Target:Position())
    end)
end