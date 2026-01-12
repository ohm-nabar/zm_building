#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;
#insert scripts\shared\ai\zombie.gsh;

#insert scripts\zm\_zm.gsh;
#insert scripts\zm\_zm_utility.gsh;

#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_utility;

#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;

#using scripts\zm\_zm_score;

#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_zm_spawner;

#using scripts\zm\_zm_ai_dogs;

#using scripts\shared\system_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\zm\zm_abbey_inventory;
#using scripts\zm\zm_cloak_logic;
#using scripts\zm\zm_room_manager;

#precache( "material", "shadow_kill_indicator" ); 

#precache( "eventstring", "generator_attacked" );

#define CLOAK_SPAWN_DELAY_MIN 2
#define CLOAK_SPAWN_DELAY_MAX 4

#namespace zm_ai_shadowpeople;

REGISTER_SYSTEM( "zm_ai_shadowpeople", &__init__, undefined )
	
function __init__()
{
	level clientfield::register( "clientuimodel", "shadowPerks", VERSION_SHIP, 3, "int");
	level clientfield::register( "actor", "cloak_shadowing", VERSION_SHIP, 1, "int" );
	level clientfield::register( "actor", "shadow_death", VERSION_SHIP, 1, "int" );
	level clientfield::register( "scriptmover", "lightning_spawn", VERSION_SHIP, 1, "int" );

	level.in_shadow_spawn_sequence = false;
	
	level.choker_spawn_points = GetEntArray("choker_spawn_point", "targetname");

	level.choker_spawner = GetEnt("choker_spawner", "script_noteworthy");
	level.choker_spawner thread spawner::add_spawn_function(&choker_spawn_init);

	level.escargot_spawner = GetEnt("escargot_spawner", "script_noteworthy");
	level.escargot_spawner thread spawner::add_spawn_function(&escargot_spawn_init);

	level.cloak_spawner = GetEnt("cloak_spawner", "script_noteworthy");
	level.cloak_spawner thread spawner::add_spawn_function(&cloak_spawn_init);

	level.shadow_ai_limit = 40;
	level.shadow_transition_active = false;
	level.shadow_vision_active = false;
	level.shadow_round_paused = false;

	num_cloaks1 = array(2, 2, 3, 3);
	num_cloaks2 = array(3, 3, 4, 4);
	num_cloaks3 = array(4, 4, 5, 6);

	num_escargots1 = array(1, 1, 1, 1);
	num_escargots2 = array(2, 2, 2, 2);
	num_escargots3 = array(2, 3, 3, 4);

	cloak_health1 = array(1045, 1527, 1045, 1527); // Round 10, 14 health
	cloak_health2 = array(4348, 5260, 4348, 5260); // Round 25, 27 health
	cloak_health3 = array(7000, 9317, 7700, 9317); // Round 30, 31, 33 health

	escargot_health1 = array(5786, 7000, 5786, 7000); // Round 28, 30 health
	escargot_health2 = array(11272, 12399, 13638, 15001); // Round 35, 36, 37, 38 health
	escargot_health3 = array(18151, 18151, 19966, 18151); // Round 40, 41 health

	level.num_cloaks_table = array(num_cloaks1, num_cloaks2, num_cloaks3);
	level.num_escargots_table = array(num_escargots1, num_escargots2, num_escargots3);

	level.cloak_health_table = array(cloak_health1, cloak_health2, cloak_health3);
	level.escargot_health_table = array(escargot_health1, escargot_health2, escargot_health3);

	level.max_cloaks_table = array(1, 1, 2, 2);

	level.dog_round_track_override = &zm_ai_shadowpeople::dog_round_tracker;
	level zm::register_player_damage_callback( &player_damage_override );
	level zm::register_actor_damage_callback( &damage_adjustment );
	level zm::register_zombie_damage_override_callback( &zombie_damage_override );
	level visionset_mgr::register_info("visionset", "abbey_shadow", VERSION_SHIP, 61, 1, true);
	level thread skip_round_check();
}

function is_shadow_boss()
{
	return (isdefined(self.targetname) && (self.targetname == "zombie_cloak" || self.targetname == "zombie_escargot"));
}

function is_shadow_person()
{
	return (isdefined(self.targetname) && (self is_shadow_boss() || self.targetname == "zombie_choker"));
}

function is_cloak(ai)
{
	return IS_EQUAL(ai.targetname, "zombie_cloak");
}

function get_cloaks()
{
	cloaks = GetAISpeciesArray("axis", "all");
	cloaks = level array::filter(cloaks, false, &is_cloak);

	return cloaks;
}

function player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if(IS_TRUE(self.shadow_invulnerable))
	{
		return 0;
	}

	return -1;
}

function damage_adjustment(  inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType  )
{
    if(isdefined(attacker) && isdefined(attacker.activated_by_player) && isdefined(self.targetname) && (self.targetname == "zombie_cloak" || self.targetname == "zombie_escargot"))
	{
		return 0;
	}

	return -1;
}

function zombie_damage_override(willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if ( isPlayer( attacker ) && willBeKilled && ! IS_TRUE(attacker.no_shadow_points) )
	{
		if(isdefined(self.targetname))
		{
			if(self.targetname == "zombie_cloak")
			{
				if(level.zombie_vars[attacker.team]["zombie_point_scalar"] == 2)
				{
					attacker thread zm_score::add_to_player_score( 1500 );
				}
				else
				{
					attacker thread zm_score::add_to_player_score( 750 );
				}
			}
			else if(self.targetname == "zombie_escargot")
			{
				if(level.zombie_vars[attacker.team]["zombie_point_scalar"] == 2)
				{
					attacker thread zm_score::add_to_player_score( 3000 );
				}
				else
				{
					attacker thread zm_score::add_to_player_score( 1500 );
				}
			}
		}
	}
}

function pause(antiverse=false)
{
	level.shadow_round_paused = true;

	if(antiverse)
	{
		wait(5);
		zombies = GetAITeamArray( level.zombie_team );
		foreach(zombie in zombies)
		{
			if(zombie.targetname == "zombie_choker")
			{
				zombie dodamage( zombie.health + 666, zombie.origin );
			}
			else
			{
				zombie.kill_indicator.alpha = 0;
				if(zombie.targetname == "zombie_cloak")
				{
					zombie ASMSetAnimationRate(0);
				}
			}
			
		}		
	}
}

function unpause(antiverse=false)
{
	level.shadow_round_paused = false;

	if(antiverse)
	{
		zombies = GetAITeamArray( level.zombie_team );
		foreach(zombie in zombies)
		{
			if(zombie.targetname != "zombie_choker")
			{
				zombie.kill_indicator.alpha = 1;
				zombie ASMSetAnimationRate(1);
			}
		}
	}
}

function escargot_spawn(spawn_point)
{
	if(! isdefined(spawn_point))
	{
		spawn_point = level dog_spawn_factory_logic(level get_random_valid_player(false));
	}

	escargot = level zombie_utility::spawn_zombie(level.escargot_spawner);

	level dog_spawn_fx( spawn_point );
	escargot ForceTeleport(spawn_point.origin, spawn_point.angles);

	//escargot clientfield::set( "shadow_fx", 1 );

	escargot thread ai_waypoint_manage(75);
	escargot thread escargot_death_notify();

	wait(0.25);
	escargot PlaySound("shadow_escargot_spawn");


	//escargot clientfield::set( "shadow_choker_fx", 1 );
	//escargot thread ai_testeroo();
}

function cloak_spawn(target, spawn_point)
{
	level endon(#"skip_round");

	level dog_spawn_fx( spawn_point );
	cloak = zombie_utility::spawn_zombie(level.cloak_spawner);
	cloak ForceTeleport(spawn_point.origin, spawn_point.angles);
	//cloak clientfield::set( "shadow_wizard_fx", 1 );
	
	//cloak clientfield::set( "shadow_wizard_fx", 1 );
	cloak thread ai_waypoint_manage(75);
	cloak thread cloak_death_notify();
	//generator = GetEnt("generator1", "script_noteworthy");
	cloak.v_zombie_custom_goal_pos = target.origin;
	
	return cloak;
	//generator zm_utility::create_zombie_point_of_interest( 1536, 1, 10000 );
}

function choker_spawn(player)
{
	level endon("last_ai_down");

	spawn_point = level dog_spawn_factory_logic(player);
	level dog_spawn_fx( spawn_point );
	choker = zombie_utility::spawn_zombie(level.choker_spawner);
	//spawner = array::random( level.zombie_spawners );
	//choker = zombie_utility::spawn_zombie( spawner, spawner.targetname ); 
	choker.favoriteenemy = player;
	choker ForceTeleport(spawn_point.origin, spawn_point.angles);
	choker thread choker_death_notify();
	//choker thread monitor_cloak_interaction();

	//choker clientfield::set( "shadow_choker_fx", 1 );
}

function monitor_cloak_interaction()
{
	self endon("death");

	while(true)
	{
		if( isdefined(level.cloak) && IsAlive(level.cloak) && Distance(self.origin, level.cloak.origin) < 35 )
		{
			self DoDamage(self.health + 666, self.origin);
		}
		wait(0.05);	
	}
}

function ai_waypoint_manage(offset)
{
	waypoint_pos = Spawn("script_model", self.origin);
	waypoint_pos SetModel("tag_origin");
	waypoint_pos LinkTo(self, "tag_origin", (0, 0, offset));

	kill_indicator = NewHudElem();
	kill_indicator SetTargetEnt(waypoint_pos);
	kill_indicator SetShader("shadow_kill_indicator");
	kill_indicator SetWayPoint(true, "shadow_kill_indicator", false, false);
	self.kill_indicator = kill_indicator;

	self waittill("death");
	waypoint_pos Delete();
	kill_indicator Destroy();
}

function dog_round_tracker()
{
	level.dog_round_count = 1;
	
	// PI_CHANGE_BEGIN - JMA - making dog rounds random between round 5 thru 7
	// NOTE:  RandomIntRange returns a random integer r, where min <= r < max
	level waittill(#"generator_activated");
	level.next_dog_round = level.round_number + randomintrange( 3, 5 );
	// PI_CHANGE_END
	
	old_spawn_func = level.round_spawn_func;
	old_wait_func  = level.round_wait_func;

	while ( 1 )
	{
		level waittill ( "between_round_over" );

		if ( level.round_number == level.next_dog_round )
		{
			level.sndMusicSpecialRound = true;
			old_spawn_func = level.round_spawn_func;
			old_wait_func  = level.round_wait_func;

			zm_ai_dogs::dog_round_start();
			SetDvar( "ai_meleeRange", level.melee_range_sav ); 
		 	SetDvar( "ai_meleeWidth", level.melee_width_sav );
		 	SetDvar( "ai_meleeHeight", level.melee_height_sav );

			level.round_spawn_func = &dog_round_spawning;
			level.round_wait_func = &zm_ai_dogs::dog_round_wait_func;

			level.next_dog_round = level.round_number + randomintrange( 5, 7 );
		}
		else if ( level flag::get( "dog_round" ) )
		{
			zm_ai_dogs::dog_round_stop();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func  = old_wait_func;
		}
	}	
}

function end_shadow_round()
{
	zombies = GetAITeamArray( level.zombie_team );
	for(i = 0; i < zombies.size; i++)
	{
		zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
	}

	level notify ( "last_ai_down" );
	level.shadow_vision_active = false;
	level zm_audio::sndMusicSystem_StopAndFlush();
	level lui::screen_flash( 0.3, 0.8, 0.3, 1.0, "white" );
	level util::set_lighting_state( 0 );
	foreach(player in level.players)
	{
		player.shadow_invulnerable = true;
		player.inhibit_scoring_from_zombies = false;
		player PlaySoundToPlayer("shadow_flash", player);
		level visionset_mgr::deactivate("visionset", "abbey_shadow", player);
	}

	level.in_shadow_spawn_sequence = false;
	level.no_powerups = false;
	
	level.dog_round_count += 1;
	level.zombie_ai_limit = 24;

	wait(1.4);
	foreach(player in level.players)
	{
		player.shadow_invulnerable = false;
	}
}

function skip_round_check()
{
	while(true)
	{	
		level waittill(#"skip_round");
		if(level flag::get("dog_round"))
		{
			level end_shadow_round();
		}
	}
}

function dog_round_spawning()
{
	level endon( "intermission" );
	level endon( "end_of_round" );
	level endon( "restart_round" );
	level endon( "kill_round" );
	level endon( #"skip_round" );

	if( level.intermission )
	{
		return;
	}

	level.dog_intermission = true;
	level thread zm_ai_dogs::dog_round_aftermath();
	level array::thread_all( level.players,&zm_ai_dogs::play_dog_round );	
	wait(1.1);
	level.shadow_transition_active = true;
	foreach(player in level.players)
	{
		player util::show_hud(false);
	}
	level thread lui::screen_fade_out( 2, "black" );
	for(i = 0; i < 2 && ! level.in_antiverse; i += 0.05)
	{
		wait(0.05);
	}
	while(level.in_antiverse)
	{
		wait(0.05);
	}
	level util::set_lighting_state( 1 );
	foreach(player in level.players)
	{
		level visionset_mgr::activate("visionset", "abbey_shadow", player, 0.5, 9999, 0.5);
		player.inhibit_scoring_from_zombies = true;

		primary_weapons = player GetWeaponsListPrimaries();
		foreach( weapon in primary_weapons )
		{
			player SetWeaponAmmoClip(weapon, weapon.clipSize);
			player GiveMaxAmmo(weapon);
		}
	}
	level.shadow_vision_active = true;
	level thread lui::screen_fade_in( 4.9, "black" );
	for(i = 0; i < 4.9 && ! level.in_antiverse; i += 0.05)
	{
		wait(0.05);
	}

	while(level.in_antiverse)
	{
		wait(0.05);
	}
	
	//level thread zm_audio::sndAnnouncerPlayVox("dogstart");
	level zm_audio::sndMusicSystem_StopAndFlush();
	level thread zm_audio::sndMusicSystem_PlayState("shadow_breach");
	foreach(player in level.players)
	{
		if(! player.abbey_no_hud)
		{
			player util::show_hud(true);
		}
	}
	level.shadow_transition_active = false;

	level.cloak_health = level calculate_cloak_health();
	level.choker_health = level calculate_choker_health();
	level.escargot_health = level calculate_escargot_health();

	level.num_cloaks = level calculate_num_cloaks();
	level.num_escargots = level calculate_num_escargots();

	level.no_powerups = true;
	level.zombie_ai_limit = 64;

	while( IsWorldPaused() ) 
	{
		wait(0.05);
	}

	level.in_shadow_spawn_sequence = true;

	level thread cloak_spawn_sequence();

	while(level.num_cloaks > 0)
	{
		in_antiverse = false;
		if(zombie_utility::get_current_zombie_count() >= level.shadow_ai_limit || (level.shadow_round_paused && ! level.in_antiverse))
		{
			wait(0.05);
			continue;
		}

		while(level.in_antiverse)
		{
			in_antiverse = true;
			wait(0.05);
		}

		if(in_antiverse)
		{
			wait(1);
		}
		else
		{
			level thread choker_spawn(level get_random_valid_player());
			choker_wait_time = 1 - ( 0.2 * (level.players.size - 1) );
			wait(choker_wait_time);
		}
	}

	while(level.shadow_round_paused)
	{
		wait(0.05);
	}

	lui::screen_flash( 0.3, 0.8, 0.3, 1.0, "white" );
	foreach(player in level.players)
	{
		player.shadow_invulnerable = true;
		player PlaySoundToPlayer("shadow_flash", player);
	}
	wait(1);

	zombies = GetAITeamArray( level.zombie_team );
	for(i = 0; i < zombies.size; i++)
	{
		zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
	}

	wait(0.4);

	foreach(player in level.players)
	{
		player.shadow_invulnerable = false;
	}

	level thread escargot_spawn_sequence();

	while(level.num_escargots > 0)
	{
		in_antiverse = false;
		if(zombie_utility::get_current_zombie_count() >= level.shadow_ai_limit || (level.shadow_round_paused && ! level.in_antiverse))
		{
			wait(0.05);
			continue;
		}

		while(level.in_antiverse)
		{
			in_antiverse = true;
			wait(0.05);
		}

		if(in_antiverse)
		{
			wait(1);
		}

		level thread choker_spawn(level get_random_valid_player());
		choker_wait_time = 1 - ( 0.2 * (level.players.size - 1) );
		wait(choker_wait_time);
	}

	level end_shadow_round();
}

function get_random_valid_player(ignore_laststand_players=true)
{
	valid_players = [];
	foreach(player in level.players)
	{
		if(level zm_utility::is_player_valid(player, false, ignore_laststand_players))
		{
			level array::add(valid_players, player);
		}
	}
	return level array::random(valid_players);
}

function cloak_spawn_sequence()
{
	level endon(#"skip_round");

	cloaks_to_spawn = level.num_cloaks;
	max_cloaks = level calculate_max_cloaks();
	generators = level array::randomize(level.active_generators);

	level.generators_shadowed = [];
	level.num_cloaks_alive = 0;

	for(i = 0; i < cloaks_to_spawn; i++)
	{
		in_antiverse = false;
		time_to_wait = RandomIntRange(CLOAK_SPAWN_DELAY_MIN, CLOAK_SPAWN_DELAY_MAX + 1);
		wait(time_to_wait);

		if(level.generators_shadowed.size == generators.size)
		{
			level.num_cloaks = 0;
			break;
		}

		counter = 0;
		do
		{
			gen_num = generators[(i + counter) % generators.size];
			cloaks = level get_cloaks();
			used_gen_nums = [];
			foreach(cloak in cloaks)
			{
				level array::add(used_gen_nums, cloak.gen_num);
			}
			counter += 1;
			wait(0.05);
		}
		while(level array::contains(used_gen_nums, gen_num));

		attack_struct = level struct::get("generator" + gen_num + "_attack", "targetname");
		num_cloaks_prev = level.num_cloaks;

		generator_already_shadowed = false;
		for(j = 0; j < level.generators_shadowed.size; j++)
		{
			if(gen_num == level.generators_shadowed[j])
			{
				generator_already_shadowed = true;
			}
		}

		if(generator_already_shadowed)
		{
			level.num_cloaks--;
			continue;
		}

		while(level.shadow_round_paused && ! level.in_antiverse)
		{
			wait(0.05);
		}

		while(level.in_antiverse)
		{
			in_antiverse = true;
			wait(0.05);
		}

		if(in_antiverse)
		{
			wait(1);
		}

		level thread zm_cloak_logic::cloak_spawn_logic(attack_struct, gen_num);
		level.num_cloaks_alive += 1;

		while(level.num_cloaks_alive >= max_cloaks)
		{
			wait(0.05);
		}
	}
}

function escargot_spawn_sequence()
{
	for(i = 0; i < level.num_escargots; i++)
	{
		time_to_wait = RandomIntRange(CLOAK_SPAWN_DELAY_MIN, CLOAK_SPAWN_DELAY_MAX + 1);
		wait(time_to_wait);

		while(level.shadow_round_paused && ! level.in_antiverse)
		{
			wait(0.05);
		}

		in_antiverse = false;
		while(level.in_antiverse)
		{
			in_antiverse = true;
			wait(0.05);
		}
		if(in_antiverse)
		{
			wait(1);
		}

		level zm_cloak_logic::escargot_spawn_logic();
	}
}

function calculate_choker_health()
{
	if(level.dog_round_count == 1)
	{
		return 10; // instakill health
	}
	else if(level.dog_round_count == 2)
	{
		return 10; // instakill health
	}
	else
	{
		return 10; // instakill health
	}
}

function calculate_num_cloaks()
{
	round_index = level.dog_round_count - 1;
	player_index = level.players.size - 1;

	return level.num_cloaks_table[round_index][player_index];
}

function calculate_num_escargots()
{
	round_index = level.dog_round_count - 1;
	player_index = level.players.size - 1;

	return level.num_escargots_table[round_index][player_index];
}

function calculate_cloak_health()
{
	round_index = level.dog_round_count - 1;
	player_index = level.players.size - 1;

	return level.cloak_health_table[round_index][player_index];
}

function calculate_escargot_health()
{
	round_index = level.dog_round_count - 1;
	player_index = level.players.size - 1;

	return level.escargot_health_table[round_index][player_index];
}

function calculate_max_cloaks()
{
	player_index = level.players.size - 1;
	return level.max_cloaks_table[player_index];
}

function cloak_think()
{
	self endon( "death" ); 
	assert( !self.isdog );
	
	self.ai_state = "zombie_think";
	//self.find_flesh_struct_string = "find_flesh";

	//self SetGoal( self.origin );
	self PathMode( "move allowed" );
	self.zombie_think_done = true;
}

function cloak_spawn_init()
{
	
	self.targetname = "zombie_cloak";
	self.script_noteworthy = undefined;
	//self.start_inert = true;
	self.ignore_nuke = true;
	self.instakill_func = &instakill_func;
	//self.custom_location = &do_zombie_spawn;

	//A zombie was spawned - recalculate zombie array
	zm_utility::recalc_zombie_array();

	self.animname = "zombie"; 		
	
	//pre-spawn gamemodule init
	if(isdefined(zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")]]();
	}

	/*
	self thread zm_spawner::play_ambient_zombie_vocals();
	self thread zm_audio::zmbAIVox_NotifyConvert();
	self.zmb_vocals_attack = "zmb_vocals_zombie_attack";
	*/
	 
	self.ignoreme = false;
	self.allowdeath = true; 			// allows death during animscripted calls
	self.force_gib = false; 		// we don't want him to gib, he is shadow
	self.is_zombie = true; 			// needed for melee.gsc in the animscripts
	self allowedStances( "stand" );
	self BloodImpact("none");
	
	//needed to make sure zombies don't distribute themselves amongst players
	self.attackerCountThreatScale = 0;
	//reduce the amount zombies favor their current enemy
	self.currentEnemyThreatScale = 0;
	//reduce the amount zombies target recent attackers
	self.recentAttackerThreatScale = 0;
	//zombies dont care about whether players are in cover
	self.coverThreatScale = 0;
	//make sure zombies have 360 degree visibility
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	
	self.zombie_damaged_by_bar_knockdown = false; // This tracks when I can knock down a zombie with a bar

	self.gibbed = false; 
	self.head_gibbed = false;
	
	// might need this so co-op zombie players cant block zombie pathing
//	self PushPlayer( true ); 
//	self.meleeRange = 128; 
//	self.meleeRangeSq = anim.meleeRange * anim.meleeRange; 

	self setPhysParams( 15, 0, 72 );
	self.goalradius = 32;
	
	self.disableArrivals = true; 
	self.disableExits = true; 
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;

	self.ignoreSuppression = true; 	
	self.suppressionThreshold = 1; 
	self.noDodgeMove = true; 
	self.dontShootWhileMoving = true;
	self.pathenemylookahead = 0;


	self.holdfire			= true;	//no firing - performance gain

	self.badplaceawareness = 0;
	self.chatInitialized = false;
	self.missingLegs = false;

	if ( !isdefined( self.zombie_arms_position ) )
	{
		if(randomint( 2 ) == 0)
			self.zombie_arms_position = "up";
		else
			self.zombie_arms_position = "down";
	}

	if ( randomint( 100 ) < ZM_CAN_STUMBLE )
	{
		self.canStumble = true;
	}
	
	//self.a.disablepain = true;
	self zm_utility::disable_react(); // SUMEET - zombies dont use react feature.
	
	self.maxhealth = level.cloak_health; 
	self.health = self.maxhealth; 
	
	self.freezegun_damage = 0;

	//setting avoidance parameters for zombies
	self setAvoidanceMask( "avoid none" );

	// wait for zombie to teleport into position before pathing
	self PathMode( "dont move" );

	level thread zm_spawner::zombie_death_event( self );

	// We need more script/code to get this to work properly
//	self add_to_spectate_list();
//	self random_tan(); 
	self zm_utility::init_zombie_run_cycle(); 
	self zombie_utility::set_zombie_run_cycle( "sprint" );
	//self thread zm_spawner::zombie_think(); 
	self thread cloak_think();
	//self thread zombie_utility::zombie_gib_on_damage(); 
	self thread zm_spawner::zombie_damage_failsafe();
	
	self thread zm_spawner::enemy_death_detection();

	if(IsDefined(level._zombie_custom_spawn_logic))
	{
		if(IsArray(level._zombie_custom_spawn_logic))
		{
			for(i = 0; i < level._zombie_custom_spawn_logic.size; i ++)
			{
			self thread [[level._zombie_custom_spawn_logic[i]]]();
			}
		}
		else
		{
			self thread [[level._zombie_custom_spawn_logic]]();
		}
	}

	self.no_eye_glow = true;
	
	if ( !isdefined( self.no_eye_glow ) || !self.no_eye_glow )
	{
		if ( !IS_TRUE( self.is_inert ) )
		{
			self thread zombie_utility::delayed_zombie_eye_glow();	// delayed eye glow for ground crawlers (the eyes floated above the ground before the anim started)
		}
	}
	self.deathFunction = &zm_spawner::zombie_death_animscript;
	self.flame_damage_time = 0;

	self.meleeDamage = 60;	// 45
	self.no_powerups = true;
	
	self zm_spawner::zombie_history( "choker_spawn_init -> Spawned = " + self.origin );

	self.thundergun_knockdown_func = level.basic_zombie_thundergun_knockdown;
	//self.tesla_head_gib_func = &zombie_tesla_head_gib;

	self.team = level.zombie_team;
	
	// No sight update
	self.updateSight = false;

	self.heroweapon_kill_power = ZM_ZOMBIE_HERO_WEAPON_KILL_POWER;
	self.sword_kill_power = ZM_ZOMBIE_HERO_WEAPON_KILL_POWER;

	self PushActors(false);

	self thread cloak_ignore_all();

	if ( isDefined(level.achievement_monitor_func) )
	{
		self [[level.achievement_monitor_func]]();
	}

	//gamemodule post init
	if(isdefined(zm_utility::get_gamemode_var("post_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("post_init_zombie_spawn_func")]]();
	}

	if ( isDefined( level.zombie_init_done ) )
	{
		self [[ level.zombie_init_done ]]();
	}
	self.zombie_init_done = true;

	self notify( "zombie_init_done" );
}

function cloak_ignore_all()
{
	self endon("death");
	self endon("goal_reached");

	while(true)
	{
		self.ignoreall = true; 
		self.favortieenemy = undefined;
		wait(0.05);
	}
}

function escargot_spawn_init()
{
	
	self.targetname = "zombie_escargot";
	self.script_noteworthy = undefined;
	self.start_inert = true;
	self.ignore_nuke = true;
	self.instakill_func = &instakill_func;
	//self.custom_location = &do_zombie_spawn;

	//A zombie was spawned - recalculate zombie array
	zm_utility::recalc_zombie_array();

	self.animname = "zombie"; 		
	
	//pre-spawn gamemodule init
	if(isdefined(zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")]]();
	}

	/*
	self thread zm_spawner::play_ambient_zombie_vocals();
	self thread zm_audio::zmbAIVox_NotifyConvert();
	self.zmb_vocals_attack = "zmb_vocals_zombie_attack";
	*/
	 
	self.ignoreme = false;
	self.allowdeath = true; 			// allows death during animscripted calls
	self.force_gib = false; 		// we don't want him to gib, he is shadow
	self.is_zombie = true; 			// needed for melee.gsc in the animscripts
	self allowedStances( "stand" );
	self BloodImpact("none");
	
	//needed to make sure zombies don't distribute themselves amongst players
	self.attackerCountThreatScale = 0;
	//reduce the amount zombies favor their current enemy
	self.currentEnemyThreatScale = 0;
	//reduce the amount zombies target recent attackers
	self.recentAttackerThreatScale = 0;
	//zombies dont care about whether players are in cover
	self.coverThreatScale = 0;
	//make sure zombies have 360 degree visibility
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	
	self.zombie_damaged_by_bar_knockdown = false; // This tracks when I can knock down a zombie with a bar

	self.gibbed = false; 
	self.head_gibbed = false;
	
	// might need this so co-op zombie players cant block zombie pathing
//	self PushPlayer( true ); 
//	self.meleeRange = 128; 
//	self.meleeRangeSq = anim.meleeRange * anim.meleeRange; 

	self setPhysParams( 15, 0, 72 );
	self.goalradius = 32;
	
	self.disableArrivals = true; 
	self.disableExits = true; 
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;

	self.ignoreSuppression = true; 	
	self.suppressionThreshold = 1; 
	self.noDodgeMove = true; 
	self.dontShootWhileMoving = true;
	self.pathenemylookahead = 0;


	self.holdfire			= true;	//no firing - performance gain

	self.badplaceawareness = 0;
	self.chatInitialized = false;
	self.missingLegs = false;

	if ( !isdefined( self.zombie_arms_position ) )
	{
		if(randomint( 2 ) == 0)
			self.zombie_arms_position = "up";
		else
			self.zombie_arms_position = "down";
	}

	if ( randomint( 100 ) < ZM_CAN_STUMBLE )
	{
		self.canStumble = true;
	}
	
	//self.a.disablepain = true;
	self zm_utility::disable_react(); // SUMEET - zombies dont use react feature.
	
	self.maxhealth = level.escargot_health; 
	self.health = self.maxhealth; 
	
	self.freezegun_damage = 0;

	//setting avoidance parameters for zombies
	self setAvoidanceMask( "avoid none" );

	// wait for zombie to teleport into position before pathing
	self PathMode( "dont move" );

	level thread zm_spawner::zombie_death_event( self );

	// We need more script/code to get this to work properly
//	self add_to_spectate_list();
//	self random_tan(); 
	self zm_utility::init_zombie_run_cycle(); 
	self zombie_utility::set_zombie_run_cycle( "walk" );
	self thread zm_spawner::zombie_think(); 
	//self thread zombie_utility::zombie_gib_on_damage(); 
	self thread zm_spawner::zombie_damage_failsafe();
	
	self thread zm_spawner::enemy_death_detection();

	if(IsDefined(level._zombie_custom_spawn_logic))
	{
		if(IsArray(level._zombie_custom_spawn_logic))
		{
			for(i = 0; i < level._zombie_custom_spawn_logic.size; i ++)
			{
			self thread [[level._zombie_custom_spawn_logic[i]]]();
			}
		}
		else
		{
			self thread [[level._zombie_custom_spawn_logic]]();
		}
	}

	self.no_eye_glow = true;
	
	if ( !isdefined( self.no_eye_glow ) || !self.no_eye_glow )
	{
		if ( !IS_TRUE( self.is_inert ) )
		{
			self thread zombie_utility::delayed_zombie_eye_glow();	// delayed eye glow for ground crawlers (the eyes floated above the ground before the anim started)
		}
	}
	self.deathFunction = &zm_spawner::zombie_death_animscript;
	self.flame_damage_time = 0;

	self.meleeDamage = 60;	// 45
	self.no_powerups = true;
	
	self zm_spawner::zombie_history( "choker_spawn_init -> Spawned = " + self.origin );

	self.thundergun_knockdown_func = level.basic_zombie_thundergun_knockdown;
	//self.tesla_head_gib_func = &zombie_tesla_head_gib;

	self.team = level.zombie_team;
	
	// No sight update
	self.updateSight = false;

	self.heroweapon_kill_power = ZM_ZOMBIE_HERO_WEAPON_KILL_POWER;
	self.sword_kill_power = ZM_ZOMBIE_HERO_WEAPON_KILL_POWER;

	self PushActors(false);

	if ( isDefined(level.achievement_monitor_func) )
	{
		self [[level.achievement_monitor_func]]();
	}

	//gamemodule post init
	if(isdefined(zm_utility::get_gamemode_var("post_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("post_init_zombie_spawn_func")]]();
	}


	if ( isDefined( level.zombie_init_done ) )
	{
		self [[ level.zombie_init_done ]]();
	}
	self.zombie_init_done = true;

	self notify( "zombie_init_done" );
}

/*
	Name: function_dc28c71b
	Namespace: namespace_36e5bc12
	Checksum: 0x6D15B00F
	Offset: 0xFC8
	Size: 0x17C
	Parameters: 3
	Flags: Linked
*/
function function_dc28c71b(zombie, type, override)
{
	zombie endon("death");
	if(!isdefined(zombie))
	{
		return;
	}
	if(!isdefined(zombie.voiceprefix))
	{
		return;
	}
	alias = (("zmb_vocals_" + zombie.voiceprefix) + "_") + type + RandomIntRange(1, 4);
	if(zm_audio::sndIsNetworkSafe())
	{
		if(isdefined(override) && override)
		{
			if(type == "death")
			{
				zombie playsound(alias);
			}
			else
			{
				zombie playsoundontag(alias, "j_neck");
			}
		}
		else if(!(isdefined(zombie.talking) && zombie.talking))
		{
			zombie.talking = 1;
			zombie playsoundwithnotify(alias, "sounddone", "j_neck");
			zombie waittill("sounddone");
			zombie.talking = 0;
		}
	}
}

/*
	Name: function_f93398c4
	Namespace: namespace_36e5bc12
	Checksum: 0x3C6935D4
	Offset: 0x1150
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function function_f93398c4()
{
	self endon("death");
	wait(randomfloatrange(1, 3));
	while(true)
	{
		type = "sprint";
		self notify("bhtn_action_notify", type);
		wait(randomfloatrange(1, 4));
	}
}

/*
	Name: function_b7efd00a
	Namespace: namespace_36e5bc12
	Checksum: 0xA8609CA9
	Offset: 0xE68
	Size: 0x152
	Parameters: 0
	Flags: Linked
*/
function function_b7efd00a()
{
	self endon("death");
	while(true)
	{
		self waittill("bhtn_action_notify", notify_string);
		if(isdefined(level.bzm_worldpaused) && level.bzm_worldpaused)
		{
			continue;
		}
		if(self isinscriptedstate())
		{
			continue;
		}
		switch(notify_string)
		{
			case "attack_melee":
			case "behind":
			case "close":
			case "death":
			case "electrocute":
			{
				level thread function_dc28c71b(self, notify_string, 1);
				break;
			}
			case "ambient":
			case "crawler":
			case "sprint":
			case "taunt":
			case "teardown":
			{
				level thread function_dc28c71b(self, notify_string, 0);
				break;
			}
		}
	}
}

function choker_spawn_init()
{
	self.targetname = "zombie_choker";
	self.script_noteworthy = undefined;
	self.start_inert = true;
	self.ignore_nuke = true;
	self.instakill_func = &instakill_func;
	//self.custom_location = &do_zombie_spawn;

	//A zombie was spawned - recalculate zombie array
	zm_utility::recalc_zombie_array();

	self.animname = "zombie"; 		
	
	//pre-spawn gamemodule init
	if(isdefined(zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")]]();
	}

	self.voiceprefix = "choker";
	self thread function_f93398c4();
	self thread function_b7efd00a();
	 
	self.ignoreme = false;
	self.allowdeath = true; 			// allows death during animscripted calls
	self.force_gib = false; 		// we don't want him to gib, he is shadow
	self.is_zombie = true; 			// needed for melee.gsc in the animscripts
	self allowedStances( "stand" );
	self BloodImpact("none");
	
	//needed to make sure zombies don't distribute themselves amongst players
	self.attackerCountThreatScale = 0;
	//reduce the amount zombies favor their current enemy
	self.currentEnemyThreatScale = 0;
	//reduce the amount zombies target recent attackers
	self.recentAttackerThreatScale = 0;
	//zombies dont care about whether players are in cover
	self.coverThreatScale = 0;
	//make sure zombies have 360 degree visibility
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	
	self.zombie_damaged_by_bar_knockdown = false; // This tracks when I can knock down a zombie with a bar

	self.gibbed = false; 
	self.head_gibbed = false;
	
	// might need this so co-op zombie players cant block zombie pathing
//	self PushPlayer( true ); 
//	self.meleeRange = 128; 
//	self.meleeRangeSq = anim.meleeRange * anim.meleeRange; 

	self setPhysParams( 15, 0, 72 );
	self.goalradius = 32;
	
	self.disableArrivals = true; 
	self.disableExits = true; 
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;

	self.ignoreSuppression = true; 	
	self.suppressionThreshold = 1; 
	self.noDodgeMove = true; 
	self.dontShootWhileMoving = true;
	self.pathenemylookahead = 0;


	self.holdfire			= true;	//no firing - performance gain

	self.badplaceawareness = 0;
	self.chatInitialized = false;
	self.missingLegs = false;

	if ( !isdefined( self.zombie_arms_position ) )
	{
		if(randomint( 2 ) == 0)
			self.zombie_arms_position = "up";
		else
			self.zombie_arms_position = "down";
	}

	if ( randomint( 100 ) < ZM_CAN_STUMBLE )
	{
		self.canStumble = true;
	}
	
	//self.a.disablepain = true;
	self zm_utility::disable_react(); // SUMEET - zombies dont use react feature.
	
	self.maxhealth = level.choker_health; 
	self.health = self.maxhealth; 
	
	self.freezegun_damage = 0;

	//setting avoidance parameters for zombies
	self setAvoidanceMask( "avoid none" );

	// wait for zombie to teleport into position before pathing
	self PathMode( "dont move" );

	level thread zm_spawner::zombie_death_event( self );

	// We need more script/code to get this to work properly
//	self add_to_spectate_list();
//	self random_tan(); 
	self zm_utility::init_zombie_run_cycle(); 
	self zombie_utility::set_zombie_run_cycle( "super_sprint" );
	self thread zm_spawner::zombie_think(); 
	//self thread zombie_utility::zombie_gib_on_damage(); 
	self thread zm_spawner::zombie_damage_failsafe();
	
	self thread zm_spawner::enemy_death_detection();

	if(IsDefined(level._zombie_custom_spawn_logic))
	{
		if(IsArray(level._zombie_custom_spawn_logic))
		{
			for(i = 0; i < level._zombie_custom_spawn_logic.size; i ++)
			{
			self thread [[level._zombie_custom_spawn_logic[i]]]();
			}
		}
		else
		{
			self thread [[level._zombie_custom_spawn_logic]]();
		}
	}

	self.no_eye_glow = true;
	
	if ( !isdefined( self.no_eye_glow ) || !self.no_eye_glow )
	{
		if ( !IS_TRUE( self.is_inert ) )
		{
			self thread zombie_utility::delayed_zombie_eye_glow();	// delayed eye glow for ground crawlers (the eyes floated above the ground before the anim started)
		}
	}
	self.deathFunction = &zm_spawner::zombie_death_animscript;
	self.flame_damage_time = 0;

	self.meleeDamage = 60;	// 45
	self.no_powerups = true;
	
	self zm_spawner::zombie_history( "choker_spawn_init -> Spawned = " + self.origin );

	self.thundergun_knockdown_func = level.basic_zombie_thundergun_knockdown;
	//self.tesla_head_gib_func = &zombie_tesla_head_gib;

	self.team = level.zombie_team;
	
	// No sight update
	self.updateSight = false;

	self.heroweapon_kill_power = ZM_ZOMBIE_HERO_WEAPON_KILL_POWER;
	self.sword_kill_power = ZM_ZOMBIE_HERO_WEAPON_KILL_POWER;

	self PushActors(false);

	if ( isDefined(level.achievement_monitor_func) )
	{
		self [[level.achievement_monitor_func]]();
	}

	//gamemodule post init
	if(isdefined(zm_utility::get_gamemode_var("post_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("post_init_zombie_spawn_func")]]();
	}

	if ( isDefined( level.zombie_init_done ) )
	{
		self [[ level.zombie_init_done ]]();
	}
	self.zombie_init_done = true;

	self notify( "zombie_init_done" );
}

function instakill_func(player, mod, hit_location)
{
	return true;
}

function escargot_death_notify()
{
	self waittill("death");
	level.num_escargots--;

	PlaySoundAtPosition("shadow_escargot_kill", self.origin);
	self clientfield::set("shadow_death", 1);

	level notify("escargot_killed", self.origin);

	if(!level.trident_shell_activated && self zm_room_manager::is_player_in_room(level.abbey_rooms[level.trident_init_room]))
	{
		level.trident_shell_activated = true;
	}

	if(level.num_escargots == 0)
	{
		zm_powerups::specific_powerup_drop( "full_ammo", self.origin);
		if(level.generators_shadowed.size == 0)
		{
			zm_powerups::specific_powerup_drop("free_perk", self.origin + (40,0,0));
		}
		else if(level.generators_shadowed.size == 4)
		{
			zm_powerups::specific_powerup_drop("free_perk", self.origin + (40,0,0));
			zm_powerups::specific_powerup_drop("free_perk", self.origin + (-40,0,0));
		}
	}
	level util::wait_network_frame();
	self Delete();
}

function cloak_death_notify()
{
	self waittill("death");
	level.num_cloaks--;
	level.num_cloaks_alive--;
	alias_name = "shadow_kill" + RandomIntRange(1, 4);
	PlaySoundAtPosition(alias_name, self.origin);
	self clientfield::set("shadow_death", 1);
	level util::wait_network_frame();
	self Delete();
}

function choker_death_notify()
{
	self waittill("death");
	alias_name = "shadow_kill" + RandomIntRange(1, 4);
	PlaySoundAtPosition(alias_name, self.origin);
	self clientfield::set("shadow_death", 1);
	level util::wait_network_frame();
	self Delete();
}

function dog_spawn_factory_logic(favorite_enemy, cloak_spawn)
{
	dog_locs = array::randomize( level.zm_loc_types[ "dog_location" ] );
	//assert( dog_locs.size > 0, "Dog Spawner locs array is empty." );
	for( i = 0; i < dog_locs.size; i++ )
	{
		if( ( isdefined( level.old_dog_spawn ) && level.old_dog_spawn == dog_locs[i] ) || ( IS_TRUE(cloak_spawn) && ( !isdefined(dog_locs[i].script_string) || dog_locs[i].script_string != "cloak" ) ) )
		{
			continue;
		}

		dist_squared = DistanceSquared( dog_locs[i].origin, favorite_enemy.origin );
		if(  dist_squared > ( 400 * 400 ) && dist_squared < ( 1000 * 1000 ) )
		{
			level.old_dog_spawn = dog_locs[i];
			return dog_locs[i];
		}	
	}

	return dog_locs[0];
}

function dog_spawn_fx( ent )
{
	
	/*if ( !IsDefined(ent) )
	{
		ent = struct::get( self.target, "targetname" );
	}*/

//	if ( isdefined( ent ) )

	fx_model = Spawn("script_model", ent.origin);
	fx_model SetModel("tag_origin");
	fx_model clientfield::set("lightning_spawn", 1);
	playsoundatposition( "zmb_hellhound_prespawn", ent.origin );
	wait( 1.5 );
	playsoundatposition( "zmb_hellhound_bolt", ent.origin );

	Earthquake( 0.5, 0.75, ent.origin, 1000);
	//PlayRumbleOnPosition("explosion_generic", ent.origin);
	playsoundatposition( "zmb_hellhound_spawn", ent.origin );
	fx_model Delete();
}