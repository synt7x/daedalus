local function Validate(Model, Type)
    if Model:IsA(Type) then
        return Model
    end

    error("Expected type " .. Type .. " but got " .. Model.ClassName .. " instead.")
    return nil
end

local function CreateProp(Type, Name, Parent)
    local Prop = Instance.new(Type)
    Prop.Name = Name
    Prop.Parent = Parent
end

local function CreateReplicatedProp(Type, Name)
    return CreateProp(Type, Name, ReplicatedStorage)
end

local function MoveProp(Prop, Parent)
    -- Create a clone of the current prop
    local Clone = Prop:Clone()
    DropProp(Clone, Parent)

    -- Return the clone
    return Clone
end

local function DropProp(Prop, Parent)
    Prop.Parent = Parent
    return Prop
end

local function HideProp(Prop)
    -- Create a clone and destroy the original
    local Clone = Prop:Clone()
    Prop:Destroy()

    -- Return new clone with nil instance
    return Clone
end