
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#using scripts\shared\ai\zombie_utility;

//Perks
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_electric_cherry;
#using scripts\zm\_zm_perks;

//Powerups
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;

//Traps
#using scripts\zm\_zm_trap_electric;

#using scripts\zm\zm_usermap;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_laststand;

#using scripts\shared\hud_util_shared;

#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_zm_spawner;
#using scripts\shared\ai\zombie_shared;

#using scripts\zm\_zm_ai_dogs;

#using scripts\shared\system_shared;


#insert scripts\shared\ai\zombie.gsh;
#insert scripts\shared\ai\systems\gib.gsh;

#insert scripts\zm\_zm.gsh;
#insert scripts\zm\_zm_perks.gsh;


function main() 
{
	level.room_flooded = [];
	level.room_flooded["Spawn Room"] = false;
	level.room_flooded["Staminarch"] = false;
	level.room_flooded["Clean Room"] = false;
	level.room_flooded["Lion Room"] = false;

	level.flood_water = [];
	level.flood_water["Spawn Room"] = GetEnt("spawn_room_water", "targetname");
	level.flood_water["Staminarch"] = GetEnt("staminarch_water", "targetname");
	level.flood_water["Clean Room"] = GetEnt("clean_room_water", "targetname");
	level.flood_water["Lion Room"] = GetEnt("lion_room_water", "targetname");

	level.flood_water_origin = [];
	level.flood_water_origin["Spawn Room"] = level.flood_water["Spawn Room"].origin;
	level.flood_water_origin["Staminarch"] = level.flood_water["Staminarch"].origin;
	level.flood_water_origin["Clean Room"] = level.flood_water["Clean Room"].origin;
	level.flood_water_origin["Lion Room"] = level.flood_water["Lion Room"].origin;

	level.flood_water_dest = [];	
	level.flood_water_dest["Spawn Room"] = (344, -144, 112);
	level.flood_water_dest["Staminarch"] = (1032, -1142, 276);
	level.flood_water_dest["Clean Room"] = (-424, 352, 96);
	level.flood_water_dest["Lion Room"] = (200, 1704, 112);

	thread tide_manager();
	//thread testeroo();
}

function testeroo()
{
	while(true)
	{
		IPrintLn(level.flood_water_origin["Staminarch"]);
		wait(1.5);
	}
}

function tide_manager()
{
	drain_trig1 = GetEnt("drain_trig1", "targetname");
	drain_trig1 SetCursorHint("HINT_NOICON");
	drain_trig2 = GetEnt("drain_trig2", "targetname");
	drain_trig2 SetCursorHint("HINT_NOICON");
	drain_trig3 = GetEnt("drain_trig3", "targetname");
	drain_trig3 SetCursorHint("HINT_NOICON");

	drain_trig1 Hide();
	drain_trig2 Hide();
	drain_trig3 Hide();

	while(true)
	{
		roundsToWait = randomintrange( 2, 3 );
		for(i = 0; i < roundsToWait; i++)
		{
			level waittill("start_of_round");
		}
		while(level.in_unpausable_ee_sequence || level flag::get( "dog_round" ))
		{
			level waittill("start_of_round");
		}

		rooms = GetArrayKeys(level.floodable_rooms);

		room_index = RandomIntRange(0, rooms.size);
		flood_room1 = rooms[room_index];
		level.room_flooded[flood_room1] = true;
		rooms = array::remove_index(rooms, room_index);

		room_index = RandomIntRange(0, rooms.size);
		flood_room2 = rooms[room_index];
		level.room_flooded[flood_room2] = true;
		rooms = array::remove_index(rooms, room_index);

		room_index = RandomIntRange(0, rooms.size);
		flood_room3 = rooms[room_index];
		level.room_flooded[flood_room3] = true;

		IPrintLnBold("High tides!");

		drain_trig1 Show();
		drain_trig2 Show();
		drain_trig3 Show();

		drain_trig1 thread drain_trig_think(flood_room1);
		drain_trig2 thread drain_trig_think(flood_room2);
		drain_trig3 thread drain_trig_think(flood_room3);

		level waittill("end_of_round");

		drain_trig1 Hide();
		drain_trig2 Hide();
		drain_trig3 Hide();

		foreach(flood_room in GetArrayKeys(level.room_flooded))
		{
			//IPrintLn("looping " + flood_room);
			if(level.room_flooded[flood_room])
			{
				flood_water = level.flood_water[flood_room];
				level.room_flooded[flood_room] = false;
				flood_water MoveTo(level.flood_water_origin[flood_room], 5);
				thread delayed_notify(flood_room);
			}
		}

	}
}

function delayed_notify(flood_room)
{
	wait(5);
	IPrintLnBold(flood_room + " water drained");
	level notify(flood_room + "_drained");
}

function drain_trig_think(flood_room)
{
	level endon(flood_room + "_drained");

	flood_water = level.flood_water[flood_room];
	flood_water_move_to = struct::get(flood_water.target, "targetname");

	IPrintLnBold("Flooding will make " + flood_room + " uninhabitable");
	flood_water MoveTo(level.flood_water_dest[flood_room], 10);
	IPrintLn(level.flood_water_dest[flood_room]);
	wait(10);

	foreach(player in GetPlayers())
	{
		player thread check_player_in_flood(flood_room);
	}
	
	self SetHintString("Press ^3[{+activate}]^7 to drain water in " + flood_room + " [Blood Vial required]");

	self waittill("trigger", player);
	while(! level.hasVial)
	{
		self waittill("trigger", player);
	}

	self Hide();
	level.hasVial = false;
	level.room_flooded[flood_room] = false;
	flood_water MoveTo(level.flood_water_origin[flood_room], 5);
	wait(5);
	IPrintLnBold(flood_room + " water drained");
	level notify(flood_room + "_drained");
}

function check_player_in_flood(flood_room)
{
	level endon(flood_room + "_drained");

	zoneset = level.floodable_rooms[flood_room];

	while(true)
	{
		if(self is_player_in_room(zoneset))
		{
			self DisableInvulnerability();
			self.lives = 0;
			self dodamage( self.health + 1000, self.origin );
			self.bleedout_time = 0;
		}
		wait(0.05);
	}

}

function is_player_in_room(zoneset)
{
	for(i = 0; i < zoneset.size; i++)
	{
		if( self zm_zonemgr::entity_in_zone(zoneset[i]) )
		{
			return true;
		}
	}
	return false;
}