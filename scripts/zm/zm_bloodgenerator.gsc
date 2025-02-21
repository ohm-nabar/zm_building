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
#using scripts\shared\music_shared;

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

#using scripts\shared\visionset_mgr_shared;

#using scripts\zm\_zm_magicbox;

#using scripts\zm\zm_abbey_inventory;
#using scripts\zm\zm_room_manager;

#insert scripts\zm\_zm_audio.gsh;
#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_perk_quick_revive.gsh;
#insert scripts\zm\_zm_perk_staminup.gsh;
#insert scripts\zm\_zm_perk_additionalprimaryweapon.gsh;
#insert scripts\zm\_zm_perk_deadshot.gsh;
#insert scripts\zm\_zm_perk_poseidonspunch.gsh;
#insert scripts\zm\_zm_perk_doubletaporiginal.gsh;
#insert scripts\zm\_zm_perk_phdlite.gsh;
#insert scripts\zm\zm_abbey_inventory.gsh;

//Blood vial shaders
#precache( "material", "acquire_waypoint" );
#precache( "material", "deposit_waypoint" );
#precache( "material", "deposit_waypoint_jug" );

#precache( "fx", "zombie/fx_perk_quick_revive_factory_zmb" );
#precache( "fx", "zombie/fx_perk_doubletap2_factory_zmb" );
#precache( "fx", "zombie/fx_perk_daiquiri_factory_zmb" );
#precache( "fx", "zombie/fx_perk_stamin_up_factory_zmb" );
#precache( "fx", "zombie/fx_perk_mule_kick_factory_zmb" );
#precache( "fx", "custom/fx_poseidons_punch" );
#precache( "fx", "_mikeyray/perks/phd/fx_perk_phd");

#precache( "eventstring", "blood_vial_update" );
#precache( "eventstring", "generator_activated" );
#precache( "eventstring", "generator_hide" );
#precache( "eventstring", "generator_reset" );

#precache( "string", "ZM_ABBEY_SHADOW_DISABLED" );
#precache( "string", "ZM_ABBEY_GENERATOR_DEPOSIT" );
#precache( "string", "ZM_ABBEY_GENERATOR_NO_BLOOD" );
#precache( "string", "ZM_ABBEY_BLOODGUN_IN_USE" );
#precache( "string", "ZM_ABBEY_BLOODGUN_HAS_VIAL" );
#precache( "string", "ZM_ABBEY_BLOODGUN_COOLDOWN" );
#precache( "string", "ZM_ABBEY_BLOODGUN_ACTIVATE" );

#precache( "model", "mainframe_comp_offline_s38" );
#precache( "model", "mainframe_comp_online_s38" );
#precache( "model", "mainframe_comp_online_s_s38" );
#precache( "model", "mainframe_comp_online_ms_s38" );

#precache( "model", "mainframe_comp_offline_s38_blank" );
#precache( "model", "mainframe_comp_online_s38_blank" );
#precache( "model", "mainframe_comp_online_ms_s38_blank" );
#precache( "model", "mainframe_comp_online_s_s38_blank" );

#precache( "model", "p7_zm_abbey_computer_bloodgen" );
#precache( "model", "p7_zm_abbey_computer_bloodgen_online" );
#precache( "model", "p7_zm_abbey_computer_bloodgen_online_s" );

#precache( "model", "zm_abbey_bg_inactive" );
#precache( "model", "zm_abbey_bg_kill" );
#precache( "model", "zm_abbey_bg_cooldown" );
#precache( "model", "zm_abbey_bg_shadow" );

#define ELECTRIC_CHERRY_MACHINE_LIGHT_FX                    "electric_cherry_light"

// MAIN
//*****************************************************************************

function autoexec main()
{
	level flag::init("power_on1");
	level flag::init("power_on2");
	level flag::init("power_on3");
	level flag::init("power_on4");
	
	callback::on_connect( &on_player_connect );
	callback::on_laststand( &on_laststand );
	zm::register_actor_damage_callback( &damage_adjustment );
	thread pap_think();

	level.zombie_powerup_weapon[ "bloodgun" ] = GetWeapon("bloodgun");

    //level.papReady = 0; // 4 turns on PaP
	level.vialFilled = 0;
	level.hasVial = false;
	level.bloodgun_active = false;
	level.bloodgun_cost = 2000;
	level.bloodgun_kills = 10;
	level.blood_cooling_down = false;
	level.blood_uses = 0;
	level.active_generators = [];
	level.bloodgun = GetWeapon("bloodgun");

	level.boxcages_q1 = getEntArray("boxcage_q1", "targetname");
	level.boxcages_q2 = getEntArray("boxcage_q2", "targetname");
	level.boxcages_q3 = getEntArray("boxcage_q3", "targetname");
	level.boxcages_q4 = getEntArray("boxcage_q4", "targetname");

	bloodgun_trigs = getEntArray("bloodgun_trig", "targetname");
	bloodgenerator_trigs = getEntArray("bloodgenerator_trig", "targetname");

	for(i = 0; i < bloodgun_trigs.size; i++)
	{
		bloodgun_trigs[i] SetCursorHint( "HINT_NOICON" );
		bloodgun_trigs[i] thread blood_think();
	}

	//visionset_mgr::register_info( "visionset", "zm_blood", VERSION_SHIP, 1200, 31, true, &visionset_mgr::ramp_in_thread_per_player, false );

	for(i = 0; i < bloodgenerator_trigs.size; i++) 
	{
		bloodgenerator_trigs[i] SetCursorHint( "HINT_NOICON" );
		bloodgenerator_trigs[i] thread generator_think();
	}

	blood_mainframes = GetEntArray("blood_mainframe", "targetname");
	blood_mainframe2s = GetEntArray("blood_mainframe2", "targetname");
	blood_computers = GetEntArray("blood_computer", "targetname");

	bloodgun_stations = GetEntArray("bloodgun_station", "targetname");
	bloodgun_screens = GetEntArray("bloodgun_screen", "targetname");

	blood_wires_off = GetEntArray("blood_wire_off", "targetname");
	blood_wires_on = GetEntArray("blood_wire_on", "targetname");

	level array::thread_all(blood_mainframes, &blood_mainframe_think);
	level array::thread_all(blood_mainframe2s, &blood_mainframe2_think);
	level array::thread_all(blood_computers, &blood_computer_think);

	level array::thread_all(bloodgun_stations, &bloodgun_station_think);
	level array::thread_all(bloodgun_screens, &bloodgun_screen_think);

	level array::thread_all(blood_wires_off, &blood_wire_off_think);
	level array::thread_all(blood_wires_on, &blood_wire_on_think);

	level thread blood_cool_down();
	level thread acquire_waypoint_manage();
	level thread perk_set_fx();

	zm::register_zombie_damage_override_callback( &zombie_damage_override );
}

function zombie_damage_override(willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if ( isPlayer( attacker ) && willBeKilled && isdefined(attacker.bloodgun_kills) && isdefined(weapon) && weapon == GetWeapon("bloodgun") && meansofdeath == "MOD_RIFLE_BULLET" )
	{
		attacker.bloodgun_kills += 1;
	}
}

function blood_wire_off_think()
{
	level waittill("power_on" + self.script_int);
	self Delete();
}

function blood_wire_on_think()
{
	self Hide();
	level waittill("power_on" + self.script_int);
	self Show();
}

function blood_mainframe_think()
{
	self SetModel("mainframe_comp_offline_s38");
	level waittill("power_on" + self.script_int);
	while(true)
	{
		self SetModel("mainframe_comp_online_s38");
		level waittill("generator" + self.script_int + "_attacked");
		self SetModel("mainframe_comp_online_ms_s38");
		event =  level util::waittill_any_return("generator" + self.script_int + "_shadowed", "generator" + self.script_int + "_saved", "last_ai_down");
		if(event != "generator" + self.script_int + "_shadowed")
		{
			continue;
		}
		self SetModel("mainframe_comp_online_s_s38");
		level waittill("last_ai_down");
	}
}

function blood_mainframe2_think()
{
	self SetModel("mainframe_comp_offline_s38_blank");
	level waittill("power_on" + self.script_int);

	while(true)
	{
		self SetModel("mainframe_comp_online_s38_blank");
		level waittill("generator" + self.script_int + "_attacked");
		self SetModel("mainframe_comp_online_ms_s38_blank");
		event =  level util::waittill_any_return("generator" + self.script_int + "_shadowed", "generator" + self.script_int + "_saved", "last_ai_down");
		if(event != "generator" + self.script_int + "_shadowed")
		{
			continue;
		}
		self SetModel("mainframe_comp_online_s_s38_blank");
		level waittill("last_ai_down");
	}
}

function blood_computer_think()
{
	self SetModel("p7_zm_abbey_computer_bloodgen");
	level waittill("power_on" + self.script_int);

	while(true)
	{
		self SetModel("p7_zm_abbey_computer_bloodgen_online");
		level waittill("generator" + self.script_int + "_attacked");
		self SetModel("p7_zm_abbey_computer_bloodgen_online_ms");
		event =  level util::waittill_any_return("generator" + self.script_int + "_shadowed", "generator" + self.script_int + "_saved", "last_ai_down");
		if(event != "generator" + self.script_int + "_shadowed")
		{
			continue;
		}
		self SetModel("p7_zm_abbey_computer_bloodgen_online_s");
		level waittill("last_ai_down");
	}
}

function bloodgun_station_think()
{
	while(true)
	{
		self SetVisibleToAll();
		while(! level.bloodgun_active)
		{
			wait(0.05);
		}
		self SetInvisibleToAll();
		while(level.bloodgun_active)
		{
			wait(0.05);
		}
	}
}

function bloodgun_screen_think()
{
	while(! isdefined(level.shadow_vision_active))
	{
		wait(0.05);
	}

	while(true)
	{
		self SetModel("zm_abbey_bg_inactive");
		while(! (level.bloodgun_active || level.shadow_vision_active))
		{
			wait(0.05);
		}
		self SetModel("zm_abbey_bg_shadow");
		while(level.shadow_vision_active)
		{
			wait(0.05);
		}
		self SetModel("zm_abbey_bg_kill");
		while(level.bloodgun_active)
		{
			wait(0.05);
		}
		self SetModel("zm_abbey_bg_cooldown");
		while(level.blood_uses >= 2)
		{
			wait(0.05);
		}
	}
}

function perk_set_fx()
{
	while(! (level flag::exists("initial_blackscreen_passed") && level flag::get("initial_blackscreen_passed")))
	{
		wait(0.05);
	}

	level._effect[QUICK_REVIVE_MACHINE_LIGHT_FX]                = "zombie/fx_perk_quick_revive_factory_zmb";
    level._effect[DOUBLE_TAP_MACHINE_LIGHT_FX]                  = "zombie/fx_perk_doubletap2_factory_zmb";  
    level._effect[DEADSHOT_MACHINE_LIGHT_FX]                    = "zombie/fx_perk_daiquiri_factory_zmb";
    level._effect[STAMINUP_MACHINE_LIGHT_FX]                    = "zombie/fx_perk_stamin_up_factory_zmb";
    level._effect[ADDITIONAL_PRIMARY_WEAPON_MACHINE_LIGHT_FX]   = "zombie/fx_perk_mule_kick_factory_zmb";
    level._effect[ELECTRIC_CHERRY_MACHINE_LIGHT_FX]             = "zombie/fx_perk_quick_revive_factory_zmb";
	level._effect[PHD_LITE_MACHINE_LIGHT_FX]             		= "_mikeyray/perks/phd/fx_perk_phd";
	level._effect[POSEIDON_PUNCH_MACHINE_LIGHT_FX]              = "custom/fx_poseidons_punch";
}

function game_over_check()
{
	self endon("disconnect");

	level waittill ( "end_game" );
	self LUINotifyEvent(&"generator_hide", 0);
}

function damage_adjustment(  inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType  )
{
    if( isdefined(weapon) && (weapon == level.bloodgun || weapon == level.zombie_powerup_weapon[ "minigun" ]) )
	{
		return self.health + 666;
	}
	return -1;
}

function on_player_connect()
{
	self.isInBloodMode = false;
	self LUINotifyEvent(&"generator_reset", 0);
	self thread deposit_waypoint_manage();
	self thread game_over_check();
	self thread set_bloodgun_ammo();

	while( ! (level flag::exists("initial_blackscreen_passed") && level flag::get("initial_blackscreen_passed")))
	{
		wait(0.05);
	}
	self LUINotifyEvent(&"blood_vial_update", 1, 0);
}

function on_laststand()
{
	self endon("disconnect");

	self thread zm_powerups::weapon_watch_gunner_downed("bloodgun");
}

function weapon_powerup_bloodgun( ent_player, str_weapon, allow_cycling = false )
{
	str_weapon_on 			= "zombie_powerup_" + str_weapon + "_on";
	str_weapon_time_over 	= str_weapon + "_time_over";
	
	ent_player notify( "replace_weapon_powerup" );
	ent_player._show_solo_hud = true;
	
	ent_player.has_specific_powerup_weapon[ str_weapon ] = true;
	ent_player.has_powerup_weapon = true;
	
	ent_player zm_utility::increment_is_drinking();
	
	if( allow_cycling )
	{
		ent_player EnableWeaponCycling();
	}
	
	ent_player._zombie_weapon_before_powerup[ str_weapon ] = ent_player GetCurrentWeapon();
	
	// give player the powerup weapon
	ent_player GiveWeapon( level.zombie_powerup_weapon[ str_weapon ] );
	ent_player SwitchToWeapon( level.zombie_powerup_weapon[ str_weapon ] );
	
	ent_player.zombie_vars[ str_weapon_on ] = true;
	
	level thread weapon_powerup_countdown_bloodgun( ent_player, str_weapon_time_over, str_weapon );
	level thread zm_powerups::weapon_powerup_replace( ent_player, str_weapon_time_over, str_weapon );
	level thread zm_powerups::weapon_powerup_change( ent_player, str_weapon_time_over, str_weapon );
}

function weapon_powerup_countdown_bloodgun( ent_player, str_gun_return_notify, str_weapon )
{
	ent_player endon( "death" );
	ent_player endon( "disconnect" );
	ent_player endon( "player_downed" );
	ent_player endon( str_gun_return_notify );
	ent_player endon( "replace_weapon_powerup" );

	ent_player waittill(#"bloodgun_complete");
	
	level thread zm_powerups::weapon_powerup_remove( ent_player, str_gun_return_notify, str_weapon, true );	
}

function acquire_waypoint_manage()
{
	room = "Choir";
	if(GetDvarString("ui_mapname") == "zm_building")
	{
		room = "Water Tower";
	}
	while(! (isdefined(level.abbey_rooms) && level zm_room_manager::is_room_active(level.abbey_rooms[room])))
	{
		wait(0.05);
	}
	bloodgun_trigs = GetEntArray("bloodgun_trig", "targetname");
	foreach(player in level.players)
	{
		player.acquire_indicators = [];
	}
	waypoint_poses = [];
	foreach(trig in bloodgun_trigs)
	{
		waypoint_pos = Spawn("script_model", trig.origin);
		waypoint_pos SetModel("tag_origin");
		waypoint_poses[waypoint_poses.size] = waypoint_pos;
		foreach(player in level.players)
		{
			acquire_indicator = NewClientHudElem(player);
			acquire_indicator SetTargetEnt(waypoint_pos);
			acquire_indicator SetShader("acquire_waypoint");
			acquire_indicator SetWayPoint(true, "acquire_waypoint", false, false);
			acquire_indicator.alpha = 0;
			acquire_indicator.linked_origin = trig.origin;
			player.acquire_indicators[player.acquire_indicators.size] = acquire_indicator;
		}
	}

	foreach(player in level.players)
	{
		player thread zm_abbey_inventory::notifyText(NOTIF_GLOBAL_HUD_TOGGLE, NOTIF_FLASH_LEFT, NOTIF_ALERT_NEUTRAL);
	}

	while(!level.bloodgun_active)
	{
		foreach(player in level.players)
		{
			if(IS_TRUE(player.abbey_no_waypoints))
			{
				foreach(acquire_indicator in player.acquire_indicators)
				{
					acquire_indicator.alpha = 0;
				}
			}
			else
			{
				closest_dist = 9999999;
				closest_dist_index = -1;

				for(i = 0; i < player.acquire_indicators.size; i++)
				{
					dist = DistanceSquared(player.origin, player.acquire_indicators[i].linked_origin);
					if(dist < closest_dist)
					{
						closest_dist = dist;
						closest_dist_index = i;
					}
				}

				for(i = 0; i < player.acquire_indicators.size; i++)
				{
					if(i == closest_dist_index)
					{
						player.acquire_indicators[i].alpha = 1;
					}
					else
					{
						player.acquire_indicators[i].alpha = 0.5;
					}
				}
			}
		}
		wait(0.05);
	}


	while(true)
	{
		foreach(player in level.players)
		{
			if(isdefined(player.blood_vial_trial_fills) && IS_TRUE(player.athos_indicators_active))
			{
				closest_dist = 9999999;
				closest_dist_index = -1;

				for(i = 0; i < player.acquire_indicators.size; i++)
				{
					dist = DistanceSquared(player.origin, player.acquire_indicators[i].linked_origin);
					if(dist < closest_dist)
					{
						closest_dist = dist;
						closest_dist_index = i;
					}
				}

				for(i = 0; i < player.acquire_indicators.size; i++)
				{
					if(i == closest_dist_index)
					{
						player.acquire_indicators[i].alpha = 1;
					}
					else
					{
						player.acquire_indicators[i].alpha = 0.5;
					}
				}
			}
			else
			{
				foreach(acquire_indicator in player.acquire_indicators)
				{
					acquire_indicator.alpha = 0;
				}
			}
		}
		wait(0.05);
	}
}

function deposit_waypoint_manage()
{
	self endon("disconnect");

	generators = GetEntArray("bloodgenerator_trig", "targetname");
	fountains = GetEntArray("jug_activate", "targetname");

	self.generator_indicators = [];
	foreach(generator in generators)
	{
		waypoint_pos = Spawn("script_model", generator.origin);
		waypoint_pos SetModel("tag_origin");
		deposit_indicator = NewClientHudElem(self);
		deposit_indicator SetTargetEnt(waypoint_pos);
		deposit_indicator SetShader("deposit_waypoint");
		deposit_indicator SetWayPoint(true, "deposit_waypoint", false, false);
		deposit_indicator.alpha = 0;
		deposit_indicator.linked_origin = generator.origin;
		self.generator_indicators[generator.script_noteworthy] = deposit_indicator;
	}

	self.fountain_indicators = [];
	foreach(fountain in fountains)
	{
		waypoint_pos = Spawn("script_model", fountain.origin);
		waypoint_pos SetModel("tag_origin");
		fountain_indicator = NewClientHudElem(self);
		fountain_indicator SetTargetEnt(waypoint_pos);
		fountain_indicator SetShader("deposit_waypoint_jug");
		fountain_indicator SetWayPoint(true, "deposit_waypoint_jug", false, false);
		fountain_indicator.alpha = 0;
		fountain_indicator.linked_origin = fountain.origin;
		self.fountain_indicators[self.fountain_indicators.size] = fountain_indicator;
	}

	while(! isdefined(level.shadow_vision_active))
	{
		wait(0.05);
	}

	while(true)
	{
		if(!level.hasVial || IS_TRUE(self.abbey_no_waypoints) || level.shadow_vision_active)
		{
			foreach(indicator in self.generator_indicators)
			{
				indicator.alpha = 0;
			}
			foreach(indicator in self.fountain_indicators)
			{
				indicator.alpha = 0;
			}
		}
		else
		{
			closest_dist = 9999999;
			closest_dist_key = -1;
			keys = GetArrayKeys(self.generator_indicators);

			foreach(key in keys)
			{
				dist = DistanceSquared(self.origin, self.generator_indicators[key].linked_origin);
				if(dist < closest_dist)
				{
					closest_dist = dist;
					closest_dist_key = key;
				}
			}

			foreach(key in keys)
			{
				if(key == closest_dist_key)
				{
					self.generator_indicators[key].alpha = 1;
				}
				else
				{
					self.generator_indicators[key].alpha = 0.5;
				}
			}

			if(level.active_generators.size >= 2 && isdefined(level.jug_uses_left) && level.jug_uses_left == 0)
			{
				closest_dist = 9999999;
				closest_dist_index = -1;

				for(i = 0; i < self.fountain_indicators.size; i++)
				{
					dist = DistanceSquared(self.origin, self.fountain_indicators[i].linked_origin);
					if(dist < closest_dist)
					{
						closest_dist = dist;
						closest_dist_index = i;
					}
				}

				for(i = 0; i < self.fountain_indicators.size; i++)
				{
					if(i == closest_dist_index)
					{
						self.fountain_indicators[i].alpha = 1;
					}
					else
					{
						self.fountain_indicators[i].alpha = 0.5;
					}
				}
			}
		}
		wait(0.05);
	}
}

function set_bloodgun_ammo()
{
	self endon("disconnect");

	bloodgun = GetWeapon("bloodgun");
	root_gun = bloodgun.rootWeapon;
	has_no_bloodgun = true;
	while(true)
	{
		if(self GetCurrentWeapon() == bloodgun && has_no_bloodgun)
		{
			self GiveMaxAmmo(root_gun);
			has_no_bloodgun = false;
		}
		else if(self GetCurrentWeapon() != bloodgun)
		{
			has_no_bloodgun = true;
		}
		wait(0.05);
	}
	
}

function pap_think()
{
	level thread pap_jingle();
	papReady = 0;
	while(papReady < 4)
	{
		level waittill(#"generator_activated");
		papReady++;
	}
	level flag::set("power_on");
	level notify( "Pack_A_Punch_on" );
}

function pap_jingle()
{
	level waittill( "Pack_A_Punch_on" );

	pap_trigger = GetEnt("pack_a_punch", "script_noteworthy");
	pap_trigger thread zm_audio::sndPerksJingles_Timer();
}

function blood_cool_down()
{
	while(true)
	{
		level waittill("end_of_round");
		level.blood_uses = 0;
		wait(0.05);
	}
}

function blood_think()
{
	while(true) 
	{
		self thread set_bloodgun_hintstring();
		self waittill("trigger", player);
		if(! (zm_utility::is_player_valid(player)) || level.bloodgun_active || level.blood_cooling_down || level.hasVial || ! player zm_magicbox::can_buy_weapon() || level.shadow_vision_active)
		{
			wait(0.05);
			continue;
		}
		/*
		if(player.score < level.bloodgun_cost)
		{
			player playSound("no_cha_ching"); // no idea if this sound exists, or if this function is right
			wait(0.05);
			continue;
		}
		*/

		level.blood_uses++;
		level.bloodgun_active = true;
		player.isInBloodMode = true;
		//player zm_score::minus_to_player_score(level.bloodgun_cost);
		//visionset_mgr::activate("visionset", "zm_blood", player, 0.5);
		

		weapon_powerup_bloodgun(player, "bloodgun");
		
		player AllowMelee(false);
		player.attracting_zombies = true;
		visionset_mgr::activate("visionset", "zm_bgb_in_plain_sight", player, 0.5, 9999, 0.5);
		visionset_mgr::activate("overlay", "zm_bgb_in_plain_sight", player);

		player.bloodgun_kills = 0;
		start_kills = player.bloodgun_kills;
		success = false; 
		player thread zm_abbey_inventory::notifyText(NOTIF_POWER_BG, undefined, NOTIF_ALERT_POWER, undefined, true);

		foreach(p in level.players)
		{
			if(p != player)
			{
				p thread zm_abbey_inventory::notifyText(NOTIF_POWER_TEAM, undefined, NOTIF_ALERT_POWER, undefined, true);
			}
			p thread show_blood_empty(player);
		}

		music_index = level.active_generators.size + 1;
		if(level.active_generators.size >= 4)
		{
			music_index = RandomIntRange(1, 5);
		}
		level thread zm_audio::sndMusicSystem_PlayState("blood_gene" + music_index + "_mx");
		
		while(!success) 
		{
			if(! isdefined( level.musicSystem.currentState ) || level.musicSystem.currentState == "none")
			{
				level thread zm_audio::sndMusicSystem_PlayState("blood_gene" + music_index + "_mx");
			}

			for(i = 0; i < level.players.size; i++)
			{
				if(level.players[i] != player)
				{
					level.players[i].ignoreme = true;
				}
			}
			if(!zm_utility::is_player_valid(player) && ! player laststand::player_is_in_laststand()) 
			{
				wait(0.05);
				break;
			}
			else if(player laststand::player_is_in_laststand()) {
				wait(0.05);
				break;
			}
			else if(level.shadow_vision_active)
			{
				//player zm_score::add_to_player_score(level.bloodgun_cost);
				wait(0.05);
				break;
			}
			if(level.vialFilled >= level.bloodgun_kills)
			{
				//player zm_score::add_to_player_score(level.bloodgun_cost/2);

				//IPrintLn("Vial Filled!");				
				level.hasVial = true;
				success = true;
				if(isdefined(p.blood_vial_trial_fills))
				{
					p.blood_vial_trial_fills += 1;
				}
			}

			zombies = GetAISpeciesArray("axis", "all");
			for(i = 0; i < zombies.size; i++)
			{
				if(! IS_TRUE(zombies[i].blood_sped_up))
				{
					zombies[i].blood_sped_up = true;
					zombies[i] thread zombie_super_speed();
				}
			}

			killsGained = player.bloodgun_kills - start_kills;
			level.vialFilled += killsGained;
			//IPrintLn("start_kills" + start_kills);
			//IPrintLn("added " + killsGained + " kills");
			start_kills = player.bloodgun_kills;
			wait(0.05);
		}

		player notify(#"bloodgun_complete");
		level notify(#"blood_finished");

		visionset_mgr::deactivate( "overlay", "zm_bgb_in_plain_sight", player );
		visionset_mgr::deactivate( "visionset", "zm_bgb_in_plain_sight", player );

		if(isdefined(level.musicSystem.currentState) && IsSubStr(level.musicSystem.currentState, "blood_gene"))
		{
			level zm_audio::sndMusicSystem_StopAndFlush();
			level music::setmusicstate("none");
		}

		player.bloodgun_kills = undefined;

		for(i = 0; i < zombies.size; i++)
		{
			zombies[i].blood_sped_up = false;
			zombies[i] zombie_utility::set_zombie_run_cycle_restore_from_override();

			if(zombies[i].zombie_move_speed == "super_sprint") {
				if(level.zombie_move_speed > 70)
				{
					zombies[i] zombie_utility::set_zombie_run_cycle( "sprint" );
				}
				else if(level.zombie_move_speed > 40)
				{
					zombies[i] zombie_utility::set_zombie_run_cycle( "run" );
				}
				else
				{
					zombies[i] zombie_utility::set_zombie_run_cycle( "walk" );
				}
			}
		}
		
		for(i = 0; i < level.players.size; i++)
		{
			if(level.players[i] != player)
			{
				level.players[i].ignoreme = false;
			}
			level.players[i] thread show_blood_full(player);
		}

		player AllowMelee(true);
		level.bloodgun_active = false;
		level.vialFilled = 0;
		player.isInBloodMode = false;
		player.attracting_zombies = false;

		while(level.blood_uses == 2)
		{
			level.blood_cooling_down = true;
			wait(0.05);
		}
		level.blood_cooling_down = false;
	}
}

function generator_sound_think()
{
	while(! (level flag::exists("initial_blackscreen_passed") && level flag::get("initial_blackscreen_passed")))
	{
		wait(0.05);
	}
	sound_origin = Spawn("script_model", self.origin);
	sound_origin SetModel("tag_origin");
	sound_origin playloopsound("blood_gene_idle_loop");
	self waittill(#"generator_online");
	sound_origin stoploopsound();
	sound_origin playloopsound("blood_gene_running");
}

function zombie_super_speed()
{
	self endon("death");
	level endon(#"blood_finished");
	/*
	playable_area = getentarray("player_volume","script_noteworthy");
	while(true)
	{
		for (i = 0; i < playable_area.size; i++)
		{
			if (self IsTouching(playable_area[i]))
			{
				break;
			}
		}
		wait(0.05);
	}
	*/
	
	while(! IS_TRUE(self.completed_emerging_into_playable_area))
	{
		wait(0.05);
	}
	
	self zombie_utility::set_zombie_run_cycle_override_value("super_sprint");
	self thread play_ambient_zombie_vocals();
}

function play_ambient_zombie_vocals()
{
    self endon( "death" );
	level endon(#"blood_finished");
    
    while(1)
    {
        type = "ambient";
        float = 4;
        
        if( isdefined( self.zombie_move_speed ) )
        {
	        switch(self.zombie_move_speed)
		    {
				case "walk":    type="ambient"; float=4;    break;
				case "run":     type="sprint";  float=4;    break;
				case "sprint":  type="sprint";  float=4;    break;
				case "super_sprint":  type="sprint";  float=4;    break;
			}
        }
		
		if( self.animname == "zombie" && self.missingLegs )
		{
		    type = "crawler";
		}
		else if( self.animname == "thief_zombie" || self.animname == "leaper_zombie" )
		{
		    float = 1.2;
		}
		else if( self.voicePrefix == "keeper" )
		{
		    float = 1.2;
		}
		
		name = self.animname;
		if( isdefined( self.sndname ) )
		{
			name = self.sndname;
		}
		
		
		self notify( "bhtn_action_notify", type );
		
		wait(RandomFloatRange(1,float));
    }
}

function generator_think() 
{
	while(true)
	{
		self thread generator_sound_think();
		generator_name = self.script_noteworthy;
		self thread set_generator_hintstring();
		self waittill("trigger", player);
		//IPrintLn(generator_name + " had an attempt to activate it");
		if(level.hasVial && ! level.shadow_vision_active) 
		{
			//IPrintLn(generator_name + " was successfully activated, and the blood vial was taken.");
			level.hasVial = false;
			level turn_generator_on(generator_name);
			self notify(#"generator_online");
			player zm_audio::create_and_play_dialog( "general", "power_on" );
			wait(0.05);
			break;
		}
		wait(0.05);
	}
	self TriggerEnable(false);
}

function turn_generator_on(generator_name, after_shadow)
{
	if(! IsString(generator_name))
	{
		return;
	}

	foreach(p in level.players)
	{
		if(level.blood_uses == 4)
		{
			p PlaySound("blood_gene_all_activate");
		}
		else
		{
			p PlaySound("blood_gene_activate");
		}
	}

	switch(generator_name) {
		case "generator1":
			level flag::set("power_on1");

			if(! isdefined(after_shadow) || ! after_shadow)
			{
				for(i = 0; i < level.boxcages_q1.size; i++)
				{
					level.boxcages_q1[i] Delete();
				}
				level.active_generators[level.active_generators.size] = "generator1";
				foreach(player in level.players)
				{
					player.generator_indicators["generator1"] Destroy();
					player.generator_indicators = array::remove_index(player.generator_indicators, "generator1", true);
					player LUINotifyEvent(&"generator_activated", 1, 0);
				}
				
				level notify(#"generator_activated");
			}
			break;
		case "generator2":
			level flag::set("power_on2");

			if(! isdefined(after_shadow) || ! after_shadow)
			{
				for(i = 0; i < level.boxcages_q2.size; i++)
				{
					level.boxcages_q2[i] Delete();
				}
				level.active_generators[level.active_generators.size] = "generator2";
				foreach(player in level.players)
				{
					player.generator_indicators["generator2"] Destroy();
					player.generator_indicators = array::remove_index(player.generator_indicators, "generator2", true);
					player LUINotifyEvent(&"generator_activated", 1, 1);
				}
				level notify(#"generator_activated");
			}
			break;
		case "generator3":
			level flag::set("power_on3");

			if(! isdefined(after_shadow) || ! after_shadow)
			{
				for(i = 0; i < level.boxcages_q3.size; i++)
				{
					level.boxcages_q3[i] Delete();
				}
				level.active_generators[level.active_generators.size] = "generator3";
				foreach(player in level.players)
				{
					player.generator_indicators["generator3"] Destroy();
					player.generator_indicators = array::remove_index(player.generator_indicators, "generator3", true);
					player LUINotifyEvent(&"generator_activated", 1, 2);
				}
				level notify(#"generator_activated");
			}
			break;
		case "generator4":
			level flag::set("power_on4");

			if(! isdefined(after_shadow) || ! after_shadow)
			{
				for(i = 0; i < level.boxcages_q4.size; i++)
				{
					level.boxcages_q4[i] Delete();
				}
				level.active_generators[level.active_generators.size] = "generator4";
				foreach(player in level.players)
				{
					player.generator_indicators["generator4"] Destroy();
					player.generator_indicators = array::remove_index(player.generator_indicators, "generator4", true);
					player LUINotifyEvent(&"generator_activated", 1, 3);
				}
				level notify(#"generator_activated");
			}
			break;
	}

	foreach(player in level.players)
	{
		player thread zm_abbey_inventory::notifyGenerator();
	}
}

function turn_generator_off(generator_name)
{
	switch(generator_name) {
		case "generator1":
			//level notify( getVendingMachineNotify(PERK_QUICK_REVIVE) + "_off" );
			//zm_perks::perk_pause(PERK_QUICK_REVIVE);
			level flag::clear("power_on1");
			//zm_perks::perk_pause(PERK_ELECTRIC_CHERRY);
			break;
		case "generator2":
			level flag::clear("power_on2");
			//zm_perks::perk_pause(PERK_JUGGERNOG);
			break;
		case "generator3":
			level flag::clear("power_on3");
			break;
		case "generator4":
			level flag::clear("power_on4");
			break;
	}
}

function set_generator_hintstring() 
{
	prev_hintstring_state = -1;
	hintstring_state = -1;
	hintstrings = array(&"ZM_ABBEY_SHADOW_DISABLED", &"ZM_ABBEY_GENERATOR_DEPOSIT", &"ZM_ABBEY_GENERATOR_NO_BLOOD");

	while(! isdefined(level.shadow_vision_active))
	{
		wait(0.05);
	}
	
	while(true) 
	{
		if(level.shadow_vision_active)
		{
			hintstring_state = 0;
		}
		else if(level.hasVial)
		{
			hintstring_state = 1;
		}
		else
		{
			hintstring_state = 2;
		}

		if(prev_hintstring_state != hintstring_state)
		{
			self SetHintString(hintstrings[hintstring_state]);
			prev_hintstring_state = hintstring_state;
		}
		wait(0.05);
	}
}

function set_bloodgun_hintstring() 
{
	prev_hintstring_state = -1;
	hintstring_state = -1;
	hintstrings = array(&"ZM_ABBEY_BLOODGUN_IN_USE", &"ZM_ABBEY_SHADOW_DISABLED", &"ZM_ABBEY_BLOODGUN_HAS_VIAL", &"ZM_ABBEY_BLOODGUN_COOLDOWN", &"ZM_ABBEY_BLOODGUN_ACTIVATE");
	
	while(! isdefined(level.shadow_vision_active))
	{
		wait(0.05);
	}

	while(true) 
	{
		if(level.bloodgun_active)
		{
			hintstring_state = 0;
		}	
		else if(level.shadow_vision_active)
		{
			hintstring_state = 1;
		}
		else if(level.hasVial)
		{
			hintstring_state = 2;
		}
		else if(level.blood_cooling_down)
		{
			hintstring_state = 3;
		}
		else
		{
			hintstring_state = 4;
		}

		if(prev_hintstring_state != hintstring_state)
		{
			self SetHintString(hintstrings[hintstring_state]);
			prev_hintstring_state = hintstring_state;
		}
		wait(0.05);
	}
}

function show_blood_empty(player) 
{
	self LUINotifyEvent(&"blood_vial_update", 2, 1, player.characterIndex);
}

function show_blood_full(player) 
{
	self endon("disconnect");

	self LUINotifyEvent(&"blood_vial_update", 2, 2, player.characterIndex);
	while(level.hasVial)
	{
		wait(0.05);
	}
	self LUINotifyEvent(&"blood_vial_update", 2, 0, player.characterIndex);
}

function getVendingMachineNotify(perkName)
{
	str_perk = undefined;
	
	if ( isdefined( level._custom_perks[ perkName ] ) && isdefined( level._custom_perks[ perkName ].alias ) )
	{
		str_perk = level._custom_perks[ perkName ].alias;
	}	
	
	return str_perk;
}

function give_guns_back(weapon_store, weapon_store_clip, weapon_store_stock)
{
	self endon("disconnect");
	self endon("bled_out");

	// self DisableWeaponCycling();
	bloodgun = GetWeapon("bloodgun");
	self TakeWeapon(bloodgun);

	self waittill("player_revived");
	//IPrintLn("Yerr up it's time to get yer guns back!");

	self EnableWeaponCycling();
	self EnableOffhandWeapons();
	self GiveWeapon(weapon_store);
	self SetWeaponAmmoClip(weapon_store, weapon_store_clip);
	self SetWeaponAmmoStock(weapon_store, weapon_store_stock);
	self SwitchToWeapon(weapon_store);
	wait(0.05);
}