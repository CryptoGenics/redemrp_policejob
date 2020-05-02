RegisterServerEvent('redemrp_policejob:givegun')
AddEventHandler("redemrp_policejob:givegun", function(weapon)
  TriggerClientEvent('redemrp_policejob:okgun', source, weapon)
end)

RegisterServerEvent("redemrp_policejob:SVhasEnteredMarker")
AddEventHandler("redemrp_policejob:SVhasEnteredMarker", function(currentZone)
    local _src = source
    TriggerEvent('redemrp:getPlayerFromId', _src, function(user)
        if user.getJob() == 'police' then
            TriggerClientEvent('redemrp_policejob:hasEnteredMarker', _src, currentZone)
        end
    end)
end)

RegisterServerEvent('redemrp_policejob:openmenusv')
AddEventHandler('redemrp_policejob:openmenusv', function(source, cb)
    local _source = tonumber(source)
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		if user.getJob() == "police" then
			TriggerClientEvent('redemrp_policejob:okleo', _source)
		else
			TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Your are not LEO!^0")
		end
	end)
end)

RegisterServerEvent('redemrp_policejob:menusv')
AddEventHandler('redemrp_policejob:menusv', function(source, cb)
    local _source = tonumber(source)
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		if user.getJob() == "police" then
			TriggerClientEvent('redemrp_policejob:okleomenu', _source)
		end
	end)
end)

RegisterServerEvent('redemrp_policejob:handcuffsv')
AddEventHandler('redemrp_policejob:handcuffsv', function(target)
    local _source = tonumber(source)
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		if user.getJob() == "police" then
			TriggerClientEvent('redemrp_policejob:handcuff', target)
		else
			print(('redemrp_policejob: %s attempted to handcuff a player (is not police)!'):format(GetPlayerName(_source)))
		end
	end)
end)

RegisterServerEvent('redemrp_policejob:handcuffsv2')
AddEventHandler('redemrp_policejob:handcuffsv2', function(target)
    local _source = tonumber(source)
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		if user.getJob() == "police" then
			TriggerClientEvent('redemrp_policejob:handcuff2', target)
		else
			print(('redemrp_policejob: %s attempted to handcuff a player (is not police)!'):format(GetPlayerName(_source)))
		end
	end)
end)

RegisterServerEvent('redemrp_policejob:hogtiesv')
AddEventHandler('redemrp_policejob:hogtiesv', function(target)
    local _source = tonumber(source)
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		if user.getJob() == "police" then
			TriggerClientEvent('redemrp_policejob:hogtie', target)
		else
			print(('redemrp_policejob: %s attempted to handcuff a player (is not police)!'):format(GetPlayerName(_source)))
		end
	end)
end)

RegisterServerEvent('redemrp_policejob:dragsv')
AddEventHandler('redemrp_policejob:dragsv', function(target)
    local _source = tonumber(source)
    TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		if user.getJob() == "police" then
			TriggerClientEvent('redemrp_policejob:drag', target, source)
		else
			print(('redemrp_policejob: %s attempted to drag a player (is not police)!'):format(GetPlayerName(_source)))
		end
	end)
end)
