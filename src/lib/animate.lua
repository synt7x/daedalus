Library.Animate = {}

function Library.Animate:LoadAnimations(Animations)
    -- Check for humanoid
    if not AI.Humanoid then
        return warn('Cannot load animations without a humanoid!')
    end

    -- Get an animator
    local Animator = AI.Humanoid:FindFirstChildOfClass('Animator') or AI.Humanoid
    self.Animations = {}

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

-- Loading Animation functions
function Library.Animate:Use(Callback)
    -- Create a thread
    local Thread = task.spawn(function()
        Callback(self, self.Animations, AI)
    end)

    -- Stop the thread once the round ends
    AI.Cleanup:Connect(function()
        task.cancel(Thread)
    end)

    return Thread
end

-- Default functions
function Library.Animate:Single(Animations, AI)
    -- Play all animations
    for i, Animation in Animations do
        if not Animation.IsPlaying then
            Animation:Play()
        end
    end
end

function Library.Animate:Chaser(Animations, AI)
    -- Prefetch animations
    local Idle = Animations.Idle
    local Walk = Animations.Walk or Animations.Run


end

function Library.Animate.Runner(Threshold)
    -- Prefetch animations
    local Idle = Animations.Idle
    local Walk = Animations.Walk
    local Run = Animations.Run

    -- Return closure with the given threshold
    return function(self, Animations, AI)

    end
end