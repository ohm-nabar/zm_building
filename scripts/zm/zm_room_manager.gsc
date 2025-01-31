#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_zm_utility;
#using scripts\shared\callbacks_shared;
#using scripts\zm\_zm;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\scene_shared;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_zonemgr;
#using scripts\shared\laststand_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_room_manager;

REGISTER_SYSTEM( "zm_room_manager", &__init__, undefined )

function __init__() 
{
	clientfield::register( "clientuimodel", "abbeyRoom", VERSION_SHIP, 5, "int" );

	if(GetDvarString("ui_mapname") == "zm_building")
	{
		spawn_room_zones = []; spawn_room_zones[spawn_room_zones.size] = "start_zone";
		staminarch_zones = []; staminarch_zones[staminarch_zones.size] = "staminarch";
		water_tower_zones = []; water_tower_zones[water_tower_zones.size] = "wtower";
		clean_room_zones = []; clean_room_zones[clean_room_zones.size] = "clean";
		lion_room_zones = []; lion_room_zones[lion_room_zones.size] = "dirty";
		downstairs_room_zones = []; downstairs_room_zones[downstairs_room_zones.size] = "downstairs";

		level.abbey_rooms = [];
		level.abbey_rooms["Spawn Room"] = spawn_room_zones;
		level.abbey_rooms["Staminarch"] = staminarch_zones;
		level.abbey_rooms["Water Tower"] = water_tower_zones;
		level.abbey_rooms["Clean Room"] = clean_room_zones;
		level.abbey_rooms["Lion Room"] = lion_room_zones;
		level.abbey_rooms["Downstairs Room"] = downstairs_room_zones;

		level.abbey_rooms_indices = [];
		level.abbey_rooms_indices["Spawn Room"] = 0;
		level.abbey_rooms_indices["Staminarch"] = 1;
		level.abbey_rooms_indices["Water Tower"] = 2;
		level.abbey_rooms_indices["Clean Room"] = 3;
		level.abbey_rooms_indices["Lion Room"] = 4;
		level.abbey_rooms_indices["Downstairs Room"] = 5;

		level.above_rooms = [];
		level.above_rooms[level.above_rooms.size] = "Spawn Room";
		level.above_rooms[level.above_rooms.size] = "Water Tower";
		level.above_rooms[level.above_rooms.size] = "Staminarch";
		level.above_rooms[level.above_rooms.size] = "Lion Room";
		level.above_rooms[level.above_rooms.size] = "Downstairs Room";

		level.beach_rooms = [];
		level.beach_rooms[level.beach_rooms.size] = "Clean Room";
	}
	else
	{
		spawn_room_zones = []; spawn_room_zones[spawn_room_zones.size] = "start_zone";
		redroom_zones = []; redroom_zones[redroom_zones.size] = "red_zone";
		bell_zones = []; bell_zones[bell_zones.size] = "bell_zone";
		platform_zones = []; platform_zones[platform_zones.size] = "platform_r_zone"; platform_zones[platform_zones.size] = "platform_t_zone"; platform_zones[platform_zones.size] = "platform_l_zone";
		scaffolding_zones = []; scaffolding_zones[scaffolding_zones.size] = "platform_m_zone";
		choir_zones = []; choir_zones[choir_zones.size] = "heart_zone"; choir_zones[choir_zones.size] = "choir_r_zone"; choir_zones[choir_zones.size] = "choir_l_zone"; choir_zones[choir_zones.size] = "choir_t_zone";
		centre_zones = []; centre_zones[centre_zones.size] = "centre_zone";
		basilica_zones = []; basilica_zones[basilica_zones.size] = "basilica_zone";
		pilgrimage_zones = []; pilgrimage_zones[pilgrimage_zones.size] = "pilgrimage_zone";
		urm_lab_zones = []; urm_lab_zones[urm_lab_zones.size] = "urm_labs_zone";
		bridge_zones = []; bridge_zones[bridge_zones.size] = "bridge_zone";
		mid_pilgrimage_zones = []; mid_pilgrimage_zones[mid_pilgrimage_zones.size] = "mid_pilgrimage_zone";
		guardcatwalk_zones = []; guardcatwalk_zones[guardcatwalk_zones.size] = "guardcatwalk_zone";
		library_zones = []; library_zones[library_zones.size] = "library_zone";
		lower_pilgrimage_zones = []; lower_pilgrimage_zones[lower_pilgrimage_zones.size] = "lower_pilgrimage_zone";
		courtroom_zones = []; courtroom_zones[courtroom_zones.size] = "courtroom_zone";
		courtyard_zones = []; courtyard_zones[courtyard_zones.size] = "courtyard_zone";
		airfield_zones = []; airfield_zones[airfield_zones.size] = "airfield_zone";
		dormitory_zones = []; dormitory_zones[dormitory_zones.size] = "dormitory_zone";
		cloitre_zones = []; cloitre_zones[cloitre_zones.size] = "cloitre_zone";
		merveille_zones = []; merveille_zones[merveille_zones.size] = "merveille_zone";
		spiral_zones = []; spiral_zones[spiral_zones.size] = "spiral_zone";
		forum_zones = []; forum_zones[forum_zones.size] = "forum_zone";
		bridge2_zones = []; bridge2_zones[bridge2_zones.size] = "bridge2_zone";
		nml_zones = []; nml_zones[nml_zones.size] = "nml_zone";

		level.abbey_rooms = [];
		level.abbey_rooms["Crash Site"] = spawn_room_zones;
		level.abbey_rooms["Red Room"] = redroom_zones;
		level.abbey_rooms["Bell Tower"] = bell_zones;
		level.abbey_rooms["Radio Gallery"] = platform_zones;
		level.abbey_rooms["Scaffolding"] = scaffolding_zones;
		level.abbey_rooms["Choir"] = choir_zones;
		level.abbey_rooms["Centre"] = centre_zones;
		level.abbey_rooms["Basilica"] = basilica_zones;
		level.abbey_rooms["Airfield"] = airfield_zones;
		level.abbey_rooms["Dormitory"] = dormitory_zones;
		level.abbey_rooms["Cloitre"] = cloitre_zones;
		level.abbey_rooms["Merveille de Verite"] = merveille_zones;
		level.abbey_rooms["Guard Tower"] = spiral_zones;
		level.abbey_rooms["Courtyard"] = courtyard_zones;
		level.abbey_rooms["Courtroom"] = courtroom_zones;
		level.abbey_rooms["Verite Library"] = library_zones;
		level.abbey_rooms["Lower Pilgrimage Stairs"] = lower_pilgrimage_zones;
		level.abbey_rooms["Guard Tower Catwalk"] = guardcatwalk_zones;
		level.abbey_rooms["Bridge"] = bridge_zones;
		level.abbey_rooms["URM Laboratory"] = urm_lab_zones;
		level.abbey_rooms["Upper Pilgrimage Stairs"] = pilgrimage_zones;
		level.abbey_rooms["Middle Pilgrimage Stairs"] = mid_pilgrimage_zones;
		level.abbey_rooms["Bridge v2"] = bridge2_zones;
		level.abbey_rooms["Knight's Hall"] = forum_zones;
		level.abbey_rooms["No Man's Land"] = nml_zones;

		level.abbey_rooms_indices = [];
		level.abbey_rooms_indices["Crash Site"] = 0;
		level.abbey_rooms_indices["Red Room"] = 1;
		level.abbey_rooms_indices["Bell Tower"] = 2;
		level.abbey_rooms_indices["Radio Gallery"] = 3;
		level.abbey_rooms_indices["Scaffolding"] = 4;
		level.abbey_rooms_indices["Choir"] = 5;
		level.abbey_rooms_indices["Centre"] = 6;
		level.abbey_rooms_indices["Basilica"] = 7;
		level.abbey_rooms_indices["Airfield"] = 8;
		level.abbey_rooms_indices["Dormitory"] = 9;
		level.abbey_rooms_indices["Cloitre"] = 10;
		level.abbey_rooms_indices["Merveille de Verite"] = 11;
		level.abbey_rooms_indices["Guard Tower"] = 12;
		level.abbey_rooms_indices["Courtyard"] = 13;
		level.abbey_rooms_indices["Courtroom"] = 14;
		level.abbey_rooms_indices["Verite Library"] = 15;
		level.abbey_rooms_indices["Lower Pilgrimage Stairs"] = 16;
		level.abbey_rooms_indices["Guard Tower Catwalk"] = 17;
		level.abbey_rooms_indices["Bridge"] = 18;
		level.abbey_rooms_indices["URM Laboratory"] = 19;
		level.abbey_rooms_indices["Upper Pilgrimage Stairs"] = 20;
		level.abbey_rooms_indices["Middle Pilgrimage Stairs"] = 21;
		level.abbey_rooms_indices["Bridge v2"] = 22;
		level.abbey_rooms_indices["Knight's Hall"] = 23;
		level.abbey_rooms_indices["No Man's Land"] = 24;

		level.above_rooms = [];
		level.above_rooms[level.above_rooms.size] = "Crash Site";
		level.above_rooms[level.above_rooms.size] = "Red Room";
		level.above_rooms[level.above_rooms.size] = "Bell Tower";
		level.above_rooms[level.above_rooms.size] = "Radio Gallery";
		level.above_rooms[level.above_rooms.size] = "Scaffolding";
		level.above_rooms[level.above_rooms.size] = "Choir";
		level.above_rooms[level.above_rooms.size] = "Centre";
		level.above_rooms[level.above_rooms.size] = "Basilica";
		level.above_rooms[level.above_rooms.size] = "Airfield";
		level.above_rooms[level.above_rooms.size] = "Dormitory";
		level.above_rooms[level.above_rooms.size] = "Cloitre";
		level.above_rooms[level.above_rooms.size] = "Merveille de Verite";
		level.above_rooms[level.above_rooms.size] = "Courtyard";
		level.above_rooms[level.above_rooms.size] = "Courtroom";
		level.above_rooms[level.above_rooms.size] = "Verite Library";
		level.above_rooms[level.above_rooms.size] = "Bridge";
		level.above_rooms[level.above_rooms.size] = "URM Laboratory";
		level.above_rooms[level.above_rooms.size] = "Upper Pilgrimage Stairs";
		level.above_rooms[level.above_rooms.size] = "Lower Pilgrimage Stairs";
		level.above_rooms[level.above_rooms.size] = "Middle Pilgrimage Stairs";
		level.above_rooms[level.above_rooms.size] = "Bridge v2";
		level.above_rooms[level.above_rooms.size] = "Knight's Hall";
		level.above_rooms[level.above_rooms.size] = "Guard Tower";

		level.beach_rooms = [];
		level.beach_rooms[level.beach_rooms.size] = "No Man's Land";

		level thread monitor_beach_zones();
	}

    callback::on_connect( &on_player_connect );
}

function on_player_connect()
{
	self thread room_manager();
}


function room_manager()
{
	self endon("disconnect");
	
	while(! level flag::get("initial_blackscreen_passed"))
	{
		wait(0.05);
	}

	rooms = GetArrayKeys(level.abbey_rooms);
	while(true)
	{
		foreach(room in rooms)
		{
			if( self is_player_in_room(level.abbey_rooms[room]) )
			{
				self clientfield::set_player_uimodel("abbeyRoom", level.abbey_rooms_indices[room]);
				break;
			}
		}
		util::wait_network_frame();
	}
}

function is_room_active(zoneset) 
{
	return zm_zonemgr::zone_is_enabled( zoneset[0] );
}

function monitor_beach_zones()
{
	while(true)
	{
		players = GetPlayers();
		alive_players = 0;
		beach_players = 0;
		for(i = 0; i < players.size; i++)
		{
			if(players[i].sessionstate != "spectator" && ! players[i] laststand::player_is_in_laststand() && IsAlive(players[i]))
			{
				alive_players += 1;
			}
			for(j = 0; j < level.beach_rooms.size; j++)
			{
				if(players[i] is_player_in_room(level.abbey_rooms[level.beach_rooms[j]]))
				{
					beach_players += 1;
					break;
				}
			}
		}

		zombies = GetAiTeamArray( level.zombie_team );

		if(beach_players == 0)
		{
			for(i = 0; i < zombies.size; i++)
			{
				for(j = 0; j < level.beach_rooms.size; j++)
				{
					if(! IS_TRUE( zombies[i].in_the_ground ) && zombies[i] is_player_in_room(level.abbey_rooms[level.beach_rooms[j]]) && zombies[i].targetname != "zombie_cloak" && zombies[i].targetname != "zombie_escargot")
					{
						level.zombie_total++;
						level.zombie_respawns++;
						zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
						//IPrintLn("sending above");
						break;
					}
				}
			}
		}
		else if(beach_players == alive_players)
		{
			for(i = 0; i < zombies.size; i++)
			{
				for(j = 0; j < level.above_rooms.size; j++)
				{
					if(! IS_TRUE( zombies[i].in_the_ground ) && zombies[i] is_player_in_room(level.abbey_rooms[level.above_rooms[j]]) && zombies[i].targetname != "zombie_cloak" && zombies[i].targetname != "zombie_escargot")
					{
						level.zombie_total++;
						level.zombie_respawns++;
						zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
						//IPrintLn("sending to beach");
						break;
					}
				}
			}
		}

		wait(0.05);
	}
}

function is_player_in_room(zoneset)
{
	for(i = 0; i < zoneset.size; i++)
	{
		if( self zm_zonemgr::entity_in_zone(zoneset[i], true) )
		{
			return true;
		}
	}
	return false;
}