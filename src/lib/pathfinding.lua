Library.Pathfinding = {}

-- Calculate a path to a specific `Vector` Vector3 position.
-- Returns a table of `Waypoint`s that the AI should follow.
-- This function is synchronous and will return immediately.
function Library.Pathfinding:Calculate(Vector)
	local Path = PathfindingService:CreatePath(OPTIONS.Pathfinding or {})
	Path:ComputeAsync(AI:Position(), Vector)

	if Path.Status == Enum.PathStatus.Success then
		return Path:GetWaypoints()
	end

	return {}
end

-- Calculate a path between two Vector3s `Start` and `End`.
-- Returns a table of `Waypoint`s.
-- This function is synchronous and will return immediately.
function Library.Pathfinding:Between(Start, End)
	-- Create a path between two points
	local Path = PathfindingService:CreatePath(OPTIONS.Pathfinding or {})
	Path:ComputeAsync(Start, End)

	if Path.Status == Enum.PathStatus.Success then
		return Path:GetWaypoints()
	end

	return {}
end
