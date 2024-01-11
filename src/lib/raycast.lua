Library.Raycasting = {
    Parameters = {}
}

Library.Raycasting.Parameters.Default = RaycastParams.new()
Library.Raycasting.Parameters.Transparent = RaycastParams.new()

function Library.Raycasting:GetParameters(Character, Map)
    self.Parameters.Default.FilterDescendantsInstances = { Character }
    self.Parameters.Default.FilterType = Enum.RaycastFilterType.Exclude
    
    if Map then
        local Blacklist = { Character }

        for i, Child in Map:GetDescendants() do
            if Child:IsA('BasePart') and Child.Transparency >= .1 or not Child.CanCollide then
                table.insert(Blacklist, Child)
            end
        end

        self.Parameters.Transparent.FilterDescendantsInstances = Blacklist
        self.Parameters.Transparent.FilterType = Enum.RaycastFilterType.Exclude
    end

    return self.Parameters
end

function Library.Raycasting:Raycast(Origin, Direction, Scalar, Parameters)
    local Result = workspace:Raycast(Origin, Direction * Scalar, Parameters or self.Parameters.Default)

    if Result then
        return Result.Instance, Result.Position, Result.Normal
    end
end

function Library.Raycasting:SightCast(Origin, Direction, Scalar, Parameters)
    return self:Raycast(Origin, Direction, Scalar, Parameters)
end

function Library.Raycasting:PlayerCast(Origin, Direction, Scalar, Parameters)
    local Result = self:Raycast(Origin, Direction, Scalar, Parameters)
    if not Result then return end

    local Model = Result:FindFirstAncestorOfClass('Model')
    return Model and Library.Players:GetTarget(Model)
end

function Library.Raycasting:ReflectCast(Origin, Direction, Scalar, Parameters)
    local Part, Position, Normal = self:Raycast(Origin, Direction, Scalar, Parameters)
    if not Part then return end

    local Direction = Direction - 2 * Direction:Dot(Normal) * Normal
    local RPart, RPosition, RNormal = self:Raycast(Position, Direction, Scalar, Parameters)
    if not RPart then return { Part, Position, Normal } end

    return { Part, Position, Normal }, { RPart, RPosition, RNormal }
end

function Library.Raycasting:HitScan(Origin, Direction, Scalar, Parameters)
    local Part, Position, Normal = self:Raycast(Origin, Direction, Scalar, Parameters)
    if not Part then return end

    local Model = Part:FindFirstAncestorOfClass('Model')
    if Model and Library.Players:GetTarget(Model) then
        return Part, Position, Normal
    end
end

function Library.Raycasting:PierceScan(Origin, Direction, Scalar, Parameters)
    local Hits = {}
    local Part, Position, Normal

    repeat
        Part, Position, Normal = self:HitScan(Origin, Direction, Scalar, Parameters)
        if Part then table.insert(Hits, { Part, Position, Normal }) end

        Origin = Position + Direction * 2
    until not Part

    return Hits
end