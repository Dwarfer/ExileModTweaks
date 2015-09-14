/**
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_itemClassName","_cantBuildNear"];
_itemClassName = _this select 0;
if( isClass(configFile >> "CfgMagazines" >> _itemClassName >> "Interactions" >> "Constructing") ) then
{
	if (findDisplay 602 != displayNull) then
	{
		(findDisplay 602) closeDisplay 2; 
	};
	try 
	{
		if !((vehicle player) isEqualTo player) then { throw "ConstructionVehicleWarning"; };
		if ((getPosATL player) call ExileClient_util_world_isTraderZoneNearby) then { throw "ConstructionTraderZoneWarning"; };
		if ((getPosATL player) call ExileClient_util_world_isSpawnZoneNearby) then { throw "ConstructionSpawnZoneWarning"; };

		//Stops Building In Towns
		_cnt = count nearestLocations [getPosATL player, ["NameVillage","NameCity","NameCityCapital"], 500];
		if (_cnt > 0 ) then { throw "ConstructionAbortedInformation"; };		
		
		/* PREVENT BUILDING NEAR CERTAIN TYPES OF BUILDING */
		_cantBuildNear = [
			"Land_Dome_Big_F",
			"Land_Dome_Small_F",
			"Land_Barracks_ruins_F",
			"Land_i_Barracks_V1_F",
			"Land_i_Barracks_V1_dam_F",
			"Land_i_Barracks_V2_F",
			"Land_i_Barracks_V2_dam_F",
			"Land_u_Barracks_V2_F",
			"Land_Hospital_main_F",
			"Land_Hospital_side1_F",
			"Land_Hospital_side2_F",
			"Land_MilOffices_V1_F",
			"Land_TentHangar_V1_F",
			"Land_Hangar_F",
			"Land_Airport_Tower_F",
			"Land_Cargo_House_V1_F",
			"Land_Cargo_House_V3_F",
			"Land_Cargo_HQ_V1_F",
			"Land_Cargo_HQ_V2_F",
			"Land_Cargo_HQ_V3_F",
			"Land_Cargo_Patrol_V1_F",
			"Land_Cargo_Patrol_V2_F",
			"Land_Cargo_Tower_V1_F",
			"Land_Cargo_Tower_V1_No1_F",
			"Land_Cargo_Tower_V1_No2_F",
			"Land_Cargo_Tower_V1_No3_F",
			"Land_Cargo_Tower_V1_No4_F",
			"Land_Cargo_Tower_V1_No5_F",
			"Land_Cargo_Tower_V1_No6_F",
			"Land_Cargo_Tower_V1_No7_F",
			"Land_Cargo_Tower_V2_F",
			"Land_Cargo_Tower_V3_F",
			"Land_Radar_F"
		];
		_cantBuildDist = 100;
		if ({typeOf _x in _cantBuildNear} count nearestObjects[player, _cantBuildNear, _cantBuildDist] > 0) then { throw "ConstructionAbortedInformation"; };
		
		/* PREVENT BUILDING NEAR KEY MILITARY AND INDUSTRIAL LOCATIONS */
//		if ((player distance [23802.7, 16133.9, 0]) < 1500) then { throw "ConstructionAbortedInformation"; };
		if ((player distance [3073.84,13177.1,0]) < 250) then { throw "ConstructionAbortedInformation"; };
		if ((player distance [12813.08, 16672.213, 0]) < 500) then { throw "ConstructionAbortedInformation"; };
		if ((player distance [20941.604, 19236.865, 0]) < 150) then { throw "ConstructionAbortedInformation"; };
		if ((player distance [6178.40, 16245.77, 0]) < 250) then { throw "ConstructionAbortedInformation"; };
		if ((player distance [14347.18, 18940.27, 0]) < 200) then { throw "ConstructionAbortedInformation"; };
		if ((player distance [18310.604, 15548.075, 0]) < 150) then { throw "ConstructionAbortedInformation"; };
		if ((player distance [16083.555, 16992.264, 0]) < 200) then { throw "ConstructionAbortedInformation"; };
		if ((player distance [17432.287, 13148.771, 0]) < 150) then { throw "ConstructionAbortedInformation"; };
		if ((player distance [23581.842, 21099.982, 0]) < 200) then { throw "ConstructionAbortedInformation"; };
		
		/* PREVENT BUILDING ON ROADS */
		if (isOnRoad getPosATL player) then { throw "ConstructionAbortedInformation"; }; 		

		if(_itemClassName isEqualTo "Exile_Item_Flag") then { throw "FLAG"; };
		[_itemClassName] call ExileClient_construction_beginNewObject;
	}
	catch 
	{
		if(_exception isEqualTo "FLAG")then
		{
			call ExileClient_gui_setupTerritoryDialog_show;
		}
		else
		{
			if(_exception isEqualTo "ConstructionAbortedInformation")then{
				[_exception,"Building Permit Denied"] call ExileClient_gui_notification_event_addNotification;
			}else{
				[_exception] call ExileClient_gui_notification_event_addNotification;
			};
		};	
	};
};
true