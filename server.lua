Script = GetCurrentResourceName()

RegisterServerEvent(Script .. ':deposit')
AddEventHandler(Script .. ':deposit', function(amount, Callback)

	local Player = ESX.GetPlayerFromId(source);

	amount = tonumber(amount)

	if Player.getMoney() >= amount then
		Player.removeMoney(amount);
		FWFuncs.SV.AddBank(source, amount);

		Callback(true)
	else
		Callback(false)
	end
end)

RegisterServerEvent(Script .. ':withdraw')
AddEventHandler(Script .. ':withdraw', function(amount, Callback)

	local Player = ESX.GetPlayerFromId(source);

	amount = tonumber(amount)

	if FWFuncs.SV.GetBank(source) >= amount then
		FWFuncs.SV.RemoveBank(source, amount);
		Player.addMoney(amount);

		Callback(true)
	else
		Callback(false)
	end
end)

-- RegisterServerEvent(Script .. ':addAccount')
-- AddEventHandler(Script .. ':addAccount', function(args)
-- 	-- print("server: " .. dump(args))
-- 	local source = source
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	GetExtraAccounts({ [1] = {
-- 		name = 'bank',
-- 		money = FWFuncs.SV.GetBank(source),
-- 		label = 'Bank',
-- 		owners = { tostring(FWFuncs.SV.GetIdentifier(source)) }
-- 	} }, FWFuncs.SV.GetIdentifier(source), function(accounts)


-- 		local name = "u-" .. args.name .. "-" .. FWFuncs.SV.GetIdentifier(source)


-- 		for i = 1, #accounts do
-- 			if accounts[i].name == name then
-- 				xPlayer.showNotification('Kontot finns redan. Använd ett annat namn!')
-- 				return
-- 			end
-- 		end

-- 		local owners = '["' .. FWFuncs.SV.GetIdentifier(source) .. '"]'
-- 		print(owners)

-- 		MySQL.Async.execute("INSERT INTO user_accounts (`name`, `label`, `money`, `owners`) VALUES (@name, @label, 0, @owners)"
-- 			, {
-- 				['name'] = name,
-- 				['label'] = args.label,
-- 				['owners'] = owners
-- 			}, function(affectedRows)
-- 			if affectedRows == 1 then
-- 				print(('[^2INFO^7] Saved player ^5"%s^7"'):format(xPlayer.name))
-- 			end
-- 		end)
-- 	end)
-- end)

RegisterServerEvent(Script .. ':transfer')
AddEventHandler(Script .. ':transfer', function(args)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	GetExtraAccounts({ [1] = {
		name = 'bank',
		money = FWFuncs.SV.GetBank(source),
		label = 'Bank',
		owners = { tostring(FWFuncs.SV.GetIdentifier(source)) }
	} }, FWFuncs.SV.GetIdentifier(source), function(accounts)


		local bank = {}
		local from = {}
		local target = {}
		for i = 1, #accounts do
			if accounts[i].name == "bank" then
				bank = accounts[i]
			end
			if accounts[i].name == args.target then
				target = accounts[i]
			end
			if accounts[i].name == args.from then
				from = accounts[i]
			end
		end

		if (args.from == "bank" and tonumber(args.amount) <= tonumber(bank.money)) then
			xPlayer.removeBank(tonumber(args.amount))
			AddMoneyToAccount(args.target, tonumber(args.amount))
			TriggerEvent(Script .. ':addTransaction', FWFuncs.SV.GetIdentifier(source), args.target, "Bank -> " .. target.label,
				args.amount)
		elseif (tonumber(args.amount) <= tonumber(from.money)) then
			RemoveMoneyFromAccount(args.from, tonumber(args.amount))
			if (args.target == "bank") then
				xPlayer.addBank(tonumber(args.amount))
				TriggerEvent(Script .. ':addTransaction', args.from, FWFuncs.SV.GetIdentifier(source), from.label .. " -> Bank",
					args.amount)
			else
				AddMoneyToAccount(args.target, args.amount)
				TriggerEvent(Script .. ':addTransaction', args.from, args.target, from.label .. " -> " .. target.label, args.amount)
			end
		end
	end)

end)

ESX.RegisterServerCallback(Script .. ':getAccounts', function(playerId, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	GetExtraAccounts({ 
		[1] = {
			name = 'money',
			money = FWFuncs.SV.GetMoney(playerId),
			label = 'Money',
			owners = { tostring(FWFuncs.SV.GetIdentifier(playerId)) }
		},
		[2] = {
			name = 'bank',
			money = FWFuncs.SV.GetBank(playerId),
			label = 'Bank',
			owners = { tostring(FWFuncs.SV.GetIdentifier(playerId)) }
		}
	}, FWFuncs.SV.GetIdentifier(playerId), function(accounts)
		cb(accounts)
	end)


end)

RegisterServerEvent(Script .. ':removeAccountOwner')
AddEventHandler(Script .. ':removeAccountOwner', function(args, account)

	local s = string.gsub(account.owners, "%[", "")
	s = string.gsub(s, '%]', "")
	s = string.gsub(s, '"', "")
	s = Split(s, ",")

	local owners = {}
	for i = 1, #s do
		if s[i] ~= args.identifier then
			table.insert(owners, s[i])
		end
	end



	local ownersString = '['
	for i = 1, #owners do
		ownersString = ownersString .. '"' .. owners[i] .. '"' .. ','
	end

	if ownersString:sub(#ownersString) == "," then
		ownersString = ownersString:sub(1, -2)
	end
	ownersString = ownersString .. ']'

	account.owners = ownersString

	TriggerEvent('va:updateAccountData', account)
end)


-- * Kolla detta!!!!
-- RegisterServerEvent(Script .. ':addBankMoney')
-- AddEventHandler(Script .. ':addBankMoney', function(personalnumber, amount)

-- 	local xPlayer = ESX.GetPlayerFromPersonalNumber(personalnumber)

-- 	if xPlayer then
-- 		xPlayer.addBank(amount)
-- 	else
-- 		MySQL.Async.fetchAll('SELECT * FROM `characters` WHERE `personalnumber` = @personalnumber', {
-- 			personalnumber = personalnumber,
-- 		}, function(player)
-- 			local bank = player[1].bank + amount

-- 			-- bank = bank + amount

-- 			MySQL.Async.execute('UPDATE `characters` SET `bank` = @bank WHERE `personalnumber` = @personalnumber', {
-- 				bank = bank,
-- 				personalnumber = personalnumber,
-- 			})
-- 		end)
-- 	end
-- end)

-- RegisterServerEvent(Script .. ':addTransaction')
-- AddEventHandler(Script .. ':addTransaction', function(from, to, description, amount)
-- 	MySQL.Async.execute('INSERT INTO `transactions` (`from`, `to`, `description`, `amount`) VALUES (@from, @to, @description, @amount)'
-- 		,
-- 		{
-- 			['from'] = from,
-- 			['to'] = to,
-- 			['description'] = description,
-- 			['amount'] = amount
-- 		})
-- end)

-- ESX.RegisterServerCallback(Script .. ':getTransactions', function(source, cb, account)

-- 	local xPlayer = ESX.GetPlayerFromId(source)

-- 	if account == 'bank' then
-- 		account = xPlayer.character.personalnumber
-- 	end

-- 	MySQL.Async.fetchAll('SELECT * FROM `transactions` WHERE `from`=@from OR `to`=@to ORDER BY `time` DESC',
-- 		{
-- 			['from'] = account,
-- 			['to'] = account
-- 		}, function(transactions)


-- 		for k, v in pairs(transactions) do
-- 			if v.from == account then
-- 				transactions[k].amount = -transactions[k].amount
-- 			end
-- 		end

-- 		cb(transactions)
-- 	end)
-- end)

function GetExtraAccounts(accountsBase, identifier, cb)
	cb(accountsBase)
end

-- 	MySQL.Async.fetchAll("SELECT * FROM user_accounts", {}, function(extraAccounts)
-- 		print(dump(accountsBase))


-- 		for i = 1, #extraAccounts do
-- 			local s = string.gsub(extraAccounts[i].owners, "%[", "")
-- 			s = string.gsub(s, '%]', "")
-- 			s = string.gsub(s, '"', "")
-- 			s = Split(s, ",")

-- 			-- local s = extraAccounts[i].owners
-- 			if (HasValue(s, identifier)) then
-- 				accountsBase[#accountsBase + 1] = {
-- 					name = extraAccounts[i].name,
-- 					money = extraAccounts[i].money,
-- 					label = extraAccounts[i].label,
-- 					owners = extraAccounts[i].owners
-- 				}
-- 			end
-- 		end
-- 		cb(accountsBase)
-- 	end)
-- end

-- function AddMoneyToAccount(accountName, amount)
-- 	MySQL.Async.fetchAll('SELECT * FROM `valeria`.`user_accounts` WHERE name = @accountName', {
-- 		['@accountName'] = accountName
-- 	}, function(account)

-- 		MySQL.Async.execute('UPDATE `valeria`.`user_accounts` SET `money`=@money WHERE  `name`=@name', {
-- 			['money'] = account[1].money + amount,
-- 			['name'] = accountName
-- 		}, function(affectedRows)
-- 			if affectedRows == 1 then
-- 				print(('[^2INFO^7] Saved player ^5"%s^7"'):format(xPlayer.name))
-- 			end
-- 		end)
-- 	end)
-- end

-- function RemoveMoneyFromAccount(accountName, amount)
-- 	MySQL.Async.fetchAll('SELECT * FROM `valeria`.`user_accounts` WHERE name = @accountName', {
-- 		['@accountName'] = accountName
-- 	}, function(account)

-- 		MySQL.Async.execute('UPDATE `valeria`.`user_accounts` SET `money`=@money WHERE  `name`=@name', {
-- 			['money'] = account[1].money - amount,
-- 			['name'] = accountName
-- 		}, function(affectedRows)
-- 			if affectedRows == 1 then
-- 				print(('[^2INFO^7] Saved player ^5"%s^7"'):format(xPlayer.name))
-- 			end
-- 		end)
-- 	end)
-- end

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
	result = {};
	for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
		table.insert(result, match);
	end
	return result;
end
