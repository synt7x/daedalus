Library.Raycasting = {
	Parameters = {},
}

-- Simple raycasting, which only ignores the killer.
Library.Raycasting.Parameters.Default = RaycastParams.new()

-- Raycasting that ignores all parts with a transparency of 0.1 or higher,
-- and all parts that do not collide.
Library.Raycasting.Parameters.Transparent = RaycastParams.new()

-- Generate the default raycasting parameters.
-- Takes a `Character` and an optional `Map`.
function Library.Raycasting:GetParameters(Character, Map)
	self.Parameters.Default.FilterDescendantsInstances = { Character }
	self.Parameters.Default.FilterType = Enum.RaycastFilterType.Exclude

	if Map then
		local Blacklist = { Character }

		for i, Child in Map:GetDescendants() do
			if Child:IsA("BasePart") and Child.Transparency >= 0.1 or not Child.CanCollide then
				table.insert(Blacklist, Child)
			end
		end

		self.Parameters.Transparent.FilterDescendantsInstances = Blacklist
		self.Parameters.Transparent.FilterType = Enum.RaycastFilterType.Exclude
	end

	return self.Parameters
end

-- Simple raycasting function, takes an `Origin`, `Direction`, `Scalar` and optional `Parameters`.
-- Returns the hit `Instance`, `Position` and `Normal`.
function Library.Raycasting:Raycast(Origin, Direction, Scalar, Parameters)
	local Result = workspace:Raycast(Origin, Direction * Scalar, Parameters or self.Parameters.Default)

	if Result then
		return Result.Instance, Result.Position, Result.Normal
	end
end

-- Wrapper around the raycasting function for checking sight lines.
-- Takes an `Origin`, `Direction`, `Scalar` and optional `Parameters`.
function Library.Raycasting:SightCast(Origin, Direction, Scalar, Parameters)
	return self:Raycast(Origin, Direction, Scalar, Parameters)
end

-- Cast a ray and return the player if one was hit.
-- Takes an `Origin`, `Direction`, `Scalar` and optional `Parameters`.
function Library.Raycasting:PlayerCast(Origin, Direction, Scalar, Parameters)
	local Result = self:Raycast(Origin, Direction, Scalar, Parameters)
	if not Result then
		return
	end

	local Model = Result:FindFirstAncestorOfClass("Model")
	return Model and Library.Players:GetTarget(Model)
end

-- Cast a ray and reflects it off a surface.
-- Takes an `Origin`, `Direction`, `Scalar` and optional `Parameters`.
function Library.Raycasting:ReflectCast(Origin, Direction, Scalar, Parameters)
	local Part, Position, Normal = self:Raycast(Origin, Direction, Scalar, Parameters)
	if not Part then
		return
	end

	local Direction = Direction - 2 * Direction:Dot(Normal) * Normal
	local RPart, RPosition, RNormal = self:Raycast(Position, Direction, Scalar, Parameters)
	if not RPart then
		return { Part, Position, Normal }
	end

	return { Part = Part, Position = Position, Normal = Normal }, {
		Part = RPart,
		Position = RPosition,
		Normal = RNormal,
	}
end

-- Cast a ray and return the `Part`, `Position`, `Normal` and `Target` if a player was hit.
-- Takes an `Origin`, `Direction`, `Scalar` and optional `Parameters`.
function Library.Raycasting:HitScan(Origin, Direction, Scalar, Parameters)
	local Part, Position, Normal = self:Raycast(Origin, Direction, Scalar, Parameters)
	if not Part then
		return
	end

	local Model = Part:FindFirstAncestorOfClass("Model")
	local Target = Library.Players:GetTarget(Model)

	if Model and Target then
		return Part, Position, Normal, Target
	end
end

-- Cast a ray and pierce through multiple parts.
-- Takes an `Origin`, `Direction`, `Scalar` and optional `Parameters`.
-- This will continue to cast rays until no more parts are hit.
-- Returns a table of hits with `Part`, `Position`, `Normal` and `Target`.
function Library.Raycasting:PierceScan(Origin, Direction, Scalar, Parameters)
	local Hits = {}
	local Part, Position, Normal, Target

	repeat
		Part, Position, Normal, Target = self:HitScan(Origin, Direction, Scalar, Parameters)

		if Part then
			table.insert(Hits, {
				Part = Part,
				Position = Position,
				Normal = Normal,
				Target = Target,
			})
		end

		Origin = Position + Direction * 2
	until not Part

	return Hits
end
