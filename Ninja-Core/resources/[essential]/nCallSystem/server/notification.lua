RegisterServerEvent('callsystem:sendMessageToEmergency')
AddEventHandler('callsystem:sendMessageToEmergency', function(playerID, x, y, z, job, reason)
	TriggerClientEvent('callsystem:ReceiveEmergencyMessage', -1, playerID, x, y, z, source, job, reason)
end)

RegisterServerEvent('callsystem:getTheCall')
AddEventHandler('callsystem:getTheCall', function(playerName, playerID, x, y, z, sourcePlayer, job)
	TriggerClientEvent('callsystem:callTaken', -1, playerName, playerID, x, y, z, sourcePlayer, job)
end)

RegisterServerEvent('callsystem:sendMessageToPlayer')
AddEventHandler('callsystem:sendMessageToPlayer', function(sourcePlayer, job)
	TriggerClientEvent('callsystem:sendMessageToPlayer', sourcePlayer, job)
end)

RegisterServerEvent('callsystem:getTheCallDring')
AddEventHandler('callsystem:getTheCallDring', function(player_serverid)
	TriggerClientEvent('nMenuNotif:showNotification', player_serverid, "Bienvenue !")
	TriggerClientEvent('nMenuNotif:showNotification', source, "Vous avez ouvert la porte !")
	TriggerClientEvent('apart:CanEnterDring', player_serverid)
end)