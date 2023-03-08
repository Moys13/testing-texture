//This server made by
//Edited by: Moyo

#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <a_mysql>
#include <a_vehicles>
#include <streamer>
#include <foreach>
#include <easyDialog>
#include <components/mSelection>
#include <discord-connector>
#include <mapandreas>


#pragma tabsize 0

//==============INCLUDE MAPPING============
#include "components/mapping/palomino"
#include "components/mapping/asgh"
#include "components/mapping/tinju"
#include "components/mapping/verona"
#include "components/mapping/market"
#include "components/mapping/sweeper"
//=========================================
//===============CHECKPOINT================
#include "modules/Sweepjob/sweepcheckpoint.inc"
//=========================================

//HUD				
new Text:PublicTD[4];
new hideinfo[MAX_PLAYERS];
//All god
new godmode [MAX_PLAYERS];

static RemVeh[MAX_PLAYERS] = { -1, ... };
static bool:IsRemVeh[MAX_VEHICLES] = { false, ... };
new vgod[MAX_PLAYERS];
new jumpmode[MAX_PLAYERS];

new sniperworld[MAX_PLAYERS];

//=======Pickup=======
new pintutinju;
new pintuverdant;
new pintukeluarverdant;

#define COL_WHITE	(0xffffffFF)   
#define COL_BLACk	(0x000000FF)   
#define COL_RED		(0xff0000FF)
#define COL_ORANGE	(0xffaa00FF)
#define COL_GREEN	(0x00ff15FF)
#define COL_YELLOW	(0xd9ff00FF)
#define COLOR_STEEL_BLUE (0x4682B4FF)
#define COLOR_FIREBRICK	(0x4682B4FF)
#define COLOR_DODGER_BLUE (0x1E90FFFF)
#define COL_PINK 	(0xff00aeFF)



#define SCM SendClientMessage
#define function:%0(%1) forward %0(%1); public %0(%1)
#define SCMex SendClientMessageEx
#define tele (13)
#define fight (16)
#define DIALOG_DROP (47)
#define BBPlay (22)
#define DIALOG_LEAVEDM (54)

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

// PRESSED(keys)
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

//========Tune Dialogs=========
#define DIALOG_MAIN 			903
#define DIALOG_PAINTJOBS 		904
#define DIALOG_COLORS 			905
#define DIALOG_EXHAUSTS 		906
#define DIALOG_FBUMPS 			907
#define DIALOG_RBUMPS 			908
#define DIALOG_ROOFS    		909
#define DIALOG_SPOILERS 		910
#define DIALOG_SIDESKIRTS 		911
#define DIALOG_BULLBARS 		912
#define DIALOG_WHEELS 			913
#define DIALOG_CSTEREO 			914
#define DIALOG_HYDRAULICS 		915
#define DIALOG_NITRO 			916
#define DIALOG_LIGHTS 			917
#define DIALOG_HOODS 			918
#define DIALOG_VENTS 			919

//===========Dialogs==========

#define DIALOG_REGISTER (0)
#define DIALOG_LOGIN (1)


//===========statik===========

static stock g_arrVehicleNames[][] = {
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
    "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Cruiser", "SFPD Cruiser", "LVPD Cruiser",
    "Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};

//=============Vehicle Select==============

#define VEHICLE_TYPE_CAR        "Car"
#define VEHICLE_TYPE_MOTORBIKE  "Motorcycle"
#define VEHICLE_TYPE_AIR        "Aircraft"
#define VEHICLE_TYPE_BOAT       "Boat"
#define VEHICLE_TYPE_TRAILER    "Trailer"
#define VEHICLE_TYPE_RC         "RC Toy"
#define VEHICLE_TYPE_OTHERS     "Train & Others"
#define VEHICLE_TYPE_BIKE       "Bicycle"

//===========Mysql============
new MySQL:ourconnection;

#define MYSQL_HOSTNAME		"localhost"
#define MYSQL_USERNAME		"root"
#define MYSQL_PASSWORD		""
#define MYSQL_DATABASE		"datasamp"

//============================

//=========Data Akun============
enum p_Account_Data
{
	pDBID,
	pAccname [60],
	pSkin,
	bool: pLoggedin,
	pAdmin,
	pMoney,
	pSweeping
}


new dropCampfire[MAX_PLAYERS][1];
new dropBoombox[MAX_PLAYERS][1];
new campFire[MAX_PLAYERS];
new boomBox[MAX_PLAYERS];
new Text3D:Label_Boombox;

//======Register & loging Stuff======

new joinskin = mS_INVALID_LISTID;
new playerLogin[MAX_PLAYERS];

//========Discord==========
new DCC_Channel:g_Discord_Chat;
new chatdc [MAX_PLAYERS];
//==========================

new selectskin = mS_INVALID_LISTID;

new AccountInfo[MAX_PLAYERS][p_Account_Data];

//========Speedometer===========
new speedactive[MAX_PLAYERS];
new speedinfo[MAX_PLAYERS];
new PlayerText:speed[MAX_PLAYERS][4];
//==============================

main()
{
	g_Discord_Chat = DCC_FindChannelById("855808643123380265");//ID channel Discord
	print("\n------------------------");
	print(" Server ini milik bagas");
	print("------------------------\n");
}

public OnGameModeInit()
{
	MapAndreas_Init(MAP_ANDREAS_MODE_FULL, "scriptfiles/SAFull.hmap");
	
	AddCharModel(305, 20001, "lvpdpc2.dff", "lvpdpc2.txd");
	AddCharModel(305, 20002, "lapdpd2.dff", "lapdpd2.txd");

	DisableInteriorEnterExits();
	ourconnection = mysql_connect(MYSQL_HOSTNAME, MYSQL_USERNAME, MYSQL_PASSWORD, MYSQL_DATABASE);
	if(ourconnection == MYSQL_INVALID_HANDLE || mysql_errno(ourconnection) != 0)
	{
		print("SERVER: MySQL Connection failed, shutting the server down!");
		return 1;
	}
	SetGameModeText("Moyo");
	print("SERVER: MySQL Connection was successful.");

	joinskin = LoadModelSelectionMenu("skins.txt");
	selectskin = LoadModelSelectionMenu("skins.txt");
//=========================LOAD MAPPINGAN===================================
	loadMappingVerona();
	loadMappingAsgh();
	loadMappingPalomino();
	loadMappingTinju();
	loadMappingMarket();
	loadMappingSweeper();
//==========================================================================
	SetTimer("ReturnDate", 1000, true);
	SetTimer("infoplayer", 100, true);
	//Textdraws
	PublicTD[0] = TextDrawCreate(579.000000, 22.000000, "00:00");//Jam
	TextDrawFont(PublicTD[0], 3);
	TextDrawLetterSize(PublicTD[0], 0.420831, 1.749999);
	TextDrawTextSize(PublicTD[0], 396.500000, 54.000000);
	TextDrawSetOutline(PublicTD[0], 2);
	TextDrawSetShadow(PublicTD[0], 0);
	TextDrawAlignment(PublicTD[0], 2);
	TextDrawColor(PublicTD[0], -1);
	TextDrawBackgroundColor(PublicTD[0], 255);
	TextDrawBoxColor(PublicTD[0], 50);
	TextDrawUseBox(PublicTD[0], 0);
	TextDrawSetProportional(PublicTD[0], 1);
	TextDrawSetSelectable(PublicTD[0], 0);

	PublicTD[1] = TextDrawCreate(579.000000, 39.000000, "00.00.0000");//Tanggal
	TextDrawFont(PublicTD[1], 3);
	TextDrawLetterSize(PublicTD[1], 0.274997, 1.299997);
	TextDrawTextSize(PublicTD[1], 400.000000, 17.000000);
	TextDrawSetOutline(PublicTD[1], 2);
	TextDrawSetShadow(PublicTD[1], 0);
	TextDrawAlignment(PublicTD[1], 2);
	TextDrawColor(PublicTD[1], -1);
	TextDrawBackgroundColor(PublicTD[1], 255);
	TextDrawBoxColor(PublicTD[1], 50);
	TextDrawUseBox(PublicTD[1], 0);
	TextDrawSetProportional(PublicTD[1], 1);
	TextDrawSetSelectable(PublicTD[1], 0);

	PublicTD[2] = TextDrawCreate(535.000000, 3.000000, "Moyo Freeroam");//nama server
	TextDrawFont(PublicTD[2], 1);
	TextDrawLetterSize(PublicTD[2], 0.345833, 1.350000);
	TextDrawTextSize(PublicTD[2], 709.000000, 17.000000);
	TextDrawSetOutline(PublicTD[2], 1);
	TextDrawSetShadow(PublicTD[2], 0);
	TextDrawAlignment(PublicTD[2], 1);
	TextDrawColor(PublicTD[2], 16777215);
	TextDrawBackgroundColor(PublicTD[2], 255);
	TextDrawBoxColor(PublicTD[2], 50);
	TextDrawUseBox(PublicTD[2], 0);
	TextDrawSetProportional(PublicTD[2], 1);
	TextDrawSetSelectable(PublicTD[2], 0);
	
	PublicTD[3] = TextDrawCreate(318.000000, 435.000000, "VID:_3_|_POS:_xyz_|_WID:_3_|_INT:_5");
	TextDrawFont(PublicTD[3], 2);
	TextDrawLetterSize(PublicTD[3], 0.279166, 1.350000);
	TextDrawTextSize(PublicTD[3], 12.000000, 640.000000);
	TextDrawSetOutline(PublicTD[3], 0);
	TextDrawSetShadow(PublicTD[3], 0);
	TextDrawAlignment(PublicTD[3], 2);
	TextDrawColor(PublicTD[3], -1);
	TextDrawBackgroundColor(PublicTD[3], 255);
	TextDrawBoxColor(PublicTD[3], 101);
	TextDrawUseBox(PublicTD[3], 1);
	TextDrawSetProportional(PublicTD[3], 1);
	TextDrawSetSelectable(PublicTD[3], 0);

	pintutinju = CreatePickup(19133, 1, 871.8083,-1293.5560,3001.0859, -1);
	pintuverdant = CreatePickup(1273, 1, 1122.7091,-2037.0099,69.8942, -1);
	pintukeluarverdant = CreatePickup(1273, 1, 1260.6509,-785.4543,1091.9063, -1);

	// =====================SWEEPER JOB========================
	CreateVehicle(574,433.449,-1360.448,14.532,31.414,6,6,-1,0);
    CreateVehicle(574,437.099,-1358.218,14.538,30.034,6,5,-1,0);
    CreateVehicle(574,441.202,-1355.651,14.545,32.059,6,0,-1,0);
    CreateVehicle(574,444.897,-1353.384,14.550,30.334,6,6,-1,0);
	// ========================================================

	
	return 1;
}

public OnGameModeExit()
{
	foreach(Player, i) 
	{
		saveData(i);
	}
	mysql_close(ourconnection);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(AccountInfo[playerid][pLoggedin] == false)
	{
		SetSpawnInfo( playerid, 0, 0, 563.3157, 3315.2559, 0, 269.15, 0, 0, 0, 0, 0, 0 );
		ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
		TogglePlayerSpectating(playerid, true);
		TogglePlayerSpectating(playerid, false);
		SetPlayerCamera(playerid);
		return 1;
	}
	SetSpawnInfo(playerid, 0, AccountInfo[playerid][pSkin], 929.0081,-1720.4331,13.5465,80.3241,0,0,0,0,0,0);
 	SpawnPlayer(playerid);
	return 0;
}

public OnPlayerConnect(playerid)
{
	speed[playerid][0] = CreatePlayerTextDraw(playerid, 528.982299, 183.216751, "box");
	PlayerTextDrawLetterSize(playerid, speed[playerid][0], 0.000000, 6.720351);
	PlayerTextDrawTextSize(playerid, speed[playerid][0], 640.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, speed[playerid][0], 1);
	PlayerTextDrawColor(playerid, speed[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, speed[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, speed[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, speed[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, speed[playerid][0], 255);
	PlayerTextDrawFont(playerid, speed[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, speed[playerid][0], 1);

	speed[playerid][1] = CreatePlayerTextDraw(playerid, 562.679992, 164.916641, "Turismo");
	PlayerTextDrawLetterSize(playerid, speed[playerid][1], 0.446851, 2.014167);
	PlayerTextDrawTextSize(playerid, speed[playerid][1], -3.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, speed[playerid][1], 1);
	PlayerTextDrawColor(playerid, speed[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, speed[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, speed[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, speed[playerid][1], 255);
	PlayerTextDrawFont(playerid, speed[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, speed[playerid][1], 1);

	speed[playerid][2] = CreatePlayerTextDraw(playerid, 531.757141, 190.583374, "Speed:_200_KM/H");
	PlayerTextDrawLetterSize(playerid, speed[playerid][2], 0.249604, 1.454166);
	PlayerTextDrawAlignment(playerid, speed[playerid][2], 1);
	PlayerTextDrawColor(playerid, speed[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, speed[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, speed[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, speed[playerid][2], 255);
	PlayerTextDrawFont(playerid, speed[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, speed[playerid][2], 1);

	speed[playerid][3] = CreatePlayerTextDraw(playerid, 532.388793, 217.416625, "HEALTH:_100");
	PlayerTextDrawLetterSize(playerid, speed[playerid][3], 0.231332, 1.494999);
	PlayerTextDrawAlignment(playerid, speed[playerid][3], 1);
	PlayerTextDrawColor(playerid, speed[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, speed[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, speed[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, speed[playerid][3], 255);
	PlayerTextDrawFont(playerid, speed[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, speed[playerid][3], 1);
	
	speedactive[playerid] = 1;
	
	new string[120], pName[MAX_PLAYER_NAME];
    GetPlayerName(playerid,pName,MAX_PLAYER_NAME);
    format(string,sizeof string,"%s has joined the server. Welcome!",pName);
    SendClientMessageToAll(COL_PINK,string);

	//Remove Buildings///////////////////////////////////////////////////////////////////////////////////////////////
	removeBuildingVerona(playerid);
	removeBuildingSweeper(playerid);
	/////////////////////////////////////////////////////////////////////////////////////////
	
	SetPlayerCamera(playerid);
	ResetPlayer(playerid);

	new existCheck [250];
	mysql_format(ourconnection, existCheck, sizeof(existCheck), "SELECT * FROM `accounts` WHERE `acc_name` = '%e'", ReturnName(playerid));
	mysql_tquery(ourconnection, existCheck, "Logplayerin", "d", playerid);
	
	
	SetPlayerInterior(playerid, 0);
	sniperworld[playerid] = false;
	campFire[playerid] = 0;
	boomBox[playerid] = 0;
	AccountInfo[playerid][pSweeping] = 0;
	
	TextDrawHideForAll(PublicTD[3]);
	hideinfo[playerid] = 0;
	
	for(new w = 0; w < 4; w++)
	{
	TextDrawShowForPlayer(playerid, PublicTD[w]);
	}

	chatdc[playerid] = 0;
    new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof name);
    if (_:g_Discord_Chat == 0)
	g_Discord_Chat = DCC_FindChannelById("855808643123380265");//ID channel Discord
    format(string, sizeof string, " ```%s telah memasuki server!```", name);
    DCC_SendChannelMessage(g_Discord_Chat, string);

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	 new
        szString[64],
        playerName[MAX_PLAYER_NAME];
 
    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);
 
    new szDisconnectReason[3][] =
    {
        "Timeout/Crash",
        "Quit",
        "Kick/Ban"
    };
	
	saveData(playerid);

    format(szString, sizeof szString, "%s left the server (%s).", playerName, szDisconnectReason[reason]);
	SendClientMessageToAll(COL_PINK, szString);
	
	AccountInfo[playerid][pSweeping] = 0;

	new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof name);
    if (_:g_Discord_Chat == 0)
    g_Discord_Chat = DCC_FindChannelById("856012335679143967"); // Discord channel ID
    new string[128];
    format(string, sizeof string, " ```%s telah keluar dari server!```", name);
    DCC_SendChannelMessage(g_Discord_Chat, string);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(godmode[playerid]==1)
	{  
		SetPlayerHealth(playerid,1000000);    
	}
	else 
	{
		SetPlayerHealth(playerid,100.0);
	}
	if(sniperworld[playerid] == 1)
	{
		setspawnsniper(playerid);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SendDeathMessage(killerid, playerid, reason);
	GivePlayerMoney(killerid, 500);
	SetPlayerScore(killerid, 1);
	DisablePlayerCheckpoint(playerid);
	if(AccountInfo[playerid][pSweeping] == 1)
	{
		SetVehicleToRespawn(GetPlayerVehicleID(playerid));
		AccountInfo[playerid][pSweeping] = 0;
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	new playerid;
	if(GetVehicleModel(574))
	{
		SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(chatdc[playerid] == 1)
    {
    new name[MAX_PLAYER_NAME + 1];
    new pText[144];
    format(pText, sizeof (pText), "{ff00ae}[LIVE DISCORD] {aa1bb5}: {ffffff}%s", text);
    SendPlayerMessageToAll(playerid, pText);
    GetPlayerName(playerid, name, sizeof name);
    new msg[128];
    format(msg, sizeof(msg), "```%s: %s```", name, text);
    DCC_SendChannelMessage(g_Discord_Chat, msg);
    return 0;
    }
	return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	if(GetPVarType(playerid, "CMD_muted") != PLAYER_VARTYPE_NONE)
	{
		SCM(playerid, COL_RED, "kamu sedang berapa di dalam Death Match!");
		return 0;
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if (vgod[playerid] == 1)
	{
		vgod[playerid] = 0;
		SetVehicleHealth(GetPlayerVehicleID(playerid), 1000);
	}
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 574)
	{
		AccountInfo[playerid][pSweeping] = 0;
		SCM(playerid, COL_RED, "Sweeper: Kamu keluar dari kendaraan otomatis Sweeper gagal");
		SetVehicleToRespawn(GetPlayerVehicleID(playerid));
		DisablePlayerCheckpoint(playerid);
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(oldstate == PLAYER_STATE_DRIVER && RemVeh[playerid] != -1)
	{
		IsRemVeh[RemVeh[playerid]] = false;
		DestroyVehicle(RemVeh[playerid]);
		RemVeh[playerid] = -1;
	}
	if(newstate == PLAYER_STATE_DRIVER && GetVehicleModel(GetPlayerVehicleID(playerid)) == 574)
	{
			AccountInfo[playerid][pSweeping] = 1;
			SCM(playerid, COL_GREEN, "Sweeper: Ikuti Checkpoint yang ada di map!");
			Dialog_Show(playerid, DIALOG_SWEEPER , DIALOG_STYLE_LIST, "Sweeper", "SMB\nRodeo\nTemple\nMarket", "Select", "Cancel");
	}
	if(speedactive[playerid] == 1)
	{
		if(newstate == PLAYER_STATE_DRIVER)
		{
			PlayerTextDrawShow(playerid, speed[playerid][0]);
			PlayerTextDrawShow(playerid, speed[playerid][1]);
			PlayerTextDrawShow(playerid, speed[playerid][2]);
			PlayerTextDrawShow(playerid, speed[playerid][3]);
	        speedinfo[playerid] = SetTimerEx("speedometer",1000,1,"d",playerid);
		}
		if(oldstate == PLAYER_STATE_DRIVER)
		{
			PlayerTextDrawHide(playerid, speed[playerid][0]);		
			PlayerTextDrawHide(playerid, speed[playerid][1]);
			PlayerTextDrawHide(playerid, speed[playerid][2]);
			PlayerTextDrawHide(playerid, speed[playerid][3]);
			KillTimer(speedinfo[playerid]);
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	sweepSmbCheckpoint(playerid);
	sweepRodeoCheckpoint(playerid);
	sweepTempleCheckpoint(playerid);
	sweepMarketCheckpoint(playerid);
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if (pickupid == pintutinju)
	{
		SetPlayerSkin(playerid, AccountInfo[playerid][pSkin]);
		SpawnPlayer(playerid);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
	}
	if (pickupid == pintuverdant)
	{
		SetPlayerPos(playerid, 1262.6552,-785.3302,1091.9063);
		SetPlayerInterior(playerid, 5);
	}
	if (pickupid == pintukeluarverdant)
	{
		SetPlayerPos(playerid, 1125.1886,-2036.5970,69.8822);
		SetPlayerInterior(playerid, 0);
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (PRESSED(KEY_LOOK_BEHIND))
    {
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			SetVehicleSpeed(GetPlayerVehicleID(playerid), 200, true);
	}
	if (PRESSED(KEY_YES))
	{
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		ShowPlayerTuneDialog(playerid);
	}
	if(PRESSED(KEY_JUMP))
	{
		if(jumpmode[playerid] == 1)
		{
			static Float:velo[3];
			GetPlayerVelocity(playerid,velo[0],velo[1],velo[2]);
			SetPlayerVelocity(playerid,velo[0],velo[1],velo[2]+1.0);
		}
	}
	if(PRESSED(KEY_NO))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new Float:angle;
			new vehid = GetPlayerVehicleID(playerid);
			GetVehicleZAngle(vehid,angle);
			SetVehicleZAngle(vehid,angle);
		}
	}
	if(PRESSED(KEY_CTRL_BACK))
	{
		if(sniperworld[playerid] == 1)
		{
			sniperworld[playerid] = 0;
			ShowPlayerDialog(playerid, DIALOG_LEAVEDM, DIALOG_STYLE_MSGBOX, "Death Match", "Apakah kamu akan keluar dari Death Match?", "yes", "No");
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_REGISTER:
		{
			if(!response)
				return Kick(playerid);

			new insert [250];

			if(strlen(inputtext) > 120 || strlen(inputtext) < 3)
				return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Selamat datang di server ini", "tolong isi password dengan benar\nSelamat datang:\ntolong masukan password dibawah ini.\n\n", "Buat", "Batal");

			mysql_format(ourconnection, insert, sizeof(insert), "INSERT INTO `accounts` (`acc_name`, `acc_pass`, `register_ip`, `register_date`) VALUES ('%e', sha1('%e'), '%e', '%e')", ReturnName(playerid), inputtext, ReturnIP(playerid), ReturnDate());
			mysql_tquery(ourconnection, insert, "OnPlayerRegister", "d", playerid);
		}
		case DIALOG_LOGIN:
		{
			if (!response)
				return Kick(playerid);
			
			new continueCheck[211];
			mysql_format(ourconnection, continueCheck, sizeof(continueCheck), "SELECT `acc_dbid` FROM `accounts` WHERE `acc_name` = '%e' AND `acc_pass` = sha1('%e') LIMIT 1",ReturnName(playerid), inputtext);
			mysql_tquery(ourconnection, continueCheck, "LoggingIn", "d", playerid);
			return 1;
		}
	}
	
	if (response) //dialog teleport
	{
		switch (dialogid)
		{
			case tele:
			{
				switch (listitem)
				{
					case 0:
					{
						SetPlayerPos(playerid, 1543.7524,-1352.8965,329.4748);
						GivePlayerWeapon(playerid, 46, 1);
						return 1;
					}
					case 1:
					{
						
						SetPlayerPos(playerid, -2231.4399,-1739.2311,481.3414);
						GivePlayerWeapon(playerid, 46, 1);
						return 1;
					}
					case 2:
					{
						SetPlayerPos(playerid, 876.9653,-1293.1692,3001.0859);
						SetPlayerInterior(playerid, 13);
						SetPlayerSkin(playerid, 80);

						return 1;
					}
				}
			}
		}
	}

	if(response)
	{
		switch(dialogid)
		{
			case DIALOG_DROP:
			{
				switch(listitem)
				{
					case 0:
					{
						if(campFire[playerid] == 0)
						{
							new Float:CFPos[4]; //CFPos adalah camp fire position.
							GetPlayerPos(playerid, CFPos[0], CFPos[1], CFPos[2]);
							GetPlayerFacingAngle(playerid, CFPos[3]);
							dropCampfire[playerid][0] = CreateDynamicObject(19632, CFPos[0], CFPos[1], CFPos[2]-1, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid),  GetPlayerInterior(playerid));
							ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
							campFire[playerid] = 1;
							return 1;
						}
						if(campFire[playerid] == 1)
						{
							SCM(playerid, COL_ORANGE, "Anda berhasil menghapus Campfire");
							DestroyDynamicObject(dropCampfire[playerid][0]);
							campFire[playerid] = 0;
						}
						return 1;
					}
					case 1:
					{
						if(boomBox[playerid] == 0)
						{
							ShowPlayerDialog(playerid, BBPlay, DIALOG_STYLE_INPUT, "Link Music kalian.", "Masukan Link disini!", "PLAY", "BATAL");
							return 1;
						}
						if(boomBox[playerid] == 1)
						{
							ShowPlayerDialog(playerid, BBPlay, DIALOG_STYLE_MSGBOX, "Menghapus Boombox", "Boombox akan di hapus secara otomatis", "OKE", "");
						}
						return 1;
					}
				}
			}
		}
	}

	if(dialogid == BBPlay)//DIALOG LEAVE
	{
		if(response)
		{
			if(boomBox[playerid] == 0)
			{
				new string[128], pName[MAX_PLAYER_NAME];
				new Float:BBPos[4]; //BBPos adalah BoomBox Position.
				GetPlayerPos(playerid, BBPos[0], BBPos[1], BBPos[2]);
				GetPlayerFacingAngle(playerid, BBPos[3]);
				dropBoombox[playerid][0] = CreateDynamicObject(2226, BBPos[0], BBPos[1], BBPos[2]-1, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid),  GetPlayerInterior(playerid));
				GetPlayerName(playerid,pName,MAX_PLAYER_NAME);
				format(string, sizeof(string), "Pemilik Boombox ini %s", pName);
				Label_Boombox = Create3DTextLabel(string, COL_WHITE, BBPos[0], BBPos[1], BBPos[2]-0.8, 7.0, GetPlayerVirtualWorld(playerid), 0);
				foreach(Player, i)
				{
				PlayAudioStreamForPlayer(i, inputtext, BBPos[0], BBPos[1], BBPos[2], 7.0, 1);
				}
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
				boomBox[playerid] = 1;
				return 1;
			}
			if(boomBox[playerid] == 1)
			{
				foreach(Player, i)
				{
					StopAudioStreamForPlayer(i);
					DestroyDynamicObject(dropBoombox[playerid][0]);
					Delete3DTextLabel(Label_Boombox);
				}
				boomBox[playerid] = 0;
				return 1;
			}
			return 1;
		}
	}
	if(response)//gaya tarung
	{
		switch (dialogid)
		{
			case fight:
			{
				switch(listitem)
				{
					case 0:
					{
					SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);
					return 1;
					}
					case 1:
					{
					SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
					return 1;
					}
					case 2:
					{
						SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
						return 1;
					}
					case 3:
					{
						SetPlayerFightingStyle(playerid, FIGHT_STYLE_KNEEHEAD);
						return 1;
					}
					case 4:
					{
						SetPlayerFightingStyle(playerid, FIGHT_STYLE_GRABKICK);
						return 1;
					}
					case 5:
					{
						SetPlayerFightingStyle(playerid, FIGHT_STYLE_ELBOW);
						return 1;
					}
				}
				
			}
		}
	}

	if(dialogid == DIALOG_LEAVEDM)//DIALOG LEAVE
	{
		if(response)
		{
			SetPlayerVirtualWorld(playerid, 0);
			SpawnPlayer(playerid);
			DeletePVar(playerid, "CMD_muted");

			SetPlayerInterior(playerid,0);
			SCM(playerid, COL_ORANGE, "Anda keluar dari Deathmatch");
				
			SetCameraBehindPlayer(playerid);
		}
		return 1;
	}

	if(dialogid == DIALOG_MAIN)//main tune dialog
    {
        if(response)
        {
           	switch(listitem)
        	{
        	    // Paintjobs
        	    case 0: ShowPlayerDialog(playerid, DIALOG_PAINTJOBS, DIALOG_STYLE_LIST, "Paintjobs", "Paint Job 1\nPaint Job 2\nPaint Job 3\nPaint Job 4\nPaint Job 5", "Select", "Back");
        	    // colors
				case 1: ShowPlayerDialog(playerid, DIALOG_COLORS, DIALOG_STYLE_LIST, "Colors", "Black\nWhite\nRed\nBlue\nGreen\nYellow\nPink\nBrown\nGrey\nGold\nDark Blue\nLight Blue\nCold Green\nLight Grey\nDark Red\nDark Brown", "Select", "Back");
        	    // Hoods
        	    case 2: ShowPlayerDialog(playerid, DIALOG_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx", "Select", "Back");
        	    // Vents
        	    case 3: ShowPlayerDialog(playerid, DIALOG_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare", "Select", "Back");
        	    // Lights
        	    case 4: ShowPlayerDialog(playerid, DIALOG_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare", "Select", "Back");
        	    // Exhausts
        	    case 5: ShowPlayerDialog(playerid, DIALOG_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust", "Select", "Back");
        	    // Front Bumpers
				case 6: ShowPlayerDialog(playerid, DIALOG_FBUMPS, DIALOG_STYLE_LIST,"Front Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Select", "Back");
        	    // Rear Bumpers
				case 7: ShowPlayerDialog(playerid, DIALOG_RBUMPS, DIALOG_STYLE_LIST, "Rear Bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow Co. Chromer Bumper\nLow Co. Slamin Bumper", "Select", "Back");
        	    // Roofs
				case 8: ShowPlayerDialog(playerid, DIALOG_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop", "Select", "Back");
        	    // Spoilers
				case 9: ShowPlayerDialog(playerid, DIALOG_SPOILERS, DIALOG_STYLE_LIST, "Spoilers", "Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler", "Select", "Back");
        	    // Side Skirts
				case 10: ShowPlayerDialog(playerid, DIALOG_SIDESKIRTS, DIALOG_STYLE_LIST, "Side Skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt", "Select", "Back");
        	    // Bullbars
				case 11: ShowPlayerDialog(playerid, DIALOG_BULLBARS, DIALOG_STYLE_LIST, "Bullbars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar", "Select", "Back");
        	    // Wheels
				case 12: ShowPlayerDialog(playerid, DIALOG_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar", "Select", "Back");
        	    // Car Stereo
				case 13: ShowPlayerDialog(playerid, DIALOG_CSTEREO, DIALOG_STYLE_LIST, "Car Stereo", "Bass Boost", "Select", "Back");
        	    // Hydraulics
				case 14: ShowPlayerDialog(playerid, DIALOG_HYDRAULICS, DIALOG_STYLE_LIST, "Hydaulics", "Hydaulics", "Select", "Back");
        	    // Nitrous Oxide
				case 15: ShowPlayerDialog(playerid, DIALOG_NITRO, DIALOG_STYLE_LIST, "Nitrous Oxide", "2x Nitrous\n5x Nitrous\n10x Nitrous", "Select", "Back");
        	    // Repair Car
				case 16:
        	    {
					RepairVehicle(GetPlayerVehicleID(playerid));
					SetVehicleHealth(GetPlayerVehicleID(playerid), 1000);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				 	SendClientMessage(playerid, COLOR_STEEL_BLUE, "Kamu telah berhasil memperbaiki mobil.");
					ShowPlayerTuneDialog(playerid);
					return 1;
        	    }
			}
		}
	}

	if(dialogid == DIALOG_PAINTJOBS)// Paintjobs
	{
        if(! response) ShowPlayerTuneDialog(playerid);
	    if(response)
	    {
			switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
			{
				case 562,565,559,561,560,575,534,567,536,535,576,558:
				{
					ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), listitem);
					SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully added paintjob to your car.");
					PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
				}
				default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: Paintjob is only for Wheel Arch Angels and Loco Low Co types of cars.");
			}
			ShowPlayerTuneDialog(playerid);
 		}
 	}

	if(dialogid == DIALOG_COLORS)// Colors
	{
        if(! response) ShowPlayerTuneDialog(playerid);
	    if(response)
	    {
	        new colors[2], colorname[14];
			switch(listitem)
			{
                case 0: colors[0] = 0, colors[1] = 0, colorname = "Black";
        	    case 1: colors[0] = 1, colors[1] = 1, colorname = "White";
        	    case 2: colors[0] = 3, colors[1] = 3, colorname = "Red";
        	    case 3: colors[0] = 79, colors[1] = 79, colorname = "Blue";
        	    case 4: colors[0] = 86, colors[1] = 86, colorname = "Green";
        	    case 5: colors[0] = 6, colors[1] = 6, colorname = "Yellow";
        	    case 6: colors[0] = 126, colors[1] = 126, colorname = "Pink";
        	    case 7: colors[0] = 66, colors[1] = 66, colorname = "Brown";
        	    case 8: colors[0] = 24, colors[1] = 24, colorname = "Grey";
        	    case 9: colors[0] = 123, colors[1] = 123, colorname = "Gold";
        	    case 10: colors[0] = 53, colors[1] = 53, colorname = "Dark Blue";
        	    case 11: colors[0] = 93, colors[1] = 93, colorname = "Light Blue";
        	    case 12: colors[0] = 83, colors[1] = 83, colorname = "Cold Green";
        	    case 13: colors[0] = 60, colors[1] = 60, colorname = "Light Grey";
        	    case 14: colors[0] = 161, colors[1] = 161, colorname = "Dark Red";
        	    case 15: colors[0] = 153, colors[1] = 153, colorname = "Dark Brown";
			}
			ChangeVehicleColor(GetPlayerVehicleID(playerid), colors[0], colors[1]);
			new string[144];
			format(string, sizeof(string), "You have succesfully changed colour of your car to %s (%i & %i).", colorname, colors[0], colors[1]);
			SendClientMessage(playerid, COLOR_DODGER_BLUE, string);
			PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			ShowPlayerTuneDialog(playerid);
		}
	}

	if(dialogid == DIALOG_EXHAUSTS)// Exhausts
    {
        if(! response) ShowPlayerTuneDialog(playerid);
        if(response)
        {
		    new exhaust = 0;
            switch(listitem)
            {
                case 0:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: exhaust = 1034;
						case 565: exhaust = 1046;
						case 559: exhaust = 1065;
						case 561: exhaust = 1064;
						case 560: exhaust = 1028;
						case 558: exhaust = 1089;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Ehausts to this vehicle.");
					}
					if(exhaust != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), exhaust);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed exhaust of your car to Wheel Arc. Alien exhaust.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 1:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: exhaust = 1037;
						case 565: exhaust = 1045;
						case 559: exhaust = 1066;
						case 561: exhaust = 1059;
						case 560: exhaust = 1029;
						case 558: exhaust = 1092;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Ehausts to this vehicle.");
					}
					if(exhaust != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), exhaust);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed exhaust of your car to Wheel Arc. X-Flow exhaust.");
					}
					ShowPlayerTuneDialog(playerid);
				}
				case 2:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: exhaust = 1044;
						case 565: exhaust = 1126;
						case 559: exhaust = 1129;
						case 561: exhaust = 1104;
						case 560: exhaust = 1113;
						case 558: exhaust = 1136;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Ehausts to this vehicle.");
					}
					if(exhaust != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), exhaust);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed exhaust of your car to Low Co. Chromer exhaust.");
					}
					ShowPlayerTuneDialog(playerid);
				}
				case 3:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: exhaust = 1043;
						case 565: exhaust = 1127;
						case 559: exhaust = 1132;
						case 561: exhaust = 1105;
						case 560: exhaust = 1114;
						case 558: exhaust = 1135;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Ehausts to this vehicle.");
					}
					if(exhaust != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), exhaust);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed exhaust of your car to Low Co. Slamin exhaust.");
					}
					ShowPlayerTuneDialog(playerid);
				}
				case 4:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 401,518,527,542,589,400,517,603,426,547,405,580,550,549,477: exhaust = 1020;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Ehausts to this vehicle.");
					}
					if(exhaust != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), exhaust);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed exhaust of your car to Transfender Large exhaust.");
					}
					ShowPlayerTuneDialog(playerid);
				}
				case 5:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 527,542,400,426,436,547,405,477: exhaust = 1021;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Ehausts to this vehicle.");
					}
					if(exhaust != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), exhaust);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed exhaust of your car to Transfender Twin exhaust.");
					}
					ShowPlayerTuneDialog(playerid);
				}
				case 6:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 518,415,542,546,400,517,603,426,436,547,405,550,549,477: exhaust = 1019;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Ehausts to this vehicle.");
					}
					if(exhaust != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), exhaust);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed exhaust of your car to Transfender Twin exhaust.");
					}
					ShowPlayerTuneDialog(playerid);
				}
				case 7:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 401,518,527,542,589,400,517,603,426,547,405,580,550,549,477: exhaust = 1018;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Ehausts to this vehicle.");
					}
					if(exhaust != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), exhaust);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed exhaust of your car to Transfender Upswept exhaust.");
					}
					ShowPlayerTuneDialog(playerid);
				}
			}
		}
	}

	if(dialogid == DIALOG_FBUMPS)
    {
        if(! response) ShowPlayerTuneDialog(playerid);
        if(response)
        {
        	new bumper = 0;
            switch(listitem)
            {
                case 0:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: bumper = 1171;
						case 565: bumper = 1153;
						case 559: bumper = 1160;
						case 561: bumper = 1155;
						case 560: bumper = 1169;
						case 558: bumper = 1166;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Front bumpers to this vehicle.");
					}
					if(bumper != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), bumper);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed front bumpers of your car to Wheel Arc. Alien Bumper.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 1:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: bumper = 1172;
						case 565: bumper = 1152;
						case 559: bumper = 1173;
						case 561: bumper = 1157;
						case 560: bumper = 1170;
						case 558: bumper = 1165;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Front bumpers to this vehicle.");
					}
					if(bumper != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), bumper);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed front bumpers of your car to Wheel Arc. X-Flow Bumper.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 2:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 575: bumper = 1174;
						case 534: bumper = 1179;
						case 567: bumper = 1189;
						case 536: bumper = 1182;
						case 535: bumper = 1115;
						case 576: bumper = 1191;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Front bumpers to this vehicle.");
					}
					if(bumper != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), bumper);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed front bumpers of your car to Low co. Chromer Bumper.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 3:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 575: bumper = 1175;
						case 534: bumper = 1185;
						case 567: bumper = 1188;
						case 536: bumper = 1181;
						case 535: bumper = 1116;
						case 576: bumper = 1190;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Front bumpers to this vehicle.");
					}
					if(bumper != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), bumper);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed front bumpers of your car to Low co. Slamin Bumper.");
					}
					ShowPlayerTuneDialog(playerid);
				}
			}
		}
	}

	if(dialogid == DIALOG_RBUMPS)// Rear bumbers
    {
        if(! response) ShowPlayerTuneDialog(playerid);
        if(response)
        {
        	new bumper = 0;
            switch(listitem)
            {
                case 0:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: bumper = 1149;
						case 565: bumper = 1150;
						case 559: bumper = 1159;
						case 561: bumper = 1154;
						case 560: bumper = 1141;
						case 558: bumper = 1168;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Rear bumpers to this vehicle.");
					}
					if(bumper != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), bumper);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed rear bumpers of your car to Wheel Arc. Alien Bumper.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 1:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: bumper = 1148;
						case 565: bumper = 1151;
						case 559: bumper = 1161;
						case 560: bumper = 1140;
						case 561: bumper = 1156;
						case 558: bumper = 1167;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add rear bumpers to this vehicle.");
					}
					if(bumper != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), bumper);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed rear bumpers of your car to Wheel Arc. X-Flow Bumper.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 2:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 575: bumper = 1176;
						case 534: bumper = 1180;
						case 567: bumper = 1187;
						case 536: bumper = 1184;
						case 535: bumper = 1109;
						case 576: bumper = 1192;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add rear bumpers to this vehicle.");
					}
					if(bumper != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), bumper);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed rear bumpers of your car to Low co. Chromer Bumper.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 3:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 575: bumper = 1177;
						case 534: bumper = 1178;
						case 567: bumper = 1186;
						case 536: bumper = 1183;
						case 535: bumper = 1110;
						case 576: bumper = 1193;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add rear bumpers to this vehicle.");
					}
					if(bumper != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), bumper);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed rear bumpers of your car to Low co. Slamin Bumper.");
					}
					ShowPlayerTuneDialog(playerid);
				}
			}
		}
	}

	if(dialogid == DIALOG_ROOFS)// Roofs
    {
        if(! response) ShowPlayerTuneDialog(playerid);
        if(response)
        {
		    new roof = 0;
			switch(listitem)
            {
                case 0:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: roof = 1038;
						case 565: roof = 1054;
						case 559: roof = 1067;
						case 561: roof = 1055;
						case 560: roof = 1032;
						case 558: roof = 1088;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Roof to this vehicle.");
					}
					if(roof != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), roof);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed roof of your car to Wheel Arc. Alien roof.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 1:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: roof = 1035;
						case 565: roof = 1053;
						case 559: roof = 1068;
						case 561: roof = 1061;
						case 560: roof = 1033;
						case 558: roof = 1091;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Roof to this vehicle.");
					}
					if(roof != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), roof);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed roof of your car to Wheel Arc. X-Flow roof.");
					}
					ShowPlayerTuneDialog(playerid);
				}
				case 2:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 567: roof = 1130;
						case 536: roof = 1128;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Roof to this vehicle.");
					}
					if(roof != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), roof);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed roof of your car to Low Co. Hardtop roof.");
					}
					ShowPlayerTuneDialog(playerid);
				}
				case 3:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 567: roof = 1131;
						case 536: roof = 1103;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Roof to this vehicle.");
					}
					if(roof != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), roof);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed roof of your car to Low Co. Softtop roof.");
					}
					ShowPlayerTuneDialog(playerid);
				}
				case 4:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 401,518,589,492,546,603,426,436,580,550,477: roof = 1006;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add Roof to this vehicle.");
					}
					if(roof != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), roof);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed roof of your car to Transfender Roof Scoop.");
					}
					ShowPlayerTuneDialog(playerid);
				}
 			}
		}
	}

	if(dialogid == DIALOG_SPOILERS)// Spoilers
    {
        if(! response) ShowPlayerTuneDialog(playerid);
        if(response)
        {
		    new spoiler = 0;
			switch(listitem)
            {
                case 0:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: spoiler = 1147;
						case 565: spoiler = 1049;
						case 559: spoiler = 1162;
						case 561: spoiler = 1158;
						case 560: spoiler = 1138;
						case 558: spoiler = 1164;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add spoiler to this vehicle.");
					}
					if(spoiler != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), spoiler);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed spoiler of your car to Wheel Arc. Alien.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 1:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: spoiler = 1146;
						case 565: spoiler = 1150;
						case 559: spoiler = 1158;
						case 561: spoiler = 1060;
						case 560: spoiler = 1139;
						case 558: spoiler = 1163;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add spoiler to this vehicle.");
					}
					if(spoiler != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), spoiler);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed spoiler of your car to Wheel Arc. X-Flow.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 2:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 401,518,527,415,546,603,426,436,405,477,580,550,549: spoiler = 1001;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add spoiler to this vehicle.");
					}
					if(spoiler != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), spoiler);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed spoiler of your car to Transfender Win Spoiler.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 3:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 518,415,546,517,603,405,477,580,550,549: spoiler = 1023;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add spoiler to this vehicle.");
					}
					if(spoiler != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), spoiler);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed spoiler of your car to Transfender Fury Spoiler.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 4:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 518,415,546,517,603,405,477,580,550,549: spoiler = 1003;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add spoiler to this vehicle.");
					}
					if(spoiler != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), spoiler);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed spoiler of your car to Transfender Alpha Spoiler.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 5:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 589,492,547,405: spoiler = 1000;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add spoiler to this vehicle.");
					}
					if(spoiler != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), spoiler);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed spoiler of your car to Transfender Pro Spoiler.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 6:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 527,542,405: spoiler = 1014;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add spoiler to this vehicle.");
					}
					if(spoiler != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), spoiler);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed spoiler of your car to Transfender Champ Spoiler.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 7:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 527,542: spoiler = 1014;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add spoiler to this vehicle.");
					}
					if(spoiler != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), spoiler);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed spoiler of your car to Transfender Race Spoiler.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 8:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 546,517: spoiler = 1002;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add spoiler to this vehicle.");
					}
					if(spoiler != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), spoiler);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed spoiler of your car to Transfender Drag Spoiler.");
					}
					ShowPlayerTuneDialog(playerid);
				}
			}
		}
	}

	if(dialogid == DIALOG_SIDESKIRTS)// Side skirts
    {
        if(! response) ShowPlayerTuneDialog(playerid);
        if(response)
        {
		    new skirts[2] = {0, 0};
			switch(listitem)
            {
                case 0:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: skirts[0] = 1036, skirts[1] = 1040;
						case 565: skirts[0] = 1047, skirts[1] = 1051;
						case 559: skirts[0] = 1069, skirts[1] = 1071;
						case 561: skirts[0] = 1056, skirts[1] = 1062;
						case 560: skirts[0] = 1026, skirts[1] = 1027;
						case 558: skirts[0] = 1090, skirts[1] = 1094;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add side skirts to this vehicle.");
					}
					if(skirts[0] != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[0]);
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[1]);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed side skirts of your car to Wheel Arc. Alien Side Skirts.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 1:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 562: skirts[0] = 1039, skirts[1] = 1041;
						case 565: skirts[0] = 1048, skirts[1] = 1052;
						case 559: skirts[0] = 1070, skirts[1] = 1072;
						case 561: skirts[0] = 1057, skirts[1] = 1063;
						case 560: skirts[0] = 1031, skirts[1] = 1030;
						case 558: skirts[0] = 1093, skirts[1] = 1095;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add side skirts to this vehicle.");
					}
					if(skirts[0] != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[0]);
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[1]);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed side skirts of your car to Wheel Arc. X-Flow Side Skirts.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 2:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 575: skirts[0] = 1042, skirts[1] = 1099;
						case 567: skirts[0] = 1102, skirts[1] = 1133;
						case 576: skirts[0] = 1134, skirts[1] = 1137;
						case 536: skirts[0] = 1108, skirts[1] = 1107;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add side skirts to this vehicle.");
					}
					if(skirts[0] != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[0]);
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[1]);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed side skirts of your car to Locos Chrome Strip.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 3:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 534: skirts[0] = 1122, skirts[1] = 1101;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add side skirts to this vehicle.");
					}
					if(skirts[0] != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[0]);
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[1]);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed side skirts of your car to Locos Chrome Flames.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 4:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 534: skirts[0] = 1106, skirts[1] = 1124;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add side skirts to this vehicle.");
					}
					if(skirts[0] != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[0]);
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[1]);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed side skirts of your car to Locos Chrome Arches.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 5:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 535: skirts[0] = 1118, skirts[1] = 1120;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add side skirts to this vehicle.");
					}
					if(skirts[0] != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[0]);
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[1]);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed side skirts of your car to Locos Chrome Trim.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 6:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 535: skirts[0] = 1119, skirts[1] = 1121;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add side skirts to this vehicle.");
					}
					if(skirts[0] != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[0]);
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[1]);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed side skirts of your car to Locos Wheelcovers.");
					}
					ShowPlayerTuneDialog(playerid);
				}
                case 7:
                {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 401,518,527,415,589,546,517,603,436,439,580,549,477: skirts[0] = 1007, skirts[1] = 1017;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add side skirts to this vehicle.");
					}
					if(skirts[0] != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[0]);
					    AddVehicleComponent(GetPlayerVehicleID(playerid), skirts[1]);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed side skirts of your car to Transfender Side Skirt.");
					}
					ShowPlayerTuneDialog(playerid);
				}
			}
		}
    }

    if(dialogid == DIALOG_BULLBARS)// Bull bars
    {
        if(! response) ShowPlayerTuneDialog(playerid);
        if(response)
        {
            new bulls = 0, bullsname[26];
            switch(listitem)
            {
                case 0:
                {
                    if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 534) SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add bull bars to this vehicle.");
					else bulls = 1100, bullsname = "Locos Chrome Grill";
				}
				case 1:
				{
                    if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 534) SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add bull bars to this vehicle.");
					else bulls = 1123, bullsname = "Locos Chrome Bars";
				}
				case 2:
				{
                    if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 534) SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add bull bars to this vehicle.");
					else bulls = 1125, bullsname = "Locos Chrome Lights";
				}
				case 3:
				{
                    if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 535) SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add bull bars to this vehicle.");
					else bulls = 1117, bullsname = "Locos Chrome Bullbar";
				}
            }
            if(bulls != 0)
			{
				AddVehicleComponent(GetPlayerVehicleID(playerid), bulls);
				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				new string[144];
				format(string, sizeof(string), "You have succesfully changed bull bars of your car to %s.", bullsname);
				SendClientMessage(playerid, COLOR_DODGER_BLUE, string);
			}
			ShowPlayerTuneDialog(playerid);
        }
    }

    if(dialogid == DIALOG_WHEELS)// Wheels
    {
        if(! response) ShowPlayerTuneDialog(playerid);
	    if(response)
	    {
	        new wheels, wheelsname[26];
			switch(listitem)
			{
                case 0: wheels = 1025, wheelsname = "Offroad Wheels";
                case 1: wheels = 1074, wheelsname = "Mega Wheels";
                case 2: wheels = 1076, wheelsname = "Wires Wheels";
                case 3: wheels = 1078, wheelsname = "Twist Wheels";
                case 4: wheels = 1081, wheelsname = "Grove Wheels";
                case 5: wheels = 1082, wheelsname = "Import Wheels";
                case 6: wheels = 1085, wheelsname = "Atomic Wheels";
                case 7: wheels = 1096, wheelsname = "Ahab Wheels";
                case 8: wheels = 1097, wheelsname = "Virtual Wheels";
                case 9: wheels = 1098, wheelsname = "Access Wheels";
                case 10: wheels = 1084, wheelsname = "Trance Wheels";
                case 11: wheels = 1073, wheelsname = "Shadow Wheels";
                case 12: wheels = 1075, wheelsname = "Rimshine Wheels";
                case 13: wheels = 1077, wheelsname = "Classic Wheels";
                case 14: wheels = 1079, wheelsname = "Cutter Wheels";
                case 15: wheels = 1080, wheelsname = "Switch Wheels";
                case 16: wheels = 1083, wheelsname = "Dollar Wheels";
			}
			AddVehicleComponent(GetPlayerVehicleID(playerid), wheels);
			new string[144];
			format(string, sizeof(string), "You have succesfully changed wheels of your car to %s (%i).", wheelsname, wheels);
			SendClientMessage(playerid, COLOR_DODGER_BLUE, string);
			PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			ShowPlayerTuneDialog(playerid);
		}
	}

	if(dialogid == DIALOG_WHEELS)// Stero
    {
        if(! response) ShowPlayerTuneDialog(playerid);
	    if(response)
	    {
			AddVehicleComponent(GetPlayerVehicleID(playerid), 1086);
			SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully added a stero to your vehicle.");
			PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			ShowPlayerTuneDialog(playerid);
		}
	}

	if(dialogid == DIALOG_HYDRAULICS)// Hydraulics
    {
        if(! response) ShowPlayerTuneDialog(playerid);
	    if(response)
	    {
			AddVehicleComponent(GetPlayerVehicleID(playerid), 1087);
			SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully added hydraulics to your vehicle.");
			PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			ShowPlayerTuneDialog(playerid);
		}
	}

	if(dialogid == DIALOG_NITRO)// Nitros !
    {
        if(! response) ShowPlayerTuneDialog(playerid);
	    if(response)
	    {
	        new nitro, nitroname[5];
			switch(listitem)
			{
                case 0: nitro = 1008, nitroname = "2x";
                case 1: nitro = 1009, nitroname = "5x";
                case 2: nitro = 1010, nitroname = "10x";
			}
			AddVehicleComponent(GetPlayerVehicleID(playerid), nitro);
			new string[144];
			format(string, sizeof(string), "You have succesfully added nitros to your car, %s.", nitroname);
			SendClientMessage(playerid, COLOR_DODGER_BLUE, string);
			PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			ShowPlayerTuneDialog(playerid);
		}
	}

	if(dialogid == DIALOG_HOODS)// Hoods
    {
		if(! response) ShowPlayerTuneDialog(playerid);
	    if(response)
	    {
	        new hood = 0;
	        switch(listitem)
	        {
	            case 0:
	            {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 401,518,589,492,426,550: hood = 1005;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add hood to this vehicle.");
					}
					if(hood != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), hood);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed hood of your car to Fury.");
					}
					ShowPlayerTuneDialog(playerid);
				}
	            case 1:
	            {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 401,546,492,426,550: hood = 1004;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add hood to this vehicle.");
					}
					if(hood != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), hood);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed hood of your car to Champ.");
					}
					ShowPlayerTuneDialog(playerid);
				}
	            case 2:
	            {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 549: hood = 1011;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add hood to this vehicle.");
					}
					if(hood != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), hood);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed hood of your car to Race.");
					}
					ShowPlayerTuneDialog(playerid);
				}
	            case 3:
	            {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 549: hood = 1012;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add hood to this vehicle.");
					}
					if(hood != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), hood);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed hood of your car to Worx.");
					}
					ShowPlayerTuneDialog(playerid);
				}
			}
	    }
    }

    if(dialogid == DIALOG_VENTS)// Vents
    {
		if(! response) ShowPlayerTuneDialog(playerid);
	    if(response)
	    {
	        new vents[2] = {0, 0};
	        switch(listitem)
	        {
	            case 0:
	            {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 401,518,546,517,603,547,439,550,549: vents[0] = 1142, vents[1] = 1143;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add vents to this vehicle.");
					}
					if(vents[0] != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), vents[0]);
					    AddVehicleComponent(GetPlayerVehicleID(playerid), vents[1]);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed vents of your car to Oval.");
					}
					ShowPlayerTuneDialog(playerid);
				}
	            case 1:
	            {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 401,518,546,517,603,547,439,550,549: vents[0] = 1144, vents[1] = 1145;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add vents to this vehicle.");
					}
					if(vents[0] != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), vents[0]);
					    AddVehicleComponent(GetPlayerVehicleID(playerid), vents[1]);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed vents of your car to Square.");
					}
					ShowPlayerTuneDialog(playerid);
				}
			}
		}
    }

    if(dialogid == DIALOG_LIGHTS)// Lights
    {
		if(! response) ShowPlayerTuneDialog(playerid);
	    if(response)
	    {
	        new light = 0;
	        switch(listitem)
	        {
	            case 0:
	            {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 401,518,589,400,436,439: light = 1013;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add lights to this vehicle.");
					}
					if(light != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), light);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed lights of your car to Round.");
					}
					ShowPlayerTuneDialog(playerid);
				}
	            case 1:
	            {
		           	switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
					{
						case 589,603,400: light = 1024;
						default: SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You can't add lights to this vehicle.");
					}
					if(light != 0)
					{
					    AddVehicleComponent(GetPlayerVehicleID(playerid), light);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
						SendClientMessage(playerid, COLOR_DODGER_BLUE, "You have succesfully changed lights of your car to Square.");
					}
					ShowPlayerTuneDialog(playerid);
				}
			}
		}
    }
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == joinskin)
	{
		if(!response)
			return ShowModelSelectionMenu(playerid, joinskin, "Pilih Skin");

		SetCameraBehindPlayer(playerid);
		SetPlayerSkin(playerid, modelid);
		AccountInfo[playerid][pSkin] = modelid;
		SetSpawnInfo(playerid, 0, modelid, 929.0081,-1720.4331,13.5465,80.3241,0,0,0,0,0,0);
		SpawnPlayer(playerid);
		return 1;
	}
	if(listid == selectskin)
	{
		if(!response)
			return ShowModelSelectionMenu(playerid, joinskin, "Pilih Skin");
		SetPlayerSkin(playerid, modelid);
		AccountInfo[playerid][pSkin] = modelid;
		return 1;
	}
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	SetPlayerPosFindZ(playerid, fX, fY, fZ);
	SetVehiclePos(GetPlayerVehicleID(playerid), fX, fY, fZ);
	PutPlayerInVehicle(playerid, GetPlayerVehicleID(playerid), 0);
	LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(playerid));
	SCM(playerid, COL_GREEN, "[SERVER]: teleportasi {61c5dd}berhasil");
	return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	if(vgod[playerid]==1)
	{  
		RepairVehicle(GetPlayerVehicleID(playerid));
		SetVehicleHealth(GetPlayerVehicleID(playerid), 1000000);
	}
	return 1;
}

//____________________DISCORD Connector______________
/*
untuk berinteraksi pada channel discord
*/
forward DCC_OnMessageCreate(DCC_Message:message);
public DCC_OnMessageCreate(DCC_Message:message)
{
	new realMsg[100];
    DCC_GetMessageContent(message, realMsg, 100);
    new bool:IsBot;
    new DCC_Channel:channel;
 	DCC_GetMessageChannel(message, channel);
    new DCC_User:author;
	DCC_GetMessageAuthor(message, author);
    DCC_IsUserBot(author, IsBot);
    if(channel == g_Discord_Chat && !IsBot) //!IsBot will block BOT's message in game
    {
        new user_name[32 + 1], str[152];
       	DCC_GetUserName(author, user_name, 32);
        format(str,sizeof(str), "{ff00ae}[DISCORD] {aa1bb5}%s: {ffffff}%s",user_name, realMsg);
        SendClientMessageToAll(-1, str);
    }
    return 1;
}

// _________________DIALOG_____________________________

Dialog:DIALOG_SWEEPER(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
				SetPlayerCheckpoint(playerid, sweepersmb1, 3.0);
			}
			case 1:
			{
				SetPlayerCheckpoint(playerid, sweeperrodeo1, 5.0);
			}
			case 2:
			{
				SetPlayerCheckpoint(playerid, sweepertemple1, 5.0);
			}
			case 3:
			{
				SetPlayerCheckpoint(playerid, sweepermarket1, 5.0);
			}
		}
	}
	else
	{
		AccountInfo[playerid][pSweeping] = 0;
		SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	}
	return 1;
}

//_________________Command___________________

CMD:cmdlist(playerid, params[])
{
	if(AccountInfo[playerid][pAdmin] >= 2)
	{
		SCM(playerid, COL_ORANGE, "CMD Admin level 2:");
		SCM(playerid, COL_YELLOW, "/kill /get /dveh /setworld /freeze /unfreeze");
	}
	if(AccountInfo[playerid][pAdmin] >= 1)
	{
		SCM(playerid, COL_ORANGE, "CMD Admin level 1:");
		SCM(playerid, COL_YELLOW, "/health /money ");
	}
	SCM(playerid, COL_ORANGE, "CMD Player:");
	SCM(playerid, COL_YELLOW, "/jetpack /skin /weap /spawn /god /teleport /v /spawnveh /para /goto");
	SCM(playerid, COL_YELLOW, "/sfight /heal /sjump /vgod /boom /spin /snip /world /stopmusic");
	
	SCM(playerid, COL_ORANGE, "CMD Discord:");
	SCM(playerid, COL_YELLOW, "/discord");
	return 1;
}

CMD:makeadmin(playerid, params[])
{
	if(AccountInfo[playerid][pAdmin] >= 2 || IsPlayerAdmin(playerid))
	{
		new playerb, adminlvl, insert[120];
		if(sscanf(params, "ui", playerb, adminlvl))
			return SCM(playerid, COL_RED, "/makeadmin {61c5dd}[playerid/nama] [Level 1-2]");
		if(adminlvl < 0 || adminlvl > 2)
			return SCM(playerid, COL_RED, "Invalid Admin Level");

		SCMex(playerid, COL_ORANGE, "Kamu baru saja membuat: %s menjadi admin level: %i", ReturnName(playerb), adminlvl);
		SCMex(playerb, COL_ORANGE, "Kamu telah menjadi admin level: %i oleh: %s", adminlvl, ReturnName(playerid));

		AccountInfo[playerb][pAdmin] = adminlvl;
		mysql_format(ourconnection, insert, sizeof(insert), "UPDATE `accounts` SET `Admin` = %i WHERE `acc_dbid` = %i", adminlvl, AccountInfo[playerb][pDBID]);
		mysql_tquery(ourconnection, insert);
	}
	else return SCM(playerid, COL_RED, "Kamu tidak diizinkan menggunakan perintah ini");
	return 1;
}

CMD:jetpack(playerid, params[]) //cmd jetpack
{
	if(sscanf(params, "i", playerid))
		return SCM(playerid, COL_RED, "[SERVER]: /jetpack {61c5dd}[playerid]");
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
	return 1;
}

CMD:kill(playerid, params[]) //cmd bundir
{
	new target;
	if(AccountInfo[playerid][pAdmin] < 2)
		return SCM(playerid, COL_RED, "Kamu tidak diizinkan menggunakan perintah ini");
	if(sscanf(params, "i", target))
		return SCM(playerid, COL_RED, "[SERVER]: /kill {61c5dd}[playerid]");
	SetPlayerHealth(target, 0);
	SCMex(playerid, COL_ORANGE, "Kamu berhasil membunuh {61c5dd}%s", ReturnName(target));
	SCMex(target, COL_ORANGE, "Kamu telah dibunuh oleh {61c5dd}%s", ReturnName(playerid));
	return 1;
}

CMD:skin(playerid, params[]) //cmd skin
{
	new modelid;
	if(!strcmp(params,"list",true))
	{
		ShowModelSelectionMenu(playerid, selectskin, "Pilih Skin");
		SetPlayerSkin(playerid, modelid);
		return 1;
	}
	if(sscanf(params, "i", modelid))
		return SCM(playerid, COL_RED, "[SERVER]: /skin {61c5dd}[skinID/list]");
	if(modelid < 1 || modelid > 299)
		return SCM(playerid, COL_RED, "[SERVER]: Tidak bisa memilih skin tersebut" );
	SetPlayerSkin(playerid, modelid);
	return 1;
}

CMD:health(playerid, params[])
{
	if(AccountInfo[playerid][pAdmin] < 1)
		return SCM(playerid, COL_RED, "Kamu tidak diizinkan menggunakan perintah ini");
	new health;
	if(sscanf(params, "i", health ))
		return SCM(playerid, COL_RED, "[SERVER]: /health {61c5dd}[berapa darah]");
	
	if(health < 10 || health > 100 )
		return SCM(playerid, COL_RED, "[SERVER]: terlalu banyak darah yang anda minta!");

	SetPlayerHealth(playerid, health);

	return 1;
}

CMD:weap(playerid, params[])
{
	new weaponid, ammo;
	if(sscanf(params, "ii", weaponid, ammo))
		return SCM(playerid, COL_RED, "[SERVER]: /w {61c5dd}[IDweapon] [Ammo]");

	if(weaponid < 1 || weaponid > 40)
		return SCM(playerid, COL_RED, "[SERVER]: tidak dapat memilih senjata tersebut");

	GivePlayerWeapon(playerid, weaponid, ammo);
	
	return 1;
}

CMD:spawn(playerid, params[])
{
	SpawnPlayer(playerid);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}

CMD:god(playerid, params[])
{
	if(godmode[playerid] == 0)
	{
	    godmode[playerid] = 1;
		SetPlayerHealth(playerid, 1000000);
	    GameTextForPlayer(playerid, "~g~GODMODE ~w~~h~ON", 5000, 3);

	}
	else
	{
		godmode[playerid] = 0;
	    SetPlayerHealth(playerid, 100);
	    GameTextForPlayer(playerid, "~g~GODMODE ~w~~h~OFF", 5000, 3);

	    DeletePVar(playerid, "PlayerGod");
	}
	return 1;
}


CMD:teleport(playerid, params[])
{
	ShowPlayerDialog(playerid, tele, DIALOG_STYLE_LIST, "Mau pergi kemana?", "Terjun bebas Tower\nTerjun bebas MountChiliad\nTinju", "Spawn", "Batal");
	return 1;
}


CMD:v(playerid,params[])
{
	new vid;
	if(sscanf(params,"i",vid) || (vid < 400 || vid > 611)) 
		return SendClientMessage(playerid, COL_RED,"[SERVER]: /v {61c5dd}[VehicleID (400-611)]");
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		return SCM(playerid, COL_RED, "Kamu tidak bisa spawn di dalam kendaraan!");
	if(vid == 574)
		return SCM(playerid, COL_RED, "Kamu tidak bisa spawn kendaraan tersebut!");
	new Float:pos[4];
		GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
		GetPlayerFacingAngle(playerid,pos[3]);
		SetPlayerInterior(playerid, GetPlayerInterior(playerid));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(playerid));
		RemVeh[playerid] = CreateVehicle(vid,pos[0],pos[1],pos[2],pos[3],-1,-1,0,0);
		IsRemVeh[RemVeh[playerid]] = true;
		PutPlayerInVehicle(playerid, RemVeh[playerid], 0);
		SCM(playerid, COL_ORANGE,"[SRVER]: Vehicle Spawned!");
	return 1;
}

CMD:para(playerid, params[])
{
	GivePlayerWeapon(playerid, 46, 1);
	SCM(playerid, COL_GREEN, "[SERVER]: berhasil mendapatkan parachute");
	return 1;
}

CMD:money(playerid, params[])
{
	new money;
	new target;
	new reason[128];
	if(AccountInfo[playerid][pAdmin] < 1)
		return SCM(playerid, COL_RED, "Kamu tidak diizinkan menggunakan perintah ini");
	if(sscanf(params, "iis[128]", target, money, reason))
		return SCM(playerid, COL_RED, "[SERVER]: /Money {61c5dd}[PlayerID][Jumlah][Alasan]");
	GivePlayerMoney(target,money);
	SCMex(playerid, COL_ORANGE, "Kamu Memberikan uang sebesar {61c5dd}%i {ffaa00}kepada {61c5dd}%s", money, ReturnName(target));
	SCMex(target, COL_ORANGE, "Kamu telah diberikan uang oleh {61c5dd}%s {ffaa00}sebesar {61c5dd}%i {ffaa00}[Reason: %s]", ReturnName(playerid), money, reason);
	return 1;
}


CMD:goto(playerid, params[])
{
	new target;
	if(sscanf(params, "u", target)) 
		return SendClientMessage(playerid, COL_RED, "[SERVER]: /goto {61c5dd}[player/ID]");

	if(! IsPlayerConnected(target)) 
		return SendClientMessage(playerid, COL_RED, "ERROR: Player tidak konek.");

	if(target == playerid) 
		return SendClientMessage(playerid, COL_RED, "ERROR: Kamu tidak dapat teleport diri kamu sendiri.");

	new Float:pos[3];
	GetPlayerPos(target, pos[0], pos[1], pos[2]);
	SetPlayerInterior(playerid, GetPlayerInterior(target));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(target));
	if(GetPlayerState(playerid) == 2)
	{
		SetVehiclePos(GetPlayerVehicleID(playerid), pos[0] + 2.5, pos[1], pos[2]);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(target));
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), GetPlayerVirtualWorld(target));
		
	}
	else SetPlayerPos(playerid, pos[0] + 2.0, pos[1], pos[2]);

	SCMex(playerid, COL_ORANGE, "Kamu baru saja teleport ke:{61c5dd} %s", ReturnName(target));
	SCMex(target, COL_ORANGE, "Kamu telah di teleport oleh:{61c5dd} %s", ReturnName(playerid));
	return 1;
}

CMD:get(playerid, params[])
{
	if(AccountInfo[playerid][pAdmin] < 2)
		return SCM(playerid, COL_RED, "Kamu tidak diizinkan menggunakan perintah ini");
	new target;
	if(sscanf(params, "u", target)) 
	return SendClientMessage(playerid, COL_RED, "[SERVER]: /get {61c5dd}[player/ID]");

	if(! IsPlayerConnected(target)) 
	return SendClientMessage(playerid, COL_RED, "ERROR: Player tidak konek.");

	if(target == playerid) 
	return SendClientMessage(playerid, COL_RED, "ERROR: Kamu tidak dapat teleport diri kamu sendiri.");

	new Float:pos[3];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

	if(GetPlayerState(target) == PLAYER_STATE_DRIVER)
	{
		SetVehiclePos(GetPlayerVehicleID(target), pos[0] + 3.0, pos[1], pos[2]);
		LinkVehicleToInterior(GetPlayerVehicleID(target), GetPlayerInterior(playerid));
		SetVehicleVirtualWorld(GetPlayerVehicleID(target), GetPlayerVirtualWorld(playerid));
	}
	else
	{
		SetPlayerPos(target, pos[0] + 2.5, pos[1], pos[2]);
	}
	SetPlayerInterior(target, GetPlayerInterior(playerid));
	SetPlayerVirtualWorld(target, GetPlayerVirtualWorld(playerid));

	SCMex(playerid, COL_ORANGE, "Kamu baru saja menarik: %s", ReturnName(target));
	SCMex(target, COL_ORANGE, "Kamu telah di tarik oleh: %s", ReturnName(playerid));
	return 1;
}

CMD:sfight(playerid, params[])
{
	ShowPlayerDialog(playerid, fight, DIALOG_STYLE_LIST, "Pilih gaya bertarung", "Normal\nBoxing\nKungfu\nKneehead\nGrabkick\nElbow", "Spawn", "Batal");
	return 1;
}

CMD:heal(playerid, params[])
{
	SetPlayerHealth(playerid, 100);
	SCM(playerid, COL_ORANGE, "Heal berhasil");
	return 1;
}

ShowPlayerTuneDialog(playerid)
{
    ShowPlayerDialog(	playerid,
						DIALOG_MAIN,
						DIALOG_STYLE_LIST,
						"Vehicle tuning:",
						"Paint Jobs\n\
						Colors\n\
						Hoods\n\
						Vents\n\
						Lights\n\
						Exhausts\n\
						Front Bumpers\n\
						Rear Bumpers\n\
						Roofs\n\
						Spoilers\n\
						Side Skirts\n\
						Bullbars\n\
						Wheels\n\
						Car Stereo\n\
						Hydraulics\n\
						Nitrous Oxide\n\
						Repair Car",
						"Enter",
						"Close"
					);
	return true;
}


CMD:dveh(playerid, params[])
{
	if(AccountInfo[playerid][pAdmin] < 2)
		return SCM(playerid, COL_RED, "Kamu tidak diizinkan menggunakan perintah ini");
	new pid;
	if(sscanf(params, "i", pid)) 
		return SCM(playerid, COL_RED, "[SERVER]: /dveh {61c5dd}[player/id]");
	if(IsPlayerInAnyVehicle(pid))
	{
	new vehicleid = GetPlayerVehicleID(pid);
    DestroyVehicle(vehicleid);

	SCMex(playerid, COL_ORANGE, "menghapus kendaraan {61c5dd}%s", ReturnName(pid));
	SCMex(pid, COL_ORANGE, "kendaraan di hapus oleh: {61c5dd}%s", ReturnName(playerid));
	return 1;
	}
	SCM(playerid, COL_RED, "Error: Player tidak di dalam kendaraaan");
	return 1;
}

CMD:setworld(playerid, params[])
{
	if(AccountInfo[playerid][pAdmin] < 2)
		return SCM(playerid, COL_RED, "Kamu tidak diizinkan menggunakan perintah ini");
	new target, id;
	if(sscanf(params, "ui", target, id)) 
	return SCM(playerid, COL_RED, "[SERVER]: /setworld {61c5dd}[player/id] [WorldID]");

	if(! IsPlayerConnected(target)) 
	return SCM(playerid, COL_RED, "ERROR: Player tidak konek.");

	SetPlayerVirtualWorld(target, id);

	SCMex(playerid, COL_ORANGE, "Admin %s[%i] menempatkan kamu ke Virtual world %i.", ReturnPlayerName(playerid), playerid, id);
	SCMex(target, COL_ORANGE, "Kamu di tempatkan %s[%i]'s virtual world ID %i.", ReturnPlayerName(target), target, id);
	return 1;
}

CMD:freeze(playerid, params[])
{
	if(AccountInfo[playerid][pAdmin] < 2)
		return SCM(playerid, COL_RED, "Kamu tidak diizinkan menggunakan perintah ini");
	new target, reason[35];
	if(sscanf(params, "uS(No reason specified)[35]", target, reason)) 
	return SCM(playerid, COL_RED, "[SERVER]: /freeze {61c5dd}[playerid] [reason]");

	if(! IsPlayerConnected(target)) 
	return SCM(playerid, COLOR_FIREBRICK, "ERROR: Player tidak konek.");

	TogglePlayerControllable(target, false);
	PlayerPlaySound(target, 1057, 0.0, 0.0, 0.0);
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);

	SCMex(playerid, COL_ORANGE, "admin %s has freezed you.", ReturnName(playerid));
	SCMex(target, COL_ORANGE, "You have freezed by %s.", ReturnName(playerid));
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	if(AccountInfo[playerid][pAdmin] < 2)
		return SCM(playerid, COL_RED, "Kamu tidak diizinkan menggunakan perintah ini");
	new target;
	if(sscanf(params, "u", target)) return SendClientMessage(playerid, COL_RED, "[SERVER]: /unfreeze {61c5dd}[playerid]");

	if(! IsPlayerConnected(target)) 
	return SCM(playerid, COLOR_FIREBRICK, "ERROR: Player tidak konek.");

	TogglePlayerControllable(target, true);
	PlayerPlaySound(target, 1057, 0.0, 0.0, 0.0);
	PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);

	SCMex(playerid, COL_ORANGE, "admin %s has unfreezed you.", ReturnName(playerid));
	SCMex(target, COL_ORANGE, "You have unfreezed by %s.", ReturnName(target));

	return 1;
}

CMD:sjump(playerid, params[])
{
	if(jumpmode[playerid] == 0)
	{
	    jumpmode[playerid] = 1;
	    GameTextForPlayer(playerid, "~g~JUMPMODE ~w~~h~ON", 5000, 3);

	}
	else
	{
		jumpmode[playerid] = 0;
	    GameTextForPlayer(playerid, "~g~JUMPMODE ~w~~h~OFF", 5000, 3);

	    DeletePVar(playerid, "Jumpmode");
	}
	return 1;
}

CMD:vgod(playerid, params[])
{
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
			if(vgod[playerid] == 0)
			{
				vgod[playerid] = 1;
				SetVehicleHealth(GetPlayerVehicleID(playerid), 1000000);
				GameTextForPlayer(playerid, "~g~GODMODE ~w~~h~ON", 5000, 3);
			}
			else
			{
				vgod[playerid] = 0;
				SetVehicleHealth(GetPlayerVehicleID(playerid), 1000);
				GameTextForPlayer(playerid, "~g~GODMODE ~w~~h~OFF", 5000, 3);

				DeletePVar(playerid, "vgod");
			}
		}
		else
		{
			SCM(playerid, COL_RED, "kamu tidak sedang mengemudi kendaraan");
		}
	return 1;
}

CMD:boom(playerid, params[])
{
	new target, Float:x, Float:y, Float:z;
	if(sscanf(params, "u", target)) 
	return SCM(playerid, COL_RED, "[SERVER]: /boom {61c5dd}[playerid]");
	GetPlayerPos(target, x, y, z);
    CreateExplosion(x, y, z, 10, 100);
	return 1;
}

CMD:spin(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
        SetVehicleAngularVelocity(GetPlayerVehicleID(playerid), 0.0, 0.0, 2.0);
	return 1;
}

CMD:snip(playerid, params[])
{
	new string[120];
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		return DestroyVehicle(GetPlayerVehicleID(playerid));
	if(!isnull(params))
	{
		if(!strcmp(params,"join",true))
		{
			sniperworld[playerid] = 1;
			setspawnsniper(playerid);
			SCM(playerid, COL_YELLOW, "TEKAN {ffaa00}'H' {d9ff00}UNTUK KELUAR DARI DEATH MATCH ");
			SetPlayerHealth(playerid, 100);
			SCM(playerid, COL_ORANGE, "Anda bergabung di sniper Deathmatch");
		}
	}
	SetPVarInt(playerid, "CMD_muted", 1);
	sniperworld[playerid] = true;
	setspawnsniper(playerid);
	SCM(playerid, COL_YELLOW, "TEKAN {ffaa00}'H' {d9ff00}UNTUK KELUAR DARI DEATH MATCH ");
	SetPlayerHealth(playerid, 100);
	SCM(playerid, COL_ORANGE, "Anda berada di sniper Deathmatch");
	format(string,sizeof string,"{ffaa00}%s {d9ff00}telah masuk ke DM {ffaa00}'/snip join' {d9ff00}jika ingin bergabung", ReturnName(playerid));
	SendClientMessageToAll(COL_YELLOW,string);
	return 1;
}

CMD:world(playerid, params[])
{
	SCMex(playerid, COL_PINK, "anda berada di world %i int %i", GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
	return 1;
}

CMD:rename(playerid, params[])
{
	new name[128];
	if(AccountInfo[playerid][pAdmin] < 1)
		return SCM(playerid, COL_RED, "Kamu tidak diizinkan menggunakan perintah ini");
	if(sscanf(params, "s[128]", name))
		return SCM(playerid, COL_RED, "[SERVER]: /rename {61c5dd}[Name]");
	SetPlayerName(playerid, name);
	return 1;
}

CMD:spec(playerid, params[])
{
	new target;
	if(!strcmp(params,"off",true))
		{
			TogglePlayerSpectating(playerid, 0);
			return 1;
		}
	if(sscanf(params, "i", target))
		return SCM(playerid, COL_RED, "[SERVER]: /spec {61c5dd}[playerid]");
	TogglePlayerSpectating(playerid, 1);
	PlayerSpectatePlayer(playerid, target);
	SetCameraBehindPlayer(target);
	return 1;
}

CMD:drop(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_DROP, DIALOG_STYLE_LIST, "Pilih barang mana yang mau di drop", "Campfire\nBoombox",  "DROP", "BATAL");
    return 1;
}

CMD:tes(playerid, params[])
{
	SetPlayerSkin(playerid, 20001);
	return 1;
}


CMD:infohide(playerid, params[])
{
	if(hideinfo[playerid] == 0)
	{
		TextDrawHideForPlayer(playerid, PublicTD[3]);
		hideinfo[playerid] = 1;
		SCM(playerid, COL_GREEN, "Berhasil menyembunyikan HUD player info /hideinfo untuk memunculkannya lagi");
	}
	else
	{
		TextDrawShowForPlayer(playerid, PublicTD[3]);
		hideinfo[playerid] = 0;
	}
	return 1;
}

CMD:discord(playerid, params[])
{
    if(!strcmp(params, "live", true))
    {
        chatdc[playerid] = 1;
        SendClientMessage(playerid, COL_YELLOW, "Anda telah mengaktifkan chat discord!");
        return 1;
    }
    if(!strcmp(params, "mute", true))
    {
        chatdc[playerid] = 0;
        SendClientMessage(playerid, COL_YELLOW, "Anda telah membisukan obrolan discord!");
        return 1;
    }
    else
    {
        SendClientMessage(playerid, COL_RED, "ERROR: chose Live or Mute!");
    }
    return 1;
}

// CMD:tp(playerid,params[])
// {
// 		new Float:posx,Float:posy,Float:posz, inte;
// 		if(sscanf(params,"fffi",posx,posy,posz,inte))return SendClientMessage(playerid,-1,"* Tyope: /gotoxyz [posx][posy][posz][int]");
// 		{
// 			SetPlayerPos(playerid,posx,posy,posz);
// 			SetPlayerInterior(playerid,inte);
// 			GameTextForPlayer(playerid,"~w~You got~y~teleported",5000,4);
// 		}
// 	return 1;
// }


//CMD:setcolor(playerid, params[])
//{
	//new target;
	//if(sscanf(params, "u", target)) return SendClientMessage(playerid, COLOR_THISTLE, "USAGE: /setcolor [player]");

	//if(! IsPlayerConnected(target)) return SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: The specified player is not conected.");

	//if(GetPlayerGAdminLevel(playerid) < GetPlayerGAdminLevel(target)) return SendClientMessage(playerid, COLOR_FIREBRICK, "ERROR: You cannot use this command on higher level admin.");

	//SetPVarInt(playerid, "PlayerColor", target);
	//PlayerPlaySound(target, 1057, 0.0, 0.0, 0.0);
	//PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
	//ShowPlayerDialog(playerid, DIALOG_PLAYER_COLORS, DIALOG_STYLE_LIST, "Select a color", ""BLACK"Black\n"WHITE"White\n"RED"Red\n"ORANGE"Orange\n"YELLOW"Yellow\n"GREEN"Green\n"RED"Blue\n"VIOLET"Purple\n"BROWN"Brown\n"PINK"Pink", "Select", "Cancel");
	//return 1;
//}


//___________________stock value_____________________

stock ReturnName(playerid, underScore = 1)
{
	new playersName[MAX_PLAYER_NAME + 2];
	GetPlayerName(playerid, playersName, sizeof(playersName));
 
	if(!underScore)
	{
		{
			for(new i = 0, j = strlen(playersName); i < j; i ++)
			{
				if(playersName[i] == '_')
				{
					playersName[i] = ' ';
				}
			}
		}
	}
 
	return playersName;
}
 
stock ReturnIP(playerid)
{
	new
		ipAddress[20];
 
	GetPlayerIp(playerid, ipAddress, sizeof(ipAddress));
	return ipAddress;
}

stock KickEx(playerid)
{
	return SetTimerEx("KickTimer", 100, false, "i", playerid);
}

stock SendClientMessageEx(playerid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[156]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args
 
	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start
 
	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 156
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format
 
		SendClientMessage(playerid, color, string);
 
		#emit LCTRL 5
		#emit SCTRL 4
		#emit RETN
	}
	return SendClientMessage(playerid, color, str);
}
 
stock ReturnVehicleName(vehicleid)
{
	new
		model = GetVehicleModel(vehicleid),
		name[32] = "None";
 
    if (model < 400 || model > 611)
	    return name;
 
	format(name, sizeof(name), g_arrVehicleNames[model - 400]);
	return name;
}

stock GetVehicleRotation(vehicleid,&Float:rx,&Float:ry,&Float:rz)
{
	new Float:qw,Float:qx,Float:qy,Float:qz;
	GetVehicleRotationQuat(vehicleid,qw,qx,qy,qz);
	rx = asin(2*qy*qz-2*qx*qw);
	ry = -atan2(qx*qz+qy*qw,0.5-qx*qx-qy*qy);
	rz = -atan2(qx*qy+qz*qw,0.5-qx*qx-qz*qz);
}

stock SetVehicleSpeed(vehicleid, Float:speed, bool:kmh = true)
{
	new Float:vPos[4];
	GetVehicleVelocity(vehicleid,vPos[0],vPos[1],vPos[2]);
    GetVehicleZAngle(vehicleid, vPos[3]);
    speed = (kmh ? (speed / 136.666667) : (speed / 85.4166672));
    return SetVehicleVelocity(vehicleid, speed * floatsin(-vPos[3], degrees), speed * floatcos(-vPos[3], degrees), (vPos[2]-0.005));
}

stock Setplayerspeed(playerid, Float:speed, bool:kmh = true)
{
	new Float:Pos[4];
	GetPlayerVelocity(playerid,Pos[0], Pos[1], Pos[2]);
    GetVehicleZAngle(playerid, Pos[3]);
    return SetPlayerVelocity(playerid, speed * floatsin(-Pos[3], degrees), speed * floatcos(-Pos[3], degrees), (Pos[2]-0.005));
}
stock setspawnsniper(playerid)
{
	new ran = random(3);
	switch(ran)
	{
		case 0:
		{
			SetPlayerPos(playerid, 2185.6409,1036.1057,79.5547);
			GivePlayerWeapon(playerid, 34, 999);
			SetPlayerVirtualWorld(playerid, 45);
			GivePlayerWeapon(playerid, 34, 999);
		}
		case 1:
		{
			SetPlayerPos(playerid, 2250.4131,1156.8633,79.5547);
			GivePlayerWeapon(playerid, 34, 999);
			SetPlayerVirtualWorld(playerid, 45);
			GivePlayerWeapon(playerid, 34, 999);
		}
		case 2:
		{
			SetPlayerPos(playerid, 2319.1365,1120.3313,79.5546);
			GivePlayerWeapon(playerid, 34, 999);
			SetPlayerVirtualWorld(playerid, 45);
			GivePlayerWeapon(playerid, 34, 999);
		}
		case 3:
		{
			SetPlayerPos(playerid, 2270.3198,1015.2457,79.5547);
			GivePlayerWeapon(playerid, 34, 999);
			SetPlayerVirtualWorld(playerid, 45);
			GivePlayerWeapon(playerid, 34, 999);
		}
		case 4:
		{
			SetPlayerPos(playerid, 2208.4358,1062.7822,71.6051);
			GivePlayerWeapon(playerid, 34, 999);
			SetPlayerVirtualWorld(playerid, 45);
			GivePlayerWeapon(playerid, 34, 999);
		}
		case 5:
		{
			SetPlayerPos(playerid, 2274.1780,1110.8516,70.9151);
			GivePlayerWeapon(playerid, 34, 999);
			SetPlayerVirtualWorld(playerid, 45);
			GivePlayerWeapon(playerid, 34, 999);
		}
	}
}

stock isabike(vehicleid)
{
	switch(GetVehicleModel(vehicleid))
	{
		case 481, 509, 510: return 1;
	}
	return 0;
}

stock GetPlayerSpeed(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
	GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
	else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 100.3;
    return floatround(ST[3]);
}

stock dmmute(playerid)
{
	if (sniperworld[playerid] == true)
		return SCM(playerid, COL_RED, "Anda berada di dalam Deathmatch");
}

stock saveData(playerid)
{
	new insert[150];
	AccountInfo[playerid][pMoney] = GetPlayerMoney(playerid);
	mysql_format(ourconnection, insert, sizeof(insert), "UPDATE `accounts` SET `Money` = %i WHERE `acc_dbid` = %i", GetPlayerMoney(playerid), AccountInfo[playerid][pDBID]);
	mysql_tquery(ourconnection, insert);
	return 1;
}

stock sweepSmbCheckpoint(playerid)
{
    if(AccountInfo[playerid][pSweeping] == 1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb1))
		{
			SetPlayerCheckpoint(playerid, sweepersmb2, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb2))
		{
			SetPlayerCheckpoint(playerid, sweepersmb3, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb3))
		{
			SetPlayerCheckpoint(playerid, sweepersmb4, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb4))
		{
			SetPlayerCheckpoint(playerid, sweepersmb5, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb5))
		{
			SetPlayerCheckpoint(playerid, sweepersmb6, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb6))
		{
			SetPlayerCheckpoint(playerid, sweepersmb7, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb7))
		{
			SetPlayerCheckpoint(playerid, sweepersmb8, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb8))
		{
			SetPlayerCheckpoint(playerid, sweepersmb9, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb9))
		{
			SetPlayerCheckpoint(playerid, sweepersmb10, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb10))
		{
			SetPlayerCheckpoint(playerid, sweepersmb11, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb11))
		{
			SetPlayerCheckpoint(playerid, sweepersmb12, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb12))
		{
			SetPlayerCheckpoint(playerid, sweepersmb13, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb13))
		{
			SetPlayerCheckpoint(playerid, sweepersmb14, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb14))
		{
			SetPlayerCheckpoint(playerid, sweepersmb15, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb15))
		{
			SetPlayerCheckpoint(playerid, sweepersmb16, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb16))
		{
			SetPlayerCheckpoint(playerid, sweepersmb17, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb17))
		{
			SetPlayerCheckpoint(playerid, sweepersmb18, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb18))
		{
			SetPlayerCheckpoint(playerid, sweepersmb19, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb19))
		{
			SetPlayerCheckpoint(playerid, sweepersmb20, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb20))
		{
			SetPlayerCheckpoint(playerid, sweepersmb21, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb21))
		{
			SetPlayerCheckpoint(playerid, sweepersmb22, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb22))
		{
			SetPlayerCheckpoint(playerid, sweepersmb23, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb23))
		{
			SetPlayerCheckpoint(playerid, sweepersmb24, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb24))
		{
			SetPlayerCheckpoint(playerid, sweepersmb25, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb25))
		{
			SetPlayerCheckpoint(playerid, sweepersmb26, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb26))
		{
			SetPlayerCheckpoint(playerid, sweepersmb27, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb27))
		{
			SetPlayerCheckpoint(playerid, sweepersmb28, 5.0);
		}
		if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepersmb28))
		{
			GivePlayerMoney(playerid, 3000);
			SetVehicleToRespawn(GetPlayerVehicleID(playerid));
			DisablePlayerCheckpoint(playerid);
			AccountInfo[playerid][pSweeping] = 0;
		}
	}
    return 1;
}

stock sweepRodeoCheckpoint(playerid)
{
	if(AccountInfo[playerid][pSweeping] == 1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo1))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo2, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo2))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo3, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo3))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo4, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo4))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo5, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo5))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo6, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo6))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo7, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo7))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo8, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo8))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo9, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo9))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo10, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo10))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo11, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo11))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo12, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo12))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo13, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo13))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo14, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo14))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo15, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo15))
		{
			SetPlayerCheckpoint(playerid, sweeperrodeo16, 5.0);
		}
		if(IsPlayerInRangeOfPoint(playerid, 5.0, sweeperrodeo16))
		{
			GivePlayerMoney(playerid, 3000);
			SetVehicleToRespawn(GetPlayerVehicleID(playerid));
			DisablePlayerCheckpoint(playerid);
			AccountInfo[playerid][pSweeping] = 0;
		}
	}
	return 1;
}

stock sweepTempleCheckpoint(playerid)
{
	if(AccountInfo[playerid][pSweeping] == 1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple1))
		{
			SetPlayerCheckpoint(playerid, sweepertemple2, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple2))
		{
			SetPlayerCheckpoint(playerid, sweepertemple3, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple3))
		{
			SetPlayerCheckpoint(playerid, sweepertemple4, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple4))
		{
			SetPlayerCheckpoint(playerid, sweepertemple5, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple5))
		{
			SetPlayerCheckpoint(playerid, sweepertemple6, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple6))
		{
			SetPlayerCheckpoint(playerid, sweepertemple7, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple7))
		{
			SetPlayerCheckpoint(playerid, sweepertemple8, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple8))
		{
			SetPlayerCheckpoint(playerid, sweepertemple9, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple9))
		{
			SetPlayerCheckpoint(playerid, sweepertemple10, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple10))
		{
			SetPlayerCheckpoint(playerid, sweepertemple11, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple11))
		{
			SetPlayerCheckpoint(playerid, sweepertemple12, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple12))
		{
			SetPlayerCheckpoint(playerid, sweepertemple13, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple13))
		{
			SetPlayerCheckpoint(playerid, sweepertemple14, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple14))
		{
			SetPlayerCheckpoint(playerid, sweepertemple15, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple15))
		{
			SetPlayerCheckpoint(playerid, sweepertemple16, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple16))
		{
			SetPlayerCheckpoint(playerid, sweepertemple17, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple17))
		{
			SetPlayerCheckpoint(playerid, sweepertemple18, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple18))
		{
			SetPlayerCheckpoint(playerid, sweepertemple19, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple19))
		{
			SetPlayerCheckpoint(playerid, sweepertemple20, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple20))
		{
			SetPlayerCheckpoint(playerid, sweepertemple21, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple21))
		{
			SetPlayerCheckpoint(playerid, sweepertemple22, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple22))
		{
			SetPlayerCheckpoint(playerid, sweepertemple23, 5.0);
		}
		if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepertemple23))
		{
			GivePlayerMoney(playerid, 3000);
			SetVehicleToRespawn(GetPlayerVehicleID(playerid));
			DisablePlayerCheckpoint(playerid);
			AccountInfo[playerid][pSweeping] = 0;
		}
	}
	return 1;
}

stock sweepMarketCheckpoint(playerid)
{
	if(AccountInfo[playerid][pSweeping] == 1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket1))
		{
			SetPlayerCheckpoint(playerid, sweepermarket2, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket2))
		{
			SetPlayerCheckpoint(playerid, sweepermarket3, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket3))
		{
			SetPlayerCheckpoint(playerid, sweepermarket4, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket4))
		{
			SetPlayerCheckpoint(playerid, sweepermarket5, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket5))
		{
			SetPlayerCheckpoint(playerid, sweepermarket6, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket6))
		{
			SetPlayerCheckpoint(playerid, sweepermarket7, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket7))
		{
			SetPlayerCheckpoint(playerid, sweepermarket8, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket8))
		{
			SetPlayerCheckpoint(playerid, sweepermarket9, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket9))
		{
			SetPlayerCheckpoint(playerid, sweepermarket10, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket10))
		{
			SetPlayerCheckpoint(playerid, sweepermarket11, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket11))
		{
			SetPlayerCheckpoint(playerid, sweepermarket12, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket12))
		{
			SetPlayerCheckpoint(playerid, sweepermarket13, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket13))
		{
			SetPlayerCheckpoint(playerid, sweepermarket14, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket14))
		{
			SetPlayerCheckpoint(playerid, sweepermarket15, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket15))
		{
			SetPlayerCheckpoint(playerid, sweepermarket16, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket16))
		{
			SetPlayerCheckpoint(playerid, sweepermarket17, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket17))
		{
			SetPlayerCheckpoint(playerid, sweepermarket18, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket18))
		{
			SetPlayerCheckpoint(playerid, sweepermarket19, 5.0);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket19))
		{
			SetPlayerCheckpoint(playerid, sweepermarket20, 5.0);
		}
		if(IsPlayerInRangeOfPoint(playerid, 5.0, sweepermarket20))
		{
			GivePlayerMoney(playerid, 3000);
			SetVehicleToRespawn(GetPlayerVehicleID(playerid));
			DisablePlayerCheckpoint(playerid);
			AccountInfo[playerid][pSweeping] = 0;
		}
	}
	return 1;
}

//===========Function===========

function:SetPlayerCamera(playerid)
{
	new rand = random(3);

	switch(rand)
	{
		case 0:
		{
			SetPlayerCameraPos(playerid, 1217.8131, -1377.3015, 30.2422);
			SetPlayerCameraLookAt(playerid, 1217.0529, -1376.6432, 30.0271);
		}
		case 1:
		{
			SetPlayerCameraPos(playerid, 980.3136, -1664.1619, 71.7542);
			SetPlayerCameraLookAt(playerid, 979.7733, -1665.0083, 70.9241);
		}
		case 2:
		{
			SetPlayerCameraPos(playerid, 1244.9244, -2036.5120, 71.9354);
			SetPlayerCameraLookAt(playerid, 1243.9196, -2036.5469, 71.9701);
		}
		
	}
	return 1;
}

function:ResetPlayer(playerid)
{
	playerLogin[playerid] = 0;
	AccountInfo[playerid][pLoggedin] = false;
	AccountInfo[playerid][pSkin] = 0;
	AccountInfo[playerid][pAdmin] = 0;
}

function:Logplayerin(playerid)
{
	if(cache_num_rows())
	{
		SCMex(playerid, COL_GREEN, "Akun anda telah login kembali di server ini");
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Selamat datang di server ini", "Player ini sudah terdaftar\n tolong masukan password dibawah\n\n", "Login", "Batal");
		return 1;
	}
	SCMex(playerid, COL_ORANGE, "Pemain %s tidak terdaftar di server ini", ReturnName(playerid));
	SCMex(playerid, COL_ORANGE, "Tolong daftar untuk melanjutkan");
	ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Selamat datang di server ini", "Selamat datang:\ntolong masukan password dibawah ini.\n\n", "Buat", "Batal");
	return 1;
}

function:OnPlayerRegister(playerid)
{
	AccountInfo[playerid][pDBID] = cache_insert_id();
	format(AccountInfo[playerid][pAccname], 30, "%s", ReturnName(playerid));

	new thread[120];

	mysql_format(ourconnection, thread, sizeof(thread), "SELECT * FROM accounts WHERE acc_name = '%e'", ReturnName(playerid));
	mysql_tquery(ourconnection, thread, "Query_LoadAccount", "i", playerid);

	AccountInfo[playerid][pLoggedin] = true;
	ShowModelSelectionMenu(playerid, joinskin, "Pilih Skin");

}

function:LoggingIn(playerid)
{
	if(!cache_num_rows())
	{
		playerLogin[playerid]++;
		if(playerLogin[playerid] == 3)
		{
			SCM(playerid, COL_RED, "[SERVER]: Kamu di kick karena memasukan password terlalu sering");
			return KickEx(playerid);
		}

		return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Selamat datang di server ini", "{ff0000}Kamu memasukan password yang salah!{ffffff}\n player ini sudah terdaftar\n tolong masukan password dibawah\n\n", "Login", "Batal");
	}

	new thread[120];

	mysql_format(ourconnection, thread, sizeof(thread), "SELECT * FROM `accounts` WHERE `acc_name` = '%e'", ReturnName(playerid));
	mysql_tquery(ourconnection, thread, "Query_LoadAccount", "d", playerid);

	GivePlayerMoney(playerid,AccountInfo[playerid][pMoney]);
	format(AccountInfo[playerid][pAccname], 30, "%s", ReturnName(playerid));
	
	AccountInfo[playerid][pLoggedin] = true;
    ShowModelSelectionMenu(playerid, joinskin, "Pick A Skin");
	return 1;
}


function:Query_LoadAccount(playerid)
{
	cache_get_value_name_int(0, "Money", AccountInfo[playerid][pMoney]);
	cache_get_value_name_int(0, "Admin", AccountInfo[playerid][pAdmin]);
	cache_get_value_name_int(0, "acc_dbid", AccountInfo[playerid][pDBID]);
	return 1;
}

function:ReturnPlayerName(playerid)
{
	new player_name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, player_name, MAX_PLAYER_NAME);
	return 1;
}

function:ReturnDate()
{
	new	
		string[800],
        month[12],
        date[6];
 
    getdate(date[2], date[1], date[0]);
    gettime(date[3], date[4], date[5]);
 
    switch (date[1]) 
	{
        case 1: month = "01";
        case 2: month = "02";
        case 3: month = "03";
        case 4: month = "04";
        case 5: month = "05";
        case 6: month = "06";
        case 7: month = "07";
        case 8: month = "08";
        case 9: month = "09";
        case 10: month = "10";
        case 11: month = "11";
        case 12: month = "12";
	}
    format(string, sizeof string, "%02d:%02d:%02d", date[3], date[4], date[5]);//jam
    TextDrawSetString(PublicTD[0], string);
	format(string, sizeof string, "%02d/%s/%d", date[0], month, date[2]);//Tanggal
	TextDrawSetString(PublicTD[1], string);
	return 1;
}

function:infoplayer(playerid)
{
	new string1[256];
    new Float:X,Float:Y,Float:Z;
    GetPlayerPos(playerid, X, Y, Z);
    format(string1,sizeof(string1),"VID:%d_|_POS:_X:%.0f Y:%.0f Z:%.0f_|_WID:%d_|_INT:%d", GetPlayerVehicleID(playerid), X, Y, Z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    TextDrawSetString(PublicTD[3], string1);
	return 1;
}

function: speedometer(playerid)
{
	new String[150];
	format(String,150,"~R~%s",g_arrVehicleNames[GetVehicleModel(GetPlayerVehicleID(playerid))-400]);
    PlayerTextDrawSetString(playerid, speed[playerid][1], String);
	new Float:X;
	new Float:Y;
	new Float:Z;
	GetVehicleVelocity(GetPlayerVehicleID(playerid),X,Y,Z);
	format(String,150,"SPEED ~R~%d KM/H",floatround(floatsqroot(X * X + Y * Y + Z * Z) * 150.0000));
    PlayerTextDrawSetString(playerid, speed[playerid][2], String);
	new Float:Health;
	GetVehicleHealth(GetPlayerVehicleID(playerid),Health);
	format(String,150,"Health ~R~%d.0",floatround(Health / 10));
    PlayerTextDrawSetString(playerid, speed[playerid][3], String);
	return 1;
}