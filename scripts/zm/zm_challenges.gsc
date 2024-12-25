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
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_magicbox;
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
#using scripts\zm\_zm_bgb;

#using scripts\zm\zm_usermap;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_weap_cymbal_monkey;

#using scripts\zm\zm_abbey_inventory;
#using scripts\zm\zm_bgb_custom_util;
#using scripts\zm\custom_gg_machine;
#using scripts\zm\zm_room_manager;

#using scripts\shared\system_shared;

#using scripts\zm\_zm_bgb;

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

#precache( "string", "ZM_ABBEY_TRIAL_ACTIVATE" );
#precache( "string", "ZM_ABBEY_TRIAL_IN_PROGRESS" );
#precache( "string", "ZM_ABBEY_TRIAL_REWARD" );

// 8400
#define TRIAL_GOAL 8400
#define TRIAL_KILL_INCREMENT 140
#define TRIAL_AREA_INCREMENT 3
#define TRIAL_BASE_TIME 1800
#define TRIAL_EXTENDED_TIME 3000

#define WALLBUY_OFFSET 1
#define ROOM_TIME_OFFSET 11
#define ROOM_KILLS_OFFSET 21
#define CLASSES_OFFSET 31
#define HEADSHOTS_OFFSET 35
#define BOX_OFFSET 36
#define ELEVATION_OFFSET 37

#define ARAMIS_INDEX 0
#define PORTHOS_INDEX 1
#define DART_INDEX 2
#define ATHOS_INDEX 3

#define RAND_CF_NEUTRAL 0

#namespace zm_challenges;

REGISTER_SYSTEM( "zm_challenges", &__init__, undefined )

function __init__()
{
	clientfield::register( "toplayer", "trials.tier1", VERSION_SHIP, 7, "int" );
	clientfield::register( "toplayer", "trials.tier2", VERSION_SHIP, 13, "int" );
	clientfield::register( "toplayer", "trials.tier3", VERSION_SHIP, 5, "int" );

	clientfield::register( "toplayer", "trials.aramis", VERSION_SHIP, 5, "float" );
	clientfield::register( "toplayer", "trials.porthos", VERSION_SHIP, 5, "float" );
	clientfield::register( "toplayer", "trials.dart", VERSION_SHIP, 5, "float" );
	clientfield::register( "toplayer", "trials.athos", VERSION_SHIP, 5, "float" );

	clientfield::register( "toplayer", "trials.aramisRandom", VERSION_SHIP, 3, "int" );
	clientfield::register( "toplayer", "trials.porthosRandom", VERSION_SHIP, 3, "int" );
	clientfield::register( "toplayer", "trials.dartRandom", VERSION_SHIP, 3, "int" );
	clientfield::register( "toplayer", "trials.athosRandom", VERSION_SHIP, 3, "int" );

	clientfield::register( "toplayer", "trials.playerCountChange", VERSION_SHIP, 1, "int" );

	level.gg_tier1 = array("zm_bgb_stock_option", "zm_bgb_sword_flay", "zm_bgb_temporal_gift", "zm_bgb_in_plain_sight", "zm_bgb_im_feelin_lucky");
	level.gg_tier2 = array("zm_bgb_immolation_liquidation", "zm_bgb_pop_shocks", "zm_bgb_challenge_rejected", "zm_bgb_flavor_hexed", "zm_bgb_crate_power", "zm_bgb_aftertaste_blood", "zm_bgb_extra_credit");
	level.gg_tier3 = array("zm_bgb_on_the_house", "zm_bgb_unquenchable", "zm_bgb_head_drama", "zm_bgb_alchemical_antithesis");

	aramis_goals = array(2, 3, 4, 5, 5);
	porthos_goals = array(3, 3, 3, 3, 3);
	dart_goals = array(2, 2, 2, 2, 2);
	athos_goals = array(3, 3, 3, 3, 3);
	level.gargoyle_goals = array(aramis_goals, porthos_goals, dart_goals, athos_goals);

	level.gargoyle_cfs = array("trials.aramis", "trials.porthos", "trials.dart", "trials.athos");

	sten = GetWeapon("bo3_sten");
	thompson = GetWeapon("s4_thompsonm1a1");
	type11 = GetWeapon("s4_type11");
	bar = GetWeapon("s4_bar");
	trench = GetWeapon("s4_combat_shotgun");
	stg = GetWeapon("bo3_stg44");
	double_barrel = GetWeapon("s4_double_barrel_sawn");
	mas = GetWeapon("s2_mas38");
	level.wallbuy_challenge_guns = array(sten, thompson, type11, bar, trench, stg, double_barrel, mas);

	callback::on_connect( &on_player_connect );
	zm::register_zombie_damage_override_callback( &zombie_damage_override );
}

function zombie_damage_override(willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if ( isPlayer( attacker ) && willBeKilled )
	{
		attacker notify(#"potential_challenge_kill", self.origin);
		if(meansofdeath == "MOD_MELEE")
		{
			attacker notify(#"dart_trial_kill", self.origin);
		}
	}
}

function on_player_connect()
{
	self.lua_increment_quantity_queue_pos = [];
	self setup_gum_rewards();
	self setup_trials();

	self LUINotifyEvent(&"trial_upgrade_text_show", 1, 0);
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

	tier1_factoradic = level factoradic(tier1_indices);
	tier2_factoradic = level factoradic(tier2_indices);
	tier3_factoradic = level factoradic(tier3_indices);

	while(self clientfield::get_to_player("trials.tier1") != tier1_factoradic)
	{
		self clientfield::set_to_player("trials.tier1", tier1_factoradic);
		util::wait_network_frame();
	}
	while(self clientfield::get_to_player("trials.tier2") != tier2_factoradic)
	{
		self clientfield::set_to_player("trials.tier2", tier2_factoradic);
		util::wait_network_frame();
	}
	while(self clientfield::get_to_player("trials.tier3") != tier3_factoradic)
	{
		self clientfield::set_to_player("trials.tier3", tier3_factoradic);
		util::wait_network_frame();
	}
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
}

function gargoyle_progress_check(garg_num, progress)
{
	self endon("disconnect");

	self.gargoyle_progress[garg_num] += progress;

	index = self.gargoyle_indices[garg_num];
	if(self.gargoyle_progress[garg_num] >= 1)
	{
		self.gargoyle_progress[garg_num] = 0;
		while(self clientfield::get_to_player(level.gargoyle_cfs[garg_num]) != 1)
		{
			self clientfield::set_to_player(level.gargoyle_cfs[garg_num], 1);
			util::wait_network_frame();
		}
		if(index >= level.gargoyle_goals[garg_num].size - 1)
		{
			//rand_index = RandomIntRange(0, level.gargoyle_goals[garg_num].size - 1);
			rand_index = 0;
			rand_cf = level.gargoyle_cfs[garg_num] + "Random";
			gum = self.gargoyle_gums[garg_num][rand_index];
			self.gg_quantities[gum] += 1;
			self thread lua_increment_quantity(rand_cf, rand_index + 1);
		}
		else
		{
			gum = self.gargoyle_gums[garg_num][index];
			self.gg_quantities[gum] += 1;
			self.gargoyle_indices[garg_num] += 1;
		}
	}
	else if(progress > 0)
	{
		self clientfield::set_to_player(level.gargoyle_cfs[garg_num], self.gargoyle_progress[garg_num]);
	}
	util::wait_network_frame();
}

function lua_increment_quantity(cf, cf_val)
{
	self endon("disconnect");

	if(! isdefined(self.lua_increment_quantity_queue_pos[cf]))
	{
		self.lua_increment_quantity_queue_pos[cf] = 0;
	}
	queue_pos = self.lua_increment_quantity_queue_pos[cf];
	while(queue_pos > 0)
	{
		self waittill(#"lua_increment_quantity_queue_pop");
		queue_pos -= 1;
	}

	self.lua_increment_quantity_queue_pos[cf] += 1;

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

	self notify(#"lua_increment_quantity_queue_pop");
	self.lua_increment_quantity_queue_pos[cf] -= 1;
}

function aramis_trial()
{
	self endon("disconnect");

	level waittill("start_of_round");
	while(true)
	{
		level waittill("start_of_round");
		index = self.gargoyle_indices[ARAMIS_INDEX];
		progress = 1 / level.gargoyle_goals[ARAMIS_INDEX][index];
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
		index = self.gargoyle_indices[PORTHOS_INDEX];
		progress = headshots / level.gargoyle_goals[PORTHOS_INDEX][index];
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

		index = self.gargoyle_indices[DART_INDEX];
		progress = 1 / level.gargoyle_goals[DART_INDEX][index];
		self gargoyle_progress_check(DART_INDEX, progress);
	}
}

function wallbuy_challenge_hub()
{
	weapon_index = RandomIntRange(0, level.wallbuy_challenge_guns.size);
	level.wallbuy_challenge_weapon = level.wallbuy_challenge_guns[weapon_index];

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] clientfield::set_player_uimodel("trialName", WALLBUY_OFFSET + weapon_index);
		players[i] thread wallbuy_challenge();
	}
}


function wallbuy_challenge()
{
	self endon("disconnect");

	self thread zm_abbey_inventory::notifyText("splash_trial_wallbuy", level.open_inventory_prompt, level.abbey_alert_neutral);

	wallbuys = struct::get_array("weapon_upgrade", "targetname");
	wallbuy = undefined;
	for(i = 0; i < wallbuys.size; i++)
	{
		if(wallbuys[i].zombie_weapon_upgrade == level.wallbuy_challenge_weapon.name)
		{
			wallbuy = wallbuys[i];
		}
	}

	waypoint_pos = Spawn("script_model", wallbuy.origin);
	waypoint_pos SetModel("tag_origin");

	wallbuy_indicator = NewClientHudElem(self);
	wallbuy_indicator SetTargetEnt(waypoint_pos);
	wallbuy_indicator SetShader("buy_waypoint");
	wallbuy_indicator SetWayPoint(true, "buy_waypoint", false, false);

	self thread wallbuy_indicator_monitor(wallbuy_indicator);
	
	self thread wallbuy_challenge_kill_monitor();
	self thread monitor_pap(true);

	while(level.is_in_team_challenge)
	{
		wait(0.05);
	}

	wallbuy_indicator Destroy();
	waypoint_pos Delete();

	self notify(#"wallbuy_challenge_finished");
}

function wallbuy_indicator_monitor(wallbuy_indicator)
{
	self endon("disconnect");
	self endon(#"wallbuy_challenge_finished");

	while(true)
	{
		weapons = self GetWeaponsListPrimaries();
		for(i = 0; i < weapons.size; i++) 
		{
			if(weapons[i] == level.wallbuy_challenge_weapon || zm_weapons::get_base_weapon(weapons[i]) == level.wallbuy_challenge_weapon || self.abbey_no_waypoints)
			{
				wallbuy_indicator.alpha = 0;
			}
			else
			{
				wallbuy_indicator.alpha = 1;
			}
		}

		wait(0.05);
	}
}

function wallbuy_challenge_kill_monitor()
{
	self endon("disconnect");
	self endon(#"wallbuy_challenge_finished");

	while(true)
	{
		self waittill("zom_kill");
		if(self GetCurrentWeapon() == level.wallbuy_challenge_weapon || zm_weapons::get_base_weapon(self GetCurrentWeapon()) == level.wallbuy_challenge_weapon)
		{
			self.trial_progress = Min(self.trial_progress + TRIAL_KILL_INCREMENT, TRIAL_GOAL);
		}
	}
}

function box_challenge_hub()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] clientfield::set_player_uimodel("trialName", BOX_OFFSET);
		players[i] thread box_challenge();
	}
}

function box_challenge()
{
	self endon("disconnect");

	self thread zm_abbey_inventory::notifyText( "splash_trial_mystery_box", level.open_inventory_prompt, level.abbey_alert_neutral );

	self.box_challenge_weapons = [];
	self thread box_challenge_weapons_monitor();
	
	self thread box_challenge_kill_monitor();
	while(level.is_in_team_challenge)
	{
		wait(0.05);
	}

	self notify(#"box_challenge_finished");
}

function box_challenge_weapons_monitor()
{
	self endon("disconnect");
	self endon(#"box_challenge_finished");

	self.check_weapon_give = undefined;
	self.check_box_grab = false;

	self thread check_weapon_give();
	self thread check_box_grab();
	self thread monitor_pap();

	while(true)
	{
		if(isdefined(self.check_weapon_give) && self.check_box_grab)
		{
			self.box_challenge_weapons[self.box_challenge_weapons.size] = self.check_weapon_give;
			self.check_weapon_give = undefined;
			self.check_box_grab = false;
		}
		wait(0.05);
	}
}

function check_weapon_give()
{
	self endon("disconnect");
	self endon(#"box_challenge_finished");

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
	self endon(#"box_challenge_finished");

	while(true)
	{
		self waittill( "user_grabbed_weapon");
		self.check_box_grab = true;
		wait(0.1);
		self.check_box_grab = false;
	}
}

function box_challenge_kill_monitor()
{
	self endon("disconnect");
	self endon(#"box_challenge_finished");

	while(true)
	{
		self waittill("zom_kill");
		for(i = 0; i < self.box_challenge_weapons.size; i++)
		{
			if(self GetCurrentWeapon() == self.box_challenge_weapons[i] || zm_weapons::get_base_weapon(self GetCurrentWeapon()) == self.box_challenge_weapons[i])
			{
				self.trial_progress = Min(self.trial_progress + TRIAL_KILL_INCREMENT, TRIAL_GOAL);
				break;
			}		
		}
		
	}
}

function monitor_pap(wallbuy_challenge=false)
{
	self endon("disconnect");
	level endon(#"team_challenge_completed");

	self thread monitor_double_tap(wallbuy_challenge);
	self thread monitor_prompt(wallbuy_challenge);
	self thread disable_prompt();

	shown_prompt = [];

	while(true)
	{
		weapon = self challenge_upgrade_weapon_check(wallbuy_challenge);
		if(isdefined(weapon))
		{
			if(! array::contains(shown_prompt, weapon))
			{
				//self zm_abbey_inventory::notifyText("", level.challenge_upgrade_prompt, level.abbey_alert_neutral, true);
				shown_prompt[shown_prompt.size] = weapon;
			}
			// magic
		}
		wait(0.05);
	}
}

function monitor_double_tap(wallbuy_challenge)
{
	self endon("disconnect");
	level endon(#"team_challenge_completed");

	while(true)
	{
		if(self UseButtonPressed())
		{
			while(self UseButtonPressed())
			{
				wait(0.05);
			}
			time = 0;
			while(! self UseButtonPressed())
			{
				time += 0.05;
				wait(0.05);
			}
			if(time > 0 && time < 0.35 && self.score >= 4000)
			{
				weapon = self challenge_upgrade_weapon_check(wallbuy_challenge);
				if(isdefined(weapon))
				{
					self zm_score::minus_to_player_score(4000);
					self zm_weapons::weapon_give(level.zombie_weapons[weapon].upgrade);
				}
			}
		}
		wait(0.05);
	}
}

function monitor_prompt(wallbuy_challenge)
{
	self endon("disconnect");
	level endon(#"team_challenge_completed");

	showing_prompt = false;
	while(true)
	{
		if(isdefined(self challenge_upgrade_weapon_check(wallbuy_challenge)) && !showing_prompt)
		{
			self LUINotifyEvent(&"trial_upgrade_text_show", 1, 1);
			showing_prompt = true;
		}
		else if(!(isdefined(self challenge_upgrade_weapon_check(wallbuy_challenge)) && showing_prompt))
		{
			self LUINotifyEvent(&"trial_upgrade_text_show", 1, 0);
			showing_prompt = false;
		}
		wait(0.05);
	}
}

function disable_prompt()
{
	self endon("disconnect");

	level waittill(#"team_challenge_completed");
	self LUINotifyEvent(&"trial_upgrade_text_show", 1, 0);
}

function challenge_upgrade_weapon_check(wallbuy_challenge)
{
	self endon("disconnect");

	wallbuy_arr = []; wallbuy_arr[0] = level.wallbuy_challenge_weapon;
	challenge_weapons = (wallbuy_challenge ? wallbuy_arr : self.box_challenge_weapons);
	foreach(weapon in challenge_weapons)
	{
		if(self GetCurrentWeapon() == weapon)
		{
			return weapon;
		}
	}
	return undefined;
}

function room_kills_challenge()
{
	self endon("disconnect");

	self thread zm_abbey_inventory::notifyText( "splash_trial_area_assault", level.open_inventory_prompt, level.abbey_alert_neutral );
	self thread room_challenge_kill_monitor();

	while(level.is_in_team_challenge)
	{
		wait(0.05);
	}

	self notify(#"room_challenge_finished");
}

function room_challenge_kill_monitor()
{
	self endon("disconnect");
	self endon(#"room_challenge_finished");

	while(true)
	{
		self waittill("zom_kill");
		if(self zm_room_manager::is_player_in_room(level.challenge_room_zone))
		{
			self.trial_progress = Min(self.trial_progress + TRIAL_KILL_INCREMENT, TRIAL_GOAL);
		}
	}
}

function elevation_challenge()
{
	self endon("disconnect");

	self thread zm_abbey_inventory::notifyText( "splash_trial_high_ground", level.open_inventory_prompt, level.abbey_alert_neutral );

	self thread elevation_challenge_kill_monitor();

	while(level.is_in_team_challenge)
	{
		wait(0.05);
	}

	self notify(#"elevation_challenge_finished");
}

function elevation_challenge_kill_monitor()
{
	self endon("disconnect");
	self endon(#"elevation_challenge_finished");

	while(true)
	{
		self waittill(#"potential_challenge_kill", origin);
		if(self.origin[2] - origin[2] >= 30)
		{
			self.trial_progress = Min(self.trial_progress + TRIAL_KILL_INCREMENT, TRIAL_GOAL);
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