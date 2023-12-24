RegisterNetEvent('requestPlayerData')
AddEventHandler('requestPlayerData', function()
    local playerId = source
    local identifier = GetPlayerIdentifierByType(playerId, 'license')
	local defaultMoney = 0
	
	local newPlayerDefaults = {
		identifier = GetPlayerIdentifierByType(playerId, 'license'),
		bank = 0,
		cash = 0,
		inventory = {},
		weapons = {},
		cars = {},
		properties = {}
	}

    local response = MySQL.query.await('SELECT * FROM players WHERE identifier = ?', { identifier })

    if response and #response > 0 then
        local results = response[1] -- Assuming you only want the first result if there are multiple
        TriggerClientEvent('chat:addMessage', playerId, {
            args = { "Welcome back: " .. results.identifier .. "!" }
        })
		
		local weaponsData = json.decode(results.weapons)
		results.weapons = json.decode(results.weapons)
		results.inventory = json.decode(results.inventory)

        if type(weaponsData) == 'table' then
            for _, weapon in pairs(weaponsData) do
                GiveWeaponToPed(playerId, weapon.hash, 0, false, false)
            end
		elseif type(weaponsData) == 'nil' then
			print(playerId .. ' has no weapons')
        else
            print('Invalid weaponsData format:', weaponsData)
        end
		
		TriggerClientEvent('recievePlayerData', playerId, results)
    else
        -- Handle the case when no results are found
        MySQL.insert.await('INSERT INTO players (identifier, bank, cash) VALUES (?, ?, ?)', {
			identifier,
			defaultMoney,
			defaultMoney
		})
		
		TriggerClientEvent('recievePlayerData', playerId, newPlayerDefaults)
    end
end)

RegisterNetEvent('recieveUpdateFromClient')
AddEventHandler('recieveUpdateFromClient', function(dataToSend)
	local playerId = source
    local identifier = GetPlayerIdentifierByType(playerId, 'license')
	
	MySQL.update('UPDATE players SET inventory = ? WHERE identifier = ?', {
		json.encode(dataToSend.inventory), identifier
	})
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		TriggerClientEvent('sendPlayerUpdateToServer', -1)
	end
end)