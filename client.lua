--[[
──────────────────────────────────────────────────────────────

	SEM_InteractionMenu (client.lua) - Created by Scott M
	Current Version: v1.7.1 (Sep 2021)
	
	Support: https://semdevelopment.com/discord
	
		!!! Change vaules in the 'config.lua' !!!
	DO NOT EDIT THIS IF YOU DON'T KNOW WHAT YOU ARE DOING

──────────────────────────────────────────────────────────────
]]



--Cuffing Event
local isCuffed = false
local amount = false
RegisterNetEvent('SEM_InteractionMenu:Cuff')
AddEventHandler('SEM_InteractionMenu:Cuff', function()
    local Ped = PlayerPedId()
    if (DoesEntityExist(Ped)) then
        Citizen.CreateThread(function()
            RequestAnimDict('mp_arrest_paired')           
            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
                Citizen.Wait(0)
            end

            if isCuffed then
                isCuffed = false
                Citizen.Wait(500)
                SetEnableHandcuffs(Ped, false)
                ClearPedTasksImmediately(Ped)
            else
                isCuffed = true
                SetEnableHandcuffs(Ped, true)
                TaskPlayAnim(Ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
        end)
    end
end)

--Cuff Animation & Restructions
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if isCuffed then
            if not IsEntityPlayingAnim(GetPlayerPed(PlayerId()), 'mp_arresting', 'idle', 3) then
                TaskPlayAnim(GetPlayerPed(PlayerId()), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            end

            SetCurrentPedWeapon(PlayerPedId(), 'weapon_unarmed', true)
            
            if not Config.VehEnterCuffed then
                DisableControlAction(1, 23, true) --F | Enter Vehicle
                DisableControlAction(1, 75, true) --F | Exit Vehicle
            end
            DisableControlAction(1, 140, true) --R
            DisableControlAction(1, 141, true) --Q
            DisableControlAction(1, 142, true) --LMB
            SetPedPathCanUseLadders(GetPlayerPed(PlayerId()), false)
            if IsPedInAnyVehicle(GetPlayerPed(PlayerId()), false) then
                DisableControlAction(0, 59, true) --Vehicle Driving
            end
        end
    end
end)



--Dragging Event
local Drag = false
local OfficerDrag = -1
RegisterNetEvent('SEM_InteractionMenu:Drag')
AddEventHandler('SEM_InteractionMenu:Drag', function(ID)
	Drag = not Drag
	OfficerDrag = ID
	
	if not Drag then
        DetachEntity(PlayerPedId(), true, false)
	end
end)

--Drag Attachment
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if Drag then
            local Ped = GetPlayerPed(GetPlayerFromServerId(OfficerDrag))
            local Ped2 = PlayerPedId()
            AttachEntityToEntity(Ped2, Ped, 4103, 0.35, 0.38, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            DisableControlAction(1, 140, true) --R
			DisableControlAction(1, 141, true) --Q
			DisableControlAction(1, 142, true) --LMB
        end
    end
end)



--Force Seat Player Event
RegisterNetEvent('SEM_InteractionMenu:Seat')
AddEventHandler('SEM_InteractionMenu:Seat', function(Veh)
	local Pos = GetEntityCoords(PlayerPedId())
	local EntityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
    local RayHandle = CastRayPointToPoint(Pos.x, Pos.y, Pos.z, EntityWorld.x, EntityWorld.y, EntityWorld.z, 10, PlayerPedId(), 0)
    local _, _, _, _, VehicleHandle = GetRaycastResult(RayHandle)
    if VehicleHandle ~= nil then
		SetPedIntoVehicle(PlayerPedId(), VehicleHandle, 1)
	end
end)



--Force Unseat Player Event
RegisterNetEvent('SEM_InteractionMenu:Unseat')
AddEventHandler('SEM_InteractionMenu:Unseat', function(ID)
	local Ped = GetPlayerPed(ID)
	ClearPedTasksImmediately(Ped)
	PlayerPos = GetEntityCoords(PlayerPedId(),  true)
	local X = PlayerPos.x - 0
	local Y = PlayerPos.y - 0

    SetEntityCoords(PlayerPedId(), X, Y, PlayerPos.z)
end)



--Spike Strip Spawn Event
local SpawnedSpikes = {}
RegisterNetEvent('SEM_InteractionMenu:Spikes-SpawnSpikes')
AddEventHandler('SEM_InteractionMenu:Spikes-SpawnSpikes', function(Length)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        Notify('~r~You can\'t set spikes while in a vehicle!')
        return
    end

    local SpawnCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()) , 0.0, 2.0, 0.0)
    for a = 1, Length do
        local Spike = CreateObject(GetHashKey('P_ld_stinger_s'), SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, 1, 1, 1)
        local NetID = NetworkGetNetworkIdFromEntity(Spike)
        SetNetworkIdExistsOnAllMachines(NetID, true)
        SetNetworkIdCanMigrate(NetID, false)
        SetEntityHeading(Spike, GetEntityHeading(GetPlayerPed(PlayerId()) ))
        PlaceObjectOnGroundProperly(Spike)
        FreezeEntityPosition(Spike, true)
        SpawnCoords = GetOffsetFromEntityInWorldCoords(Spike, 0.0, 4.0, 0.0)
        table.insert(SpawnedSpikes, NetID)
    end
end)

--Spike Strip Delete Event
RegisterNetEvent('SEM_InteractionMenu:Spikes-DeleteSpikes')
AddEventHandler('SEM_InteractionMenu:Spikes-DeleteSpikes', function()
    for a = 1, #SpawnedSpikes do
        local Spike = NetworkGetEntityFromNetworkId(SpawnedSpikes[a])
        DeleteEntity(Spike)
    end
    Notify('~r~Spikes Strips Removed!')
    SpawnedSpikes = {}
end)

--Spike Strip Tire Popping
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(25)

        if IsPedInAnyVehicle(PlayerPedId() , false) then
            local Vehicle = GetVehiclePedIsIn(PlayerPedId() , false)

            if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId()  then
                local VehiclePos = GetEntityCoords(Vehicle, false)
                local Spike = GetClosestObjectOfType(VehiclePos.x, VehiclePos.y, VehiclePos.z, 2.0, GetHashKey('P_ld_stinger_s'), 1, 1, 1)

                if Spike ~= 0 then
                    local Tires = {
                        {bone = 'wheel_lf', index = 0},
                        {bone = 'wheel_rf', index = 1},
                        {bone = 'wheel_lm', index = 2},
                        {bone = 'wheel_rm', index = 3},
                        {bone = 'wheel_lr', index = 4},
                        {bone = 'wheel_rr', index = 5}
                    }
        
                    for a = 1, #Tires do
                        local TirePos = GetWorldPositionOfEntityBone(Vehicle, GetEntityBoneIndexByName(Vehicle, Tires[a].bone))
                        local Spike = GetClosestObjectOfType(TirePos.x, TirePos.y, TirePos.z, 2.0, GetHashKey('P_ld_stinger_s'), 1, 1, 1)
                        local SpikePos = GetEntityCoords(Spike, false)
                        local Distance = Vdist(TirePos.x, TirePos.y, TirePos.z, SpikePos.x, SpikePos.y, SpikePos.z)
            
                        if Distance < 1.8 then
                            if not IsVehicleTyreBurst(Vehicle, Tires[a].index, true) or IsVehicleTyreBurst(Vehicle, Tires[a].index, false) then
                                SetVehicleTyreBurst(Vehicle, Tires[a].index, false, 1000.0)
                            end
                        end
                    end
                end
            end
        end
    end
end)



--Backup
RegisterNetEvent('SEM_InteractionMenu:CallBackup')
AddEventHandler('SEM_InteractionMenu:CallBackup', function(Code, StreetName, Coords)
    if LEORestrict() then
        local BackupBlip = nil
        local BackupBlips = {}

        local function CreateBlip(x, y, z, Name, Sprite, Size, Colour)
            BackupBlip = AddBlipForCoord(x, y, z)
            SetBlipSprite(BackupBlip, Sprite)
            SetBlipDisplay(BackupBlip, 4)
            SetBlipScale(BackupBlip, Size)
            SetBlipColour(BackupBlip, Colour)
            SetBlipAsShortRange(BackupBlip, true)
        
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(Name)
            EndTextCommandSetBlipName(BackupBlip)
            table.insert(BackupBlips, BackupBlip)
            Citizen.Wait(Config.BackupBlipTimeout * 60000)
            for _, Blip in pairs(BackupBlips) do
                RemoveBlip(Blip)
            end
        end

        if Code == 1 then
            Notify('An officer is requesting ~g~Code 1 ~w~backup at ~b~' .. StreetName)
            CreateBlip(Coords.x, Coords.y, Coords.z, 'Code 1 Backup Requested', 56, 0.8, 2)
        elseif Code == 2 then
            Notify('An officer is requesting ~y~Code 2 ~w~backup at ~b~' .. StreetName)
            CreateBlip(Coords.x, Coords.y, Coords.z, 'Code 2 Backup Requested', 56, 0.8, 17)
        elseif Code == 3 then
            Notify('An officer is requesting ~r~Code 3 ~w~backup at ~b~' .. StreetName)
            CreateBlip(Coords.x, Coords.y, Coords.z, 'Code 3 Backup Requested', 56, 1.0, 49)
        elseif Code == 99 then
            Notify('An officer is requesting ~r~Code 99 ~w~backup at ~b~' .. StreetName)
            CreateBlip(Coords.x, Coords.y, Coords.z, 'Code 99 Backup Requested', 56, 1.2, 49)
        elseif Code == 'panic' then
            Notify('An officer has pressed their ~r~Panic Button ~w~at ~b~' .. StreetName)
            CreateBlip(Coords.x, Coords.y, Coords.z, 'Panic Button Pressed', 103, 1.2, 49)
        end
    end
end)



--Jail
CurrentlyJailed = false
EarlyRelease = false
OriginalJailTime = 0
RegisterNetEvent('SEM_InteractionMenu:JailPlayer')
AddEventHandler('SEM_InteractionMenu:JailPlayer', function(JailTime)
     if CurrentlyJailed then
        return
    end
    if CurrentlyHospitaled then
        return
    end

    OriginalJailTime = JailTime

    local Ped = PlayerPedId()
    if DoesEntityExist(Ped) then
        Citizen.CreateThread(function()
            SetEntityCoords(Ped, Config.JailLocation.Jail.x, Config.JailLocation.Jail.y, Config.JailLocation.Jail.z)
            SetEntityHeading(Ped, Config.JailLocation.Jail.h)
            CurrentlyJailed = true

            while JailTime >= 0 and not EarlyRelease do
                SetEntityInvincible(Ped, true)
                if IsPedInAnyVehicle(Ped, false) then
					ClearPedTasksImmediately(Ped)
                end
                
                if JailTime % 30 == 0 and JailTime ~= 0 then
                    TriggerEvent('chat:addMessage', {
                        multiline = true,
                        color = {86, 96, 252},
                        args = {'Judge', JailTime .. ' months until release.'},
                    })
				end

                Citizen.Wait(1000)

                local Location = GetEntityCoords(Ped, true)
				local Distance = Vdist(Config.JailLocation.Jail.x, Config.JailLocation.Jail.y, Config.JailLocation.Jail.z, Location['x'], Location['y'], Location['z'])
				if Distance > 100 then
                    SetEntityCoords(Ped, Config.JailLocation.Jail.x, Config.JailLocation.Jail.y, Config.JailLocation.Jail.z)
                    SetEntityHeading(Ped, Config.JailLocation.Jail.h)
					TriggerEvent('chat:addMessage', {
                        multiline = true,
                        color = {86, 96, 252},
                        args = {'Judge', 'Don\'t try escape, its impossible'},
                    })
				end

                JailTime = JailTime - 1
            end

            if EarlyRelease then
                TriggerServerEvent('SEM_InteractionMenu:GlobalChat', {86, 96, 252}, 'Judge', GetPlayerName(PlayerId()) .. ' was released from Jail on Parole')
            else
                TriggerServerEvent('SEM_InteractionMenu:GlobalChat', {86, 96, 252}, 'Judge', GetPlayerName(PlayerId()) .. ' was released from Jail after ' .. OriginalJailTime .. ' months.')
            end
            SetEntityCoords(Ped, Config.JailLocation.Release.x, Config.JailLocation.Release.y, Config.JailLocation.Release.z)
            SetEntityHeading(Ped, Config.JailLocation.Release.h)
            CurrentlyJailed = false
            EarlyRelease = false
        end)
    end
end)

RegisterNetEvent('SEM_InteractionMenu:UnjailPlayer')
AddEventHandler('SEM_InteractionMenu:UnjailPlayer', function()
    EarlyRelease = true
end)

--Staff Jail
CurrentlyJailed = false
EarlyRelease = false
OriginalJailTime = 0
RegisterNetEvent('SEM_InteractionMenu:StaffJailPlayer')
AddEventHandler('SEM_InteractionMenu:StaffJailPlayer', function(JailTime)
     if CurrentlyJailed then
        return
    end
    if CurrentlyHospitaled then
        return
    end

    OriginalJailTime = JailTime

    local Ped = PlayerPedId()
    if DoesEntityExist(Ped) then
        Citizen.CreateThread(function()
            SetEntityCoords(Ped, Config.StaffJailLocation.Jail.x, Config.StaffJailLocation.Jail.y, Config.StaffJailLocation.Jail.z)
            SetEntityHeading(Ped, Config.StaffJailLocation.Jail.h)
            CurrentlyJailed = true

            while JailTime >= 0 and not EarlyRelease do
                SetEntityInvincible(Ped, true)
                if IsPedInAnyVehicle(Ped, false) then
					ClearPedTasksImmediately(Ped)
                end
                
                if JailTime % 30 == 0 and JailTime ~= 0 then
                    TriggerEvent('chat:addMessage', {
                        multiline = true,
                        color = {255,223,0},
                        args = {'[Civilized Roleplay]', JailTime .. ' months until release.'},
                    })
				end

                Citizen.Wait(1000)

                local Location = GetEntityCoords(Ped, true)
				local Distance = Vdist(Config.StaffJailLocation.Jail.x, Config.StaffJailLocation.Jail.y, Config.StaffJailLocation.Jail.z, Location['x'], Location['y'], Location['z'])
				if Distance > 100 then
                    SetEntityCoords(Ped, Config.StaffJailLocation.Jail.x, Config.StaffJailLocation.Jail.y, Config.StaffJailLocation.Jail.z)
                    SetEntityHeading(Ped, Config.StaffJailLocation.Jail.h)
					TriggerEvent('chat:addMessage', {
                        multiline = true,
                        color = {255,223,0},
                        args = {'[Civilized Roleplay]', 'Don\'t try escape, its impossible'},
                    })
				end

                JailTime = JailTime - 1
            end

            if EarlyRelease then
                TriggerServerEvent('SEM_InteractionMenu:GlobalChat', {255,223,0}, '[Civilized Roleplay]', GetPlayerName(PlayerId()) .. ' was released from Staff Jail on Parole')
            else
                TriggerServerEvent('SEM_InteractionMenu:GlobalChat', {255,223,0}, '[Civilized Roleplay]', GetPlayerName(PlayerId()) .. ' was released from Staff Jail after ' .. OriginalJailTime .. ' months.')
            end
            SetEntityCoords(Ped, Config.StaffJailLocation.Release.x, Config.StaffJailLocation.Release.y, Config.StaffJailLocation.Release.z)
            SetEntityHeading(Ped, Config.StaffJailLocation.Release.h)
            CurrentlyJailed = false
            EarlyRelease = false
        end)
    end
end)

RegisterNetEvent('SEM_InteractionMenu:StaffUnjailPlayer')
AddEventHandler('SEM_InteractionMenu:StaffUnjailPlayer', function()
    EarlyRelease = true
end)

--Toggle LEO Weapons
CarbineEquipped = false
ShotgunEquipped = false
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(50)

        if Config.UnrackWeapons == 1 then
            local Ped = PlayerPedId()
            local CurrentWeapon = GetSelectedPedWeapon(Ped)
        
            if CarbineEquipped then
                SetCurrentPedWeapon(Ped, 'weapon_carbinerifle', true)
            else
                if tostring(CurrentWeapon) == '-2084633992' then
                    Notify('~o~You need to unrack your rifle before you can use it')
                    SetCurrentPedWeapon(Ped, 'weapon_unarmed', true)
                end
            end
            
            if ShotgunEquipped then
                SetCurrentPedWeapon(Ped, 'weapon_pumpshotgun', true)
            else
                if tostring(CurrentWeapon) == '487013001' then
                    Notify('~o~You need to unrack your shotgun before you can use it')
                    SetCurrentPedWeapon(Ped, 'weapon_unarmed', true)
                end
            end
        end
    end
end)



--Civilian Adverts
RegisterNetEvent('SEM_InteractionMenu:SyncAds')
AddEventHandler('SEM_InteractionMenu:SyncAds',function(Text, Name, Loc, File, ID)
    Ad(Text, Name, Loc, File, ID)
end)



--Inventory
RegisterNetEvent('SEM_InteractionMenu:InventoryResult')
AddEventHandler('SEM_InteractionMenu:InventoryResult', function(Inventory)
    Citizen.Wait(5000)

    if Inventory ==  nil then
        Inventory = 'Empty'
    end

    Notify('~b~Inventory Items: ~g~' .. Inventory)
end)



--BAC
RegisterNetEvent('SEM_InteractionMenu:BACResult')
AddEventHandler('SEM_InteractionMenu:BACResult', function(BACLevel)
    Citizen.Wait(5000)

    if BACLevel == nil then
        BACLevel = 0.00
    end

    if tonumber(BACLevel) < 0.08 then
        Notify('~b~BAC Level: ~g~' .. tostring(BACLevel))
    else
        Notify('~b~BAC Level: ~r~' .. tostring(BACLevel))
    end
end)




--Hospital
CurrentlyHospitalized = false
EarlyDischarge = false
OriginalHospitalTime = 0
RegisterNetEvent('SEM_InteractionMenu:HospitalizePlayer')
AddEventHandler('SEM_InteractionMenu:HospitalizePlayer', function(HospitalTime, HospitalLocation)
    if CurrentlyHospitaled then
        return
    end
    if CurrentlyJailed then
        return
    end

    OriginalHospitalTime = HospitalTime

    local Ped = PlayerPedId()
    if DoesEntityExist(Ped) then
        Citizen.CreateThread(function()
            SetEntityCoords(Ped, HospitalLocation.Hospital.x, HospitalLocation.Hospital.y, HospitalLocation.Hospital.z)
            SetEntityHeading(Ped, HospitalLocation.Hospital.h)
            CurrentlyHospitaled = true

            while HospitalTime >= 0 and not EarlyDischarge do
                SetEntityInvincible(Ped, true)
                if IsPedInAnyVehicle(Ped, false) then
					ClearPedTasksImmediately(Ped)
                end
                
                if HospitalTime % 30 == 0 and HospitalTime ~= 0 then
                    TriggerEvent('chat:addMessage', {
                        multiline = true,
                        color = {86, 96, 252},
                        args = {'Doctor', HospitalTime .. ' months until release.'},
                    })
				end

                Citizen.Wait(1000)

                local Location = GetEntityCoords(Ped, true)
                local Distance = Vdist(HospitalLocation.Hospital.x, HospitalLocation.Hospital.y, HospitalLocation.Hospital.z, Location['x'], Location['y'], Location['z'])
				if Distance > 30 then
                    SetEntityCoords(Ped, HospitalLocation.Hospital.x, HospitalLocation.Hospital.y, HospitalLocation.Hospital.z)
                    SetEntityHeading(Ped, HospitalLocation.Hospital.h)
					TriggerEvent('chat:addMessage', {
                        multiline = true,
                        color = {86, 96, 252},
                        args = {'Doctor', 'You cannot discharge yourself!'},
                    })
				end

                HospitalTime = HospitalTime - 1
            end

            if EarlyDischarge then
                TriggerServerEvent('SEM_InteractionMenu:GlobalChat', {86, 96, 252}, 'Doctor', GetPlayerName(PlayerId()) .. ' was discharged from Hospital early')
            else
                TriggerServerEvent('SEM_InteractionMenu:GlobalChat', {86, 96, 252}, 'Doctor', GetPlayerName(PlayerId()) .. ' was discharged from Hospital after ' .. OriginalHospitalTime .. ' months.')
            end
            SetEntityCoords(Ped, HospitalLocation.Release.x, HospitalLocation.Release.y, HospitalLocation.Release.z)
            SetEntityHeading(Ped, HospitalLocation.Release.h)
            CurrentlyHospitaled = false
            EarlyDischarge = false
        end)
    end
end)

RegisterNetEvent('SEM_InteractionMenu:UnhospitalizePlayer')
AddEventHandler('SEM_InteractionMenu:UnhospitalizePlayer', function()
    EarlyDischarge = true
end)



--Station Blips
Citizen.CreateThread(function()
    if Config.DisplayStationBlips then
        local function CreateBlip(x, y, z, Name, Colour, Sprite)
            StationBlip = AddBlipForCoord(x, y, z)
            SetBlipSprite(StationBlip, Sprite)
            if Config.StationBlipsDispalyed == 1 then
                SetBlipDisplay(StationBlip, 3)
            elseif Config.StationBlipsDispalyed == 2 then
                SetBlipDisplay(StationBlip, 5)
            else
                SetBlipDisplay(StationBlip, 2)
            end
            SetBlipScale(StationBlip, 1.0)
            SetBlipColour(StationBlip, Colour)
            SetBlipAsShortRange(StationBlip, true)
        
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(Name)
            EndTextCommandSetBlipName(StationBlip)
        end

        for _, Station in pairs(Config.LEOStations) do
            CreateBlip(Station.coords.x, Station.coords.y, Station.coords.z, 'Police Station', 38, 60)
        end
        for _, Station in pairs(Config.FireStations) do
            CreateBlip(Station.coords.x, Station.coords.y, Station.coords.z, 'Fire Station', 1, 60)
        end
        for _, Station in pairs(Config.HospitalStations) do
            CreateBlip(Station.coords.x, Station.coords.y, Station.coords.z, 'Hospital', 2, 61)
        end
    end
end)



--Permissions
LEOAce = false
TriggerServerEvent('SEM_InteractionMenu:LEOPerms')
RegisterNetEvent('SEM_InteractionMenu:LEOPermsResult')
AddEventHandler('SEM_InteractionMenu:LEOPermsResult', function(Allowed)
    if Allowed then
        LEOAce = true
    else
        LEOAce = false
    end
end)

FireAce = false
TriggerServerEvent('SEM_InteractionMenu:FirePerms')
RegisterNetEvent('SEM_InteractionMenu:FirePermsResult')
AddEventHandler('SEM_InteractionMenu:FirePermsResult', function(Allowed)
    if Allowed then
        FireAce = true
    else
        FireAce = false
    end
end)

StaffAce = false
TriggerServerEvent('SEM_InteractionMenu:StaffPerms')
RegisterNetEvent('SEM_InteractionMenu:StaffPermsResult')
AddEventHandler('SEM_InteractionMenu:StaffPermsResult', function(Allowed)
    if Allowed then
        StaffAce = true
    else
        StaffAce = false
    end
end)

UnjailAllowed = false
TriggerServerEvent('SEM_InteractionMenu:UnjailPerms')
RegisterNetEvent('SEM_InteractionMenu:UnjailPermsResult')
AddEventHandler('SEM_InteractionMenu:UnjailPermsResult', function(Allowed)
    if Allowed then
        UnjailAllowed = true
    else
        UnjailAllowed = false
    end
end)

UnhospitalAllowed = false
TriggerServerEvent('SEM_InteractionMenu:UnhospitalPerms')
RegisterNetEvent('SEM_InteractionMenu:UnhospitalPermsResult')
AddEventHandler('SEM_InteractionMenu:UnhospitalPermsResult', function(Allowed)
    if Allowed then
        UnhospitalAllowed = true
    else
        UnhospitalAllowed = false
    end
end)



--Emote
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if EmotePlaying then
            if Config.EmoteHelp then
                NotifyHelp('You are playing an Emote, ~b~Move to Cancel')
            end

            --  Spacebar                   W                          S                          A                          D
            if (IsControlPressed(0, 22) or IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35)) then
                CancelEmote()
            end
        end
    end
end)



--Commands
Citizen.CreateThread(function()
    if EmoteRestrict() then
        local Index = 0
        local Emotes = ''
        for _, Emote in pairs(Config.EmotesList) do
            Index = Index + 1
            if Index == 1 then
                Emotes = Emotes .. Emote.name
            else
                Emotes = Emotes .. ', ' .. Emote.name
            end
        end
        
        TriggerEvent('chat:addSuggestion', '/emotes', 'List of Current Avaliable Emotes')
        TriggerEvent('chat:addSuggestion', '/emote', 'Play Emote', {{name = 'Emote Name', help = 'Emotes: ' .. Emotes}})
    else
        TriggerEvent('chat:removeSuggestion', '/emotes')
        TriggerEvent('chat:removeSuggestion', '/emote')
    end

    TriggerEvent('chat:addSuggestion', '/eng', 'Toggles Engine')
    TriggerEvent('chat:addSuggestion', '/hood', 'Toggles Vehicle\'s Hood')
    TriggerEvent('chat:addSuggestion', '/trunk', 'Toggles Vehicle\'s Trunk')
    TriggerEvent('chat:addSuggestion', '/clear', 'Clears all Weapons')
    TriggerEvent('chat:addSuggestion', '/cuff', 'Cuff Player', {{name = 'ID', help = 'Players Server ID'}})
    TriggerEvent('chat:addSuggestion', '/drag', 'Drag Player', {{name = 'ID', help = 'Players Server ID'}})
    TriggerEvent('chat:addSuggestion', '/dropweapon', 'Drops Weapon in Hand')
    TriggerEvent('chat:addSuggestion', '/loadout', 'Equips LEO Weapon Loadout')
    TriggerEvent('chat:addSuggestion', '/coords', 'Shows Current Player Coords and Heading')

    if Config.Radar ~= 0 then
        TriggerEvent('chat:addSuggestion', '/radar', 'Toggle Radar Menu')
    end

    if Config.LEOAccess == 3 or Config.FireAccess == 3 then
        if Config.OndutyPSWDActive then
            TriggerEvent('chat:addSuggestion', '/onduty', 'Enable LEO/Fire Menu', {{name = 'Department', help = 'LEO or Fire'}, {name = 'Password', help = 'Onduty Password'}})
        else
            TriggerEvent('chat:addSuggestion', '/onduty', 'Enable LEO/Fire Menu', {{name = 'Department', help = 'LEO or Fire'}})
        end
    else
        TriggerEvent('chat:removeSuggestion', '/onduty')
    end
end)

LEOOnduty = false
FireOnduty = false
RegisterCommand('onduty', function(source, args, rawCommand)
    if Config.LEOAccess == 3 or Config.FireAccess == 3 then
        if Config.OndutyPSWDActive then
            if args[2] == Config.OndutyPSWD then
                local Department = args[1]:lower()
                if Department == 'leo' then
                    LEOOnduty = not LEOOnduty
                    if LEOOnduty then
                        Notify('~g~You are onduty as an LEO')
                    else
                        Notify('~o~You are no longer onduty as an LEO')
                    end
                elseif Department == 'fire' then
                    FireOnduty = not FireOnduty
                    if FireOnduty == true then
                        Notify('~g~You are onduty as an Firefighter')
                    else
                        Notify('~o~You are no longer onduty as an Firefighter')
                    end
                else
                    Notify('~r~Invalid Department!')
                end
            else
                Notify('~r~Incorrect Password')
            end
        else
            local Department = args[1]:lower()
            if Department == 'leo' then
                LEOOnduty = not LEOOnduty
                if LEOOnduty then
                    Notify('~g~You are onduty as an LEO')
                else
                    Notify('~o~You are no longer onduty as an LEO')
                end
            elseif Department == 'fire' then
                FireOnduty = not FireOnduty
                if FireOnduty == true then
                    Notify('~g~You are onduty as an Firefighter')
                else
                    Notify('~o~You are no longer onduty as an Firefighter')
                end
            else
                Notify('~r~Invalid Department!')
            end
        end
    end
end)

function IsOndutyLEO()
    return LEOOnduty
end
function IsOndutyFire()
    return FireOnduty
end

RegisterCommand('cuff', function(source, args, rawCommand)
    if LEORestrict() or FireRestrict() then
        if args[1] ~= nil then
            local ID = tonumber(args[1])
            if Config.CommandDistanceChecked then
                if GetDistance(source) < Config.CommandDistance then
                    TriggerServerEvent('SEM_InteractionMenu:CuffNear', ID)
                else
                    Notify('~r~That player is too far away')
                end
            else
                TriggerServerEvent('SEM_InteractionMenu:CuffNear', ID)
            end
        else
            TriggerServerEvent('SEM_InteractionMenu:CuffNear', GetClosestPlayer())
        end
    else
        Notify('~r~Insufficient Permissions')
    end
end)

RegisterCommand('drag', function(source, args, rawCommand)
    if LEORestrict() or FireRestrict() then
        if args[1] ~= nil then
            local ID = tonumber(args[1])
            if Config.CommandDistanceChecked then
                if GetDistance(source) < Config.CommandDistance then
                    TriggerServerEvent('SEM_InteractionMenu:DragNear', ID)
                else
                    Notify('~r~That player is too far away')
                end
            else
                TriggerServerEvent('SEM_InteractionMenu:DragNear', ID)
            end
        else
            TriggerServerEvent('SEM_InteractionMenu:DragNear', GetClosestPlayer())
        end
    else
        Notify('~r~Insufficient Permissions')
    end
end)

RegisterCommand('radar', function(source, args, rawCommand)
    if Config.Radar ~= 0 then
        if LEORestrict() or FireRestrict() then
            ToggleRadar()
        else
            Notify('~r~Insufficient Permissions')
        end
    end
end)

RegisterCommand('loadout', function(source, args, rawCommand)
    if LEORestrict() then
        if args[1] then
            local RequestedLoadout = args[1]
            
            for Name, Loadout in pairs(Config.LEOLoadouts) do
                if Name:lower() == RequestedLoadout:lower() then
                    SetEntityHealth(GetPlayerPed(-1), 200)
                    RemoveAllPedWeapons(GetPlayerPed(-1), true)
                    AddArmourToPed(GetPlayerPed(-1), 100)

                    for _, Weapon in pairs(Loadout) do
                        GiveWeapon(Weapon.weapon)
                                                                
                        for _, Component in pairs(Weapon.components) do
                            AddWeaponComponent(Weapon.weapon, Component)
                        end
                    end
                    return
                end
            end

            Notify('~r~Invalid Loadout')
        else
            SetEntityHealth(PlayerPedId(), 200)
            RemoveAllPedWeapons(PlayerPedId(), true)
            AddArmourToPed(PlayerPedId(), 100)
            GiveWeapon('weapon_nightstick')
            GiveWeapon('weapon_flashlight')
            GiveWeapon('weapon_fireextinguisher')
            GiveWeapon('weapon_flare')
            GiveWeapon('weapon_stungun')
            GiveWeapon('weapon_combatpistol')
            AddWeaponComponent('weapon_combatpistol', 'component_at_pi_flsh')
            Notify('~g~Loadout Spawned')
        end
    else
        Notify('~r~You aren\'t an LEO')
    end
end)

RegisterCommand('hu', function(source, args, rawCommand)
    local Ped = PlayerPedId()
    if DoesEntityExist(Ped) and not HandCuffed then
        Citizen.CreateThread(function()
            LoadAnimation('random@mugging3')
            if IsEntityPlayingAnim(Ped, 'random@mugging3', 'handsup_standing_base', 3) or HandCuffed then
                ClearPedSecondaryTask(Ped)
                SetEnableHandcuffs(Ped, false)
            elseif not IsEntityPlayingAnim(Ped, 'random@mugging3', 'handsup_standing_base', 3) or not HandCuffed then
                TaskPlayAnim(Ped, 'random@mugging3', 'handsup_standing_base', 8.0, -8, -1, 49, 0, 0, 0, 0)
                SetEnableHandcuffs(Ped, true)
            end
        end)
    end
end)

RegisterCommand('huk', function(source, args, rawCommand)
    local Ped = PlayerPedId()
    if (DoesEntityExist(Ped) and not IsEntityDead(Ped)) and not HandCuffed then
        Citizen.CreateThread(function()
            LoadAnimation('random@arrests')
            if (IsEntityPlayingAnim(Ped, 'random@arrests', 'kneeling_arrest_idle', 3)) then
                TaskPlayAnim(Ped, 'random@arrests', 'kneeling_arrest_get_up', 8.0, 1.0, -1, 128, 0, 0, 0, 0)
            else
                TaskPlayAnim(Ped, 'random@arrests', 'idle_2_hands_up', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                Wait (4000)
                TaskPlayAnim(Ped, 'random@arrests', 'kneeling_arrest_idle', 8.0, 1.0, -1, 2, 0, 0, 0, 0)
            end
        end)
    end
end)

RegisterCommand('dropweapon', function(source, args, rawCommand)
    local CurrentWeapon = GetSelectedPedWeapon(PlayerPedId())
    SetPedDropsInventoryWeapon(PlayerPedId(), CurrentWeapon, -2.0, 0.0, 0.5, 30)
    Notify('~r~Weapon Dropped!')
end)

RegisterCommand('clear', function(source, args, rawCommand)
    SetEntityHealth(PlayerPedId(), 200)
    RemoveAllPedWeapons(PlayerPedId(), true)
    Notify('~r~All Weapons Cleared!')
end)

RegisterCommand('eng', function(source, args, rawCommand)
    local Veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if Veh ~= nil and Veh ~= 0 and GetPedInVehicleSeat(Veh, 0) then
        SetVehicleEngineOn(Veh, (not GetIsVehicleEngineRunning(Veh)), false, true)
        Notify('~g~Engine Toggled!')
    end
end)

RegisterCommand('hood', function(source, args, rawCommand)
    local Veh = GetVehiclePedIsIn(PlayerPedId(), false)

    if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
        if GetVehicleDoorAngleRatio(Veh, 4) > 0 then
            SetVehicleDoorShut(Veh, 4, false)
        else
            SetVehicleDoorOpen(Veh, 4, false, false)
        end
    end

    Notify('~g~Hood Toggled!')
end)

RegisterCommand('trunk', function(source, args, rawCommand)
    local Veh = GetVehiclePedIsIn(PlayerPedId(), false)

    if Veh ~= nil and Veh ~= 0 and Veh ~= 1 then
        if GetVehicleDoorAngleRatio(Veh, 5) > 0 then
            SetVehicleDoorShut(Veh, 5, false)
        else
            SetVehicleDoorOpen(Veh, 5, false, false)
        end
    end

    Notify('~g~Trunk Toggled!')
end)

RegisterCommand('emotes', function(source, args, rawCommand)
    if EmoteRestrict() then
        local Index = 0
        local Emotes = ''
        for _, Emote in pairs(Config.EmotesList) do
            Index = Index + 1
            if Index == 1 then
                Emotes = Emotes .. Emote.name
            else
                Emotes = Emotes .. ', ' .. Emote.name
            end
        end

        TriggerEvent('chat:addMessage', {
            multiline = true,
            color = {255, 0 ,0},
            args = {'Emotes', '\n^r^7' .. Emotes},
        })
    end
end)

RegisterCommand('emote', function(source, args, rawCommand)
    if EmoteRestrict() then
        local SelectedEmote = args[1]

        for _, Emote in pairs(Config.EmotesList) do
            if Emote.name == SelectedEmote then
                PlayEmote(Emote.emote, Emote.name)
                return
            end
        end

        TriggerEvent('chat:addMessage', {
            multiline = true,
            color = {255, 0, 0},
            args = {'Emotes', 'Invalid Emote!'},
        })
    end
end)

RegisterCommand('coords', function(source, args, rawCommand)
    local Coords = GetEntityCoords(PlayerPedId())
    local Heading = GetEntityHeading(PlayerPedId())

    TriggerEvent('chatMessage', 'Coords', {255, 255, 0}, '\nX: ' .. Coords.x .. '\nY: ' .. Coords.y .. '\nZ: ' .. Coords.z .. '\nHeading: ' .. Heading)
end)

-- Disable Combat Roleing Script Below - Added 07/01/23
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if IsPedArmed(GetPlayerPed(-1), 4 | 2) then 
			DisableControlAction(0, 22, true)
		end
	end
end)
-- /carry Scrpt Added Below - Added 10/01/23

local carry = {
	InProgress = false,
	targetSrc = -1,
	type = "",
	personCarrying = {
		animDict = "missfinale_c2mcs_1",
		anim = "fin_c2_mcs_1_camman",
		flag = 49,
	},
	personCarried = {
		animDict = "nm",
		anim = "firemans_carry",
		attachX = 0.27,
		attachY = 0.15,
		attachZ = 0.63,
		flag = 33,
	}
}

local function drawNativeNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function GetClosestPlayer(radius)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _,playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords-playerCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end
	if closestDistance ~= -1 and closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end        
    end
    return animDict
end

RegisterCommand("carry",function(source, args)
	if not carry.InProgress then
		local closestPlayer = GetClosestPlayer(3)
		if closestPlayer then
			local targetSrc = GetPlayerServerId(closestPlayer)
			if targetSrc ~= -1 then
				carry.InProgress = true
				carry.targetSrc = targetSrc
				TriggerServerEvent("CarryPeople:sync",targetSrc)
				ensureAnimDict(carry.personCarrying.animDict)
				carry.type = "carrying"
			else
				drawNativeNotification("~r~No one nearby to carry!")
			end
		else
			drawNativeNotification("~r~No one nearby to carry!")
		end
	else
		carry.InProgress = false
		ClearPedSecondaryTask(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		TriggerServerEvent("CarryPeople:stop",carry.targetSrc)
		carry.targetSrc = 0
	end
end,false)

RegisterNetEvent("CarryPeople:syncTarget")
AddEventHandler("CarryPeople:syncTarget", function(targetSrc)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
	carry.InProgress = true
	ensureAnimDict(carry.personCarried.animDict)
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, carry.personCarried.attachX, carry.personCarried.attachY, carry.personCarried.attachZ, 0.5, 0.5, 180, false, false, false, false, 2, false)
	carry.type = "beingcarried"
end)

RegisterNetEvent("CarryPeople:cl_stop")
AddEventHandler("CarryPeople:cl_stop", function()
	carry.InProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

Citizen.CreateThread(function()
	while true do
		if carry.InProgress then
			if carry.type == "beingcarried" then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarried.animDict, carry.personCarried.anim, 8.0, -8.0, 100000, carry.personCarried.flag, 0, false, false, false)
				end
			elseif carry.type == "carrying" then
				if not IsEntityPlayingAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 3) then
					TaskPlayAnim(PlayerPedId(), carry.personCarrying.animDict, carry.personCarrying.anim, 8.0, -8.0, 100000, carry.personCarrying.flag, 0, false, false, false)
				end
			end
		end
		Wait(0)
	end
end)

-----------------------------------------------------------------
--TakeHostage Script added 14/01/23
------------------------------------------------------------------

local takeHostage = {
	allowedWeapons = {
		`WEAPON_PISTOL`,
		`WEAPON_COMBATPISTOL`,
		--etc add guns you want
	},
	InProgress = false,
	type = "",
	targetSrc = -1,
	agressor = {
		animDict = "anim@gangops@hostage@",
		anim = "perp_idle",
		flag = 49,
	},
	hostage = {
		animDict = "anim@gangops@hostage@",
		anim = "victim_idle",
		attachX = -0.24,
		attachY = 0.11,
		attachZ = 0.0,
		flag = 49,
	}
}

local function drawNativeNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function GetClosestPlayer(radius)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _,playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords-playerCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end
	if closestDistance ~= -1 and closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

local function ensureAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end        
    end
    return animDict
end

local function drawNativeText(str)
	SetTextEntry_2("STRING")
	AddTextComponentString(str)
	EndTextCommandPrint(1000, 1)
end

RegisterCommand("takehostage",function()
	callTakeHostage()
end)

RegisterCommand("th",function()
	callTakeHostage()
end)

function callTakeHostage()
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)

	local canTakeHostage = false
	for i=1, #takeHostage.allowedWeapons do
		if HasPedGotWeapon(PlayerPedId(), takeHostage.allowedWeapons[i], false) then
			if GetAmmoInPedWeapon(PlayerPedId(), takeHostage.allowedWeapons[i]) > 0 then
				canTakeHostage = true 
				foundWeapon = takeHostage.allowedWeapons[i]
				break
			end 					
		end
	end

	if not canTakeHostage then 
		drawNativeNotification("You need a pistol with ammo to take a hostage at gunpoint!")
	end

	if not takeHostage.InProgress and canTakeHostage then			
		local closestPlayer = GetClosestPlayer(3)
		if closestPlayer then
			local targetSrc = GetPlayerServerId(closestPlayer)
			if targetSrc ~= -1 then
				SetCurrentPedWeapon(PlayerPedId(), foundWeapon, true)
				takeHostage.InProgress = true
				takeHostage.targetSrc = targetSrc
				TriggerServerEvent("TakeHostage:sync",targetSrc)
				ensureAnimDict(takeHostage.agressor.animDict)
				takeHostage.type = "agressor"
			else
				drawNativeNotification("~r~No one nearby to take as hostage!")
			end
		else
			drawNativeNotification("~r~No one nearby to take as hostage!")
		end
	end
end 

RegisterNetEvent("TakeHostage:syncTarget")
AddEventHandler("TakeHostage:syncTarget", function(target)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	takeHostage.InProgress = true
	ensureAnimDict(takeHostage.hostage.animDict)
	AttachEntityToEntity(PlayerPedId(), targetPed, 0, takeHostage.hostage.attachX, takeHostage.hostage.attachY, takeHostage.hostage.attachZ, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
	takeHostage.type = "hostage" 
end)

RegisterNetEvent("TakeHostage:releaseHostage")
AddEventHandler("TakeHostage:releaseHostage", function()
	takeHostage.InProgress = false 
	takeHostage.type = ""
	DetachEntity(PlayerPedId(), true, false)
	ensureAnimDict("reaction@shove")
	TaskPlayAnim(PlayerPedId(), "reaction@shove", "shoved_back", 8.0, -8.0, -1, 0, 0, false, false, false)
	Wait(250)
	ClearPedSecondaryTask(PlayerPedId())
end)

RegisterNetEvent("TakeHostage:killHostage")
AddEventHandler("TakeHostage:killHostage", function()
	takeHostage.InProgress = false 
	takeHostage.type = ""
	SetEntityHealth(PlayerPedId(),0)
	DetachEntity(PlayerPedId(), true, false)
	ensureAnimDict("anim@gangops@hostage@")
	TaskPlayAnim(PlayerPedId(), "anim@gangops@hostage@", "victim_fail", 8.0, -8.0, -1, 168, 0, false, false, false)
end)

RegisterNetEvent("TakeHostage:cl_stop")
AddEventHandler("TakeHostage:cl_stop", function()
	takeHostage.InProgress = false
	takeHostage.type = "" 
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

Citizen.CreateThread(function()
	while true do
		if takeHostage.type == "agressor" then
			if not IsEntityPlayingAnim(PlayerPedId(), takeHostage.agressor.animDict, takeHostage.agressor.anim, 3) then
				TaskPlayAnim(PlayerPedId(), takeHostage.agressor.animDict, takeHostage.agressor.anim, 8.0, -8.0, 100000, takeHostage.agressor.flag, 0, false, false, false)
			end
		elseif takeHostage.type == "hostage" then
			if not IsEntityPlayingAnim(PlayerPedId(), takeHostage.hostage.animDict, takeHostage.hostage.anim, 3) then
				TaskPlayAnim(PlayerPedId(), takeHostage.hostage.animDict, takeHostage.hostage.anim, 8.0, -8.0, 100000, takeHostage.hostage.flag, 0, false, false, false)
			end
		end
		Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do 
		if takeHostage.type == "agressor" then
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisableControlAction(0,21,true) -- disable sprint
			DisablePlayerFiring(PlayerPedId(),true)
			drawNativeText("Press [G] to release, [H] to kill")

			if IsEntityDead(PlayerPedId()) then	
				takeHostage.type = ""
				takeHostage.InProgress = false
				ensureAnimDict("reaction@shove")
				TaskPlayAnim(PlayerPedId(), "reaction@shove", "shove_var_a", 8.0, -8.0, -1, 168, 0, false, false, false)
				TriggerServerEvent("TakeHostage:releaseHostage", takeHostage.targetSrc)
			end 

			if IsDisabledControlJustPressed(0,47) then --release	
				takeHostage.type = ""
				takeHostage.InProgress = false 
				ensureAnimDict("reaction@shove")
				TaskPlayAnim(PlayerPedId(), "reaction@shove", "shove_var_a", 8.0, -8.0, -1, 168, 0, false, false, false)
				TriggerServerEvent("TakeHostage:releaseHostage", takeHostage.targetSrc)
			elseif IsDisabledControlJustPressed(0,74) then --kill 			
				takeHostage.type = ""
				takeHostage.InProgress = false 		
				ensureAnimDict("anim@gangops@hostage@")
				TaskPlayAnim(PlayerPedId(), "anim@gangops@hostage@", "perp_fail", 8.0, -8.0, -1, 168, 0, false, false, false)
				TriggerServerEvent("TakeHostage:killHostage", takeHostage.targetSrc)
				TriggerServerEvent("TakeHostage:stop",takeHostage.targetSrc)
				Wait(100)
				SetPedShootsAtCoord(PlayerPedId(), 0.0, 0.0, 0.0, 0)
			end
		elseif takeHostage.type == "hostage" then 
			DisableControlAction(0,21,true) -- disable sprint
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisableControlAction(0,263,true) -- disable melee
			DisableControlAction(0,264,true) -- disable melee
			DisableControlAction(0,257,true) -- disable melee
			DisableControlAction(0,140,true) -- disable melee
			DisableControlAction(0,141,true) -- disable melee
			DisableControlAction(0,142,true) -- disable melee
			DisableControlAction(0,143,true) -- disable melee
			DisableControlAction(0,75,true) -- disable exit vehicle
			DisableControlAction(27,75,true) -- disable exit vehicle  
			DisableControlAction(0,22,true) -- disable jump
			DisableControlAction(0,32,true) -- disable move up
			DisableControlAction(0,268,true)
			DisableControlAction(0,33,true) -- disable move down
			DisableControlAction(0,269,true)
			DisableControlAction(0,34,true) -- disable move left
			DisableControlAction(0,270,true)
			DisableControlAction(0,35,true) -- disable move right
			DisableControlAction(0,271,true)
		end
		Wait(0)
	end
end)

-- Holograms added 14th Jan 2023-501.3180, 4362.5073, 67.3173, 247.4115
Citizen.CreateThread(function()
    Holograms()
end)

function Holograms()
		while true do
			Citizen.Wait(0)			
				-- half way down road
		if GetDistanceBetweenCoords( -461.3502, 4328.8457, 61.7, GetEntityCoords(GetPlayerPed(-1))) < 10.0 then
			Draw3DText( -461.3502, 4328.8457, 61.7, "Please drive ~r~realistic", 4, 0.1, 0.1)
			Draw3DText( -461.3502, 4328.8457,  61.5, "Try ~g~passive~w~ roleplay", 4, 0.1, 0.1)
			Draw3DText( -461.3502, 4328.8457, 61.3, "Discord: ~b~discord.gg/~r~cirp", 4, 0.1, 0.1)		
		end	
        				-- Direct Spawn Hologram
        if GetDistanceBetweenCoords( -1691.4960, 491.0555, 128.8, GetEntityCoords(GetPlayerPed(-1))) < 10.0 then
			Draw3DText( -1691.4960, 491.0555, 127.8, "Click ~b~F1~w~ to get started!", 4, 0.1, 0.1)
			Draw3DText( -1691.4960, 491.0555, 127.6, "Set up your VC in ~b~ESC ~w~> ~b~Settings ~w~> ~b~VC", 4, 0.1, 0.1)
			Draw3DText( -1691.4960, 491.0555, 127.4, "Custom Cars - ~r~/cars", 4, 0.1, 0.1)		
		end	
                				-- Direct Spawn Hologram
                                if GetDistanceBetweenCoords( -1669.4133, 501.3817, 128.8, GetEntityCoords(GetPlayerPed(-1))) < 10.0 then
                                    Draw3DText( -1669.4133, 501.3817, 127.8, "Click ~b~F1~w~ to get started!", 4, 0.1, 0.1)
                                    Draw3DText( -1669.4133, 501.3817, 127.6, "Set up your VC in ~b~ESC ~w~> ~b~Settings ~w~> ~b~VC", 4, 0.1, 0.1)
                                    Draw3DText( -1669.4133, 501.3817, 127.4, "Custom Cars - ~r~/cars", 4, 0.1, 0.1)		
                                end	
				--near spawn
		if GetDistanceBetweenCoords( -1680.1479, 495.6202, 127.8, GetEntityCoords(GetPlayerPed(-1))) < 10.0 then
			Draw3DText( -1680.1479, 495.6202, 127.8, "Discord: ~b~discord.gg/~r~cirp", 4, 0.1, 0.1)
			Draw3DText( -1680.1479, 495.6202, 127.6, "Tiktok: ~b~@~r~crpBritishTea", 4, 0.1, 0.1)
			Draw3DText( -1680.1479, 495.6202, 127.4, "Need Help? Use ~r~/calladmin", 4, 0.1, 0.1)		
		end	

	end
end

-------------------------------------------------------------------------------------------------------------------------
function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
         local px,py,pz=table.unpack(GetGameplayCamCoords())
         local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
         local scale = (1/dist)*20
         local fov = (1/GetGameplayCamFov())*100
         local scale = scale*fov   
         SetTextScale(scaleX*scale, scaleY*scale)
         SetTextFont(fontId)
         SetTextProportional(1)
         SetTextColour(250, 250, 250, 255)		-- You can change the text color here
         SetTextDropshadow(1, 1, 1, 1, 255)
         SetTextEdge(2, 0, 0, 0, 150)
         SetTextDropShadow()
         SetTextOutline()
         SetTextEntry("STRING")
         SetTextCentre(1)
         AddTextComponentString(textInput)
         SetDrawOrigin(x,y,z+2, 0)
         DrawText(0.0, 0.0)
         ClearDrawOrigin()
        end
        --Hands up script added 14th January 2023
        Citizen.CreateThread(function()
            local dict = "missminuteman_1ig_2"
            
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end
            local handsup = false
            while true do
                Citizen.Wait(0)
                if IsControlJustPressed(1, 323) then --Start holding X
                    if not handsup then
                        TaskPlayAnim(GetPlayerPed(-1), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
                        handsup = true
                    else
                        handsup = false
                        ClearPedTasks(GetPlayerPed(-1))
                    end
                end
            end
        end)
-- Script Added 22/04/23 -> No Drive Bys
-- Allow passengers to shoot
local passengerDriveBy = true

-- CODE --

Citizen.CreateThread(function()
	while true do
		Wait(1)

		playerPed = GetPlayerPed(-1)
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
	end
end)

--Weapons (Melees) on back script added 15/05/23 
-- Add weapons to the 'compatable_weapon_hashes' table below to make them show up on a player's back (can use GetHashKey(...) if you don't know the hash) --
local SETTINGS = {
    back_bone = 24816,
    x = 0.075,
    y = -0.15,
    z = -0.02,
    x_rotation = 0.0,
    y_rotation = 165.0,
    z_rotation = 0.0,
    compatable_weapon_hashes = {
      -- melee:
      --["prop_golf_iron_01"] = 1141786504, -- positioning still needs work
      ["w_me_bat"] = -1786099057,
      ["prop_ld_jerrycan_01"] = 883325847,
      -- launchers:
      ["w_lr_firework"] = 2138347493
    }
}

local attached_weapons = {}

Citizen.CreateThread(function()
  while true do
      local me = GetPlayerPed(-1)
      ---------------------------------------
      -- attach if player has large weapon --
      ---------------------------------------
      for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
          if HasPedGotWeapon(me, wep_hash, false) then
              if not attached_weapons[wep_name] and GetSelectedPedWeapon(me) ~= wep_hash then
                  AttachWeapon(wep_name, wep_hash, SETTINGS.back_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
              end
          end
      end
      --------------------------------------------
      -- remove from back if equipped / dropped --
      --------------------------------------------
      for name, attached_object in pairs(attached_weapons) do
          -- equipped? delete it from back:
          if GetSelectedPedWeapon(me) ==  attached_object.hash or not HasPedGotWeapon(me, attached_object.hash, false) then -- equipped or not in weapon wheel
            DeleteObject(attached_object.handle)
            attached_weapons[name] = nil
          end
      end
  Wait(0)
  end
end)

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR, isMelee)
	local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end

  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
  }

  if isMelee then x = 0.11 y = -0.14 z = 0.0 xR = -75.0 yR = 185.0 zR = 92.0 end -- reposition for melee items
  if attachModel == "prop_ld_jerrycan_01" then x = x + 0.3 end

  SetEntityCollision(attached_weapons[attachModel].handle, false, false)
  AttachEntityToEntity(attached_weapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function isMeleeWeapon(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
      return true
    else
        return false
    end
end


--floating /me text
RegisterCommand("me", function(source, args)
    local message = table.concat(args, " ")
    local myId = GetPlayerServerId(PlayerId())
    local coords = GetEntityCoords(PlayerPedId())

    TriggerServerEvent("displayMessage", myId, coords, message)
end)

local displayedMessages = {}

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        for id, data in pairs(displayedMessages) do
            if data.time < 10 then
                data.time = data.time + 1
            else
                displayedMessages[id] = nil
            end
        end
    end
end)

RegisterNetEvent("drawMessage")
AddEventHandler("drawMessage", function(playerId, coords, message)
    local distance = #(coords - GetEntityCoords(PlayerPedId()))
    if distance < 50 then -- Adjust the radius as needed
        local offsetCoords = vector3(coords.x, coords.y, coords.z + 1.0) -- Adjust the height offset if needed
        local textId = "MESSAGE_" .. playerId

        AddTextEntry(textId, "[~y~" .. playerId .. "~w~] " .. message)
        displayedMessages[textId] = { coords = offsetCoords, time = 0 }

        Citizen.CreateThread(function()
            while displayedMessages[textId] do
                Wait(0)
                local displayData = displayedMessages[textId]
                local distanceToMessage = #(displayData.coords - GetEntityCoords(PlayerPedId()))
                if distanceToMessage < 50 then -- Adjust the radius as needed
                    DrawText3D(displayData.coords.x, displayData.coords.y, displayData.coords.z, GetLabelText(textId))
                end
            end
        end)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)

    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

-- Pausemap script (when click esc map in hand) - added 10/08/23

local wasmenuopen = false

Citizen.CreateThread(function()
	while true do
			Wait(0)
			if IsPauseMenuActive() and not wasmenuopen then
					SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263, true) -- set unarmed
					TriggerEvent("Map:ToggleMap")
					--TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_TOURIST_MAP", 0, false) -- Start the scenario
					wasmenuopen = true
			end
			
			if not IsPauseMenuActive() and wasmenuopen then
					Wait(2000)
					TriggerEvent("Map:ToggleMap")
					wasmenuopen = false
			end
	end
end)

local holdingMap = false
local mapModel = "prop_tourist_map_01"
local animDict = "amb@world_human_tourist_map@male@base"
local animName = "base"
local map_net = nil

-- Toggle Map --

RegisterNetEvent("Map:ToggleMap")
AddEventHandler("Map:ToggleMap", function()
    if not holdingMap then
        RequestModel(GetHashKey(mapModel))
        while not HasModelLoaded(GetHashKey(mapModel)) do
            Citizen.Wait(100)
        end

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(100)
        end

        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local mapspawned = CreateObject(GetHashKey(mapModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
        Citizen.Wait(1000)
        local netid = ObjToNet(mapspawned)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(mapspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
        TaskPlayAnim(GetPlayerPed(PlayerId()), animDict, animName, 1.0, -1, -1, 50, 0, 0, 0, 0)
        map_net = netid
        holdingMap = true
    else
        ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
        DetachEntity(NetToObj(map_net), 1, 1)
        DeleteEntity(NetToObj(map_net))
        map_net = nil
        holdingMap = false
    end
end)