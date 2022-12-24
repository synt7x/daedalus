local function warn(message)
    local original = warn

    if DEBUG then
        
    end

    if MODEL then
        original(
            string.format(
                "daedalus @ %s | %s",
                MODEL.Name
                message
            )
        )
    else 
        original(
            string.format(
                "daedalus | %s",
                message
            )
        )
    end
end