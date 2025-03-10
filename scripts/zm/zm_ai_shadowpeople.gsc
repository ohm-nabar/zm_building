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

#using scripts\zm\zm_room_manager;

#precache( "fx", "shadow/fx_zmb_smokey_death" );
#precache( "fx", "shadow/shadow_zombie_cloak_eyes" );
#precache( "fx", "shadow/cloak_shadowing" );

#precache( "material", "shadow_kill_indicator" ); 

#precache( "eventstring", "generator_attacked" ); 

#namespace zm_ai_shadowpeople;

REGISTER_SYSTEM( "zm_ai_shadowpeople", &__init__, undefined )
	
function __init__()
{
	clientfield::register( "clientuimodel", "shadowPerks", VERSION_SHIP, 3, "int");

	level.in_shadow_spawn_sequence = false;
	
	level.choker_spawn_points = GetEntArray("choker_spawn_point", "targetname");

	level.choker_spawner = GetEnt("choker_spawner", "script_noteworthy");
	level.choker_spawner thread spawner::add_spawn_function(&choker_spawn_init);

	level.escargot_spawner = GetEnt("escargot_spawner", "script_noteworthy");
	level.escargot_spawner thread spawner::add_spawn_function(&escargot_spawn_init);

	level.cloak_spawner = GetEnt("cloak_spawner", "script_noteworthy");
	level.cloak_spawner thread spawner::add_spawn_function(&cloak_spawn_init);

	level.shadow_ai_limit = 40;
	level.shadow_vision_active = false;
	level.shadow_round_paused = false;

	//level.shadow_moon = GetEnt("targetname", "shadow_moon");
	//level.shadow_moon SetInvisibleToAll();

	//clientfield::register( "actor", "shadow_choker_fx", VERSION_SHIP, 1, "int" );
	//clientfield::register( "actor", "shadow_wizard_fx", VERSION_SHIP, 1, "int" );

	zm::register_actor_damage_callback( &damage_adjustment );
	zm::register_zombie_damage_override_callback( &zombie_damage_override );
	visionset_mgr::register_info("visionset", "abbey_shadow", VERSION_SHIP, 61, 1, true);
	//thread choker_spawn();
	thread testeroo();
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
				zombie ASMSetAnimationRate(0);
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

function escargot_spawn(player, trident_spawn)
{
	spawn_point = undefined;
	if(IS_TRUE(trident_spawn))
	{
		spawn_point = escargot_trident_spawn_logic();
	}
	else
	{
		spawn_point = dog_spawn_factory_logic(player);
	}

	escargot = zombie_utility::spawn_zombie(level.escargot_spawner);

	dog_spawn_fx( spawn_point );
	escargot ForceTeleport(spawn_point.origin, spawn_point.angles);

	//escargot clientfield::set( "shadow_fx", 1 );

	escargot thread ai_waypoint_manage(75);
	escargot thread escargot_death_notify();

	wait(0.25);
	escargot PlaySound("shadow_escargot_spawn");


	//escargot clientfield::set( "shadow_choker_fx", 1 );
	//escargot thread ai_testeroo();
}

function cloak_spawn(target)
{
	level endon(#"skip_round");

	spawn_point = dog_spawn_factory_logic(target, true);
	if(isdefined(spawn_point))
	{
		debug_str = "" + spawn_point.origin;
		/# PrintLn(debug_str); #/
	}
	else
	{
		debug_str = "undefined";
		/# PrintLn(debug_str); #/
	}
	dog_spawn_fx( spawn_point );
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

	spawn_point = dog_spawn_factory_logic(player);
	dog_spawn_fx( spawn_point );
	choker = zombie_utility::spawn_zombie(level.choker_spawner);
	//spawner = array::random( level.zombie_spawners );
	//choker = zombie_utility::spawn_zombie( spawner, spawner.targetname ); 
	choker.favoriteenemy = player;
	choker ForceTeleport(spawn_point.origin, spawn_point.angles);
	choker thread choker_death_notify();
	//choker thread monitor_cloak_interaction();

	//choker clientfield::set( "shadow_choker_fx", 1 );
}

function escargot_spawn_ee_radio(player)
{
	level endon("radio_tower_ended");

	spawn_point = dog_spawn_factory_logic_ee_radio(player);
	dog_spawn_fx( spawn_point );
	escargot = zombie_utility::spawn_zombie(level.escargot_spawner);
	escargot ForceTeleport(spawn_point.origin, spawn_point.angles);

	//escargot clientfield::set( "shadow_fx", 1 );

	escargot thread ai_waypoint_manage(75);

	escargot thread escargot_death_notify_ee_radio();

	//escargot clientfield::set( "shadow_choker_fx", 1 );
	//escargot thread ai_testeroo();
}

function cloak_spawn_ee_radio(target)
{
	level endon("radio_tower_ended");

	spawn_point = dog_spawn_factory_logic_ee_radio(target);
	dog_spawn_fx( spawn_point );
	cloak = zombie_utility::spawn_zombie(level.cloak_spawner);
	cloak ForceTeleport(spawn_point.origin, spawn_point.angles);
	//cloak clientfield::set( "shadow_wizard_fx", 1 );
	
	//cloak clientfield::set( "shadow_wizard_fx", 1 );
	cloak thread ai_waypoint_manage(75);
	cloak thread cloak_death_notify_ee_radio();
	//generator = GetEnt("generator1", "script_noteworthy");
	cloak.v_zombie_custom_goal_pos = target.origin;
	
	return cloak;
	//generator zm_utility::create_zombie_point_of_interest( 1536, 1, 10000 );
}

function choker_spawn_ee_radio(player)
{
	level endon("radio_tower_ended");

	spawn_point = dog_spawn_factory_logic_ee_radio(player);
	dog_spawn_fx( spawn_point );
	choker = zombie_utility::spawn_zombie(level.choker_spawner);
	choker ForceTeleport(spawn_point.origin, spawn_point.angles);
	choker thread choker_death_notify_ee_radio();
	choker thread monitor_cloak_interaction();

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
		player PlaySoundToPlayer("shadow_flash", player);
		level visionset_mgr::deactivate("visionset", "abbey_shadow", player);
	}

	level.in_shadow_spawn_sequence = false;
	level.no_powerups = false;
	
	level.dog_round_count += 1;
	level.zombie_ai_limit = 24;

	foreach(player in level.players)
	{
		player.inhibit_scoring_from_zombies = false;
	}
}

function skip_round_check()
{
	while(true)
	{	
		level waittill(#"skip_round");
		level end_shadow_round();
	}
}

function dog_round_spawning()
{
	level endon( "intermission" );
	level endon( "end_of_round" );
	level endon( "restart_round" );
	level endon( "kill_round" );
	level endon( #"skip_round" );

	level thread skip_round_check();

	if( level.intermission )
	{
		return;
	}

	level.dog_intermission = true;
	level thread zm_ai_dogs::dog_round_aftermath();
	players = GetPlayers();
	array::thread_all( players,&zm_ai_dogs::play_dog_round );	

	for(i = 0; i < players.size; i++)
	{
		players[i].inhibit_scoring_from_zombies = true;
		primary_weapons = players[i] GetWeaponsList( true ); 

		players[i] notify( "zmb_max_ammo" );
		players[i] notify( "zmb_lost_knife" );
		players[i] zm_placeable_mine::disable_all_prompts_for_player();
		for( x = 0; x < primary_weapons.size; x++ )
		{
			//don't give grenades if headshot only option is enabled
			if( level.headshots_only && zm_utility::is_lethal_grenade( primary_weapons[x] ) )
			{
				continue;
			}
			
			// Don't refill Equipment
			if ( IsDefined( level.zombie_include_equipment ) && 
			     IsDefined( level.zombie_include_equipment[ primary_weapons[ x ] ] ) &&
			     !IS_TRUE( level.zombie_equipment[ primary_weapons[ x ] ].refill_max_ammo ) )
			{
				continue;
			}
			
			// exclude specific weapons from this list
			if ( IsDefined( level.zombie_weapons_no_max_ammo ) && IsDefined( level.zombie_weapons_no_max_ammo[ primary_weapons[ x ].name ] ) )
			{
				continue;
			}
			
			if ( zm_utility::is_hero_weapon( primary_weapons[ x ] ) )
			{
				continue;
			}
			

			if ( players[i] HasWeapon( primary_weapons[x] ) ) {
				players[i] ReloadWeaponAmmo( primary_weapons[x] );
				players[i] GiveMaxAmmo( primary_weapons[x] );
			}
		}
	}
	wait(1);
	//level thread zm_audio::sndAnnouncerPlayVox("dogstart");
	level zm_audio::sndMusicSystem_StopAndFlush();
	level thread zm_audio::sndMusicSystem_PlayState("shadow_breach");
	wait(2.5);
	level lui::screen_fade_out( 1, "black" );
	level util::set_lighting_state( 1 );
	level lui::screen_fade_in( 1, "black" );
	foreach(player in level.players)
	{
		visionset_mgr::activate("visionset", "abbey_shadow", player, 0.5, 9999, 0.5);
	}
	level.shadow_vision_active = true;
	wait(1);

	level.cloak_health = calculate_cloak_health();
	level.choker_health = calculate_choker_health();
	level.escargot_health = calculate_escargot_health();

	level.num_cloaks = calculate_num_cloaks();
	level.num_escargots = calculate_num_escargots();

	level.no_powerups = true;
	level.zombie_ai_limit = 64;

	while( IsWorldPaused() ) {
		wait(0.05);
	}

	level.in_shadow_spawn_sequence = true;

	debug_str1 = "in shadow spawn sequence";
	debug_str2 = "cloak spawned!";
	/# PrintLn(debug_str1); #/
	level thread cloak_spawn_sequence();
	level waittill(#"cloak_spawned");
	/# PrintLn(debug_str2); #/

	while(level.num_cloaks > 0)
	{
		if(zombie_utility::get_current_zombie_count() >= level.shadow_ai_limit || level.shadow_round_paused)
		{
			wait(0.05);
			continue;
		}
		thread choker_spawn(level get_random_valid_player());
		choker_wait_time = 1 - ( 0.2 * (players.size - 1) );
		wait(choker_wait_time);
	}

	while(level.shadow_round_paused)
	{
		wait(0.05);
	}

	lui::screen_flash( 0.3, 0.8, 0.3, 1.0, "white" );
	foreach(player in level.players)
	{
		player PlaySoundToPlayer("shadow_flash", player);
	}
	wait(1);

	zombies = GetAITeamArray( level.zombie_team );
	for(i = 0; i < zombies.size; i++)
	{
		zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
	}

	for(i = 0; i < level.num_escargots; i++)
	{
		while(level.shadow_round_paused)
		{
			wait(0.05);
		}
		if(i == 0 && ! level.trident_shell_activated && zm_room_manager::is_room_active(level.abbey_rooms[level.trident_init_room]))
		{
			thread escargot_spawn(level get_random_valid_player(), true);
		}
		else
		{
			thread escargot_spawn(level get_random_valid_player());
		}
		wait(1.5);
	}

	while(level.num_escargots > 0)
	{
		if(zombie_utility::get_current_zombie_count() >= level.shadow_ai_limit || level.shadow_round_paused)
		{
			wait(0.05);
			continue;
		}
		thread choker_spawn(level get_random_valid_player());
		choker_wait_time = 1.25 - ( 0.25 * (players.size - 1) );
		wait(choker_wait_time);
	}

	level end_shadow_round();
}

function get_random_valid_player()
{
	valid_players = [];
	foreach(player in level.players)
	{
		if(level zm_utility::is_player_valid(player, false, true))
		{
			array::add(valid_players, player);
		}
	}
	return array::random(valid_players);
}

function cloak_spawn_sequence()
{
	level endon(#"skip_round");

	cloaks_to_spawn = level.num_cloaks;
	generators = array::randomize( level.active_generators );
	generators_shadowed = [];

	gen_num_translation = [];
	gen_num_translation["generator1"] = 0;
	gen_num_translation["generator2"] = 1;
	gen_num_translation["generator3"] = 2;
	gen_num_translation["generator4"] = 3;

	level.num_gens_shadowed = 0;
	for(i = 0; i < cloaks_to_spawn; i++)
	{
		time_to_wait = randomintrange(1, 4);
		wait(time_to_wait);

		if(level.num_gens_shadowed == generators.size)
		{
			level.num_cloaks = 0;
			break;
		}
		generator_index = i % generators.size;
		trigger = GetEnt(generators[generator_index] + "_attack", "targetname");
		level.current_cloak_target_pos = trigger.origin;
		num_cloaks_prev = level.num_cloaks;

		generator_already_shadowed = false;
		for(j = 0; j < generators_shadowed.size; j++)
		{
			if(generators[generator_index] == generators_shadowed[j])
			{
				generator_already_shadowed = true;
			}
		}

		if(generator_already_shadowed)
		{
			level.num_cloaks--;
			continue;
		}

		while(level.shadow_round_paused)
		{
			wait(0.05);
		}
		cloak = cloak_spawn(trigger);
		level.cloak = cloak;
		//cloak.v_zombie_custom_goal_pos = trigger.origin;
		level notify(#"cloak_spawned");

		trigger_volume = GetEnt(trigger.target, "targetname");

		while(level.num_cloaks == num_cloaks_prev && ! cloak IsTouching(trigger_volume))
		{
			wait(0.05);
		}
		
		if(level.num_cloaks == num_cloaks_prev)
		{
			cloak notify("goal_reached");
			cloak.ignoreall = false; 
			cloak.v_zombie_custom_goal_pos = undefined;
			//cloak SetGoal(undefined);
			trigger.being_shadowed = true;
			cloak PlayLoopSound("shadow_ritual");
			PlayFXOnTag("shadow/cloak_shadowing", cloak, "tag_weapon_right");
			cloak AnimScripted("cloak_conjuring", cloak.origin, cloak.angles, "cloak_conjuring");
			gen_num = gen_num_translation[generators[generator_index]];
			foreach(player in level.players)
			{
				player thread zm_abbey_inventory::notifyGenerator();
				player LUINotifyEvent(&"generator_attacked", 1, gen_num);
			}
			level notify(generators[generator_index] + "_attacked");
		}
		
		counter = 0;
		while(counter < 10)
		{
			wait(0.05);
			counter += 0.05;
			if(level.num_cloaks != num_cloaks_prev)
			{
				level notify(generators[generator_index] + "_saved");
				trigger.being_shadowed = false;
				foreach(player in level.players)
				{
					player notify(#"generator_override");
				}
				break;
			}
		}

		if(isdefined(cloak))
		{
			cloak StopLoopSound();
		}

		if(level.num_cloaks == num_cloaks_prev)
		{	
			cloak DoDamage(cloak.maxhealth + 666, cloak.origin);
			level.num_gens_shadowed++;
			generators_shadowed[generators_shadowed.size] = generators[generator_index];
			level notify(generators[generator_index] + "_shadowed");
			trigger.being_shadowed = false;
			foreach(player in level.players)
			{
				player thread zm_abbey_inventory::notifyGenerator(true);
			}
		}
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

function calculate_cloak_health()
{
	if(level.dog_round_count == 1)
	{
		return 1045; // round 10 health
	}
	else if(level.dog_round_count == 2)
	{
		return 2710; // round 20 health
	}
	else
	{
		return 7030; // round 30 health
	}
}

function calculate_escargot_health()
{
	if(level.dog_round_count == 1)
	{
		return 5786; // round 28 health
	}
	else if(level.dog_round_count == 2)
	{
		return 8470; // round 32 health
	}
	else
	{
		return 13638; // round 37 health
	}
}

function calculate_num_escargots()
{
	players = GetPlayers();
	if(level.dog_round_count == 1)
	{
		return 1;
	}
	else if(level.dog_round_count == 2)
	{
		return 2;
	}
	else
	{
		if(players.size == 1)
		{
			return 2;
		}
		return players.size;
	}
}

function calculate_num_cloaks()
{
	players = GetPlayers();
	if(level.dog_round_count == 1)
	{
		return 2;
	}
	else if(level.dog_round_count == 2)
	{
		return 3;
	}
	else
	{
		return 4;
	}
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
		self.v_zombie_custom_goal_pos = level.current_cloak_target_pos;
		self SetGoal(level.current_cloak_target_pos);
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
	PlayFX("shadow/fx_zmb_smokey_death", self.origin + (0, 0, 40));

	level notify("escargot_killed", self.origin);

	if(!level.trident_shell_activated && self zm_room_manager::is_player_in_room(level.abbey_rooms[level.trident_init_room]))
	{
		level.trident_shell_activated = true;
	}

	if(level.num_escargots == 0)
	{
		zm_powerups::specific_powerup_drop( "full_ammo", self.origin);
		if(level.num_gens_shadowed == 0)
		{
			zm_powerups::specific_powerup_drop("free_perk", self.origin + (40,0,0));
		}
		else if(level.num_gens_shadowed == 4)
		{
			zm_powerups::specific_powerup_drop("free_perk", self.origin + (40,0,0));
			zm_powerups::specific_powerup_drop("free_perk", self.origin + (-40,0,0));
		}
	}
	self Delete();
}

function cloak_death_notify()
{
	self waittill("death");
	level.num_cloaks--;
	alias_name = "shadow_kill" + RandomIntRange(1, 4);
	PlaySoundAtPosition(alias_name, self.origin);
	PlayFX("shadow/fx_zmb_smokey_death", self.origin + (0, 0, 40));
	self Delete();
}

function choker_death_notify()
{
	self waittill("death");
	alias_name = "shadow_kill" + RandomIntRange(1, 4);
	PlaySoundAtPosition(alias_name, self.origin);
	PlayFX("shadow/fx_zmb_smokey_death", self.origin + (0, 0, 40));
	self Delete();
}

function escargot_death_notify_ee_radio()
{
	self waittill("death");
	level.num_escargots_ee--;
	alias_name = "shadow_kill" + RandomIntRange(1, 4);
	PlaySoundAtPosition(alias_name, self.origin);
	PlayFX("shadow/fx_zmb_smokey_death", self.origin + (0, 0, 40));
	self Delete();
}

function cloak_death_notify_ee_radio()
{
	self waittill("death");
	alias_name = "shadow_kill" + RandomIntRange(1, 4);
	PlaySoundAtPosition(alias_name, self.origin);
	PlayFX("shadow/fx_zmb_smokey_death", self.origin + (0, 0, 40));
	self Delete();
}

function choker_death_notify_ee_radio()
{
	self waittill("death");
	alias_name = "shadow_kill" + RandomIntRange(1, 4);
	PlaySoundAtPosition(alias_name, self.origin);
	PlayFX("shadow/fx_zmb_smokey_death", self.origin + (0, 0, 40));
	self Delete();
}

function escargot_trident_spawn_logic()
{
	dog_locs = array::randomize( level.zm_loc_types[ "dog_location" ] );
	for( i = 0; i < dog_locs.size; i++ )
	{
		if( ! (isdefined(dog_locs[i].script_string) && dog_locs[i].script_string == "escargot" ))
		{
			continue;
		}

		return dog_locs[i];
	}

	return dog_locs[0];
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

function dog_spawn_factory_logic_ee_radio(favorite_enemy)
{
	clean_locs = struct::get_array("clean_spawners", "targetname");
	dog_locs_init = [];


	for(i = 0; i < clean_locs.size; i++)
	{
		if(clean_locs[i].script_noteworthy == "dog_location")
		{
			dog_locs_init[dog_locs_init.size] = clean_locs[i];
		}
	}

	dog_locs = array::randomize(dog_locs_init);

	//assert( dog_locs.size > 0, "Dog Spawner locs array is empty." );

	for( i = 0; i < dog_locs.size; i++ )
	{
		if( isdefined( level.old_dog_spawn ) && level.old_dog_spawn == dog_locs[i] )
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

	Playfx( level._effect["lightning_dog_spawn"], ent.origin );
	playsoundatposition( "zmb_hellhound_prespawn", ent.origin );
	wait( 1.5 );
	playsoundatposition( "zmb_hellhound_bolt", ent.origin );

	Earthquake( 0.5, 0.75, ent.origin, 1000);
	//PlayRumbleOnPosition("explosion_generic", ent.origin);
	playsoundatposition( "zmb_hellhound_spawn", ent.origin );
}


function testeroo()
{
	while(true)
	{
		level.dog_round_track_override = &zm_ai_shadowpeople::dog_round_tracker;
		wait(2);
	}
}

function ai_testeroo()
{
	self endon("death");

	prevHealth = self.health;

	while(true)
	{
		if(self.health < prevHealth)
		{
			prevHealth = self.health;
		}
		wait(0.05);
	}
}