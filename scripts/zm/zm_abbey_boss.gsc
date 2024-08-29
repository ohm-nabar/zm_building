#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#using scripts\shared\ai\zombie_utility;

#using scripts\shared\hud_util_shared;

#using scripts\shared\visionset_mgr_shared;

#using scripts\shared\lui_shared;

#using scripts\zm\zm_abbey_inventory;
#using scripts\zm\zm_ai_shadowpeople;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\zm_abbey_boss.gsh;
#insert scripts\zm\_zm_traps.gsh;

#precache( "fx", "custom/fx_trail_blood_soul_zmb" );
#precache( "model", "zombietron_electric_ball" );

// MAIN
//*****************************************************************************
// set up entities and global vars
function main()
{
	level.hitmarkersound = "mpl_hit_alert";
	level.hitmarkershader = "damage_feedback";
	level.ignored_squares = []; array::add(level.ignored_squares, 14); array::add(level.ignored_squares, 15); array::add(level.ignored_squares, 20); array::add(level.ignored_squares, 21);;
	level.laser_squares_warning = array::sort_by_script_int(GetEntArray("ee_laser_square_yellow", "targetname"), true);
	level.laser_squares_fire = array::sort_by_script_int(GetEntArray("ee_laser_square_green", "targetname"), true);
	level.laser_pillars = array::sort_by_script_int(GetEntArray("ee_laser_pillar", "targetname"), true);

	level.laser_beams_fire = array::sort_by_script_int(GetEntArray("ee_laser_beam_green", "targetname"), true);
	level.laser_weak_fire = array::sort_by_script_int(GetEntArray("ee_laser_weak_green", "targetname"), true);
	level.laser_damage_trigs = array::sort_by_script_int(GetEntArray("ee_laser_damage", "targetname"), true);

	level.antimatter_strikes_warning = array::sort_by_script_int(GetEntArray("ee_antimatter_strike_yellow", "targetname"), true);
	level.antimatter_strikes_fire = array::sort_by_script_int(GetEntArray("ee_antimatter_strike_green", "targetname"), true);
	level.antimatter_strikes_hitboxes = array::sort_by_script_int(GetEntArray("ee_antimatter_strike_hitbox", "targetname"), true);

	level.cloak_models = array::sort_by_script_int(GetEntArray("ee_cloak_model", "targetname"), true);
	level.cloak_damage_trigs = array::sort_by_script_int(GetEntArray("ee_cloak_damage", "targetname"), true);

	// grammar weights
	level.ee_offensive_priority = 0.6;
	level.ee_standard_priority = 0.8;

	level.ee_laser_active = false;

	foreach(square in level.laser_squares_warning)
	{
		square SetInvisibleToAll();
	}

	foreach(square in level.laser_squares_fire)
	{
		square SetInvisibleToAll();
	}

	foreach(pillar in level.laser_pillars)
	{
		pillar SetInvisibleToAll();
	}

	foreach(beam in level.laser_beams_fire)
	{
		beam SetInvisibleToAll();
	}

	foreach(weak_spot in level.laser_weak_fire)
	{
		weak_spot SetInvisibleToAll();
	}

	foreach(strike in level.antimatter_strikes_warning)
	{
		strike SetInvisibleToAll();
	}

	foreach(strike in level.antimatter_strikes_fire)
	{
		strike SetInvisibleToAll();
	}
	foreach(cloak in level.cloak_models)
	{
		cloak SetInvisibleToAll();
	}

	//callback::on_connect( &on_player_connect );
	//callback::on_laststand( &on_laststand );
	//zm::register_actor_damage_callback( &damage_adjustment );
	level.target_trig = GetEnt("ee_start_fight", "targetname");
	level.target_trig SetHintString("Press ^3[{+activate}]^7 to start boss fight");
	level.target_trig waittill("trigger", player);
	level.target_trig SetHintString("");

	level.ee_debuff_damage = 0;

	foreach(player in level.players)
	{
		player.jug_resistance_level = 250;
		player thread health_test_display();
		player.inhibit_scoring_from_zombies = true;
	}
	level thread zm_audio::sndMusicSystem_PlayState("ascendance");
	level.longRegenTime = 10000;
	level.ee_vimana_health = BOSS_HEALTH;
	level.no_powerups = true;
	level.cloak_health = 7030; // change
	level.choker_health = 10;

	level flag::clear( "spawn_zombies" );
	prev_zombie_total = level.zombie_total;
	level.zombie_total = 100;
	level.zombie_respawns = 100;

	zombies = GetAiTeamArray( level.zombie_team );
	foreach(zombie in zombies)
	{
		zombie dodamage( zombie.health + 666, zombie.origin );
	}
	
	level lui::screen_fade_out( 1, "black" );
	level util::set_lighting_state( 1 );
	level lui::screen_fade_in( 1, "black" );
	
	wait(1.5);
	boss_fight();
}

// main boss fight function, uses the grammar to select attack patterns
function boss_fight()
{
	aggressive = []; array::add(aggressive, &laser_attack); array::add(aggressive, &laser_attack); array::add(aggressive, &projectile_attack);
	attacking = []; array::add(attacking, &laser_attack); array::add(attacking, &strike_attack); array::add(attacking, &projectile_attack);
	finisher = []; array::add(finisher, &projectile_attack); array::add(finisher, &strike_attack); array::add(finisher, &projectile_attack);

	debuffing = []; array::add(debuffing, &cloak_attack); array::add(debuffing, &cloak_attack); array::add(debuffing, &projectile_attack);
	turtling = []; array::add(turtling, &projectile_attack); array::add(turtling, &projectile_attack); array::add(turtling, &projectile_attack);
	finisher_def = []; array::add(finisher_def, &projectile_attack); array::add(finisher_def, &cloak_attack); array::add(finisher_def, &projectile_attack);

	last_laser = 0;

	while(level.ee_vimana_health > 0)
	{
		chosen_pattern = [];
		calculate_weights(last_laser);
		IPrintLn("Offensive priority: " + level.ee_offensive_priority);
		IPrintLn("Standard priority: " + level.ee_standard_priority);
		if(true)
		{
			last_laser = 0;
			if(true)
			{
				if(RandomFloatRange(0, 1) < 0.5)
				{
					IPrintLn("Choosing aggressive pattern: lasers, lasers, projectiles");
					chosen_pattern = aggressive;
				}
				else
				{
					IPrintLn("Choosing attacking pattern: lasers, strikes, projectiles");
					chosen_pattern = attacking;
				}
			}
			else
			{
				IPrintLn("Choosing finisher pattern: projectiles, strikes, projectiles");
				last_laser += 1;
				chosen_pattern = finisher;
			}
		}
		else
		{
			last_laser += 1;
			if(RandomFloatRange(0, 1) < level.ee_standard_priority)
			{
				if(RandomFloatRange(0, 1) < 0.5)
				{
					IPrintLn("Choosing debuffing pattern: cloaks, cloaks, projectiles");
					chosen_pattern = debuffing;
				}
				else
				{
					IPrintLn("Choosing turtling pattern: projectiles, projectiles, projectiles");
					chosen_pattern = turtling;
				}
			}
			else
			{
				IPrintLn("Choosing finisher (def) pattern: projectiles, cloaks, projectiles");
				chosen_pattern = finisher_def;
			}
		}

		thread [[chosen_pattern[0]]]();
		wait(ATTACK_DELAY);
		thread [[chosen_pattern[1]]]();
		wait(ATTACK_DELAY);
		thread [[chosen_pattern[2]]]();

		wait(ATTACK_PATTERN_DELAY);
	}
	IPrintLn("Beat the boss!");
}

// calculate the relevant weights each time we go through the grammar
function calculate_weights(last_laser)
{
	if(last_laser >= 4)
	{
		IPrintLn("set offensive and standard priority to 1: haven't fired lasers recently");
		level.ee_offensive_priority = 1;
		level.ee_standard_priority = 1;
		return;
	}

	level.ee_offensive_priority = BASE_OFFENSIVE_PRIORITY;
	level.ee_standard_priority = BASE_STANDARD_PRIORITY;

	if(level.players[0].health < 150)
	{
		//IPrintLn("player health: " + level.players[0].health);
		level.ee_offensive_priority += 0.1;
		level.ee_standard_priority -= 0.3;
		IPrintLn("increase offensive priority, decrease standard priority: low hp");
	}
	else
	{
		level.ee_offensive_priority -= 0.1;
		level.ee_standard_priority += 0.3;
		IPrintLn("decrease offensive priority, increase standard priority: high hp");
	}

	if(level.players[0].jug_resistance_level < 250)
	{
		IPrintLn("increase offensive priority: player has health debuffs");
		level.ee_offensive_priority += 0.1;
	}
}

// laser attack- terminal in grammar
function laser_attack()
{
	while(level.ee_laser_active)
	{
		wait(0.05);
	}

	level.ee_laser_active = true;

	foreach(beam in level.laser_beams_fire)
	{
		beam SetVisibleToAll();
	}

	foreach(weak_spot in level.laser_weak_fire)
	{
		weak_spot SetVisibleToAll();
	}

	foreach(trig in level.laser_damage_trigs)
	{
		trig thread damage_check();
	}

	for(i = 0; i < LASER_REPEATS; i++)
	{
		squares_selected = select_laser_squares();

		for(j = 0; j < squares_selected.size; j++)
		{
			//IPrintLn(i + "th laser loop index " + j);
			index = squares_selected[j];
			
			thread fire_laser(index);
		}
	
		wait(LASER_DELAY);
	}

	foreach(beam in level.laser_beams_fire)
	{
		beam SetInvisibleToAll();
	}

	foreach(weak_spot in level.laser_weak_fire)
	{
		weak_spot SetInvisibleToAll();
	}

	level.ee_laser_active = false;

	level notify("ee_disable_damage");
}

// strike attack- terminal in grammar
function strike_attack()
{
	foreach(strike in level.antimatter_strikes_warning)
	{
		if(strike.script_int % 2 == 0)
		{	
			strike SetVisibleToAll();
		}
	}

	wait(STRIKE_SHOW_TIME);

	foreach(strike in level.antimatter_strikes_warning)
	{
		if(strike.script_int % 2 == 0)
		{
			strike SetInvisibleToAll();
		}
		else
		{
			strike SetVisibleToAll();
		}
	}
	foreach(strike in level.antimatter_strikes_fire)
	{
		if(strike.script_int % 2 == 0)
		{	
			strike SetVisibleToAll();	
			strike thread strike_collision();
		}
	}

	wait(STRIKE_SHOW_TIME);

	level notify("ee_strike_ended");

	foreach(strike in level.antimatter_strikes_warning)
	{
		if(strike.script_int % 2 == 1)
		{		
			strike SetInvisibleToAll();
		}
	}

	foreach(strike in level.antimatter_strikes_fire)
	{
		if(strike.script_int % 2 == 0)
		{		
			strike SetInvisibleToAll();
		}
		else
		{
			strike SetVisibleToAll();	
			strike thread strike_collision();
		}
	}

	wait(STRIKE_SHOW_TIME);

	foreach(strike in level.antimatter_strikes_fire)
	{
		if(strike.script_int % 2 == 1)
		{		
			strike SetInvisibleToAll();
		}
	}

	level notify("ee_strike_ended");
}

// projectile attack- terminal in grammar
function projectile_attack()
{
	attack_origin = struct::get("ee_projectile_start", "targetname").origin;

	projectile = Spawn("script_model", attack_origin);
	projectile SetModel("zombietron_electric_ball");
	//PlayFXOnTag("custom/fx_trail_blood_soul_zmb", projectile, "tag_origin");

	projectile2 = Spawn("script_model", attack_origin + (0, 0, 10));
	projectile2 SetModel("zombietron_electric_ball");
	//PlayFXOnTag("custom/fx_trail_blood_soul_zmb", projectile2, "tag_origin");

	projectile3 = Spawn("script_model", attack_origin + (0, 0, 20));
	projectile3 SetModel("zombietron_electric_ball");
	//PlayFXOnTag("custom/fx_trail_blood_soul_zmb", projectile3, "tag_origin");

	wait(2);

	player = level.players[0];
	angles = player GetPlayerAngles();
	angle = angles[1] - 90;

	x = Cos(angle) * 40;
	y = Sin(angle) * 40;

	dest = player.origin + (0, 0, 40);
	dest2 = player.origin + (x, y, 40);
	dest3 = player.origin + (-x, -y, 40);

	/*
	vec = (projectile.origin - dest) * 5;
	vec2 = (projectile2.origin - dest2) * 5;
	vec3 = (projectile3.origin - dest3) * 5;
	*/

	//IPrintLn("dest: " + dest);
	//IPrintLn("dest2: " + dest2);
	//IPrintLn("dest3: " + dest3);

	dist = Distance(attack_origin, player.origin);
	travelTime = dist * 0.01;

	projectile MoveTo(dest, 0.5);
	projectile2 MoveTo(dest2, 0.5);
	projectile3 MoveTo(dest3, 0.5);

	projectile thread projectile_damage_check();
	projectile2 thread projectile_damage_check();
	projectile3 thread projectile_damage_check();


	wait(0.6);

	level notify("projectile_attack_over");

	projectile Delete();
	projectile2 Delete();
	projectile3 Delete();
}


// below: helpers for attacks

function projectile_damage_check()
{
	level endon("projectile_attack_over");

	hit_player = false;
	while(! hit_player)
	{
		foreach(player in level.players)
		{
			if(self IsTouching(player))
			{
				//IPrintLn("projectile hit!");
				player DoDamage(PROJECTILE_DAMAGE + level.ee_debuff_damage, player.origin);
				self Delete();
				hit_player = true;
			}
		}
		wait(0.05);
	}
}

// cloak attack- terminal in grammar
function cloak_attack()
{
	level.ee_cloaks_alive = 0;
	foreach(model in level.cloak_models)
	{
		model SetVisibleToAll();
		level.ee_cloaks_alive += 1;
	}
	foreach(trig in level.cloak_damage_trigs)
	{
		trig thread cloak_damage_check();
	}
	wait(CLOAK_TIME);
	if(level.ee_cloaks_alive != 0)
	{
		foreach(player in level.players)
		{
			if(player.jug_resistance_level >= 150)
			{	
				player.jug_resistance_level -= 50;
				//level.ee_debuff_damage += 20;
			}
		}
	}
	foreach(model in level.cloak_models)
	{
		model SetInvisibleToAll();
	}
}

function cloak_damage_check()
{
	level endon("cloak_time_up");
	health = CLOAK_HEALTH;
	while(health > 0)
	{	
		self waittill( "damage", amount, attacker, direction_vec, point, type, tagName, ModelName, Partname, weapon );
		attacker thread hitmarker();
		health -= (amount * 2); // TODO: remove double tap temp multiplier
	}
	
	level.ee_cloaks_alive -= 1;
	level.cloak_models[self.script_int] SetInvisibleToAll();
}

function strike_collision()
{
	level endon("ee_strike_ended");
	hitbox = level.antimatter_strikes_hitboxes[self.script_int];

	while(true)
	{
		foreach(player in level.players)
		{
			if(player IsTouching(hitbox) && ! IS_TRUE(player.ee_strike_damaged))
			{
				//IPrintLn("istouching works!");
				player DoDamage( STRIKE_DAMAGE + level.ee_debuff_damage, player.origin );
				player.ee_strike_damaged = true;
				player thread reset_strike_iframes();
			}
		}

		wait(0.05);
	}
}

function reset_strike_iframes()
{
	self endon("disconnect");

	for(i = 0; i < STRIKE_IFRAMES; i += 0.2)
	{
		IPrintLn("strike iframed");
		wait(0.2);
	}
	self.ee_strike_damaged = false;
}

function damage_check()
{
	level endon("ee_disable_damage");
	health = WEAK_SPOT_HEALTH;
	while(health > 0)
	{	
		self waittill( "damage", amount, attacker, direction_vec, point, type, tagName, ModelName, Partname, weapon );
		attacker thread hitmarker();
		health -= (amount * 2); // TODO: remove double tap temp multiplier
	}
	level.ee_vimana_health -= 1;
	level.laser_weak_fire[self.script_int] SetInvisibleToAll();
}

function select_laser_squares()
{
	squares_selected = [];
	cols_unselected = [];
	for(col = 0; col < LASER_GRID_WIDTH; col++)
	{
		array::add(cols_unselected, col);
	}

	for(row = 0; row < LASER_GRID_HEIGHT; row++)
	{
		ignore_col = array::random(cols_unselected); temp = []; array::add(temp, ignore_col); cols_unselected = array::exclude(cols_unselected, temp);
		for(col = 0; col < LASER_GRID_WIDTH; col++)
		{
			laser_index = (row * LASER_GRID_WIDTH) + col;
			if(col == ignore_col || array::contains(level.ignored_squares, laser_index))
			{
				continue;
			}
			array::add(squares_selected, laser_index);
		}
	}

	return squares_selected;
}

function fire_laser(index)
{
	//IPrintLn("firing " + index);
	level.laser_squares_warning[index] SetVisibleToAll();
	

	wait(LASER_SHOW_TIME);
	level.laser_squares_warning[index] SetInvisibleToAll();
	level.laser_squares_fire[index] SetVisibleToAll();
	level.laser_pillars[index] SetVisibleToAll();
	for(i = 0; i < LASER_SHOW_TIME; i += 0.05)
	{
		foreach(player in level.players)
		{
			if(player IsTouching(level.laser_pillars[index]) && ! IS_TRUE(player.ee_laser_damaged))
			{
				player.ee_laser_damaged = true;
				player thread laser_iframes();
				player player_elec_damage();
			}
		}
		wait(0.05);
	}
	level.laser_squares_fire[index] SetInvisibleToAll();
	level.laser_pillars[index] SetInvisibleToAll();
}

function laser_iframes()
{
	self endon("disconnect");
	wait(LASER_IFRAMES);
	self.ee_laser_damaged = false;
}

function player_elec_damage()
{	
	self endon("death");
	self endon("disconnect");
	
	if( !isdefined(level.elec_loop) )
	{
		level.elec_loop = 0;
	}

	player.ee_laser_damaged = true;	
	
	if( !IS_TRUE( self.is_burning ) && zm_utility::is_player_valid( self ) )
	{
		self.is_burning = 1;
		
		if (IS_TRUE(level.trap_electric_visionset_registered))
		{
			visionset_mgr::activate( "overlay", "zm_trap_electric", self, ZM_TRAP_ELECTRIC_MAX, ZM_TRAP_ELECTRIC_MAX );
		}
		else
		{
			self setelectrified(LASER_ELECTROCUTION);
		}
		if ( isdefined( level.str_elec_damage_shellshock_override ) )
		{
			str_elec_shellshock = level.str_elec_damage_shellshock_override;
		}
		else
		{
			str_elec_shellshock = "electrocution";
		}

		//Changed Shellshock to Electrocution so we can have different bus volumes.
		self shellshock(str_elec_shellshock, LASER_ELECTROCUTION);
		
		self PlayRumbleOnEntity( "damage_heavy" ); // PORTIZ 6/12/16: Adding rumble when damaged

		angles = self GetPlayerAngles();
		angle = 90 - angles[1];
		
		//x = Sin(angle) * LASER_PUSH_MULTIPLIER;
		//y = Cos(angle) * LASER_PUSH_MULTIPLIER;
		//self setVelocity((x, y, 0));
		
		if(level.elec_loop == 0)
		{	
			elec_loop = 1;
			self playloopsound ("electrocution");
			self playsound("wpn_zmb_electrap_zap");
		}

		self DoDamage( LASER_DAMAGE + level.ee_debuff_damage, self.origin );
		wait 0.1;
		self playsound("wpn_zmb_electrap_zap");
		self.is_burning = undefined;
	}
}

function damage_adjustment(  inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType  )
{
}

function on_player_connect()
{
}

function on_laststand()
{
}

// courtesy of MakeCents's tutorial
function hitmarker()
{
	self thread playHitSound ( level.hitmarkersound);
	self.hud_damagefeedback setShader( level.hitmarkershader, 24, 48 );
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime(1);
	self.hud_damagefeedback.alpha = 0;
}

function playHitSound (alert)
{
	self endon ("disconnect");
	
	if (self.hitSoundTracker)
	{
		self.hitSoundTracker = false;
		
		self playlocalsound(alert);

		wait .05;	// waitframe
		self.hitSoundTracker = true;
	}
}

function health_test_display()
{
	self endon("disconnect");

	health = NewClientHudElem(self);
	health.alignX = "left";
	meesage.alignY = "top";
	health.horzAlign = "left";
	health.vertAlign = "top";
	health.fontscale = 2;
	health.alpha = 1;
	health.color = (1,1,1);
	health.hidewheninmenu = true;
	health SetText("Boss Health: " + level.ee_vimana_health);

	player_health = NewClientHudElem(self);
	player_health.alignX = "left";
	player_health.alignY = "top";
	player_health.horzAlign = "left";
	player_health.vertAlign = "top";
	player_health.fontscale = 2;
	player_health.alpha = 1;
	player_health.color = (1,1,1);
	player_health.hidewheninmenu = true;
	player_health.y = 30;
	player_health SetText("Player Health: " + self.health);

	while(true)
	{
		health SetText("Boss Health: " + level.ee_vimana_health);
		player_health SetText("Player Health: " + self.health);
		wait(0.05);
	}
}