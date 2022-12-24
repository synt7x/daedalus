-- daedalus debugging script

-- Recieves messages from ReplicatedStorage.daedalus and errors/warns/prints to the developer console
-- in order for errors to be visible to clients.

local daedalus = game:GetService("ReplicatedStorage"):WaitForChild("daedalus")

if not daedalus then
    error('daedalus | Failed to connect to the daedalus debugger! Report this to Syntax#9930 on Discord')
else
    print(
        string.format('daedalus | Debugger v%s connected!', VERSION)
    )
end

-- Start listening for messages
daedalus.OnClientEvent:Connect(function(...)
    local arguments = { ... }
    local type = arguments[1]
    table.remove(arguments, 1)

    if type == "error" then
        error(table.concat(arguments, " "))
    elseif type == "warn" then
        warn(table.concat(arguments, " "))
    elseif type == "print" then
        print(table.concat(arguments, " "))
    end
end)