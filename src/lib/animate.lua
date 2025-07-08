Library.Animate = {
	PollingRate = 0.1,
}

-- Load a list of animations into the AI.
-- Takes a table of `Animations` with names as keys and animation IDs as values.
-- Generally, the utility functions use the names `Idle`, `Walk`, and `Run` to
-- handle animations, but you can use any names you want.
-- Returns a list of loaded animations (that can be called with `:Play()`),
-- in the form of `local a, b, c = Library.Animate:LoadAnimations({...})`
function Library.Animate:LoadAnimations(Animations)
	-- Check for humanoid
	if not AI.Humanoid then
		return warn("Cannot load animations without a humanoid!")
	end

	-- Get an animator
	local Animator = AI.Humanoid:FindFirstChildOfClass("Animator") or AI.Humanoid
	self.Animations = {}
	self.Pose = "Idle"

	AI.Humanoid.Running:Connect(function(Speed)
		if Speed <= 1 / 100 then
			self.Pose = "Idle"
		else
			self.Pose = "Running"
		end
	end)

	AI.Humanoid.FreeFalling:Connect(function()
		self.Pose = "Falling"
	end)

	-- Load all animations
	for Name, ID in Animations do
		local Animation = Instance.new("Animation")
		Animation.AnimationId = ID

		local Track = Animator:LoadAnimation(Animation)
		self.Animations[Name] = Track
	end

	-- Returns a list of animations
	return table.unpack(self.Animations)
end

-- Play an animation synchronously,
-- this will not play the same animation if it is already playing.
function Library.Animate:Play(Track)
	-- Don't play the same animation
	if not Track.IsPlaying then
		return self:ForcePlay(Track)
	end

	return self.PlayingAnimation
end

-- Play an animation asynchronously,
-- will force the animation to play
-- even if another animation is playing.
function Library.Animate:ForcePlay(Track)
	-- Stop playing animation
	if self.PlayingAnimation and self.PlayingAnimation.IsPlaying then
		self.PlayingAnimation:Stop()
	end

	-- Load new animation
	self.PlayingAnimation = Track
	Track:Play()

	return Track
end

-- Load a specific animation handler.
-- Must be a function that takes `Library.Aniamate`, a list
-- of `Animations` and the `AI` object.
function Library.Animate:Use(Callback)
	-- Create a thread
	local Thread = task.spawn(function()
		Callback(self, self.Animations, AI)
	end)

	-- Stop the thread once the round ends
	AI.Cleanup:Connect(function()
		if Thread then
			task.cancel(Thread)
		end
	end)

	return Thread
end

-- Plays all animations in a list of animations
-- This is meant to be used with Library.Animate:Use
function Library.Animate:Single(Animations, AI)
	-- Play all animations
	for i, Animation in Animations do
		self:Play(Animation)
	end
end

-- Plays animations whether the AI is idle or walking.
-- Takes a list of animations with `Idle` and `Walk` animations.
-- This is meant to be used with Library.Animate:Use
function Library.Animate:Chase(Animations, AI)
	-- Prefetch animations
	local Idle = Animations.Idle
	local Walk = Animations.Walk or Animations.Run

	while task.wait(self.PollingRate) do
		if self.Pose == "Idle" then
			self:Play(Idle)
		else
			self:Play(Walk)
		end
	end
end

-- Generate a function that controls the threshold for the running animation.
-- Takes a `Threshold` value, which is the speed at which the AI will switch from walking to running.
-- The result is meant to be used with Library.Animate:Use
function Library.Animate.Run(Threshold)
	-- Return closure with the given threshold
	return function(self, Animations, AI)
		local Idle = Animations.Idle
		local Walk = Animations.Walk
		local Run = Animations.Run

		while task.wait(self.PollingRate) do
			if self.Pose == "Idle" then
				self:Play(Idle)
			elseif AI.Humanoid.WalkSpeed >= Threshold then
				self:Play(Run)
			else
				self:Play(Walk)
			end
		end
	end
end
