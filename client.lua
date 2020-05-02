local isHandcuffed, isHandcuffed2, isHandcuffed3 = false, false, false
local PlayerData, dragStatus, currentTask = {}, {}, {}
dragStatus.isDragged = false
local hasAlreadyEnteredMarker, lastZone
local currentZone = nil
local active = false
local LeoPrompt

function SetupLeoPrompt()
    Citizen.CreateThread(function()
        local str = 'Open Menu'
        LeoPrompt = PromptRegisterBegin()
        PromptSetControlAction(LeoPrompt, 0xE8342FF2)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(LeoPrompt, str)
        PromptSetEnabled(LeoPrompt, false)
        PromptSetVisible(LeoPrompt, false)
        PromptSetHoldMode(LeoPrompt, true)
        PromptRegisterEnd(LeoPrompt)
    end)
end

RegisterNetEvent('redemrp_policejob:hasEnteredMarker')
AddEventHandler('redemrp_policejob:hasEnteredMarker', function(zone)
    currentZone     = zone
end)

AddEventHandler('redemrp_policejob:hasExitedMarker', function(zone)
    if active == true then
        PromptSetEnabled(LeoPrompt, false)
        PromptSetVisible(LeoPrompt, false)
        active = false
    end
	currentZone = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
		local isInMarker, letSleep, currentZone = false, true

        for k,v in ipairs(Config.Offices) do 
            local VectorCoords = vector3(coords)
            local ShopCoords = vector3(v.x, v.y, v.z)
            local distance = Vdist(ShopCoords, VectorCoords)
            if distance < 20.0 then
                Citizen.InvokeNative(0x2A32FAA57B937173, -1795314153, v.x, v.y, v.z-1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.75, 100, 50, 75, 75, false, true, 2, false, false, false, false)
				letSleep = false
                if distance < 1.5 then
					isInMarker  = true
					currentZone = v.name
					lastZone    = v.name
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
            hasAlreadyEnteredMarker = true
            TriggerServerEvent('redemrp_policejob:SVhasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('redemrp_policejob:hasExitedMarker', lastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end

	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if currentZone then
			if active == false then
                PromptSetEnabled(LeoPrompt, true)
                PromptSetVisible(LeoPrompt, true)
                active = true
            end
            if PromptHasHoldModeCompleted(LeoPrompt) then
                PromptSetEnabled(LeoPrompt, false)
                PromptSetVisible(LeoPrompt, false)
                active = false
                
                player = GetPlayerServerId()
                TriggerServerEvent("redemrp_policejob:openmenusv", player, function(cb) end)

				currentZone = nil
			end
        else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
    SetupLeoPrompt()
    while true do
        Citizen.Wait(0)       
        if IsControlJustPressed(2, 0x1F6D95E5) then
            player = GetPlayerServerId()
            TriggerServerEvent("redemrp_policejob:menusv", player, function(cb) end)
        end
    end
end)

Citizen.CreateThread(function()
    WarMenu.CreateMenu('leo', "Sheriff Office")
    WarMenu.CreateSubMenu('gun', 'leo', 'Guns')

    while true do
        if WarMenu.IsMenuOpened('leo') then
            if WarMenu.MenuButton('Guns', 'gun') then end
            WarMenu.Display()

        elseif WarMenu.IsMenuOpened('gun') then
            if WarMenu.Button("Rolling Block") then
                TriggerServerEvent("redemrp_policejob:givegun", "WEAPON_SNIPERRIFLE_ROLLINGBLOCK_EXOTIC")
            elseif WarMenu.Button("Pump Shotgun") then
                TriggerServerEvent("redemrp_policejob:givegun", "WEAPON_SHOTGUN_PUMP")
            elseif WarMenu.Button("Semi-auto Pistol") then
                TriggerServerEvent("redemrp_policejob:givegun", "WEAPON_PISTOL_SEMIAUTO")
            elseif WarMenu.Button("Lasso") then
                TriggerServerEvent("redemrp_policejob:givegun", "WEAPON_LASSO")
            elseif WarMenu.Button("Lantern") then
                TriggerServerEvent("redemrp_policejob:givegun", "WEAPON_MELEE_LANTERN_ELECTRIC")
            elseif WarMenu.Button("Knife") then
                TriggerServerEvent("redemrp_policejob:givegun", "WEAPON_MELEE_KNIFE")
            end
            WarMenu.Display()
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    WarMenu.CreateMenu('leomenu', "Sheriff Menu")
    while true do
        if WarMenu.IsMenuOpened('leomenu') then
            if WarMenu.Button('Soft Cuff') then
                local closestPlayer, closestDistance = GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('redemrp_policejob:handcuffsv2', GetPlayerServerId(closestPlayer))
                    WarMenu.CloseMenu()
                end
            elseif WarMenu.Button('Drag') then
                local closestPlayer, closestDistance = GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('redemrp_policejob:dragsv', GetPlayerServerId(closestPlayer))
                    WarMenu.CloseMenu()
                end
            elseif WarMenu.Button('Ankle Irons') then
                local closestPlayer, closestDistance = GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('redemrp_policejob:handcuffsv', GetPlayerServerId(closestPlayer))
                    WarMenu.CloseMenu()
                end
            elseif WarMenu.Button('Lock Hogtie') then
                local closestPlayer, closestDistance = GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
                    TriggerServerEvent('redemrp_policejob:hogtiesv', GetPlayerServerId(closestPlayer))
                    WarMenu.CloseMenu()
                end
            end
            WarMenu.Display()
        end
        Citizen.Wait(0)
    end
end)


Citizen.CreateThread(function()
	local playerPed
	local targetPed
	while true do
		Citizen.Wait(0)
		if isHandcuffed or isHandcuffed2 then
			playerPed = PlayerPedId()
			if dragStatus.isDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))
                AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				if IsPedDeadOrDying(targetPed, true) then
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end
			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if isHandcuffed or isHandcuffed2 or isHandcuffed3 then
			DisableControlAction(0, 0xB2F377E8, true) -- Attack
			DisableControlAction(0, 0xC1989F95, true) -- Attack 2
			DisableControlAction(0, 0x07CE1E61, true) -- Melee Attack 1
			DisableControlAction(0, 0xF84FA74F, true) -- MOUSE2
			DisableControlAction(0, 0xCEE12B50, true) -- MOUSE3
			DisableControlAction(0, 0x8FFC75D6, true) -- Shift
			DisableControlAction(0, 0xD9D0E1C0, true) -- SPACE
            DisableControlAction(0, 0xCEFD9220, true) -- E
            DisableControlAction(0, 0xF3830D8E, true) -- J
            DisableControlAction(0, 0x80F28E95, true) -- L
            DisableControlAction(0, 0xDB096B85, true) -- CTRL
            DisableControlAction(0, 0xE30CD707, true) -- R
		else
			Citizen.Wait(500)
		end
	end
end)

function GetClosestPlayer()
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
	local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false
    
    if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		usePlayerPed = true
		coords = GetEntityCoords(playerPed)
    end
    
	for i=1, #players, 1 do
        local tgt = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer = players[i]
				closestDistance = distance
			end
		end
	end
	return closestPlayer, closestDistance
end


RegisterNetEvent('redemrp_policejob:okleo')
AddEventHandler('redemrp_policejob:okleo', function() 
    WarMenu.OpenMenu('leo')
    WarMenu.Display()
end)

RegisterNetEvent('redemrp_policejob:okleomenu')
AddEventHandler('redemrp_policejob:okleomenu', function() 
    WarMenu.OpenMenu('leomenu')
    WarMenu.Display()
end)

RegisterNetEvent('redemrp_policejob:okgun')
AddEventHandler('redemrp_policejob:okgun', function(kek) 
    GiveWeaponToPed_2(PlayerPedId(), GetHashKey(kek), 500, false, true, 1, false, 0.5, 1.0, 1.0, true, 0, 0)
    local msg = "Weapon Recieved!"
    local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", msg, Citizen.ResultAsLong())
    Citizen.InvokeNative(0xFA233F8FE190514C, str)
    Citizen.InvokeNative(0xE9990552DEC71600)
end)


RegisterNetEvent('redemrp_policejob:handcuff')
AddEventHandler('redemrp_policejob:handcuff', function()
	isHandcuffed = not isHandcuffed
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if isHandcuffed then
			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed, true)
			DisplayRadar(false)
        elseif not isHandcuffed then
            if isHandcuffed2 then
                FreezeEntityPosition(playerPed, false)
            else
                ClearPedSecondaryTask(playerPed)
                SetEnableHandcuffs(playerPed, false)
                DisablePlayerFiring(playerPed, false)
                SetPedCanPlayGestureAnims(playerPed, true)
                FreezeEntityPosition(playerPed, false)
                DisplayRadar(true)
            end
		end
	end)
end)


RegisterNetEvent('redemrp_policejob:handcuff2')
AddEventHandler('redemrp_policejob:handcuff2', function()
	isHandcuffed2 = not isHandcuffed2
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if isHandcuffed2 then
			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			DisplayRadar(false)
        elseif not isHandcuffed2 then
            ClearPedSecondaryTask(playerPed)
            SetEnableHandcuffs(playerPed, false)
            DisablePlayerFiring(playerPed, false)
            SetPedCanPlayGestureAnims(playerPed, true)
            FreezeEntityPosition(playerPed, false)
            DisplayRadar(true)
            isHandcuffed = false
		end
	end)
end)

RegisterNetEvent('redemrp_policejob:hogtie')
AddEventHandler('redemrp_policejob:hogtie', function()
	isHandcuffed3 = not isHandcuffed3
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if isHandcuffed3 then
            TaskKnockedOutAndHogtied(playerPed, false, false)
			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			DisplayRadar(false)
        elseif not isHandcuffed3 then
            ClearPedTasksImmediately(playerPed, true, false)
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			DisplayRadar(true)
		end
	end)
end)

RegisterNetEvent('redemrp_policejob:drag')
AddEventHandler('redemrp_policejob:drag', function(copId)
	dragStatus.isDragged = not dragStatus.isDragged
    dragStatus.CopId = copId
end)
