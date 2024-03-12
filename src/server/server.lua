RegisterServerEvent('SDOP:Server:DeleteObject')
AddEventHandler('SDOP:Server:DeleteObject', function(netid)
    local ent = NetworkGetEntityFromNetworkId(netid)
    if DoesEntityExist(ent) then
        DeleteEntity(ent)
    end
end)