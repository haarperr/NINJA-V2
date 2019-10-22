-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

function CreatePlayer(source, permission_level, money, bank, license, group)
	local self = {}

	self.source = source
	self.permission_level = permission_level
	self.money = money
	self.bank = bank
	self.license = license
	self.group = group
	self.coords = {x = 0.0, y = 0.0, z = 0.0}
	self.session = {}
	self.bankDisplayed = true
	self.moneyDisplayed = true

	-- FXServer <3
	ExecuteCommand('add_principal license.' .. self.license .. " group." .. self.group)

	local rTable = {}

	rTable.setMoney = function(m)
		if type(m) == "number" then
			local prevMoney = self.money
			local newMoney = m

			self.money = m

			if((prevMoney - newMoney) < 0)then
				TriggerClientEvent("es:addedMoney", self.source, math.abs(prevMoney - newMoney), (settings.defaultSettings.nativeMoneySystem == "1"))
			else
				TriggerClientEvent("es:removedMoney", self.source, math.abs(prevMoney - newMoney), (settings.defaultSettings.nativeMoneySystem == "1"))
			end

			if settings.defaultSettings.nativeMoneySystem == "0" then
				TriggerClientEvent('es:activateMoney', self.source , self.money)
			end
		end
	end
	
	rTable.getMoney = function()
		return self.money
	end

	rTable.setBankBalance = function(m)
		if type(m) == "number" then
			TriggerEvent("es:setPlayerData", self.source, "bank", m, function(response, success)
				self.bank = m
			end)
		else
			log('ES_ERROR: There seems to be an issue while setting bank, something else then a number was entered.')
			print('ES_ERROR: There seems to be an issue while setting bank, something else then a number was entered.')
		end
	end

	rTable.getBank = function()
		return self.bank
	end

	rTable.getCoords = function()
		return self.coords
	end

	rTable.setCoords = function(x, y, z)
		self.coords = {x = x, y = y, z = z}
	end

	rTable.kick = function(r)
		DropPlayer(self.source, r)
	end

	rTable.addMoney = function(m)
		if type(m) == "number" then
			local newMoney = self.money + m

			self.money = newMoney

			TriggerClientEvent("es:addedMoney", self.source, m, (settings.defaultSettings.nativeMoneySystem == "1"), self.money)
			if settings.defaultSettings.nativeMoneySystem == "0" then
				TriggerClientEvent('es:activateMoney', self.source , self.money)
			end
		else
			log('ES_ERROR: There seems to be an issue while adding money, a different type then number was trying to be added.')
			print('ES_ERROR: There seems to be an issue while adding money, a different type then number was trying to be added.')
		end
	end

	rTable.removeMoney = function(m)
		if type(m) == "number" then
			local newMoney = self.money - m

			self.money = newMoney

			TriggerClientEvent("es:removedMoney", self.source, m, (settings.defaultSettings.nativeMoneySystem == "1"), self.money)
			if settings.defaultSettings.nativeMoneySystem == "0" then
				TriggerClientEvent('es:activateMoney', self.source , self.money)
			end
		else
			log('ES_ERROR: There seems to be an issue while removing money, a different type then number was trying to be removed.')
			print('ES_ERROR: There seems to be an issue while removing money, a different type then number was trying to be removed.')
		end
	end

	rTable.addBank = function(m)
		if type(m) == "number" then
			local newBank = self.bank + m
			self.bank = newBank

			TriggerClientEvent("es:addedBank", self.source, m)
		else
			log('ES_ERROR: There seems to be an issue while adding to bank, a different type then number was trying to be added.')
			print('ES_ERROR: There seems to be an issue while adding to bank, a different type then number was trying to be added.')
		end
	end

	rTable.removeBank = function(m)
		if type(m) == "number" then
			local newBank = self.bank - m
			self.bank = newBank

			TriggerClientEvent("es:removedBank", self.source, m)
		else
			log('ES_ERROR: There seems to be an issue while removing from bank, a different type then number was trying to be removed.')
			print('ES_ERROR: There seems to be an issue while removing from bank, a different type then number was trying to be removed.')
		end
	end

	rTable.displayMoney = function(m)
		if type(m) == "number" then
			if not self.moneyDisplayed then
				if settings.defaultSettings.nativeMoneySystem ~= "0" then
					TriggerClientEvent("es:displayMoney", self.source, math.floor(m))
				else
					TriggerClientEvent('es:activateMoney', self.source , self.money)
				end
				
				self.moneyDisplayed = true
			end
		else
			log('ES_ERROR: There seems to be an issue while displaying money, a different type then number was trying to be shown.')
			print('ES_ERROR: There seems to be an issue while displaying money, a different type then number was trying to be shown.')
		end
	end

	rTable.displayBank = function(m)
		if type(m) == "number" then	
			if not self.bankDisplayed then
				TriggerClientEvent("es:displayBank", self.source, math.floor(m))
				self.bankDisplayed = true
			end
		else
			log('ES_ERROR: There seems to be an issue while displaying bank, a different type then number was trying to be shown.')
			print('ES_ERROR: There seems to be an issue while displaying bank, a different type then number was trying to be shown.')
		end
	end

	rTable.setSessionVar = function(key, value)
		self.session[key] = value
	end

	rTable.getSessionVar = function(k)
		return self.session[k]
	end

	rTable.getPermissions = function()
		return self.permission_level
	end

	rTable.setPermissions = function(p)
		if type(p) == "number" then
			self.permission_level = p
		else
			log('ES_ERROR: There seems to be an issue while setting permissions, a different type then number was set.')
			print('ES_ERROR: There seems to be an issue while setting permissions, a different type then number was set.')
		end
	end

	rTable.getIdentifier = function(i)
		return self.license
	end

	rTable.getGroup = function()
		return self.group
	end

	rTable.set = function(k, v)
		self[k] = v
	end

	rTable.get = function(k)
		return self[k]
	end

	rTable.setGlobal = function(g, default)
		self[g] = default or ""

		rTable["get" .. g:gsub("^%l", string.upper)] = function()
			return self[g]
		end

		rTable["set" .. g:gsub("^%l", string.upper)] = function(e)
			self[g] = e
		end

		Users[self.source] = rTable
	end

	return rTable
end