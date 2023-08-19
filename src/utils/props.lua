local function Validate(Model, Type)
    -- Typecheck the model
    if Model:IsA(Type) then
        return Model
    end

    -- If the model is not the correct type, return nil
    error('Expected type ' .. Type .. ' but got ' .. Model.ClassName .. ' instead.')
    return nil
end

local function CreateProp(Type, Name, Parent)
    -- Create a new prop with the given type, name, and parent
    local Prop = Instance.new(Type)
    Prop.Name = Name
    Prop.Parent = Parent
end

local function CreateReplicatedProp(Type, Name)
    -- Create a prop in replicated storage
    return CreateProp(Type, Name, ReplicatedStorage)
end

local function MoveProp(Prop, Parent)
    -- Move the prop to the given parent
    Prop.Parent = Parent
    return Prop
end

local function DropProp(Prop, Parent)
    -- Create a clone of the current prop
    local Clone = Prop:Clone()
    MoveProp(Clone, Parent)

    -- Return the clone
    return Clone
end

local function HideProp(Prop)
    -- Create a clone and destroy the original
    local Clone = Prop:Clone()
    Prop:Destroy()

    -- Return new clone with nil instance
    return Clone
end