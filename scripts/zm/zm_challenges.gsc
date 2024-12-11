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

#namespace zm_challenges;

REGISTER_SYSTEM( "zm_challenges", &__init__, undefined )

function __init__()
{
	clientfield::register( "toplayer", "trials.tier1", VERSION_SHIP, 7, "int" );
	clientfield::register( "toplayer", "trials.tier2", VERSION_SHIP, 13, "int" );
	clientfield::register( "toplayer", "trials.tier3", VERSION_SHIP, 5, "int" );
	clientfield::register( "clientuimodel", "trialReward", VERSION_SHIP, 2, "int" );
	clientfield::register( "clientuimodel", "trialTimer", VERSION_SHIP, 2, "int" );
	clientfield::register( "clientuimodel", "trialName", VERSION_SHIP, 6, "int" );
	/*
	clientfield::register( "clientuimodel", "soloQueueUpdate", VERSION_SHIP, 2, "int" );
	clientfield::register( "clientuimodel", "teamChallengeUpdate", VERSION_SHIP, 13, "int" );
	clientfield::register( "clientuimodel", "teamQueueUpdate", VERSION_SHIP, 2, "int" );
	*/

	level.gg_tier1 = [];
	array::add(level.gg_tier1, "zm_bgb_stock_option");
	array::add(level.gg_tier1, "zm_bgb_sword_flay");
	array::add(level.gg_tier1, "zm_bgb_temporal_gift");
	array::add(level.gg_tier1, "zm_bgb_in_plain_sight");
	array::add(level.gg_tier1, "zm_bgb_im_feelin_lucky");

	level.gg_tier2 = [];
	array::add(level.gg_tier2, "zm_bgb_immolation_liquidation");
	array::add(level.gg_tier2, "zm_bgb_pop_shocks");
	array::add(level.gg_tier2, "zm_bgb_cache_back");
	array::add(level.gg_tier2, "zm_bgb_wall_power");
	array::add(level.gg_tier2, "zm_bgb_crate_power");
	array::add(level.gg_tier2, "zm_bgb_alchemical_antithesis");
	array::add(level.gg_tier2, "zm_bgb_extra_credit");

	level.gg_tier3 = [];
	array::add(level.gg_tier3, "zm_bgb_on_the_house");
	array::add(level.gg_tier3, "zm_bgb_unquenchable");
	array::add(level.gg_tier3, "zm_bgb_head_drama");
	array::add(level.gg_tier3, "zm_bgb_reign_drops");

	level.reward_trig1 = GetEnt("reward_trig1", "targetname");
	level.reward_trig2 = GetEnt("reward_trig2", "targetname");
	level.reward_trig3 = GetEnt("reward_trig3", "targetname");
	level.reward_trig4 = GetEnt("reward_trig4", "targetname");

	level.reward_trig1 SetCursorHint("HINT_NOICON");
	level.reward_trig2 SetCursorHint("HINT_NOICON");
	level.reward_trig3 SetCursorHint("HINT_NOICON");
	level.reward_trig4 SetCursorHint("HINT_NOICON");

	gumball1 = GetEnt(level.reward_trig1.target, "targetname");
	gumball2 = GetEnt(level.reward_trig2.target, "targetname");
	gumball3 = GetEnt(level.reward_trig3.target, "targetname");
	gumball4 = GetEnt(level.reward_trig4.target, "targetname");

	gumball1 SetInvisibleToAll();
	gumball2 SetInvisibleToAll();
	gumball3 SetInvisibleToAll();
	gumball4 SetInvisibleToAll();

	level.trial_cost = 500;

	level.team_challenge_trig = GetEnt("team_challenge", "targetname");
	level.team_challenge_trig SetCursorHint( "HINT_NOICON" );

	level.is_in_team_challenge = false;

	level.team_challenge_queue = 0;
	level.team_challenge_progress = 0;
	level.team_challenge_goal = 1;
	level.team_challenge_rounds = 1;
	level.team_challenge_text = "";

	level.divinium_trial_funcs = [];
	//level.divinium_trial_funcs[level.divinium_trial_funcs.size] = &headshot_challenge_hub;
	level.divinium_trial_funcs[level.divinium_trial_funcs.size] = &wallbuy_challenge_hub;
	//level.divinium_trial_funcs[level.divinium_trial_funcs.size] = &box_challenge_hub;
	//level.divinium_trial_funcs[level.divinium_trial_funcs.size] = &room_time_challenge_hub;
	//level.divinium_trial_funcs[level.divinium_trial_funcs.size] = &room_kills_challenge_hub;
	//level.divinium_trial_funcs[level.divinium_trial_funcs.size] = &class_challenge_hub;
	//level.divinium_trial_funcs[level.divinium_trial_funcs.size] = &elevation_challenge_hub;

	sten = GetWeapon("bo3_sten");
	thompson = GetWeapon("s4_thompsonm1a1");
	type11 = GetWeapon("s4_type11");
	bar = GetWeapon("s4_bar");
	trench = GetWeapon("s4_combat_shotgun");
	stg = GetWeapon("bo3_stg44");
	double_barrel = GetWeapon("s4_double_barrel_sawn");
	mas = GetWeapon("s2_mas38");

	level.wallbuy_challenge_guns = [];
	level.wallbuy_challenge_guns[level.wallbuy_challenge_guns.size] = sten;
	level.wallbuy_challenge_guns[level.wallbuy_challenge_guns.size] = thompson;
	level.wallbuy_challenge_guns[level.wallbuy_challenge_guns.size] = type11;
	level.wallbuy_challenge_guns[level.wallbuy_challenge_guns.size] = bar;
	level.wallbuy_challenge_guns[level.wallbuy_challenge_guns.size] = trench;
	level.wallbuy_challenge_guns[level.wallbuy_challenge_guns.size] = stg;
	level.wallbuy_challenge_guns[level.wallbuy_challenge_guns.size] = double_barrel;
	level.wallbuy_challenge_guns[level.wallbuy_challenge_guns.size] = mas;

	level.team_challenge_classes = [];
	level.team_challenge_classes[level.team_challenge_classes.size] = "pistol";
	level.team_challenge_classes[level.team_challenge_classes.size] = "smg";
	level.team_challenge_classes[level.team_challenge_classes.size] = "rifle";
	level.team_challenge_classes[level.team_challenge_classes.size] = "mg";

	level.challenge_gg_rewards = [];
	level.challenge_gg_rewards[level.challenge_gg_rewards.size] = "zm_bgb_pop_shocks";
	level.challenge_gg_rewards[level.challenge_gg_rewards.size] = "zm_bgb_wall_power";
	level.challenge_gg_rewards[level.challenge_gg_rewards.size] = "zm_bgb_crate_power";
	level.challenge_gg_rewards[level.challenge_gg_rewards.size] = "zm_bgb_unquenchable";
	level.challenge_gg_rewards[level.challenge_gg_rewards.size] = "zm_bgb_immolation_liquidation";
	level.challenge_gg_rewards[level.challenge_gg_rewards.size] = "zm_bgb_cache_back";
	level.challenge_gg_rewards[level.challenge_gg_rewards.size] = "zm_bgb_on_the_house";

	thread monitor_divinium_trial();

	callback::on_connect( &on_player_connect );
	zm::register_zombie_damage_override_callback( &zombie_damage_override );
	thread trial_prices_set();
	thread trial_hintstring_think();
	//thread testeroo();
}

function zombie_damage_override(willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if ( isPlayer( attacker ) && willBeKilled )
	{
		attacker notify(#"potential_challenge_kill", self.origin);
	}
}

function on_player_connect()
{
	//level.solo_challenge_gg_trig SetHintStringForPlayer(self, "Press ^3[{+activate}]^7 to accept an individual challenge [GobbleGum Reward]");
	//level.solo_challenge_gun_trig SetHintStringForPlayer(self, "Press ^3[{+activate}]^7 to accept an individual challenge [Weapon Reward]");
	level.reward_trig1 SetHintStringForPlayer(self, &"ZM_ABBEY_EMPTY");
	level.reward_trig2 SetHintStringForPlayer(self, &"ZM_ABBEY_EMPTY");
	level.reward_trig3 SetHintStringForPlayer(self, &"ZM_ABBEY_EMPTY");
	level.reward_trig4 SetHintStringForPlayer(self, &"ZM_ABBEY_EMPTY");

	self setup_gum_rewards();

	self.trial_progress = 0;
	self LUINotifyEvent(&"trial_upgrade_text_show", 1, 0);
	self thread monitor_divinium_trial_reward();
	//self thread create_pap_prompt();
	//self thread monitor_solo_challenge();
	//self thread testerootoo();
	//self thread monitor_solo_challenge_gun();
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

	self clientfield::set_to_player("trials.tier1", tier1_factoradic);
	self clientfield::set_to_player("trials.tier2", tier2_factoradic);
	self clientfield::set_to_player("trials.tier3", tier3_factoradic);
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
	self.aramis_gums = [];
	self.porthos_gums = [];
	self.dart_gums = [];
	self.athos_gums = [];

	tier1_gums = tier_gums_init(tier1_indices, level.gg_tier1);
	tier2_gums = tier_gums_init(tier2_indices, level.gg_tier2);
	tier3_gums = tier_gums_init(tier3_indices, level.gg_tier3);

	// this is very hardcoded, in the unlikely event of a refactor you gotta change this
	array::add(self.aramis_gums, tier1_gums[0]);
	array::add(self.aramis_gums, tier1_gums[1]);
	array::add(self.aramis_gums, tier1_gums[2]);
	array::add(self.aramis_gums, tier2_gums[0]);

	array::add(self.porthos_gums, tier1_gums[3]);
	array::add(self.porthos_gums, tier2_gums[1]);
	array::add(self.porthos_gums, tier2_gums[2]);
	array::add(self.porthos_gums, tier3_gums[0]);

	array::add(self.dart_gums, tier1_gums[4]);
	array::add(self.dart_gums, tier2_gums[3]);
	array::add(self.dart_gums, tier2_gums[4]);
	array::add(self.dart_gums, tier3_gums[1]);

	array::add(self.athos_gums, tier2_gums[5]);
	array::add(self.athos_gums, tier2_gums[6]);
	array::add(self.athos_gums, tier3_gums[2]);
	array::add(self.athos_gums, tier3_gums[3]);
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

function trial_prices_set()
{
	level waittill( "end_of_round" );
	level waittill( "end_of_round" );
	level waittill( "end_of_round" );
	level waittill( "end_of_round" );
	level waittill( "end_of_round" );
	level waittill( "end_of_round" );
	level waittill( "end_of_round" );
	level waittill( "end_of_round" );
	level waittill( "end_of_round" );
	level.trial_cost += 500;
	level waittill( "end_of_round" );
}

function trial_hintstring_think()
{
	prev_trial_cost = -1;
	prev_hintstring_state = -1;
	hintstring_state = -1;

	while(true)
	{
		if(level.is_in_team_challenge)
		{
			hintstring_state = 0;
		}
		else
		{
			hintstring_state = 1;
		}

		if(prev_hintstring_state != hintstring_state || prev_trial_cost != level.trial_cost)
		{
			if(hintstring_state == 0)
			{
				level.team_challenge_trig SetHintString(&"ZM_ABBEY_TRIAL_IN_PROGRESS");
			}
			else
			{
				level.team_challenge_trig SetHintString( &"ZM_ABBEY_TRIAL_ACTIVATE", level.trial_cost);
			}

			prev_hintstring_state = hintstring_state;
			prev_trial_cost = level.trial_cost;
		}
		wait(0.05);
	}
}

function monitor_divinium_trial_reward()
{
	self endon("disconnect");

	prev_progress = -1;
	while(true)
	{
		if(self.trial_progress >= TRIAL_GOAL)
		{
			self clientfield::set_player_uimodel("trialReward", 1);
			self.trial_progress = 0;
			self zm_score::add_to_player_score(level.trial_cost * 4);
			self thread zm_abbey_inventory::notifyText("splash_trial_filled", undefined, level.abbey_alert_pos);
			self custom_gg_machine::add_to_all_gums();
			self thread check_for_gg_reward();
		}
		if(prev_progress != self.trial_progress)
		{
			prev_progress = self.trial_progress;
		}
		
		//IPrintLn(self.trial_progress / TRIAL_GOAL);
		util::wait_network_frame();
		
		self clientfield::set_player_uimodel("trialReward", 2);
	}
}

function check_for_gg_reward()
{
	self endon("disconnect");
	self endon(#"team_challenge_completed");

	gg_reward_info = array::random(level.challenge_gg_rewards);

	index = self.characterIndex + 1; // janky stuff to avoid annoying refactor
	name = zm_bgb_custom_util::gg_name(gg_reward_info);
	reward_trig = GetEnt("reward_trig" + index, "targetname");
	reward_trig SetHintStringForPlayer(self, &"ZM_ABBEY_TRIAL_REWARD", name);

	gumball = GetEnt(reward_trig.target, "targetname");

	gumWeapon = GetWeapon("zombie_bgb_grab");
	gumStruct = zm_bgb_custom_util::lookupGobblgum(gg_reward_info);


	weapon_options = self GetBuildKitWeaponOptions( gumWeapon, gumStruct.camoIndex );
	display_ball = zm_utility::spawn_weapon_model(gumWeapon, "wpn_t7_zmb_bubblegum_view", gumball.origin, gumball.angles, weapon_options);
	display_ball SetScale(2.5);
	self thread destroy_reward_gumball(display_ball);

	player = undefined;
	while(! isdefined(player) || ! player zm_magicbox::can_buy_weapon() || player != self)
	{
		reward_trig waittill("trigger", player);
	}

	self clientfield::set_player_uimodel("trialReward", 0);
	self notify("gg_reward_taken");
	self zm_bgb_custom_util::giveGobbleGum(gumStruct);
	reward_trig SetHintStringForPlayer(self, &"ZM_ABBEY_EMPTY");
}

function destroy_reward_gumball(gumball)
{
	self util::waittill_any("disconnect", #"team_challenge_completed", "gg_reward_taken");
	gumball Delete();
}

function monitor_divinium_trial()
{
	while(true)
	{
		level.team_challenge_trig waittill("trigger", player);

		if(! (zm_utility::is_player_valid(player)) || ! zm_perks::vending_trigger_can_player_use(player) || level.is_in_team_challenge)
		{
			wait(0.05);
			continue;
		}
		if(player.score < level.trial_cost)
		{
			player playSound("no_cha_ching"); // no idea if this sound exists, or if this function is right
			wait(0.05);
			continue;
		}

		player zm_score::minus_to_player_score(level.trial_cost);
		level.is_in_team_challenge = true;
		thread divinium_trial_think();
	}
}

function divinium_trial_think()
{
	index = RandomIntRange(0, level.divinium_trial_funcs.size);

	challengeFunc = level.divinium_trial_funcs[index];
	wait(0.05);

	thread [[challengeFunc]]();

	trial_time = TRIAL_BASE_TIME;
	if(challengeFunc == &wallbuy_challenge_hub || challengeFunc == &box_challenge_hub)
	{
		trial_time = TRIAL_EXTENDED_TIME;
	}

	for(i = 0; i < trial_time; i++)
	{
		if(i % 20 == 0)
		{
			seconds_left = Int((trial_time - i) / 20);
			players = GetPlayers();
			for(j = 0; j < players.size; j++)
			{
				players[j] clientfield::set_player_uimodel("trialTimer", 1);
			}
			//IPrintLn("time left: " + seconds_left);
		}
		else
		{
			for(j = 0; j < players.size; j++)
			{
				players[j] clientfield::set_player_uimodel("trialTimer", 3);
			}
		}
		wait(0.05);
	}

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] clientfield::set_player_uimodel("trialName", 0);
		players[i] clientfield::set_player_uimodel("trialTimer", 0);
	}

	level notify(#"team_challenge_completed");
	level.is_in_team_challenge = false;

	wait(0.05);
}

function headshot_challenge_hub()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] clientfield::set_player_uimodel("trialName", HEADSHOTS_OFFSET);
		players[i] thread headshot_challenge();
	}
}

function headshot_challenge()
{
	self endon("disconnect");

	self thread zm_abbey_inventory::notifyText("splash_trial_headshot", level.open_inventory_prompt, level.abbey_alert_neutral);
	//self.solo_challenge_text = "Kill " + zombies_for_challenge + " zombies with headshots";

	headshots = 0;
	prev_headshots = self.pers["headshots"];
	while(level.is_in_team_challenge)
	{
		headshots = self.pers["headshots"] - prev_headshots;
		prev_headshots = self.pers["headshots"];
		self.trial_progress = Min(self.trial_progress + (headshots * TRIAL_KILL_INCREMENT), TRIAL_GOAL);

		//IPrintLn(headshots);
		wait(0.05);
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

function room_time_challenge_hub()
{
	rooms = GetArrayKeys(level.one_room_challenge_rooms);

	room_index = RandomIntRange(0, rooms.size);

	for(i = 0; i < rooms.size; i++)
	{
		room_index = (room_index + i) % rooms.size;
		
		level.challenge_room = rooms[room_index];
		level.challenge_room_zone = level.one_room_challenge_rooms[level.challenge_room];

		if( zm_room_manager::is_room_active(level.challenge_room_zone) )
		{
			break;
		}
	}

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] clientfield::set_player_uimodel("trialName", ROOM_TIME_OFFSET + level.one_room_challenge_rooms_indices[level.challenge_room]);
		players[i] thread room_time_challenge();
	}
}

function room_time_challenge()
{
	self endon("disconnect");

	self thread zm_abbey_inventory::notifyText( "splash_trial_area_defense", level.open_inventory_prompt, level.abbey_alert_neutral );

	while(level.is_in_team_challenge)
	{
		if(self is_player_in_room(level.challenge_room_zone))
		{
			self.trial_progress = Min(self.trial_progress + TRIAL_AREA_INCREMENT, TRIAL_GOAL);
		}
		wait(0.05);
	}
}

function room_kills_challenge_hub()
{
	rooms = GetArrayKeys(level.one_room_challenge_rooms);

	room_index = RandomIntRange(0, rooms.size);

	for(i = 0; i < rooms.size; i++)
	{
		room_index = (room_index + i) % rooms.size;
		
		level.challenge_room = rooms[room_index];
		level.challenge_room_zone = level.one_room_challenge_rooms[level.challenge_room];

		if( zm_room_manager::is_room_active(level.challenge_room_zone) )
		{
			break;
		}
	}

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] clientfield::set_player_uimodel("trialName", ROOM_KILLS_OFFSET + level.one_room_challenge_rooms_indices[level.challenge_room]);
		players[i] thread room_kills_challenge();
	}
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
		if(self is_player_in_room(level.challenge_room_zone))
		{
			self.trial_progress = Min(self.trial_progress + TRIAL_KILL_INCREMENT, TRIAL_GOAL);
		}
	}
}

function get_num_players_in_room(zoneset)
{
	num = 0;
	for(i = 0; i < zoneset.size; i++)
	{
		num += zm_zonemgr::get_players_in_zone( zoneset[i] );
	}
	return num;
}

function is_player_in_room(zoneset)
{
	self endon("disconnect");

	for(i = 0; i < zoneset.size; i++)
	{
		if( self zm_zonemgr::entity_in_zone(zoneset[i]) )
		{
			return true;
		}
	}
	return false;
}

function class_challenge_hub()
{
	class_index = RandomIntRange(0, level.team_challenge_classes.size);
	level.class_challenge_class = level.team_challenge_classes[class_index];

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] clientfield::set_player_uimodel("trialName", CLASSES_OFFSET + class_index);
		players[i] thread class_challenge();
	}
}

function class_challenge()
{
	self endon("disconnect");

	self thread zm_abbey_inventory::notifyText( "splash_trial_weapon_class", level.open_inventory_prompt, level.abbey_alert_neutral );

	self thread class_challenge_kill_monitor();

	while(level.is_in_team_challenge)
	{
		wait(0.05);
	}

	self notify(#"class_challenge_finished");
}

function class_challenge_kill_monitor()
{
	self endon("disconnect");
	self endon(#"class_challenge_finished");

	while(true)
	{
		self waittill(#"potential_challenge_kill", origin);
		weapon = self GetCurrentWeapon();
		if(weapon.weapclass == level.class_challenge_class)
		{
			self.trial_progress = Min(self.trial_progress + TRIAL_KILL_INCREMENT, TRIAL_GOAL);
		}
		wait(0.05);
	}
}

function elevation_challenge_hub()
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] clientfield::set_player_uimodel("trialName", ELEVATION_OFFSET);
		players[i] thread elevation_challenge();
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

function testeroo() 
{
	level waittill("all_players_connected");
	while(true)
	{
		IPrintLn("challenge_kills1: " + level.challenge_kills1_progress);
		IPrintLn("challenge_kills2: " + level.challenge_kills2_progress);
		IPrintLn("challenge_kills3: " + level.challenge_kills3_progress);
		wait(2);
	}
}

function testerootoo()
{
	self endon("disconnect");

	//self thread testerootree();
	while(true)
	{
		IPrintLn(self.trial_progress);
		wait(1);
	}
}

function testerootree()
{
	self endon("disconnect");

	while(true)
	{
		self waittill(#"potential_challenge_kill", origin);
		IPrintLn("Height difference: " + (self.origin[2] - origin[2]));
	}
}