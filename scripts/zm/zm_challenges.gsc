#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_magicbox;

#using scripts\zm\zm_abbey_inventory;
#using scripts\zm\zm_room_manager;

#insert scripts\zm\zm_abbey_inventory.gsh;

#precache( "material", "defend_waypoint");
#precache( "material", "buy_waypoint");
#precache( "material", "splash_trial_new");
#precache( "material", "splash_trial_filled");
#precache( "model", "gumball_blue");
#precache( "model", "gumball_green");
#precache( "model", "gumball_orange");
#precache( "model", "gumball_purple");

#precache( "fx", "custom/fx_trail_blood_soul_zmb" );

#precache( "eventstring", "trial_upgrade_text_show" );

// 8400
#define TRIAL_GOAL 8400
#define TRIAL_KILL_INCREMENT 140
#define TRIAL_AREA_INCREMENT 3
#define TRIAL_BASE_TIME 1800
#define TRIAL_EXTENDED_TIME 3000

#define ARAMIS_INDEX 0
#define PORTHOS_INDEX 1
#define DART_INDEX 2
#define ATHOS_INDEX 3

#define WALLBUY_OFFSET 2
#define AREA_ASSAULT_OFFSET 15
#define CROUCH_OFFSET 27
#define ELEVATION_OFFSET 28
#define BOX_OFFSET 29
#define TRAP_OFFSET 30
#define BLOOD_VIAL_OFFSET 31

#define	ELEVATION_MULTIPLIER 2
#define BLOOD_VIAL_MULTIPLIER 7.5

#define ELEVATION_THRESHOLD 30

#define RAND_CF_NEUTRAL 0
#define TAB_TRIAL 1

#namespace zm_challenges;

REGISTER_SYSTEM( "zm_challenges", &__init__, undefined )

function __init__()
{
	clientfield::register( "toplayer", "trials.tier1", VERSION_SHIP, 7, "int" );
	clientfield::register( "toplayer", "trials.tier2", VERSION_SHIP, 13, "int" );
	clientfield::register( "toplayer", "trials.tier3", VERSION_SHIP, 5, "int" );

	clientfield::register( "toplayer", "trials.aramis", VERSION_SHIP, 4, "float" );
	clientfield::register( "toplayer", "trials.porthos", VERSION_SHIP, 10, "float" );
	clientfield::register( "toplayer", "trials.dart", VERSION_SHIP, 10, "float" );
	clientfield::register( "toplayer", "trials.athos", VERSION_SHIP, 10, "float" );

	clientfield::register( "toplayer", "trials.aramisRandom", VERSION_SHIP, 4, "int" );
	clientfield::register( "toplayer", "trials.porthosRandom", VERSION_SHIP, 4, "int" );
	clientfield::register( "toplayer", "trials.dartRandom", VERSION_SHIP, 4, "int" );
	clientfield::register( "toplayer", "trials.athosRandom", VERSION_SHIP, 4, "int" );

	clientfield::register( "clientuimodel", "athosTrial", VERSION_SHIP, 5, "int" );
	clientfield::register( "clientuimodel", "athosWaypoints", VERSION_SHIP, 1, "int" );
	clientfield::register( "clientuimodel", "shadowTrial", VERSION_SHIP, 1, "int" );

	clientfield::register( "toplayer", "trials.playerCountChange", VERSION_SHIP, 1, "int" );

	level.gg_tier1 = array("zm_bgb_stock_option", "zm_bgb_sword_flay", "zm_bgb_temporal_gift", "zm_bgb_in_plain_sight", "zm_bgb_im_feelin_lucky");
	level.gg_tier2 = array("zm_bgb_immolation_liquidation", "zm_bgb_pop_shocks", "zm_bgb_challenge_rejected", "zm_bgb_flavor_hexed", "zm_bgb_crate_power", "zm_bgb_aftertaste_blood", "zm_bgb_extra_credit");
	level.gg_tier3 = array("zm_bgb_on_the_house", "zm_bgb_unquenchable", "zm_bgb_head_drama", "zm_bgb_alchemical_antithesis");

	aramis_goals = array(2, 3, 4, 5, 5);
	porthos_goals = array(20, 35, 55, 90, 100);
	dart_goals = array(15, 25, 25, 35, 50);
	athos_goals = array(30, 35, 45, 60, 75);
	level.gargoyle_goals = array(aramis_goals, porthos_goals, dart_goals, athos_goals);

	level.gargoyle_cfs = array("trials.aramis", "trials.porthos", "trials.dart", "trials.athos");

	level.gargoyle_notifs = array("splash_trial_aramis", "splash_trial_porthos", "splash_trial_dart", "splash_trial_athos");

	athos_trials_0 = array(&wallbuy_trial, &area_assault_trial, &crouch_trial, &elevation_trial);
	athos_trials_1 = array(&wallbuy_trial, &area_assault_trial, &crouch_trial, &elevation_trial, &blood_vial_trial, &box_trial);
	athos_trials_2 = array(&wallbuy_trial, &area_assault_trial, &crouch_trial, &elevation_trial, &blood_vial_trial, &trap_trial, &box_trial);
	athos_trials_3 = array(&wallbuy_trial, &area_assault_trial, &crouch_trial, &elevation_trial, &trap_trial, &box_trial);
	level.athos_trials = array(athos_trials_0, athos_trials_1, athos_trials_2, athos_trials_3);

	level.airfield_name = "Airfield";
	level.pilgrimage_name = "Upper Pilgrimage Stairs";
	level.airfield_box_indices = array(4, 5);
	level.pilgrimage_box_indices = array(7, 8);
	if(GetDvarString("ui_mapname") == "zm_building")
	{
		level.airfield_name = "Clean Room";
		level.pilgrimage_name = "Lion Room";
		level.airfield_box_indices = array(3);
		level.pilgrimage_box_indices = array(2);
	}
	
	kar = GetWeapon("s4_kar98k_irons");
	gewehr = GetWeapon("s4_g43");
	garand = GetWeapon("s4_m1garand");
	trench = GetWeapon("s4_combat_shotgun");
	mp40 = GetWeapon("bo3_mp40");
	double_barrel = GetWeapon("s4_double_barrel_sawn");
	sten = GetWeapon("bo3_sten");
	mas = GetWeapon("s2_mas38");
	thompson = GetWeapon("s4_thompsonm1a1");
	stg = GetWeapon("bo3_stg44");
	bar = GetWeapon("s4_bar");
	svt = GetWeapon("s4_svt40");
	type11 = GetWeapon("s4_type11");
	
	level.wallbuy_trial_guns = array(kar, gewehr, garand, trench, mp40, double_barrel, sten, mas, thompson, stg, bar, svt, type11);
	level.wallbuy_trial_start_indices = array(0, 3, 7, 0);
	level.wallbuy_trial_end_indices = array(3, 8, 12, 13);
	level.wallbuy_trial_cutoff_index = 10;

	level.area_assault_trial_rooms = array("Crash Site", "Bell Tower", "Red Room", "Basilica", "Airfield", "Upper Pilgrimage Stairs", "Merveille de Verite", "Knight's Hall", "URM Laboratory", "Verite Library", "Courtyard", "No Man's Land");
	if(GetDvarString("ui_mapname") == "zm_building")
	{
		level.area_assault_trial_rooms = array("Spawn Room", "Spawn Room", "Staminarch", "Water Tower", "Water Tower", "Water Tower", "Lion Room", "Lion Room", "Clean Room", "Clean Room", "Downstairs Room", "Downstairs Room");
	}
	level.area_assault_trial_waypoint_locs = [];
	waypoints = struct::get_array("area_assault_waypoint", "targetname");
	foreach(waypoint in waypoints)
	{
		level.area_assault_trial_waypoint_locs[waypoint.script_string] = waypoint.origin;
	}
	level.area_assault_trial_start_indices = array(0, 3, 6, 2);
	level.area_assault_trial_end_indices = array(3, 6, 10, 12);
	level.area_assault_trial_cutoff_index = 8;

	trap_a = GetEntArray("trap_a", "targetname");
	trap_b = GetEntArray("trap_b", "targetname");
	trap_c = GetEntArray("trap_c", "targetname");
	trap_d = GetEntArray("trap_d", "targetname");
	trap_e = GetEntArray("trap_e", "targetname");
	trap_f = GetEntArray("trap_f", "targetname");
	trap_g = GetEntArray("trap_g", "targetname");
	trap_h = GetEntArray("trap_h", "targetname");
	trap_i = GetEntArray("trap_i", "targetname");
	trap_j = GetEntArray("trap_j", "targetname");
	component_arrays = array(trap_a, trap_b, trap_c, trap_d, trap_e, trap_f, trap_g, trap_h, trap_i, trap_j);

	level.athos_trap_trigs = [];
	foreach(component_array in component_arrays)
	{
		foreach(component in component_array)
		{
			if(component.classname == "trigger_use")
			{
				level array::add(level.athos_trap_trigs, component);
				break;
			}
		}
	}

	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	zm::register_zombie_damage_override_callback( &zombie_damage_override );
}

function zombie_damage_override(willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if (isdefined(attacker) && willBeKilled)
	{
		if(IsPlayer(attacker))
		{
			attacker notify(#"potential_challenge_kill", self.origin);
			if(meansofdeath == "MOD_MELEE")
			{
				attacker notify(#"dart_trial_kill");
			}
			if(isdefined(attacker.area_assault_trial_kills) && attacker zm_room_manager::is_player_in_room(level.abbey_rooms[attacker.area_assault_trial_room]))
			{
				attacker.area_assault_trial_kills += 1;
			}
			else if(isdefined(attacker.crouch_trial_kills) && attacker GetStance() == "crouch")
			{
				attacker.crouch_trial_kills += 1;
			}
			else if(isdefined(attacker.elevation_trial_kills) && attacker.origin[2] - self.origin[2] >= ELEVATION_THRESHOLD)
			{
				attacker.elevation_trial_kills += 1;
			}
			else if(isdefined(weapon) && isdefined(attacker.wallbuy_trial_kills) && level zm_weapons::get_base_weapon(weapon) == attacker.wallbuy_trial_weapon)
			{
				attacker.wallbuy_trial_kills += 1;
			}
			else if(isdefined(weapon) && isdefined(attacker.box_trial_kills) && array::contains(attacker.box_trial_weapons, level zm_weapons::get_base_weapon(weapon)))
			{
				attacker.box_trial_kills += 1;
			}
		}
		else if(isdefined(attacker.activated_by_player) && isdefined(attacker.activated_by_player.trap_trial_kills))
		{
			attacker.activated_by_player.trap_trial_kills += 1;
		}
	}
}

function on_player_connect()
{
	self setup_gum_rewards();
	self setup_trials();

	self LUINotifyEvent(&"trial_upgrade_text_show", 1, 0);
}

function on_player_spawned()
{
	while(! (level flag::exists("initial_blackscreen_passed") && level flag::get("initial_blackscreen_passed")))
	{
		wait(0.05);
	}

	self thread set_gums();
	self thread display_gums();
	if(isdefined(self.athos_cf_val))
	{
		self thread set_athos_trial();
	}
	if(IS_TRUE(self.athos_indicators_active))
	{
		self clientfield::set_player_uimodel("athosWaypoints", 1);
	}
}

function set_gums()
{
	self endon("disconnect");
	self endon("bled_out");

	while(! (isdefined(self.tier1_factoradic) && isdefined(self.tier2_factoradic) && isdefined(self.tier3_factoradic)))
	{
		wait(0.05);
	}

	while(self clientfield::get_to_player("trials.tier1") != self.tier1_factoradic)
	{
		self clientfield::set_to_player("trials.tier1", self.tier1_factoradic);
		util::wait_network_frame();
	}
	while(self clientfield::get_to_player("trials.tier2") != self.tier2_factoradic)
	{
		self clientfield::set_to_player("trials.tier2", self.tier2_factoradic);
		util::wait_network_frame();
	}
	while(self clientfield::get_to_player("trials.tier3") != self.tier3_factoradic)
	{
		self clientfield::set_to_player("trials.tier3", self.tier3_factoradic);
		util::wait_network_frame();
	}
}

function display_gums()
{
	self endon("disconnect");
	self endon("bled_out");

	while(! (isdefined(self.gargoyle_gums) && isdefined(self.gg_available)))
	{
		wait(0.05);
	}

	for(i = 0; i < 4; i++)
	{
		for(j = 0; j < 4; j++)
		{
			gum = self.gargoyle_gums[i][j];
			cf_val = j + 1;
			if(! self.gg_available[gum])
			{
				cf_val += 4;
			}
			rand_cf = level.gargoyle_cfs[i] + "Random";
			self lua_toggle_gum_vis(rand_cf, cf_val);
		}
	}
}

function set_athos_trial()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon(#"athos_trial_end");

	while(self clientfield::get_player_uimodel("athosTrial") != self.athos_cf_val)
	{
		self clientfield::set_player_uimodel("athosTrial", self.athos_cf_val);
		util::wait_network_frame();
	}
}

function setup_gum_rewards()
{
	tier1_indices = level tier_indices_init(level.gg_tier1);
	tier2_indices = level tier_indices_init(level.gg_tier2);
	tier3_indices = level tier_indices_init(level.gg_tier3);

	// Ensure Sword Flay is not in Aramis (hardcoded)
	for(i = 0; i < 3; i++)
	{
		if(tier1_indices[i] == 1)
		{
			swap_index = RandomIntRange(3, 5);
			temp = tier1_indices[i];
			tier1_indices[i] = tier1_indices[swap_index];
			tier1_indices[swap_index] = temp;
			break;
		}
	}

	self assign_gargoyle_gums(tier1_indices, tier2_indices, tier3_indices);

	self.tier1_factoradic = level factoradic(tier1_indices);
	self.tier2_factoradic = level factoradic(tier2_indices);
	self.tier3_factoradic = level factoradic(tier3_indices);
}

function setup_trials()
{
	self.gargoyle_indices = [];
	self.gargoyle_progress = [];
	for(i = 0; i < 4; i++)
	{	
		array::add(self.gargoyle_indices, 0);
		array::add(self.gargoyle_progress, 0.0);
	}

	self thread aramis_trial();
	self thread porthos_trial();
	self thread dart_trial();
	self thread athos_trial();
	self thread shadow_trial_update();
}

function shadow_trial_update()
{
	self endon("disconnect");

	while(! isdefined(level.shadow_vision_active))
	{
		wait(0.05);
	}

	while(true)
	{
		while(self clientfield::get_player_uimodel("shadowTrial") != 0)
		{
			self clientfield::set_player_uimodel("shadowTrial", 0);
			util::wait_network_frame();
		}
		while(! level.shadow_vision_active)
		{
			wait(0.05);
		}
		while(self clientfield::get_player_uimodel("shadowTrial") != 1)
		{
			self clientfield::set_player_uimodel("shadowTrial", 1);
			util::wait_network_frame();
		}
		while(level.shadow_vision_active)
		{
			wait(0.05);
		}
	}
}

function gargoyle_progress_check(garg_num, progress)
{
	self endon("disconnect");

	if(garg_num != ARAMIS_INDEX && level.shadow_vision_active)
	{
		return;
	}

	self.gargoyle_progress[garg_num] += progress;

	index = self.gargoyle_indices[garg_num];
	gum = undefined;
	if(self.gargoyle_progress[garg_num] >= 1)
	{
		self notify("trial_complete" + garg_num);
		self.gargoyle_progress[garg_num] -= 1;
		while(self clientfield::get_to_player(level.gargoyle_cfs[garg_num]) != 1)
		{
			self clientfield::set_to_player(level.gargoyle_cfs[garg_num], 1);
			util::wait_network_frame();
		}
		self clientfield::set_to_player(level.gargoyle_cfs[garg_num], self.gargoyle_progress[garg_num]);
		if(index >= level.gargoyle_goals[garg_num].size - 1)
		{
			reward_arr = [];
			for(i = 0; i < 4; i++)
			{
				reward_gum = self.gargoyle_gums[garg_num][i];
				if(! self.gg_available[reward_gum])
				{
					level array::add(reward_arr, i);
				}
			}
			if(reward_arr.size > 0)
			{
				index = level array::random(reward_arr);
				rand_cf = level.gargoyle_cfs[garg_num] + "Random";
				gum = self.gargoyle_gums[garg_num][index];
				self.gg_available[gum] = true;
				self thread lua_toggle_gum_vis(rand_cf, index + 1);
			}
		}
		else
		{
			gum = self.gargoyle_gums[garg_num][index];
			self.gg_available[gum] = true;
			self.gargoyle_indices[garg_num] += 1;
		}
		if(isdefined(gum))
		{
			notif_cf = NOTIF_GUM_OFFSET + garg_num;
			gum_cf = level.gg_notifs[gum];
			self thread zm_abbey_inventory::notifyText(notif_cf, NOTIF_FLASH_RIGHT, NOTIF_ALERT_GARG, gum_cf);
			if(self.judge_indices[garg_num] != index)
			{
				self.judge_indices[garg_num] = index;
				self notify("judge_display_update" + garg_num);
			}
		}
	}
	else if(progress > 0)
	{
		self clientfield::set_to_player(level.gargoyle_cfs[garg_num], self.gargoyle_progress[garg_num]);
	}
	util::wait_network_frame();
}

function lua_toggle_gum_vis(cf, cf_val)
{
	self endon("disconnect");

	while(self clientfield::get_to_player(cf) != cf_val)
	{
		self clientfield::set_to_player(cf, cf_val);
		util::wait_network_frame();
	}
	while(self clientfield::get_to_player(cf) != RAND_CF_NEUTRAL)
	{
		self clientfield::set_to_player(cf, RAND_CF_NEUTRAL);
		util::wait_network_frame();
	}
}

function trial_progress_scale(garg_num, progress)
{
	self endon("disconnect");

	index = self.gargoyle_indices[garg_num];
	goal = level.gargoyle_goals[garg_num][index];
	if(garg_num != ARAMIS_INDEX && level.round_number >= 20 && index == 4)
	{
		goal = 0.05 * (level.round_number * level.round_number) + (goal - 20);
	}

	return progress / goal;
}

function aramis_trial()
{
	self endon("disconnect");

	level waittill("start_of_round");
	while(true)
	{
		level waittill("start_of_round");
		progress = trial_progress_scale(ARAMIS_INDEX, 1);
		self gargoyle_progress_check(ARAMIS_INDEX, progress);
		wait(0.05);
	}
}

function porthos_trial()
{
	self endon("disconnect");

	headshots = 0;
	prev_headshots = self.pers["headshots"];
	while(true)
	{
		headshots = self.pers["headshots"] - prev_headshots;
		prev_headshots = self.pers["headshots"];
		progress = trial_progress_scale(PORTHOS_INDEX, headshots);
		self gargoyle_progress_check(PORTHOS_INDEX, progress);
		wait(0.05);
	}
}

function dart_trial()
{
	self endon("disconnect");

	while(true)
	{
		self waittill(#"dart_trial_kill");
		progress = trial_progress_scale(DART_INDEX, 1);
		self gargoyle_progress_check(DART_INDEX, progress);
	}
}

function athos_trial()
{
	self endon("disconnect");

	self.first_athos_trial = true;
	self.athos_indicators_active = false;
	self thread athos_indicators_monitor();

	level waittill("start_of_round");
	prev_trial = undefined;
	while(true)
	{
		self.in_athos_indicator_trial = false;
		athos_stage = 3;
		if(level.round_number < 4)
		{
			athos_stage = 0;
		}
		else if(level.round_number < 7)
		{
			athos_stage = 1;
		}
		else if(level.round_number < 10)
		{
			athos_stage = 2;
		}

		athos_trials = ArrayCopy(level.athos_trials[athos_stage]);
		if(athos_stage == 2)
		{
			airfield_path_active = level zm_room_manager::is_room_active(level.abbey_rooms[level.airfield_name]);
			pilgrimage_path_active = level zm_room_manager::is_room_active(level.abbey_rooms[level.pilgrimage_name]);
			
			both_paths_active = airfield_path_active && pilgrimage_path_active;
			neither_path_active = ! (airfield_path_active || pilgrimage_path_active);

			cur_chest = level.chests[level.chest_index];
			box_index = level.abbey_box_location_indices[cur_chest.script_noteworthy];

			airfield_box_active = airfield_path_active && level array::contains(level.airfield_box_indices, box_index);
			pilgrimage_box_active = pilgrimage_path_active && level array::contains(level.pilgrimage_box_indices, box_index);
			
			if(! (both_paths_active || neither_path_active || airfield_box_active || pilgrimage_box_active))
			{
				ArrayRemoveValue(athos_trials, &box_trial);
			}
		}

		if(isdefined(prev_trial))
		{
			ArrayRemoveValue(athos_trials, prev_trial);
		}

		trial = level array::random(athos_trials);
		prev_trial = trial;
		self thread [[trial]](athos_stage);

		for(i = 0; i < 3; i++)
		{
			level waittill("start_of_round");
			if(i < 2)
			{
				cf_val = 1 - i;
				while(self clientfield::get_player_uimodel("athosTrial") != cf_val)
				{
					self clientfield::set_player_uimodel("athosTrial", cf_val);
					util::wait_network_frame();
				}
			}
		}

		self notify(#"athos_trial_end");
		self.wallbuy_trial_kills = undefined;
		self.area_assault_trial_kills = undefined;
		self.crouch_trial_kills = undefined;
		self.elevation_trial_kills = undefined;
		self.box_trial_kills = undefined;
		self.trap_trial_kills = undefined;
		self.blood_vial_trial_fills = undefined;
		self.athos_closest_origin = undefined;
	}
}

function wallbuy_trial(athos_stage)
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	if(self.first_athos_trial)
	{
		self.first_athos_trial = false;
	}
	else
	{
		self thread zm_abbey_inventory::notifyText(NOTIF_ATHOS_WALLBUY, NOTIF_FLASH_RIGHT, NOTIF_ALERT_ATHOS);
	}

	self.in_athos_indicator_trial = true;

	start_index = level.wallbuy_trial_start_indices[athos_stage];
	end_index = level.wallbuy_trial_end_indices[athos_stage];

	index = RandomIntRange(start_index, end_index);

	airfield_path_active = level zm_room_manager::is_room_active(level.abbey_rooms[level.airfield_name]);
	pilgrimage_path_active = level zm_room_manager::is_room_active(level.abbey_rooms[level.pilgrimage_name]);

	both_paths_active = airfield_path_active && pilgrimage_path_active;
	neither_path_active = ! (airfield_path_active || pilgrimage_path_active);
	if(athos_stage == 2 && ! both_paths_active && ! neither_path_active)
	{
		if(airfield_path_active && index >= level.wallbuy_trial_cutoff_index)
		{
			index -= 2;
			if(RandomIntRange(0, 2) == 0)
			{
				index = start_index;
			}
		}
		else if(pilgrimage_path_active && index > start_index && index < level.wallbuy_trial_cutoff_index)
		{
			index += 2;
			if(RandomIntRange(0, 2) == 0)
			{
				index = start_index;
			}
		}
	}

	self.wallbuy_trial_weapon = level.wallbuy_trial_guns[index];
	self.wallbuy_trial_kills = 0;

	self thread wallbuy_trial_indicators_monitor();

	self.athos_cf_val = WALLBUY_OFFSET + index;
	while(self clientfield::get_player_uimodel("athosTrial") != self.athos_cf_val)
	{
		self clientfield::set_player_uimodel("athosTrial", self.athos_cf_val);
		util::wait_network_frame();
	}

	prev_wallbuy_trial_kills = self.wallbuy_trial_kills;
	while(true)
	{
		if(self.wallbuy_trial_kills > prev_wallbuy_trial_kills)
		{
			progress = trial_progress_scale(ATHOS_INDEX, self.wallbuy_trial_kills - prev_wallbuy_trial_kills);
			self gargoyle_progress_check(ATHOS_INDEX, progress);
			prev_wallbuy_trial_kills = self.wallbuy_trial_kills;
		}
		wait(0.05);
	}
}

function wallbuy_trial_indicators_monitor()
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	all_wallbuys = struct::get_array("weapon_upgrade", "targetname");
	wallbuys = [];
	foreach(wallbuy in all_wallbuys)
	{
		if(wallbuy.zombie_weapon_upgrade == self.wallbuy_trial_weapon.name)
		{
			self thread wallbuy_trial_indicator_monitor(wallbuy);
			level array::add(wallbuys, wallbuy);
		}
	}

	self thread athos_closest_origin(wallbuys);
}

function wallbuy_trial_indicator_monitor(wallbuy)
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	waypoint_pos = Spawn("script_model", wallbuy.origin);
	waypoint_pos SetModel("tag_origin");

	wallbuy_indicator = NewClientHudElem(self);
	wallbuy_indicator SetTargetEnt(waypoint_pos);
	wallbuy_indicator SetShader("buy_waypoint");
	wallbuy_indicator SetWayPoint(true, "buy_waypoint", false, false);
	wallbuy_indicator.alpha = 0;

	self thread athos_indicator_cleanup(waypoint_pos, wallbuy_indicator);

	while(true)
	{
		has_trial_weapon = false;
		foreach(weapon in self GetWeaponsList())
		{
			if(level zm_weapons::get_base_weapon(weapon) == self.wallbuy_trial_weapon)
			{
				has_trial_weapon = true;
				break;
			}
		}
		if(has_trial_weapon || ! self.athos_indicators_active)
		{
			wallbuy_indicator.alpha = 0;
		}
		else if(isdefined(self.athos_closest_origin) && wallbuy.origin == self.athos_closest_origin)
		{
			wallbuy_indicator.alpha = 1;
		}
		else
		{
			wallbuy_indicator.alpha = 0.5;
		}
		wait(0.05);
	}
}

function area_assault_trial(athos_stage)
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	if(self.first_athos_trial)
	{
		self.first_athos_trial = false;
	}
	else
	{
		self thread zm_abbey_inventory::notifyText(NOTIF_ATHOS_AREA_ASSAULT, NOTIF_FLASH_RIGHT, NOTIF_ALERT_ATHOS);
	}

	self.in_athos_indicator_trial = true;

	start_index = level.area_assault_trial_start_indices[athos_stage];
	end_index = level.area_assault_trial_end_indices[athos_stage];

	airfield_path_active = level zm_room_manager::is_room_active(level.abbey_rooms[level.airfield_name]);
	pilgrimage_path_active = level zm_room_manager::is_room_active(level.abbey_rooms[level.pilgrimage_name]);

	both_paths_active = airfield_path_active && pilgrimage_path_active;
	neither_path_active = ! (airfield_path_active || pilgrimage_path_active);
	if(athos_stage == 2 && ! both_paths_active && ! neither_path_active)
	{
		if(airfield_path_active)
		{
			end_index = level.area_assault_trial_cutoff_index;
		}
		else
		{
			start_index = level.area_assault_trial_cutoff_index;
		}
	}

	index = RandomIntRange(start_index, end_index);
	self.area_assault_trial_room = level.area_assault_trial_rooms[index];
	self.area_assault_trial_kills = 0;

	self thread area_assault_indicator_monitor();

	self.athos_cf_val = AREA_ASSAULT_OFFSET + index;
	while(self clientfield::get_player_uimodel("athosTrial") != self.athos_cf_val)
	{
		self clientfield::set_player_uimodel("athosTrial", self.athos_cf_val);
		util::wait_network_frame();
	}

	prev_area_assault_trial_kills = self.area_assault_trial_kills;
	while(true)
	{
		if(self.area_assault_trial_kills > prev_area_assault_trial_kills)
		{
			progress = trial_progress_scale(ATHOS_INDEX, self.area_assault_trial_kills - prev_area_assault_trial_kills);
			self gargoyle_progress_check(ATHOS_INDEX, progress);
			prev_area_assault_trial_kills = self.area_assault_trial_kills;
		}
		wait(0.05);
	}
}

function area_assault_indicator_monitor()
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	waypoint_pos = Spawn("script_model", level.area_assault_trial_waypoint_locs[self.area_assault_trial_room]);
	waypoint_pos SetModel("tag_origin");

	room_indicator = NewClientHudElem(self);
	room_indicator SetTargetEnt(waypoint_pos);
	room_indicator SetShader("defend_waypoint");
	room_indicator SetWayPoint(true, "defend_waypoint", false, false);
	room_indicator.alpha = 0;

	self thread athos_indicator_cleanup(waypoint_pos, room_indicator);

	while(true)
	{
		if(self.athos_indicators_active)
		{
			room_indicator.alpha = 1;
		}
		else
		{
			room_indicator.alpha = 0;
		}
		wait(0.05);
	}
}

function crouch_trial(athos_stage)
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	if(self.first_athos_trial)
	{
		self.first_athos_trial = false;
	}
	else
	{
		self thread zm_abbey_inventory::notifyText(NOTIF_ATHOS_CROUCH, NOTIF_FLASH_RIGHT, NOTIF_ALERT_ATHOS);
	}

	self.crouch_trial_kills = 0;

	self.athos_cf_val = CROUCH_OFFSET;
	while(self clientfield::get_player_uimodel("athosTrial") != self.athos_cf_val)
	{
		self clientfield::set_player_uimodel("athosTrial", self.athos_cf_val);
		util::wait_network_frame();
	}

	prev_crouch_trial_kills = self.crouch_trial_kills;
	while(true)
	{
		if(self.crouch_trial_kills > prev_crouch_trial_kills)
		{
			progress = trial_progress_scale(ATHOS_INDEX, self.crouch_trial_kills - prev_crouch_trial_kills);
			self gargoyle_progress_check(ATHOS_INDEX, progress);
			prev_crouch_trial_kills = self.crouch_trial_kills;
		}
		wait(0.05);
	}
}

function elevation_trial(athos_stage)
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	if(self.first_athos_trial)
	{
		self.first_athos_trial = false;
	}
	else
	{
		self thread zm_abbey_inventory::notifyText(NOTIF_ATHOS_ELEVATION, NOTIF_FLASH_RIGHT, NOTIF_ALERT_ATHOS);
	}

	self.elevation_trial_kills = 0;

	self.athos_cf_val = ELEVATION_OFFSET;
	while(self clientfield::get_player_uimodel("athosTrial") != self.athos_cf_val)
	{
		self clientfield::set_player_uimodel("athosTrial", self.athos_cf_val);
		util::wait_network_frame();
	}

	prev_elevation_trial_kills = self.elevation_trial_kills;
	while(true)
	{
		if(self.elevation_trial_kills > prev_elevation_trial_kills)
		{
			progress = trial_progress_scale(ATHOS_INDEX, self.elevation_trial_kills - prev_elevation_trial_kills);
			progress *= ELEVATION_MULTIPLIER;
			self gargoyle_progress_check(ATHOS_INDEX, progress);
			prev_elevation_trial_kills = self.elevation_trial_kills;
		}
		wait(0.05);
	}
}

function box_trial(athos_stage)
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	if(self.first_athos_trial)
	{
		self.first_athos_trial = false;
	}
	else
	{
		self thread zm_abbey_inventory::notifyText(NOTIF_ATHOS_BOX, NOTIF_FLASH_RIGHT, NOTIF_ALERT_ATHOS);
	}

	self.in_athos_indicator_trial = true;

	self.box_trial_kills = 0;
	self.box_trial_weapons = [];

	self thread box_trial_weapons_monitor();
	self thread box_trial_indicator_monitor();

	self.athos_cf_val = BOX_OFFSET;
	while(self clientfield::get_player_uimodel("athosTrial") != self.athos_cf_val)
	{
		self clientfield::set_player_uimodel("athosTrial", self.athos_cf_val);
		util::wait_network_frame();
	}

	prev_box_trial_kills = self.box_trial_kills;
	while(true)
	{
		if(self.box_trial_kills > prev_box_trial_kills)
		{
			progress = trial_progress_scale(ATHOS_INDEX, self.box_trial_kills - prev_box_trial_kills);
			self gargoyle_progress_check(ATHOS_INDEX, progress);
			prev_box_trial_kills = self.box_trial_kills;
		}
		wait(0.05);
	}
}

function box_trial_indicator_monitor()
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	waypoint_pos = Spawn("script_model", level.chests[level.chest_index].origin + (0, 0, 20));
	waypoint_pos SetModel("tag_origin");

	room_indicator = NewClientHudElem(self);
	room_indicator SetTargetEnt(waypoint_pos);
	room_indicator SetShader("buy_waypoint");
	room_indicator SetWayPoint(true, "buy_waypoint", false, false);
	room_indicator.alpha = 0;

	self thread athos_indicator_cleanup(waypoint_pos, room_indicator);

	prev_chest_index = level.chest_index;
	while(true)
	{
		if(prev_chest_index != level.chest_index)
		{
			waypoint_pos.origin = level.chests[level.chest_index].origin + (0, 0, 20);
			prev_chest_index = level.chest_index;
		}
		if(self.athos_indicators_active)
		{
			room_indicator.alpha = 1;
		}
		else
		{
			room_indicator.alpha = 0;
		}
		wait(0.05);
	}
}

function box_trial_weapons_monitor()
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	self.check_weapon_give = undefined;
	self.check_box_grab = false;

	self thread check_weapon_give();
	self thread check_box_grab();

	while(true)
	{
		if(isdefined(self.check_weapon_give) && self.check_box_grab)
		{
			// check for Crate Power and whatnot
			weapon = level zm_weapons::get_base_weapon(self.check_weapon_give);
			level array::add(self.box_trial_weapons, weapon);
			self.check_weapon_give = undefined;
			self.check_box_grab = false;
		}
		wait(0.05);
	}
}

function check_weapon_give()
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	while(true)
	{
		self waittill( "weapon_give", weapon );
		self.check_weapon_give = weapon;
		wait(0.1);
		self.check_weapon_give = undefined;
	}
}

function check_box_grab()
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	while(true)
	{
		self waittill( "user_grabbed_weapon");
		self.check_box_grab = true;
		wait(0.1);
		self.check_box_grab = false;
	}
}

function trap_trial(athos_stage)
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	if(self.first_athos_trial)
	{
		self.first_athos_trial = false;
	}
	else
	{
		self thread zm_abbey_inventory::notifyText(NOTIF_ATHOS_TRAP, NOTIF_FLASH_RIGHT, NOTIF_ALERT_ATHOS);
	}

	self.in_athos_indicator_trial = true;
	self.trap_trial_kills = 0;

	self.athos_cf_val = TRAP_OFFSET;
	while(self clientfield::get_player_uimodel("athosTrial") != self.athos_cf_val)
	{
		self clientfield::set_player_uimodel("athosTrial", self.athos_cf_val);
		util::wait_network_frame();
	}

	self thread trap_trial_indicators_monitor();

	prev_trap_trial_kills = self.trap_trial_kills;
	while(true)
	{
		if(self.trap_trial_kills > prev_trap_trial_kills)
		{
			progress = trial_progress_scale(ATHOS_INDEX, self.trap_trial_kills - prev_trap_trial_kills);
			self gargoyle_progress_check(ATHOS_INDEX, progress);
			prev_trap_trial_kills = self.trap_trial_kills;
		}
		wait(0.05);
	}
}

function trap_trial_indicators_monitor()
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	foreach(trap_trig in level.athos_trap_trigs)
	{
		self thread trap_trial_indicator_monitor(trap_trig);
	}

	self thread athos_closest_origin(level.athos_trap_trigs);
}

function trap_trial_indicator_monitor(trap_trig)
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	waypoint_pos = Spawn("script_model", trap_trig.origin);
	waypoint_pos SetModel("tag_origin");

	trap_indicator = NewClientHudElem(self);
	trap_indicator SetTargetEnt(waypoint_pos);
	trap_indicator SetShader("buy_waypoint");
	trap_indicator SetWayPoint(true, "buy_waypoint", false, false);
	trap_indicator.alpha = 0;

	self thread athos_indicator_cleanup(waypoint_pos, trap_indicator);

	while(true)
	{
		if(! self.athos_indicators_active)
		{
			trap_indicator.alpha = 0;
		}
		else if(isdefined(self.athos_closest_origin) && self.athos_closest_origin == trap_trig.origin)
		{
			trap_indicator.alpha = 1;
		}
		else
		{
			trap_indicator.alpha = 0.5;
		}
		wait(0.05);
	}
}

function blood_vial_trial(athos_stage)
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	if(self.first_athos_trial)
	{
		self.first_athos_trial = false;
	}
	else
	{
		self thread zm_abbey_inventory::notifyText(NOTIF_ATHOS_BLOOD_VIAL, NOTIF_FLASH_RIGHT, NOTIF_ALERT_ATHOS);
	}

	self.in_athos_indicator_trial = true;
	
	self.blood_vial_trial_fills = 0;

	self.athos_cf_val = BLOOD_VIAL_OFFSET;
	while(self clientfield::get_player_uimodel("athosTrial") != self.athos_cf_val)
	{
		self clientfield::set_player_uimodel("athosTrial", self.athos_cf_val);
		util::wait_network_frame();
	}

	prev_blood_vial_trial_fills = self.blood_vial_trial_fills;
	while(true)
	{
		if(self.blood_vial_trial_fills > prev_blood_vial_trial_fills)
		{
			progress = trial_progress_scale(ATHOS_INDEX, self.blood_vial_trial_fills - prev_blood_vial_trial_fills);
			progress *= BLOOD_VIAL_MULTIPLIER;
			self gargoyle_progress_check(ATHOS_INDEX, progress);
			prev_blood_vial_trial_fills = self.blood_vial_trial_fills;
		}
		wait(0.05);
	}
}

function athos_indicators_monitor()
{
	self endon("disconnect");

	level waittill("start_of_round");

	while(true)
	{
		if(self.in_athos_indicator_trial && self.abbey_inventory_active && self.current_tab == TAB_TRIAL && self UseButtonPressed())
		{
			while(self UseButtonPressed())
			{
				wait(0.05);
			}
			self.athos_indicators_active = ! self.athos_indicators_active;
			self clientfield::set_player_uimodel("athosWaypoints", Int(self.athos_indicators_active));
		}
		wait(0.05);
	}
}

function athos_indicator_cleanup(waypoint_pos, indicator)
{
	self util::waittill_any("disconnect", #"athos_trial_end");

	waypoint_pos Delete();
	indicator Destroy();
}

function athos_closest_origin(arr)
{
	self endon("disconnect");
	self endon(#"athos_trial_end");

	while(true)
	{
		closest_dist = 9999999;
		closest_dist_index = -1;
		for(i = 0; i < arr.size; i++)
		{
			dist = DistanceSquared(self.origin, arr[i].origin);
			if(dist < closest_dist)
			{
				closest_dist = dist;
				closest_dist_index = i;
			}
		}

		for(i = 0; i < arr.size; i++)
		{
			if(i == closest_dist_index)
			{
				self.athos_closest_origin = arr[i].origin;
				break;
			}
		}
		wait(0.05);
	}
}

function tier_gums_init(indices, ref)
{
	gums = [];

	for(i = 0; i < indices.size; i++)
	{
		gums[i] = ref[indices[i]];
	}

	return gums;
}

function factoradic(arr)
{
	lehmer_encode(arr);
	factoradic = 0;

	for(i = 0; i < arr.size - 1; i++)
	{
		factoradic += (factorial(arr.size - i - 1) * arr[i]);
	}

	return factoradic;
}

function lehmer_encode(&arr)
{
	for(i = 0; i < arr.size; i++)
	{
		for(j = i + 1; j < arr.size; j++)
		{
			if(arr[j] > arr[i])
			{
				arr[j] = arr[j] - 1;
			}
		}
	}

	return arr;
}

function factorial(n)
{
	if(n == 0)
	{
		return 1;
	}

	fact = 1;
	for(i = 1; i <= n; i++)
	{
		fact *= i;
	}

	return fact;
}

function tier_indices_init(ref)
{
	indices = [];

	for(i = 0; i < ref.size; i++)
	{
		indices[i] = i;
	}

	return array::randomize(indices);
}

function assign_gargoyle_gums(tier1_indices, tier2_indices, tier3_indices)
{
	tier1_gums = tier_gums_init(tier1_indices, level.gg_tier1);
	tier2_gums = tier_gums_init(tier2_indices, level.gg_tier2);
	tier3_gums = tier_gums_init(tier3_indices, level.gg_tier3);

	// this is very hardcoded, in the unlikely event of a refactor you gotta change this
	aramis_gums = array(tier1_gums[0], tier1_gums[1], tier1_gums[2], tier2_gums[0]);
	porthos_gums = array(tier1_gums[3], tier2_gums[1], tier2_gums[2], tier3_gums[0]);
	dart_gums = array(tier1_gums[4], tier2_gums[3], tier2_gums[4], tier3_gums[1]);
	athos_gums = array(tier2_gums[5], tier2_gums[6], tier3_gums[2], tier3_gums[3]);

	self.gargoyle_gums = array(aramis_gums, porthos_gums, dart_gums, athos_gums);

	self thread monitor_player_count_gums();
}

function monitor_player_count_gums()
{
	self endon("disconnect");

	extra_credit_i = -1;
	extra_credit_j = -1;

	head_drama_i = -1;
	head_drama_j = -1;

	for(i = 0; i < self.gargoyle_gums.size; i++)
	{
		for(j = 0; j < self.gargoyle_gums[i].size; j++)
		{
			if(self.gargoyle_gums[i][j] == "zm_bgb_extra_credit")
			{
				extra_credit_i = i;
				extra_credit_j = j;
			}
			else if(self.gargoyle_gums[i][j] == "zm_bgb_head_drama")
			{
				head_drama_i = i;
				head_drama_j = j;
			}
		}
	}

	prev_player_count = 1;
	while(true)
	{
		if(level.players.size != prev_player_count)
		{
			prev_player_count = level.players.size;
			if(level.players.size == 1)
			{
				self.gargoyle_gums[extra_credit_i][extra_credit_j] = "zm_bgb_extra_credit";
				self.gargoyle_gums[head_drama_i][head_drama_j] = "zm_bgb_head_drama";
				while(self clientfield::get_to_player("trials.playerCountChange") != 0)
				{
					self clientfield::set_to_player("trials.playerCountChange", 0);
					util::wait_network_frame();
				}
			}
			else
			{
				self.gargoyle_gums[extra_credit_i][extra_credit_j] = "zm_bgb_profit_sharing";
				self.gargoyle_gums[head_drama_i][head_drama_j] = "zm_bgb_phoenix_up";
				while(self clientfield::get_to_player("trials.playerCountChange") != 1)
				{
					self clientfield::set_to_player("trials.playerCountChange", 1);
					util::wait_network_frame();
				}
			}
		}
		wait(0.05);
	}
}