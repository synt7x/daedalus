local Logs = {
    warn = warn,
    error = error,
    print = print,
}

local function warn(message)
    -- Format message with the model name if it exists
    local message = MODEL and string.format('daedalus @ %s | %s', MODEL.Name, message) or string.format('daedalus | %s', message)

    -- Fire to debug
    if DEBUG then
        Remote:FireAllClients('warn', message)
    end

    -- Log to console
    Logs.warn(message)
end

local function error(message)
    -- Format message with the model name if it exists
    local message = MODEL and string.format('daedalus @ %s | %s', MODEL.Name, message) or string.format('daedalus | %s', message)

    -- Fire to debug
    if DEBUG then
        Remote:FireAllClients('error', message)
    end

    -- Log to console
    Logs.error(message)
end