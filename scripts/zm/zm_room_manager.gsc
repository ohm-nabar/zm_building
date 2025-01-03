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

#precache( "eventstring", "abbey_room" );

function main() 
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

	level.floodable_rooms = [];
	level.floodable_rooms["Spawn Room"] = spawn_room_zones;
	level.floodable_rooms["Staminarch"] = staminarch_zones;
	level.floodable_rooms["Clean Room"] = clean_room_zones;
	//level.floodable_rooms["Lion Room"] = lion_room_zones;

	level.abbey_rooms_indices = [];
	level.abbey_rooms_indices["Spawn Room"] = 0;
	level.abbey_rooms_indices["Staminarch"] = 1;
	level.abbey_rooms_indices["Water Tower"] = 2;
	level.abbey_rooms_indices["Clean Room"] = 3;
	level.abbey_rooms_indices["Lion Room"] = 4;
	level.abbey_rooms_indices["Downstairs Room"] = 5;

	level.one_room_challenge_rooms = [];
	level.one_room_challenge_rooms["Spawn Room"] = spawn_room_zones;
	level.one_room_challenge_rooms["Staminarch"] = staminarch_zones;
	level.one_room_challenge_rooms["Water Tower"] = water_tower_zones;
	level.one_room_challenge_rooms["Clean Room"] = clean_room_zones;
	level.one_room_challenge_rooms["Lion Room"] = lion_room_zones;
	level.one_room_challenge_rooms["Downstairs Room"] = downstairs_room_zones;

	level.one_room_challenge_rooms_indices = [];
	level.one_room_challenge_rooms_indices["Spawn Room"] = 0;
	level.one_room_challenge_rooms_indices["Staminarch"] = 1;
	level.one_room_challenge_rooms_indices["Water Tower"] = 2;
	level.one_room_challenge_rooms_indices["Clean Room"] = 3;
	level.one_room_challenge_rooms_indices["Lion Room"] = 4;
	level.one_room_challenge_rooms_indices["Downstairs Room"] = 5;

	level.above_rooms = [];
	level.above_rooms[level.above_rooms.size] = "Spawn Room";
	level.above_rooms[level.above_rooms.size] = "Water Tower";
	level.above_rooms[level.above_rooms.size] = "Staminarch";
	level.above_rooms[level.above_rooms.size] = "Lion Room";
	level.above_rooms[level.above_rooms.size] = "Downstairs Room";

	level.beach_rooms = [];
	level.beach_rooms[level.beach_rooms.size] = "Clean Room";

    callback::on_connect( &on_player_connect );
    //monitor_beach_zones();
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

	/*
	room_display = NewClientHudElem(self);
	room_display.alignX = "right";
	room_display.alignY = "bottom";
	room_display.horzAlign = "fullscreen";
	room_display.vertAlign = "fullscreen";
	room_display.x = 615;
	room_display.y = 465;
	room_display.fontscale = 1;
	room_display.alpha = 1;
	room_display.color = (1,1,1);
	room_display.hidewheninmenu = true;
	room_display.foreground = true;
	room_display setText("");
	*/

	current_room = "";
	while(true)
	{
		foreach(room in rooms)
		{
			if( self is_player_in_room(level.abbey_rooms[room]) && room != current_room )
			{
				self LUINotifyEvent( &"abbey_room", 1, level.abbey_rooms_indices[room] );
				current_room = room;
				//room_display setText(room);
			}
		}
		wait(0.05);
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