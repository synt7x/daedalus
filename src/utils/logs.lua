local Logs = {
    warn = warn,
    error = error,
    print = print,
}

local function warn(message)
    local message = MODEL and string.format("daedalus @ %s | %s", MODEL.Name, message) or string.format("daedalus | %s", message)

    if DEBUG then
        Remote:FireAllClients('warn', message)
    end

    Logs.warn(message)
end

local function error(message)
    local message = MODEL and string.format("daedalus @ %s | %s", MODEL.Name, message) or string.format("daedalus | %s", message)

    if DEBUG then
        Remote:FireAllClients('error', message)
    end

    Logs.error(message)
end