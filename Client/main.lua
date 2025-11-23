local function SendCommand(command, reason)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    TriggerServerEvent("azm:commandUsed", command, reason or "", {
        x = coords.x,
        y = coords.y,
        z = coords.z
    })
end

RegisterCommand("خارج", function(_, args)
    local reason = table.concat(args, " ")
    SendCommand("خارج", reason)
end)

RegisterCommand("تخريب", function(_, args)
    local reason = table.concat(args, " ")
    SendCommand("تخريب", reason)
end)

RegisterCommand("help", function(_, args)
    local reason = table.concat(args, " ")
    SendCommand("help", reason)
end)
