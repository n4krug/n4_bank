local hasAlreadyEnteredMarker, isInATMMarker, menuIsShowed = false, false, false
local hasAlreadyEnteredBankMarker, isInBankMarker, bankMenuIsShowed = false, false, false

Script = GetCurrentResourceName()

local display = false
RegisterNUICallback('update', function()
	SetDisplay(true)
end)


RegisterNetEvent(Script .. ':showAtm')
AddEventHandler(Script .. ':showAtm', function()
	if Config.UseBankID then
		TriggerEvent(Config.BankIDPhone .. ':BankID', 'atm')
		SetLoginDisplay(true)
	else
		SetAtmDisplay(true)
	end
end)

RegisterNetEvent(Script .. ':showBank')
AddEventHandler(Script .. ':showBank', function()
	if Config.UseBankID then

		TriggerEvent(Config.BankIDPhone .. ':BankID', 'bank')
		SetLoginDisplay(true)
	else
		SetDisplay(true)
	end
end)

RegisterNUICallback("addAccount", function(args)

	TriggerServerEvent(Script .. ':addAccount', args)
	SendNUI('ui', true)
	-- ESX.TriggerServerCallback('GetPlayer', function(data)
	-- 	ESX.TriggerServerCallback(Script .. ':getAccounts', function(accounts)
	-- 		SendNUIMessage({
	-- 			Script = Script,
	-- 			type = "ui",
	-- 			status = true,
	-- 			player = {
	-- 				money = data.character.cash,
	-- 				accounts = table.remove(accounts, 1),
	-- 				identifier = data.character.personalnumber
	-- 			}
	-- 		})
	-- 	end)
	-- end)
end)


RegisterNUICallback("transfer", function(args, cb)
	TriggerServerEvent(Script .. ':transfer', args)
	SendNUI('ui', true)
	-- ESX.TriggerServerCallback('GetPlayer', function(data)
	-- 	ESX.TriggerServerCallback(Script .. ':getAccounts', function(accounts)
	-- 		SendNUIMessage({
	-- 			Script = Script,
	-- 			type = "ui",
	-- 			status = true,
	-- 			player = {
	-- 				money = data.character.cash,
	-- 				accounts = table.remove(accounts, 1),
	-- 				identifier = data.character.personalnumber
	-- 			}
	-- 		})
	-- 	end)
	-- end)
end)

RegisterNUICallback("removeAccount", function(args, cb)

	ESX.TriggerServerCallback('va:getAccountData', function(account)
		if account.money == 0 then
			TriggerServerEvent("va:removeAccount", args.account)
		end
	end, args.account)

end)

RegisterNUICallback('removeOwner', function(args, cb)
	ESX.TriggerServerCallback('va:getAccountData', function(account)
		TriggerServerEvent(Script .. ':removeAccountOwner', args, account)
	end, args.account)
	Citizen.Wait(100)
	cb({
		ok = true
	})
end)

RegisterNUICallback('getAccountMoney', function(args, cb)
	ESX.TriggerServerCallback(Script .. ':getAccounts', function(data)
		local cash = data[1].money
		local bank = data[2].money

		cb({ ["cash"] = cash, ["bank"] = bank })
	end)
end)

RegisterNUICallback('getAccounts', function(args, cb)
	ESX.TriggerServerCallback(Script .. ':getAccounts', function(accounts)
		cb(accounts)
	end)
end)

-- Stänger nui
RegisterNUICallback("exit", function(data)
	SetDisplay(false)
	SetAtmDisplay(false)
	bankMenuIsShowed = false
	menuIsShowed = false
end)

function SetDisplay(bool)
	display = bool
	SetNuiFocus(bool, bool)
	-- ESX.TriggerServerCallback('GetPlayer', function(data)
	SendNUI('ui', bool)
	-- ESX.TriggerServerCallback(Script .. ':getAccounts', function(accounts)
	-- 	SendNUIMessage({
	-- 		Script = Script,
	-- 		type = "ui",
	-- 		status = bool,
	-- 		player = {
	-- 			money = accounts[1].money,
	-- 			accounts = table.remove(accounts, 1),
	-- 			identifier = FWFuncs.CL.GetIdentifier()
	-- 		}
	-- 	})
	-- end)
	-- end)
end

function SetAtmDisplay(bool)
	display = bool
	SetNuiFocus(bool, bool)
	SendNUI('atm-ui', bool)
	-- ESX.TriggerServerCallback(Script .. ':getAccounts', function(accounts)
	-- 	SendNUIMessage({
	-- 		Script = Script,
	-- 		type = "atm-ui",
	-- 		status = bool,
	-- 		player = {
	-- 			money = accounts[1].money,
	-- 			accounts = table.remove(accounts, 1),
	-- 			identifier = FWFuncs.CL.GetIdentifier()
	-- 		}
	-- 	})
	-- end)
end

function SetLoginDisplay(bool)
	display = bool
	SetNuiFocus(bool, bool)
	SendNUI('BankIDLogin', bool)
	-- ESX.TriggerServerCallback(Script .. ':getAccounts', function(accounts)
	-- 	SendNUIMessage({
	-- 		Script = Script,
	-- 		type = "BankIDLogin",
	-- 		status = bool,
	-- 		player = {
	-- 			money = accounts[1].money,
	-- 			accounts = table.remove(accounts, 1),
	-- 			identifier = FWFuncs.CL.GetIdentifier()
	-- 		}
	-- 	})
	-- end)
end

Citizen.CreateThread(function()
	while display do
		Citizen.Wait(0)
		DisableControlAction(0, 1, display) -- LookLeftRight
		DisableControlAction(0, 2, display) -- LookUpDown
		DisableControlAction(0, 142, display) -- MeleeAttackAlternate
		DisableControlAction(0, 18, display) -- Enter
		DisableControlAction(0, 322, display) -- ESC
		DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
	end
end)

RegisterNUICallback('getTransactions', function(data, cb)
	ESX.TriggerServerCallback(Script .. ':getTransactions', cb, data.account)
end)

RegisterNUICallback('deposit', function(data, cb)
	TriggerServerEvent(Script .. ':deposit', data.amount, function() end)
	SendNUI('ui', true)
	-- ESX.TriggerServerCallback(Script .. ':getAccounts', function(accounts)
	-- 	SendNUIMessage({
	-- 		Script = Script,
	-- 		type = "ui",
	-- 		status = true,
	-- 		player = {
	-- 			money = accounts[1].money,
	-- 			accounts = table.remove(accounts, 1),
	-- 			identifier = FWFuncs.CL.GetIdentifier()
	-- 		}
	-- 	})
	-- end)
end)

RegisterNUICallback('withdraw', function(data, cb)
	TriggerServerEvent(Script .. ':withdraw', data.amount, function() end)
	SendNUI('ui', true)
	-- ESX.TriggerServerCallback(Script .. ':getAccounts', function(accounts)
	-- 	SendNUIMessage({
	-- 		Script = Script,
	-- 		type = "ui",
	-- 		status = true,
	-- 		player = {
	-- 			money = accounts[1].money,
	-- 			accounts = table.remove(accounts, 1),
	-- 			identifier = FWFuncs.CL.GetIdentifier()
	-- 		}
	-- 	})
	-- end)
end)

RegisterNUICallback('atmDeposit', function(data, cb)
	TriggerServerEvent(Script .. ':deposit', data.amount, function() end)
	SendNUI('atm-ui', true)
	-- ESX.TriggerServerCallback(Script .. ':getAccounts', function(accounts)
	-- 	SendNUIMessage({
	-- 		Script = Script,
	-- 		type = "atm-ui",
	-- 		status = true,
	-- 		player = {
	-- 			money = accounts[1].money,
	-- 			accounts = table.remove(accounts, 1),
	-- 			identifier = FWFuncs.CL.GetIdentifier()
	-- 		}
	-- 	})
	-- end)
end)

RegisterNUICallback('atmWithdraw', function(data, cb)
	TriggerServerEvent(Script .. ':withdraw', data.amount, function() end)
	SendNUI('atm-ui', true)
	-- ESX.TriggerServerCallback(Script .. ':getAccounts', function(accounts)

	-- 	SendNUIMessage({
	-- 		Script = Script,
	-- 		type = "atm-ui",
	-- 		status = true,
	-- 		player = {
	-- 			money = accounts[1].money,
	-- 			accounts = table.remove(accounts, 1),
	-- 			identifier = FWFuncs.CL.GetIdentifier()
	-- 		}
	-- 	})
	-- end)
end)

RegisterNUICallback('addOwner', function(data, cb)
	ESX.TriggerServerCallback('va:getUserFromPersonNummer', function(user)
		print(dump(user[1].identifier))

		local account = data.account
		print(dump(account))

		local s = string.gsub(account.owners, "%[", "")
		s = string.gsub(s, '%]', "")
		s = string.gsub(s, '"', "")
		s = Split(s, ",")

		if not HasValue(s, user[1].identifier) then
			table.insert(s, user[1].identifier)
		end

		local ownersString = '['
		for i = 1, #s do
			ownersString = ownersString .. '"' .. s[i] .. '"' .. ','
		end

		if ownersString:sub(#ownersString) == "," then
			ownersString = ownersString:sub(1, -2)
		end
		ownersString = ownersString .. ']'

		account.owners = ownersString

		print(dump(account))
		TriggerServerEvent("va:updateAccountData", account)
	end, data.pnummer)
end)

RegisterNUICallback('bankLoginSucces', function()
	SetDisplay(true)
end)

RegisterNUICallback('atmLoginSucces', function()
	SetAtmDisplay(true)
end)

-- * ATM scripts * --

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	if Config.UseOxTarget then
		FWFuncs.CL.AddTargetModel(Config.ATMModels, {
			{
				name = 'atm:option1',
				event = Script .. ':showAtm',
				icon = 'fa-solid fa-credit-card',
				label = 'Öppna ATM',
				canInteract = function(entity, distance, coords, name, bone)
					return distance < Config.ATMRange
				end
			}
		}) 

		for i = 1, #Config.BankEyes do
			FWFuncs.CL.AddBoxZone(Config.BankEyes[i].coords, vector3(0.45, 1.2, 0.4), Config.BankEyes[i].heading + 90.0, false, {
				{
					name = ("openBank-%s"):format(i),
					event = Script .. ':showBank',
					icon = 'fa-solid fa-credit-card',
					label = 'Öppna Bank',
					canInteract = function(entity, distance, coords, name)
						return distance < Config.BankRange
					end
				}
			})
		end

	end
end)


-- Activate menu when player is inside marker
CreateThread(function()
	while true do
		local coords = GetEntityCoords(PlayerPedId())
		local Sleep = 1500

		if not Config.UseOxTarget then
			isInBankMarker = false
			isInATMMarker = false

			for k, v in pairs(Config.ATMLocations) do
				-- print(dump(v))
				local Pos = vector3(v.x, v.y, v.z)
				if #(coords - Pos) < Config.ATMRange then
					Sleep = 0
					isInATMMarker, canSleep = true, false
					break
				end
			end


			if isInATMMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				canSleep = false
			end

			if not isInATMMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				SetNuiFocus(false)
				menuIsShowed = false
				canSleep = false

				SendNUIMessage({
					hideAll = true
				})
			end

			for k, v in pairs(Config.BankLocations) do
				local Pos = vector3(v.x, v.y, v.z)
				if #(coords - Pos) < Config.BankRange then
					Sleep = 0
					isInBankMarker, canSleep = true, false
					break
				end
			end

			if isInBankMarker and not hasAlreadyEnteredBankMarker then
				hasAlreadyEnteredBankMarker = true
				canSleep = false
			end

			if not isInBankMarker and hasAlreadyEnteredBankMarker then
				hasAlreadyEnteredBankMarker = false
				SetNuiFocus(false)
				bankMenuIsShowed = false
				canSleep = false

				SendNUIMessage({
					hideAll = true
				})
			end
		end

		Wait(Sleep)
	end
end)

-- Menu interactions
CreateThread(function()
	while true do
		local Sleep = 1500

		if isInATMMarker and not menuIsShowed then
			Sleep = 0
			-- ESX.ShowHelpNotification('Press E to use ATM')
			ESX.ShowHelpNotification("Tryck ~INPUT_PICKUP~ för att ta ut eller sätta in pengar i ~g~ATM~s~")

			if IsControlJustReleased(0, 38) and IsPedOnFoot(PlayerPedId()) then
				menuIsShowed = true
				-- SetAtmDisplay(true)
				TriggerEvent(Config.BankIDPhone .. ':BankID', 'atm')
				SetLoginDisplay(true)
			end
		end

		if isInBankMarker and not bankMenuIsShowed then
			Sleep = 0
			-- ESX.ShowHelpNotification('Press E to use ATM')
			ESX.ShowHelpNotification("Tryck ~INPUT_PICKUP~ för att öppna ~g~Bank~s~")

			if IsControlJustReleased(0, 38) and IsPedOnFoot(PlayerPedId()) then
				bankMenuIsShowed = true
				-- SetDisplay(true)
				TriggerEvent(Config.BankIDPhone .. ':BankID', 'bank')
				SetLoginDisplay(true)
			end
		end
		Wait(Sleep)
	end
end)

-- Create blips
CreateThread(function()
	if Config.EnableATMBlips then
		for k, ATMLocation in pairs(Config.ATMLocations) do
			local blip = AddBlipForCoord(ATMLocation.x, ATMLocation.y, ATMLocation.z - Config.ZDiff)
			SetBlipSprite(blip, Config.ATMBlipSprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, Config.ATMBlipScale)
			SetBlipColour(blip, Config.ATMBlipColor)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName("ATM")
			EndTextCommandSetBlipName(blip)

			Config.ATMLocations[k].blip = blip
		end
	end

	if Config.EnableBankBlips then
		for k, BankLocation in pairs(Config.BankLocations) do
			local blip = AddBlipForCoord(BankLocation.x, BankLocation.y, BankLocation.z - Config.ZDiff)
			SetBlipSprite(blip, Config.BankBlipSprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.9)
			SetBlipColour(blip, Config.BankBlipColor)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName("Bank")
			EndTextCommandSetBlipName(blip)

			Config.BankLocations[k].blip = blip
		end
	end
end)

RegisterNetEvent('SetBlipsVisible', function (blips)
	for _, location in pairs(Config.ATMLocations) do
		SetBlipDisplay(location.blip, blips['atm'] and 4 or 0)
	end
	for _, location in pairs(Config.BankLocations) do
		SetBlipDisplay(location.blip, blips['bank'] and 4 or 0)
	end

end)

function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k, v in pairs(o) do
			if type(k) ~= 'number' then k = '"' .. k .. '"' end
			s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

function HasValue(tab, val)
	for i = 1, #tab do
		if tab[i] == val then
			return true
		end
	end

	return false
end

function Split(s, delimiter)
	local result = {};
	for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match);
	end
	return result;
end

function SendNUI(type, status)
	ESX.TriggerServerCallback(Script .. ':getAccounts', function(accounts)

		local cash = table.remove(accounts, 1).money
		SendNUIMessage({
			Script = Script,
			type = type,
			status = status,
			player = {
				money = cash,
				accounts = accounts,
				identifier = FWFuncs.CL.GetIdentifier()
			}
		})
	end)
end
