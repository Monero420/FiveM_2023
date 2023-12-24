local playerData = {}

AddEventHandler('onClientResourceStart', function (resourceName)
  if(GetCurrentResourceName() ~= resourceName) then
    return
  end
  print('The resource ' .. resourceName .. ' has been started on the client.')
  
  TriggerServerEvent('requestPlayerData')
end)

RegisterNetEvent('recievePlayerData')
AddEventHandler('recievePlayerData', function(updatedPlayerData)
    if updatedPlayerData then
        --updatedPlayerData.bank = tonumber(updatedPlayerData.bank) or 0
        --updatedPlayerData.cash = tonumber(updatedPlayerData.cash) or 0
		--updatedPlayerData.inventory = json.decode(updatedPlayerData.inventory) or {}
        --updatedPlayerData.cars = json.decode(updatedPlayerData.cars)
        --updatedPlayerData.properties = json.decode(updatedPlayerData.properties)
        playerData = updatedPlayerData
    else
        print("Error: Received nil player data.")
    end
end)

RegisterNetEvent('sendPlayerUpdateToServer')
AddEventHandler('sendPlayerUpdateToServer', function()
    local dataToSend = playerData
    
    TriggerServerEvent('recieveUpdateFromClient', dataToSend)
end)

RegisterNetEvent('updateInventory')
AddEventHandler('updateInventory', function(itemData)
	local key = itemData.key
	local incrementAmount = itemData.amount
	
	if playerData.inventory[key] then
		playerData.inventory[key] = playerData.inventory[key] + incrementAmount
	else
		playerData.inventory[key] = incrementAmount
	end
	print("Inventory Changed:", json.encode(playerData.inventory))
end)

RegisterCommand('getstats', function()
    print("Bank: " .. playerData.bank .. ", Cash: " .. playerData.cash .. ", Inventory: " .. json.encode(playerData.inventory))
end)