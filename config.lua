--[[
───────────────────────────────────────────────────────────────

	Menu (config.lua) - Created by Scott M
	Current Version: v1.7.1 (Sep 2021)
	
	Support: https://semdevelopment.com/discord

───────────────────────────────────────────────────────────────
]]



Config = {}



---------------------------------------------------------------
--                                                           --
--                      Menu Features                        --
--                                                           --
---------------------------------------------------------------

--This is how the version check will be displayed in the server console
--Full = 0 [Default] | Simple = 1 | Disabled = 2
Config.VersionChecker = 2

--This is how you open the menu either via a command or button
--Button = 0 [Default]  |  Command = 1
Config.OpenMenu = 0

--This is the button that will open the menu (If chosen at Config.OpenMenu)
--Default = 244 [M]  |  To change the button check out https://docs.fivem.net/game-references/controls/
--Controller Support for this resource is DISABLED!
Config.MenuButton = 244

--This is the command that will open the menu (If chosen at Config.OpenMenu)
Config.Command = 'semmenu'

--This is the width of the menu when open
--Default = 80
Config.MenuWidth = 80

--This is the position of the menu when open
--Left = 0 [Default]  |  Right = 1
Config.MenuOrientation = 1

--This is the title of the menu dispalyed
--Default       = The default title of the menu is 'Interaction Menu'
--Player Name   = This is the name of the player
--Custom        = This is a custom title set by you at Config.MenuTitleCustom
--Default = 0 [Default]  |  Player Name = 1  |  Custom = 2
Config.MenuTitle = 2

--This is the custom title you can set for the menu (If chosen at Config.MenuTitle)
Config.MenuTitleCustom = 'Interaction Menu'

















---------------------------------------------------------------
--                                                           --
--                 General/Shared Features                   --
--                                                           --
---------------------------------------------------------------

--This determines if the onduty password is active, if false the password will NOT be required when doing the command
Config.OndutyPSWDActive = false

--This is the onduty password, only people with the password can access the menu if chosen at Config.LEOAccess/Config.FireAccess
Config.OndutyPSWD = 'OndutyPSWD'

--This determines if the distance between the player using the command and the person being cuffed/dragged is checked
Config.CommandDistanceChecked = true

--This determines how close you need to be to cuff/drag someone using their ID
--Default = 50
Config.CommandDistance = 10

--This determines if the stations section of the LEO & Fire menu will be visible
--Station Locations can be set at Config.LEOStations & Config.FireStations
Config.ShowStations = false

--This determines if the stations menu will have a teleport section, if set to false ONLY the waypoint option will be visible
Config.AllowStationTeleport = false

--This determines if the stations set in the Config.LEOStations & Config.FireStations have blips on the map
Config.DisplayStationBlips = false

--This sets where the station blips will be displayed (Mini Map / Main Map)
--On Mini Map & Main Map = 0 [Default]  |  Only on Main Map = 1  |  Only on Mini Map = 2
Config.StationBlipsDispalyed = 0

--These are the props avaliable via the LEO & Fire menus
Config.Props = {
    --[[
        EXAMPLE: 
		{name = 'a', spawncode = 'b'},
        ────────────────────────────────────────────────────────────────
        'a' is the title that shows in the menu
        'b' is the spawn code for prop that will be spawned
    ]]
    {name = 'Police Barrier', spawncode = 'prop_barrier_work05'},
    {name = 'Barrier', spawncode = 'prop_barrier_work06a'},
    {name = 'Traffic Cone', spawncode = 'prop_roadcone01a'},
    {name = 'Cone', spawncode = 'prop_roadcone02b'},
    {name = 'Work Barrier', spawncode = 'prop_mp_barrier_02b'},
    {name = 'Work Barrier 2', spawncode = 'prop_barrier_work01a'},
    {name = 'Lighting', spawncode = 'prop_worklight_03b'},
    {name = 'Tent', spawncode = 'prop_gazebo_02'},
    {name = 'Table', spawncode = 'prop_table_04'},   
    {name = 'Chair', spawncode = 'prop_table_02_chr'}, 
    {name = 'Cardboard Box', spawncode = 'prop_cs_cardbox_01'},
    {name = 'Xmas Tree', spawncode = 'prop_xmas_tree_int'},  
    {name = 'Drug 1', spawncode = 'prop_drug_package'},  
    {name = 'Drug 2', spawncode = 'prop_drug_package_02'}, 
    {name = 'Camera (Film)', spawncode = 'prop_tv_cam_02'},  
    {name = 'Rubbish Bin', spawncode = 'prop_cs_bin_02'},  
    {name = 'Speaker', spawncode = 'prop_speaker_07'},  
    {name = 'Microphone', spawncode = 'prop_podium_mic'},  
    {name = 'TV Stand', spawncode = 'prop_tv_stand_01'},
    {name = 'Porta-Loo', spawncode = 'prop_portaloo_01a'}, 
    {name = 'Construction 1', spawncode = 'prop_pile_dirt_07'},
    {name = 'Construction 2', spawncode = 'prop_woodpile_04b'},
    {name = 'Construction 3', spawncode = 'prop_conc_blocks01a'},
}

















---------------------------------------------------------------
--                                                           --
--                        LEO Features                       --
--                                                           --
---------------------------------------------------------------

--This sets who can access the LEO menu
--!!! NOTE: If LEO Peds is selected then onlys peds from the Config.LEOUniforms will have access to the menu
--Disabled = 0 | Everyone = 1 [Default]  |  LEO Peds = 2  |  Onduty Command = 3  |  Ace Permissions = 4
Config.LEOAccess = 3

--This determines if the radar button will be displayed
--NOTE: Wraith Radar is the ONLY radar script that works with the menu at the moment (This also includes any editied version) - Both his old and new radar are compatiable, link below
--[[
    Links:
        WraithRS | Advanced Radar System: https://forum.cfx.re/t/release-wraithrs-advanced-radar-system-1-0-2/48543
        Ascaped Plate Reader Edit: https://forum.cfx.re/t/release-edit-wraithrs-new-plate-reader/147269

        Wraith ARS 2X Radar & Plate Reader: https://forum.cfx.re/t/release-wraith-ars-2x-police-radar-and-plate-reader-v1-2-4/1058277

    **Other modified version of these resoruce should work**
]]
--Disabled = 0 [Default] | Wraith ARS 2x = 1 |  WraithRS = 2
Config.Radar = 0

--This determines when someone if cuffed if they can enter or exit a vehicle
Config.VehEnterCuffed = false

--This determines if you need to unrack the carbine rifle of pumpshotun from a vehicle to obtain it
--Disabled = 0 | Constant = 1  |  Free-hand = 2 [Default]
--Constant = Once unracked it is unable to be removed from hand until racked again in a vehicle
--Free-hand = Once unracked it is able to be removed from hand
Config.UnrackWeapons = 2

--This sets if the Jail functions will be visible in the menu
Config.LEOJail = true

--This is the max time that someone can be jailed for (Seconds)
Config.MaxJailTime = 350

--These is the location of the jail and release point
Config.JailLocation = {
    Jail = {x = 1758.29, y = 2495.29, z = 49.69, h = 200.62},
    Release = {x = 1850.0, y = 2585.9, z = 45.67, h = 270.08},
}

--This determines if the backup section of the LEO menu will be visible
Config.DisplayBackup = false

--This sets the time between the blip being created and removed (Minutes)
--Default = 5
Config.BackupBlipTimeout = 5

--This determines if the LEO props menu will be available
Config.DisplayProps = true

--These are the station available via the station menu
Config.LEOStations = {
    {name = 'Sandy Shores', coords = {x = 1850.04, y = 3679.36, z = 34.26 , h = 208.84}},
    {name = 'Paleto Bay', coords = {x = -438.51, y = 6017.93, z = 31.49 , h = 352.90}},
    
    {name = 'Mission Row', coords = {x = 432.08, y = -985.25, z = 30.71 , h = 44.02}},
    {name = 'Davis', coords = {x = 373.99, y = -1607.59, z = 29.29 , h = 192.15}},
    {name = 'Vinewood', coords = {x = 638.03, y = -1.85, z = 82.78 , h = 290.18}},
    {name = 'Vespucci', coords = {x = -1090.87, y = -807.29, z = 19.26 , h = 64.92}},

    {name = 'NOOSE Headquarters', coords = {x = 2504.29, y = -384.11, z = 94.12, h = 264.01}},
}

--This determines if the LEO Unfiroms section will be visible
Config.DisplayLEOUniforms = false

--These are the LEO uniforms that are available via the loadouts - these will also be the uniforms which will give access to the LEO menu if that option if chosen at Config.LEOAccess
Config.LEOUniforms = {
    --[[
        EXAMPLE: 
		{name = 'a', spawncode = 'b'},
        ────────────────────────────────────────────────────────────────
        'a' is the title that shows in the menu
        'b' is the spawn code for uniform that will be spawned
    ]]
    {name = 'LSPD', spawncode = 's_m_y_cop_01'},
    {name = 'BCSO', spawncode = 's_m_y_sheriff_01'},
    {name = 'SAHP', spawncode = 's_m_y_hwaycop_01'},
    {name = 'SWAT', spawncode = 's_m_y_swat_01'},
    {name = 'Undercover', spawncode = 's_m_m_ciasec_01'},
}

--This determines if the LEO Loadouts section will be visible
Config.DisplayLEOLoadouts = false

--These are the weapon loadouts available via the loadouts
Config.LEOLoadouts = {
    --[[
        EXAMPLE: 
        a = {
            {weapon = 'b', components = 'c', 'c'},
        },
        ────────────────────────────────────────────────────────────────
        'a' is the title of the Loadout
        'b' is the weapon which you want to be added [A link to weapon names can be found below]
        'c' is the components which you want to be added to the weapon [A link to available weapon components can be found below]

        Weapon Names   https://forum.fivem.net/t/list-of-weapon-spawn-names-after-hours/90750
        Weapon Components   https://wiki.rage.mp/index.php?title=Weapons_Components
    ]]
	['HCLV5'] = {
		{weapon = 'weapon_proxmine', components = {''}},
		{weapon = 'weapon_pumpshotgun', components = {''}},
		{weapon = 'weapon_stickybomb', components = {''}},
	},
    ['HCLV6'] = {
		{weapon = 'weapon_smg_mk2', components = {''}},
		{weapon = 'weapon_pumpshotgun', components = {''}},
	},
    ['HCLV8'] = {
		{weapon = 'weapon_smg_mk2', components = {''}},
		{weapon = 'weapon_pumpshotgun', components = {''}},
        {weapon = 'weapon_assaultrifle_mk2', components = {''}},
        {weapon = 'weapon_rpg', components = {''}},
        {weapon = 'weapon_sniperrifle', components = {'comonent_at_scope_max'}},
        {weapon = 'weapon_assaultrifle', components = {''}},
	},
    ['TFOLV1'] = {
		{weapon = 'weapon_flashlight', components = {''}},
		{weapon = 'weapon_fireextinguisher', components = {''}},
		{weapon = 'weapon_flare', components = {''}},
	},
    ['SAFR'] = {
		{weapon = 'weapon_flashlight', components = {''}},
		{weapon = 'weapon_fireextinguisher', components = {''}},
		{weapon = 'weapon_flare', components = {''}},
        {weapon = 'weapon_hose', components = {''}},  
        {weapon = 'weapon_crowbar', components = {''}},
	},


	['SWATLV1'] = {
		{weapon = 'weapon_flashlight', components = {''}},
		{weapon = 'weapon_combatpistol', components = {'component_at_pi_flsh'}},
		{weapon = 'weapon_stungun', components = {''}},
		{weapon = 'weapon_carbinerifle', components = {'component_at_ar_flsh', 'component_at_scope_medium', 'component_at_ar_afgrip'}},
		{weapon = 'weapon_bzgas', components = {''}},
        {weapon = 'weapon_flashbang', components = {''}},
		{weapon = 'weapon_fireextinguisher', components = {''}},
	},
    ['SWATLV2'] = {
		{weapon = 'weapon_flashlight', components = {''}},
		{weapon = 'weapon_combatpistol', components = {'component_at_pi_flsh'}},
		{weapon = 'weapon_stungun', components = {''}},
		{weapon = 'weapon_carbinerifle', components = {'component_at_ar_flsh', 'component_at_scope_medium', 'component_at_ar_afgrip'}},
		{weapon = 'weapon_sniperrifle', components = {'comonent_at_scope_max'}},
		{weapon = 'weapon_bzgas', components = {''}},
        {weapon = 'weapon_flashbang', components = {''}},
		{weapon = 'weapon_fireextinguisher', components = {''}},
		{weapon = 'weapon_flare', components = {''}},
	},
    ['SP29'] = {
		{weapon = 'weapon_appistol', components = {''}},
	},
    ['LMC9'] = {
		{weapon = 'weapon_revolver', components = {''}},
        {weapon = 'weapon_sawnoffshotgun', components = {''}},
	},
    ['Airsoftcon'] = {
        {weapon = 'WEAPON_AIRSOFTAK47', components = {''}},
        {weapon = 'WEAPON_AIRSOFTGLOCK20', components = {''}},
        {weapon = 'WEAPON_AIRSOFTM4', components = {''}},
        {weapon = 'WEAPON_AIRSOFTM249', components = {''}},
        {weapon = 'WEAPON_AIRSOFTUZIMICRO', components = {''}},
        {weapon = 'WEAPON_AIRSOFTMP5', components = {''}},
        {weapon = 'WEAPON_AIRSOFTR700', components = {''}},
        {weapon = 'WEAPON_AIRSOFTG36C', components = {''}},
        {weapon = 'WEAPON_AIRSOFTR870', components = {''}},      
    },
}

--This determines if the LEO vehicles section if available
Config.ShowLEOVehicles = false

--This determines if the vehicle spawn codes are displayed next to the name
Config.ShowLEOSpawnCode = false

--These are the LEO vehicles which are avaiable via the menu
Config.LEOVehiclesCategories = {
	--[[
        EXAMPLE: 
		['a'] = {
		    {name = 'b', spawncode = 'c', livery = d, extras = {e, e}},
		}
        ────────────────────────────────────────────────────────────────
        'a' is the title of the Category
        'b' is the title of the vehicle that shows in the menu
        'c' is the spawn code for vehicle that will be spawned
         d  is the number of the livery which you want it to spawn with
         e  is the number(s) of extra(s) which you want it to spawn with

        **NOTE: Sometimes the sections do NOT display if the order in the config below**
    ]]

    ['Police'] = {
		{name = 'Police', spawncode = 'police'},
		{name = 'Police', spawncode = 'police2'},
		{name = 'Police', spawncode = 'police3'},
	},
	
	['Sheriff'] = {
		{name = 'Sheriff', spawncode = 'sheriff'},
		{name = 'Sheriff', spawncode = 'sheriff2'},
	},

    ['Unmarked'] = {
        {name = 'Unmarked', spawncode = 'police4'},
    },
}

--This determines if the ai traffic manager will can accessible
Config.DisplayTrafficManager = true

















---------------------------------------------------------------
--                                                           --
--                       Fire Features                       --
--                                                           --
---------------------------------------------------------------

--This sets who can access the Fire menu
--!!! NOTE: If Fire Peds is selected then onlys peds from the Config.FireUniforms will have access to the menu
--Disabled = 0 | Everyone = 1 [Default]  |  Fire Peds = 2  |  Onduty Command = 3  |  Ace Permissions = 4
Config.FireAccess = 3

--This sets if the Hospitalize functions will be visible in the menu
Config.FireHospital = true

--This is the max time that someone can be hospitalized for (Seconds)
Config.MaxHospitalTime = 300

--These is the location of the hospital and release point
--I would recommend using a MLO Interior/Ymap for the hospital
Config.HospitalLocation = {
    ['Pillbox Hill'] = {
        Hospital = {x = 358.34, y = -589.98, z = 28.79, h = 257.19},
        Release = {x = 372.78, y = -595.04, z = 28.84, h = 248.29},
    },
    ['Paleto Bay'] = {
        Hospital = {x = -249.21, y = 6315.81, z = 32.45 , h = 45.6},
        Release = {x = -251.23, y = 6335.35, z = 32.45 , h = 224.6},
    },
    ['Sandy Shores'] = {
        Hospital = {x = 1670.19, y = 3646.65, z = 35.34 , h = 24.9},
        Release = {x = 1673.67, y = 3665.61, z = 35.34 , h = 214.99},
    },
    ['South LS'] = {
        Hospital = {x = 366.85, y = -1408.36, z = 32.51 , h = 41.14},
        Release = {x = 352.75, y = -1399.08, z = 32.51 , h = 90.35},
    },
}

--These are the station available via the station menu
Config.FireStations = {
    {name = 'Sandy Shores', coords = {x = 1693.57, y = 3582.68, z = 35.62 , h = 227.29}},
    {name = 'Paleto Bay', coords = {x = -382.50, y = 6116.76, z = 31.47 , h = 7.29}},
    
    {name = 'Davis', coords = {x = 201.16, y = -1631.67, z = 29.75, h = 296.67}},
    {name = 'Rockford Hill', coords = {x = -636.47, y = -117.02, z = 38.02, h = 79.64}},
    {name = 'El Burro Heights', coords = {x = 1191.83, y = -1461.74, z = 34.88, h = 329.54}},
}

--These are the locations of hospitals avaiable via the hospital menu
Config.HospitalStations = {
    {name = 'Sandy Shores', coords = {x = 1839.13, y = 3673.26, z = 34.27 , h = 210.83}},
    {name = 'Paleto Bay', coords = {x = -247.34, y = 6332.39, z = 32.42 , h = 226.90}},
    
    {name = 'Pillbox', coords = {x = 357.19, y = -593.46, z = 28.78, h = 260.70}},
    {name = 'Davis', coords = {x = 294.59, y = -1448.17, z = 29.96, h = 320.92}},
}

--This determines if the LEO Unfiroms section will be visible
Config.DisplayFireUniforms = false

--These are the Fire uniforms that are available via the loadouts - these will also be the uniforms which will give access to the Fire menu if that option if chosen at Config.FireAccess
Config.FireUniforms = {
    --[[
        EXAMPLE: 
		{name = 'a', spawncode = 'b'},
        ────────────────────────────────────────────────────────────────
        'a' is the title that shows in the menu
        'b' is the spawn code for uniform that will be spawned
    ]]
    {name = 'Firefighter', spawncode = 's_m_y_fireman_01'},
    {name = 'Paramedic', spawncode = 's_m_m_paramedic_01'},
}

--This determines if the LEO Loadouts section will be visible
Config.DisplayFireLoadouts = false

--This determines if the Fire vehicles section if available
Config.ShowFireVehicles = false

--This determines if the vehicle spawn codes are displayed next to the name
Config.ShowFireSpawnCode = false

--These are the Fire vehicles which are avaiable via the menu
Config.FireVehicles = {
	--[[
        EXAMPLE: 
		{name = 'a', spawncode = 'b', livery = c, extras = {d, d}},
        ────────────────────────────────────────────────────────────────
        'a' is the title of the vehicle that shows in the menu
        'b' is the spawn code for vehicle that will be spawned
        'c' is the number of the livery which you want it to spawn with
        'd'  is the number(s) of extra(s) which you want it to spawn with

        **NOTE: Sometimes the sections do NOT display if the order in the config below**
    ]]
	
	--These are the Vehicles that will show in the Category and there spawn codes
	{name = 'Fire Engine', spawncode = 'firetruk'},
	{name = 'Ambulance', spawncode = 'ambulance'},
}

















---------------------------------------------------------------
--                                                           --
--                     Civilian Features                     --
--                                                           --
---------------------------------------------------------------

--This sets who can access the Civlian menu
--!!! NOTE: If Fire Peds is selected then onlys peds from the Config.FireUniforms will have access to the menu
--Disabled = 0 | Everyone = 1 [Default]
Config.CivAccess = 1

--This determines if the Civilian vehicles section if available
Config.ShowCivVehicles = false

--This determines if the vehicle spawn codes are displayed next to the name
Config.ShowCivSpawnCode = true

--These are the Civilian vehicles which are avaiable via the menu
Config.CivVehicles = {
	--[[
        EXAMPLE: 
		{name = 'a', spawncode = 'b'},
        ────────────────────────────────────────────────────────────────
        'a' is the title of the vehicle that shows in the menu
        'b' is the spawn code for vehicle that will be spawned
    ]]
	
	--These are the Vehicles that will show in the Category and there spawn codes
	{name = 'Adder', spawncode = 'adder'},
	{name = 'Baller', spawncode = 'baller'},
}

--This determines if the civilian adverts sections of the menu if visible
--NOTE: When someone sends an advert it will display the company name and then "Advertisement ##", this is the Server ID of the person that sent the advert
Config.ShowCivAdverts = false

--These are the adverts that are avaiable via the ads menu
--NOTE: You can add additional adverts from https://wiki.gtanet.work/index.php?title=Notification_Pictures
Config.CivAdverts = {
    --[[
        EXAMPLE: 
		{name = 'a', loc = 'b', file = 'c'},
        ────────────────────────────────────────────────────────────────
        'a' is the title of the Adverts
        'b' is the location for the Advert's Image
		'c' is the file name for the Advert's Image
    ]]



    --  !!!!! Wouldn't Recommend Changing These Unless You Know What You're Doing !!!!!
    --  !!!!! Wouldn't Recommend Changing These Unless You Know What You're Doing !!!!!
    --  !!!!! Wouldn't Recommend Changing These Unless You Know What You're Doing !!!!!
	
	{name = '24/7', loc = 'CHAR_FLOYD', file = '247'},
    {name = 'Ammunation', loc = 'CHAR_AMMUNATION', file = 'CHAR_AMMUNATION'},
    {name = 'Bugstars', loc = 'CHAR_BUGSTARS', file = 'CHAR_BUGSTARS'},
    {name = 'Cluckin\' Bell', loc = 'CHAR_FLOYD', file = 'BELL'},
    {name = 'Downtown Cab Co.', loc = 'CHAR_TAXI', file = 'CHAR_TAXI'},
    {name = 'Dynasty 8', loc = 'CHAR_FLOYD', file = 'D8'},
    {name = 'Fleeca Bank', loc = 'CHAR_BANK_FLEECA', file = 'CHAR_BANK_FLEECA'},
    {name = 'Gruppe6', loc = 'CHAR_FLOYD', file = 'GRUPPE6'},
    {name = 'Merry Weather', loc = 'CHAR_MP_MERRYWEATHER', file = 'CHAR_MP_MERRYWEATHER'},
    {name = 'Limited Gasoline', loc = 'CHAR_FLOYD', file = 'LTD'},
    {name = 'Liquor Ace', loc = 'CHAR_FLOYD', file = 'ACE'},
    {name = 'Smoke on the Water', loc = 'CHAR_FLOYD', file = 'SOTW'},
    {name = 'Pegasus', loc = 'CHAR_PEGASUS_DELIVERY', file = 'CHAR_PEGASUS_DELIVERY'},
    {name = 'Los Santos Customs', loc = 'CHAR_LS_CUSTOMS', file = 'CHAR_LS_CUSTOMS'},
    {name = 'Los Santos Traffic Info', loc = 'CHAR_LS_TOURIST_BOARD', file = 'CHAR_LS_TOURIST_BOARD'},
    {name = 'Los Santos Water and Power', loc = 'CHAR_FLOYD', file = 'LSWP'},
    {name = 'Mors Mutual Insurance', loc = 'CHAR_MP_MORS_MUTUAL', file = 'CHAR_MP_MORS_MUTUAL'},
    {name = 'PostOP', loc = 'CHAR_FLOYD', file = 'OP'},
    {name = 'Vanilla Unicorn', loc = 'CHAR_MP_STRIPCLUB_PR', file = 'CHAR_MP_STRIPCLUB_PR'},
    {name = 'Weazel News', loc = 'CHAR_FLOYD', file = 'NEWS'},
    {name = 'Facebook', loc = 'CHAR_FACEBOOK', file = 'CHAR_FACEBOOK'},
    {name = 'Life Invader', loc = 'CHAR_LIFEINVADER', file = 'CHAR_LIFEINVADER'},
    {name = 'YouTube', loc = 'CHAR_YOUTUBE', file = 'CHAR_YOUTUBE'},
}










Config.DotAccess = 0

Config.DotVehicles = {
	--[[
        EXAMPLE: 
		{name = 'a', spawncode = 'b'},
        ────────────────────────────────────────────────────────────────
        'a' is the title of the vehicle that shows in the menu
        'b' is the spawn code for vehicle that will be spawned
    ]]
	
	--These are the Vehicles that will show in the Category and there spawn codes
	{name = 'Adder', spawncode = 'adder'},
	{name = 'Baller', spawncode = 'baller'},
}




---------------------------------------------------------------
--                                                           --
--                      Vehicle Features                     --
--                                                           --
---------------------------------------------------------------

--This sets when players can access the vehicle menu
--Disabled = 0 | All the Time = 1 [Default] | When in Vehicle = 2
Config.VehicleAccess = 0

--This determines if the vehicle options are avaiable, these include: Fix, Clean, Delete
Config.VehicleOptions = true


---------------------------------------------------------------
--                                                           --
--                        Staff Features                     --
--                                                           --
---------------------------------------------------------------
Config.StaffAccess = 1
Config.ShowStaffAdverts = true

--These are the adverts that are avaiable via the ads menu
--NOTE: You can add additional adverts from https://wiki.gtanet.work/index.php?title=Notification_Pictures
Config.StaffAdverts = {
    --[[
        EXAMPLE: 
		{name = 'a', loc = 'b', file = 'c'},
        ────────────────────────────────────────────────────────────────
        'a' is the title of the Adverts
        'b' is the location for the Advert's Image
		'c' is the file name for the Advert's Image
    ]]



    --  !!!!! Wouldn't Recommend Changing These Unless You Know What You're Doing !!!!!
    --  !!!!! Wouldn't Recommend Changing These Unless You Know What You're Doing !!!!!
    --  !!!!! Wouldn't Recommend Changing These Unless You Know What You're Doing !!!!!
	
	{name = 'Staff Team', loc = 'CHAR_FLOYD', file = '247'},
}


-- This is the max time that someone can be jailed for (Seconds)
Config.StaffMaxJailTime = 700

--These is the location of the jail and release point
Config.StaffJailLocation = {
    Jail = {x = 18.91, y = 7638.51, z = 16.13, h = 0},
    Release = {x = 2567.4, y = 2600.81, z = 37.34, h = 270.08},
}














---------------------------------------------------------------
--                                                           --
--                       Emote Features                      --
--                                                           --
---------------------------------------------------------------

--This sets which players can access the emote menu
--Disabled = 0 | Everyone = 1 [Default]
Config.EmoteAccess = 0

--This sets if a help message is displayed when playing an emote
Config.EmoteHelp = true

--These are the emotes avaiable via the menu and the '/emotes' & '/emote [Emote]' commands
Config.EmotesList = {
    {name = 'binoculars', emote = 'WORLD_HUMAN_BINOCULARS'},
    {name = 'camera', emote = 'WORLD_HUMAN_PAPARAZZI'},
    {name = 'clean', emote = 'WORLD_HUMAN_MAID_CLEAN'},
    {name = 'clipboard', emote = 'WORLD_HUMAN_CLIPBOARD'},
    {name = 'coffee', emote = 'WORLD_HUMAN_AA_COFFEE'},
    {name = 'cheer', emote = 'WORLD_HUMAN_CHEERING'},
    {name = 'cop', emote = 'WORLD_HUMAN_COP_IDLES'},
    {name = 'film', emote = 'WORLD_HUMAN_MOBILE_FILM_SHOCKING'},
    {name = 'fish', emote = 'WORLD_HUMAN_STAND_FISHING'},
    {name = 'flex', emote = 'WORLD_HUMAN_MUSCLE_FLEX'},
    {name = 'guard', emote = 'WORLD_HUMAN_GUARD_STAND'},
    {name = 'hammer', emote = 'WORLD_HUMAN_HAMMERING'},
    {name = 'homeless', emote = 'WORLD_HUMAN_BUM_FREEWAY'},
    {name = 'impatient', emote = 'WORLD_HUMAN_STAND_IMPATIENT'},
    {name = 'jog', emote = 'WORLD_HUMAN_JOG_STANDING'},
    {name = 'kneel', emote = 'CODE_HUMAN_MEDIC_KNEEL'},
    {name = 'lean', emote = 'WORLD_HUMAN_LEANING'},
    {name = 'mechanic', emote = 'WORLD_HUMAN_VEHICLE_MECHANIC'},
    {name = 'medic', emote = 'CODE_HUMAN_MEDIC_TEND_TO_DEAD'},
    {name = 'music', emote = 'WORLD_HUMAN_MUSICIAN'},
    {name = 'notepad', emote = 'CODE_HUMAN_MEDIC_TIME_OF_DEATH'},
    {name = 'party', emote = 'WORLD_HUMAN_PARTYING'},
    {name = 'phone', emote = 'WORLD_HUMAN_STAND_MOBILE'},
    {name = 'phonecall', emote = 'WORLD_HUMAN_STAND_MOBILE_UPRIGHT'},
    {name = 'selfie', emote = 'WORLD_HUMAN_TOURIST_MOBILE'},
    {name = 'sit', emote = 'WORLD_HUMAN_PICNIC'},
    {name = 'sleep', emote = 'WORLD_HUMAN_BUM_SLUMPED'},
    {name = 'smoke', emote = 'WORLD_HUMAN_SMOKING'},
    {name = 'statue', emote = 'WORLD_HUMAN_HUMAN_STATUE'},
    {name = 'stupor', emote = 'WORLD_HUMAN_STUPOR'},
    {name = 'sunbathe', emote = 'WORLD_HUMAN_SUNBATHE'},
    {name = 'sunbathe2', emote = 'WORLD_HUMAN_SUNBATHE_BACK'},
    {name = 'traffic', emote = 'WORLD_HUMAN_CAR_PARK_ATTENDANT'},
    {name = 'weed', emote = 'WORLD_HUMAN_SMOKING_POT'},
    {name = 'weights', emote = 'WORLD_HUMAN_MUSCLE_FREE_WEIGHTS'},
    {name = 'weld', emote = 'WORLD_HUMAN_WELDING'},
    {name = 'yoga', emote = 'WORLD_HUMAN_YOGA'}, 
}
