-- Basic type sanity checks.
local function Validate(Model, Type)
	-- Typecheck the model
	if Model:IsA(Type) then
		return Model
	end

	if not Model then
		error("Expected type " .. Type .. " but got nothing.")
	end

	-- If the model is not the correct type, return nil
	error("Expected type " .. Type .. " but got " .. Model.ClassName .. " instead.")
end

-- Quick function for creating instances.
local function CreateProp(Type, Name, Parent)
	-- Create a new prop with the given type, name, and parent
	local Prop = Instance.new(Type)
	Prop.Name = Name
	Prop.Parent = Parent
end

-- Quick function for creating a prop in ReplicatedStorage.
local function CreateReplicatedProp(Type, Name)
	-- Create a prop in replicated storage
	return CreateProp(Type, Name, ReplicatedStorage)
end

-- Quick function for moving a prop.
local function MoveProp(Prop, Parent)
	-- Move the prop to the given parent
	Prop.Parent = Parent
	return Prop
end

-- Quick function for moving a prop via cloning.
local function DropProp(Prop, Parent)
	-- Create a clone of the current prop
	local Clone = Prop:Clone()
	MoveProp(Clone, Parent)

	-- Return the clone
	return Clone
end

-- Quick function for hiding a prop from the client.
local function HideProp(Prop)
	-- Create a clone and destroy the original
	local Clone = Prop:Clone()
	Prop:Destroy()

	-- Return new clone with nil instance
	return Clone
end
