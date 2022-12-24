local Logs = {
    warn = warn,
    error = error,
    print = print,
}

local function warn(message)
    local message = if MODEL then string.format("daedalus @ %s | %s", MODEL.Name, message) else string.format("daedalus | %s", message)

    if DEBUG then
        Remote:FireAllClients('warn', message)
    end

    Logs.warn(message)
end

local function error(message)
    local message = if MODEL then string.format("daedalus @ %s | %s", MODEL.Name, message) else string.format("daedalus | %s", message)

    if DEBUG then
        Remote:FireAllClients('error', message)
    end

    Logs.error(message)
end