Library.Animate = {
    PollingRate = 0.1
}

function Library.Animate:LoadAnimations(Animations)
    -- Check for humanoid
    if not AI.Humanoid then
        return warn('Cannot load animations without a humanoid!')
    end

    -- Get an animator
    local Animator = AI.Humanoid:FindFirstChildOfClass('Animator') or AI.Humanoid
    self.Animations = {}
    self.Pose = 'Idle'

    AI.Humanoid.Running:Connect(function(Speed)
        if Speed <= 0.01 then
            self.Pose = 'Idle'
        else
            self.Pose = 'Running'
        end
    end)

    AI.Humanoid.FreeFalling:Connect(function()
        self.Pose = 'Falling'
    end)

    -- Load all animations
    for Name, ID in Animations do
        local Animation = Instance.new('Animation')
        Animation.AnimationId = ID

        local Track = Animator:LoadAnimation(Animation)
        self.Animations[Name] = Track
    end

    -- Returns a list of animations
    return table.unpack(self.Animations)
end

-- Playing animation synchronously
function Library.Animate:Play(Track)
    -- Don't play the same animation
    if not Track.IsPlaying then
        return self:ForcePlay(Track)
    end

    return self.PlayingAnimation
end

-- Playing animation asynchronously
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

-- Loading Animation functions
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

-- Default functions
function Library.Animate:Single(Animations, AI)
    -- Play all animations
    for i, Animation in Animations do
        self:Play(Animation)
    end
end

function Library.Animate:Chaser(Animations, AI)
    -- Prefetch animations
    local Idle = Animations.Idle
    local Walk = Animations.Walk or Animations.Run

    while task.wait(self.PollingRate) do
        if self.Pose == 'Idle' then
            self:Play(Idle)
        else
            self:Play(Walk)
        end
    end
end

function Library.Animate.Runner(Threshold)
    -- Return closure with the given threshold
    return function(self, Animations, AI)
        local Idle = Animations.Idle
        local Walk = Animations.Walk
        local Run = Animations.Run

        while task.wait(self.PollingRate) do
            if self.Pose == 'Idle' then
                self:Play(Idle)
            elseif AI.Humanoid.WalkSpeed >= Threshold then
                self:Play(Run)
            else
                self:Play(Walk)
            end
        end
    end
end