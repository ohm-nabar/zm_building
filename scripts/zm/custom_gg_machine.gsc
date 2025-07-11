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
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_perks;

#using scripts\shared\system_shared;

#using scripts\zm\zm_bgb_custom_util;
#using scripts\zm\zm_challenges;

#define BRIBE_MAX 3
#define BRIBE_MAX_PLAYER 3
#define BRIBE_WAIT 3
#define BRIBE_OFFSET 3.25

#define EATEN_CF_NEUTRAL 0

#precache( "model", "gumball_blue");
#precache( "model", "gumball_green");
#precache( "model", "gumball_orange");
#precache( "model", "gumball_purple");
#precache( "model", "gumball_white");

#precache( "fx", "custom/fx_trail_blood_soul_zmb" );
#precache( "eventstring", "GGReset" );

#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_GREEN", "ZMUI_BGB_STOCK_OPTION" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_GREEN", "ZMUI_BGB_SWORD_FLAY" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BLUE", "ZMUI_BGB_TEMPORAL_GIFT" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_PURPLE", "ZMUI_BGB_IN_PLAIN_SIGHT" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_PURPLE", "ZMUI_BGB_IM_FEELIN_LUCKY" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_PURPLE", "ZMUI_BGB_IMMOLATION_LIQUIDATION" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BLUE", "ZMUI_BGB_HEAD_DRAMA" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_PURPLE", "ZMUI_BGB_PHOENIX_UP" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_ORANGE", "ZMUI_BGB_POP_SHOCKS" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_PURPLE", "ZMUI_BGB_ON_THE_HOUSE" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_PURPLE", "ZMUI_BGB_EXTRA_CREDIT" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_GREEN", "ZMUI_BGB_PROFIT_SHARING" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_ORANGE", "ZMUI_BGB_FLAVOR_HEXED" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_ORANGE", "ZMUI_BGB_UNQUENCHABLE" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_PURPLE", "ZMUI_BGB_ALCHEMICAL_ANTITHESIS" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_ORANGE", "ZMUI_BGB_CRATE_POWER" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BLUE", "ZMUI_BGB_AFTERTASTE_BLOOD" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_PURPLE", "ZMUI_BGB_CHALLENGE_REJECTED" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_ORANGE", "ZMUI_BGB_PERKAHOLIC" );

#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_GREEN", "ZMUI_BGB_STOCK_OPTION" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_GREEN", "ZMUI_BGB_SWORD_FLAY" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_BLUE", "ZMUI_BGB_TEMPORAL_GIFT" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_PURPLE", "ZMUI_BGB_IN_PLAIN_SIGHT" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_PURPLE", "ZMUI_BGB_IM_FEELIN_LUCKY" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_PURPLE", "ZMUI_BGB_IMMOLATION_LIQUIDATION" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_BLUE", "ZMUI_BGB_HEAD_DRAMA" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_PURPLE", "ZMUI_BGB_PHOENIX_UP" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_ORANGE", "ZMUI_BGB_POP_SHOCKS" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_PURPLE", "ZMUI_BGB_ON_THE_HOUSE" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_PURPLE", "ZMUI_BGB_EXTRA_CREDIT" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_GREEN", "ZMUI_BGB_PROFIT_SHARING" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_ORANGE", "ZMUI_BGB_FLAVOR_HEXED" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_ORANGE", "ZMUI_BGB_UNQUENCHABLE" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_PURPLE", "ZMUI_BGB_ALCHEMICAL_ANTITHESIS" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_ORANGE", "ZMUI_BGB_CRATE_POWER" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_BLUE", "ZMUI_BGB_AFTERTASTE_BLOOD" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_PURPLE", "ZMUI_BGB_CHALLENGE_REJECTED" );

#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_GREEN", "ZMUI_BGB_STOCK_OPTION", "1" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_GREEN", "ZMUI_BGB_SWORD_FLAY", "1" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_BLUE", "ZMUI_BGB_TEMPORAL_GIFT", "1" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_PURPLE", "ZMUI_BGB_IN_PLAIN_SIGHT", "1" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_PURPLE", "ZMUI_BGB_IM_FEELIN_LUCKY", "1" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_PURPLE", "ZMUI_BGB_IMMOLATION_LIQUIDATION", "2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_BLUE", "ZMUI_BGB_HEAD_DRAMA", "3" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_PURPLE", "ZMUI_BGB_PHOENIX_UP", "3" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_ORANGE", "ZMUI_BGB_POP_SHOCKS", "2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_PURPLE", "ZMUI_BGB_ON_THE_HOUSE", "3" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_PURPLE", "ZMUI_BGB_EXTRA_CREDIT", "2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_GREEN", "ZMUI_BGB_PROFIT_SHARING", "2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_ORANGE", "ZMUI_BGB_FLAVOR_HEXED", "2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_ORANGE", "ZMUI_BGB_UNQUENCHABLE", "3" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_PURPLE", "ZMUI_BGB_ALCHEMICAL_ANTITHESIS", "3" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_ORANGE", "ZMUI_BGB_CRATE_POWER", "2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_BLUE", "ZMUI_BGB_AFTERTASTE_BLOOD", "2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_PURPLE", "ZMUI_BGB_CHALLENGE_REJECTED", "2" );

#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS0" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS1" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS3" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS4" );

#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE1" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE3" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE4" );

#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS0" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS1" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS3" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS4" );

#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE1" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE3" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE4" );

#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_DART0" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_DART1" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_DART2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_DART3" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_DART4" );

#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE1" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE3" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE4" );

#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS0" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS1" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS3" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS4" );

#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE1" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE2" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE3" );
#precache( "triggerstring", "ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE4" );

#namespace custom_gg_machine;

REGISTER_SYSTEM( "custom_gg_machine", &__init__, undefined )

function __init__() 
{
	clientfield::register( "clientuimodel", "bribeCount", VERSION_SHIP, 2, "int" );

	level.gg_all = array("zm_bgb_stock_option", "zm_bgb_sword_flay", "zm_bgb_temporal_gift", "zm_bgb_in_plain_sight", "zm_bgb_im_feelin_lucky", "zm_bgb_immolation_liquidation", "zm_bgb_phoenix_up", "zm_bgb_pop_shocks", "zm_bgb_challenge_rejected", "zm_bgb_on_the_house", "zm_bgb_profit_sharing", "zm_bgb_flavor_hexed", "zm_bgb_crate_power", "zm_bgb_unquenchable", "zm_bgb_alchemical_antithesis", "zm_bgb_extra_credit", "zm_bgb_head_drama", "zm_bgb_aftertaste_blood", "zm_bgb_perkaholic");

	level.gg_names = [];
	level.gg_names["zm_bgb_stock_option"] = &"ZMUI_BGB_STOCK_OPTION";
	level.gg_names["zm_bgb_sword_flay"] = &"ZMUI_BGB_SWORD_FLAY";
	level.gg_names["zm_bgb_temporal_gift"] = &"ZMUI_BGB_TEMPORAL_GIFT";
	level.gg_names["zm_bgb_in_plain_sight"] = &"ZMUI_BGB_IN_PLAIN_SIGHT";
	level.gg_names["zm_bgb_im_feelin_lucky"] = &"ZMUI_BGB_IM_FEELIN_LUCKY";
	level.gg_names["zm_bgb_immolation_liquidation"] = &"ZMUI_BGB_IMMOLATION_LIQUIDATION";
	level.gg_names["zm_bgb_phoenix_up"] = &"ZMUI_BGB_PHOENIX_UP";
	level.gg_names["zm_bgb_pop_shocks"] = &"ZMUI_BGB_POP_SHOCKS";
	level.gg_names["zm_bgb_challenge_rejected"] = &"ZMUI_BGB_CHALLENGE_REJECTED";
	level.gg_names["zm_bgb_on_the_house"] = &"ZMUI_BGB_ON_THE_HOUSE";
	level.gg_names["zm_bgb_profit_sharing"] = &"ZMUI_BGB_PROFIT_SHARING";
	level.gg_names["zm_bgb_flavor_hexed"] = &"ZMUI_BGB_FLAVOR_HEXED";
	level.gg_names["zm_bgb_crate_power"] = &"ZMUI_BGB_CRATE_POWER";
	level.gg_names["zm_bgb_unquenchable"] = &"ZMUI_BGB_UNQUENCHABLE";
	level.gg_names["zm_bgb_alchemical_antithesis"] = &"ZMUI_BGB_ALCHEMICAL_ANTITHESIS";
	level.gg_names["zm_bgb_extra_credit"] = &"ZMUI_BGB_EXTRA_CREDIT";
	level.gg_names["zm_bgb_head_drama"] = &"ZMUI_BGB_HEAD_DRAMA";
	level.gg_names["zm_bgb_aftertaste_blood"] = &"ZMUI_BGB_AFTERTASTE_BLOOD";
	level.gg_names["zm_bgb_perkaholic"] = &"ZMUI_BGB_PERKAHOLIC";

	level.gg_hintstrings = [];
	level.gg_hintstrings["purple"] = &"ZM_ABBEY_TRIAL_HINTSTRING_PURPLE";
	level.gg_hintstrings["blue"] = &"ZM_ABBEY_TRIAL_HINTSTRING_BLUE";
	level.gg_hintstrings["orange"] = &"ZM_ABBEY_TRIAL_HINTSTRING_ORANGE";
	level.gg_hintstrings["green"] = &"ZM_ABBEY_TRIAL_HINTSTRING_GREEN";

	level.gg_hintstrings_unavailable = [];
	level.gg_hintstrings_unavailable["purple"] = &"ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_PURPLE";
	level.gg_hintstrings_unavailable["blue"] = &"ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_BLUE";
	level.gg_hintstrings_unavailable["orange"] = &"ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_ORANGE";
	level.gg_hintstrings_unavailable["green"] = &"ZM_ABBEY_TRIAL_HINTSTRING_UNAVAILABLE_GREEN";

	level.gg_hintstrings_bribe = [];
	level.gg_hintstrings_bribe["purple"] = &"ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_PURPLE";
	level.gg_hintstrings_bribe["blue"] = &"ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_BLUE";
	level.gg_hintstrings_bribe["orange"] = &"ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_ORANGE";
	level.gg_hintstrings_bribe["green"] = &"ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_GREEN";

	level.gg_notifs = [];
	for(i = 0; i < level.gg_all.size; i++)
	{
		level.gg_notifs[ level.gg_all[i] ] = i;
	}

	aramis_dialogue = array(&"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS0", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS1", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS2", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS3", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS4");
	porthos_dialogue = array(&"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS0", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS1", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS2", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS3", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS4");
	dart_dialogue = array(&"ZM_ABBEY_TRIAL_DIALOGUE_DART0", &"ZM_ABBEY_TRIAL_DIALOGUE_DART1", &"ZM_ABBEY_TRIAL_DIALOGUE_DART2", &"ZM_ABBEY_TRIAL_DIALOGUE_DART3", &"ZM_ABBEY_TRIAL_DIALOGUE_DART4");
	athos_dialogue = array(&"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS0", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS1", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS2", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS3", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS4");

	aramis_dialogue_bribe = array(&"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE1", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE2", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE3", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE4");
	porthos_dialogue_bribe = array(&"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE1", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE2", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE3", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE4");
	dart_dialogue_bribe = array(&"ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE1", &"ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE2", &"ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE3", &"ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE4");
	athos_dialogue_bribe = array(&"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE1", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE2", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE3", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE4");

	level.gargoyle_dialogue = array(aramis_dialogue, porthos_dialogue, dart_dialogue, athos_dialogue);
	level.gargoyle_dialogue_bribe = array(aramis_dialogue_bribe, porthos_dialogue_bribe, dart_dialogue_bribe, athos_dialogue_bribe);

	level.judge_gumballs = [];
	for(i = 0; i < 4; i++)
	{
		gumballs = GetEntArray("gumball" + i, "targetname");
		models = GetEntArray("gargoyle" + i, "targetname");
		level.judge_gumballs[i] = gumballs;
		level array::thread_all(gumballs, &judge_gumball_fx, i);
		level array::thread_all(models, &judge_model_think, i);
	}

	level.gargoyle_bribes_active = [];
	level.gargoyle_first_bribe_taken = false;

	level.gargoyle_judges = GetEntArray("gargoyle_judge", "targetname");
	level array::thread_all(level.gargoyle_judges, &judge_think);

	level.gargoyle_judges_dialogue = GetEntArray("gargoyle_judge_dialogue", "targetname");

	level.gargoyle_bribes = GetEntArray("abbey_bribe", "targetname");
	level array::thread_all(level.gargoyle_bribes, &bribe_think);

	level thread bribe_manager();

	level callback::on_connect( &on_player_connect );
}

function on_player_connect()
{
	self.gg_available = [];
	foreach(gum in level.gg_all)
	{
		self.gg_available[gum] = false;
	}

	self.judge_indices = [];
	self.judge_dialogue = [];
	for(i = 0; i < 4; i++)
	{
		self.judge_indices[i] = 0;
		self.judge_dialogue[i] = level.gargoyle_dialogue[i][0];
		self thread judge_dialogue_update(i);
		level array::thread_all(level.judge_gumballs[i], &judge_display_ball_think, i, self);
	}

	self.bribe_count = 0;
	self.eating_gum = false;

	level array::thread_all(level.gargoyle_judges, &judge_hintstring_think, self);
	level array::thread_all(level.gargoyle_judges_dialogue, &judge_dialogue_think, self);
	level array::thread_all(level.gargoyle_bribes, &bribe_hintstring_think, self);
}

function judge_dialogue_update(garg_num)
{
	self endon("disconnect");

	num_trials_completed = 0;
	num_bribes_given = 0;
	trial_indices = array(0, 1, 2, 2, 3);

	while(true)
	{
		result = self util::waittill_any_return("trial_complete" + garg_num, "bribe_given" + garg_num);
		if(result == "trial_complete" + garg_num)
		{
			num_trials_completed += 1;
			trial_index = Int(Min(num_trials_completed, 4));
			self.judge_dialogue[garg_num] = level.gargoyle_dialogue[garg_num][trial_index];
		}
		else
		{
			num_bribes_given += 1;
			bribe_index = Int(Min((num_bribes_given - 1), 3));
			self.judge_dialogue[garg_num] = level.gargoyle_dialogue_bribe[garg_num][bribe_index];
		}
	}
}

function judge_display_ball_think(garg_num, player)
{
	player endon("disconnect");

	while(! isdefined(player.gargoyle_gums))
	{
		wait(0.05);
	}

	notif = "judge_display_update" + garg_num;
	display_ball = undefined;
	while(true)
	{
		index = player.judge_indices[garg_num];
		gum = player.gargoyle_gums[garg_num][index];
		gum_struct = zm_bgb_custom_util::lookup_gobblegum(gum);

		if(isdefined(display_ball))
		{
			display_ball Delete();
		}

		display_ball = player zm_bgb_custom_util::create_gg_model_for_player(gum_struct, self.origin, self.angles);
		display_ball thread display_ball_cleanup(player);
		player waittill(notif);
	}
}

function display_ball_cleanup(player)
{
	self endon("delete");

	player waittill("disconnect");
	self Delete();
}

function judge_hintstring_think(player)
{
	player endon("disconnect");

	garg_num = self.script_int;
	gum_weapon = GetWeapon("zombie_bgb_grab");

	prev_displayName = &"ZM_ABBEY_EMPTY";
	prev_gg_available = false;
	prev_bribe_count = -1;
	prev_eating = false;

	while(true)
	{
		index = player.judge_indices[garg_num];
		gum = player.gargoyle_gums[garg_num][index];
		displayName = level.gg_names[gum];
		gg_available = player.gg_available[gum];
		bribe_count = player.bribe_count;
		eating = player.eating_gum; 

		// failsafe for a weird case where a perkaholic triggerstring registered for a moment
		if(displayName == &"ZMUI_BGB_PERKAHOLIC")
		{
			displayName = &"ZMUI_BGB_STOCK_OPTION";
		}


		if(eating)
		{
			if(! prev_eating)
			{
				self SetHintStringForPlayer(player, player.judge_dialogue[garg_num]);
			}
		}
		else if(prev_eating || displayName != prev_displayName || gg_available != prev_gg_available || bribe_count != prev_bribe_count)
		{
			prev_displayName = displayName;
			prev_gg_available = gg_available;
			prev_bribe_count = bribe_count;
			bribe_cost = level zm_bgb_custom_util::gg_bribe_cost(gum);
			color = level zm_bgb_custom_util::gg_color_value(gum);
			if(gg_available)
			{
				hintstring = level.gg_hintstrings[color];
				self SetHintStringForPlayer(player, hintstring, displayName);
			}
			else if(bribe_count >= bribe_cost)
			{
				hintstring = level.gg_hintstrings_bribe[color];
				self SetHintStringForPlayer(player, hintstring, displayName, bribe_cost);
			}
			else
			{
				hintstring = level.gg_hintstrings_unavailable[color];
				self SetHintStringForPlayer(player, hintstring, displayName);
			}
		}
		prev_eating = eating;
		wait(0.05);
	}
}

function judge_dialogue_think(player)
{
	player endon("disconnect");

	self SetCursorHint("HINT_NOICON");

	garg_num = self.script_int;

	prev_dialogue = &"ZM_ABBEY_EMPTY";

	while(true)
	{
		dialogue = player.judge_dialogue[garg_num];
		if(dialogue != prev_dialogue)
		{
			prev_dialogue = dialogue;
			self SetHintStringForPlayer(player, dialogue);
		}
		wait(0.05);
	}
}

// logic for gum machines
function judge_think() 
{
	self SetCursorHint( "HINT_NOICON" );

	garg_num = self.script_int;
	while(true) {
		self waittill("trigger", player);

		index = player.judge_indices[garg_num];
		gum = player.gargoyle_gums[garg_num][index];
		gg_available = player.gg_available[gum];
		bribe_cost = zm_bgb_custom_util::gg_bribe_cost(gum);
		if(! (zm_utility::is_player_valid(player)) || ! zm_perks::vending_trigger_can_player_use(player) || (! gg_available && player.bribe_count < bribe_cost))
		{
			wait(0.05);
			continue;
		}

		player zm_audio::create_and_play_dialog("bgb", "buy");

		gum_struct = zm_bgb_custom_util::lookup_gobblegum(gum);
		player thread zm_bgb_custom_util::give_gobblegum(gum_struct);
		player.eating_gum = true;

		if(gg_available)
		{	
			player.gg_available[gum] = false;

			if(! player.gg_available[gum])
			{
				rand_cf = level.gargoyle_cfs[garg_num] + "Random";
				cf_val = index + 5;
				player thread zm_challenges::lua_toggle_gum_vis(rand_cf, cf_val);
			}
		}
		else
		{
			player.bribe_count -= bribe_cost;
			player notify("bribe_given" + garg_num);
			player thread lua_decrement_bribe_count();
		}

		wait(0.05);
	}
}

function lua_decrement_bribe_count()
{
	self endon("disconnect");

	while(self clientfield::get_player_uimodel("bribeCount") != self.bribe_count)
	{
		self clientfield::set_player_uimodel("bribeCount", self.bribe_count);
		util::wait_network_frame();
	}
}

function judge_gumball_fx(garg_num)
{
	self SetInvisibleToAll();
		
	tag_origin = Spawn("script_model", self.origin);
	tag_origin SetModel("tag_origin");
	PlayFXOnTag("custom/fx_trail_blood_soul_zmb", tag_origin, "tag_origin");
}

function judge_model_think(garg_num)
{
	self SetCanDamage(true);
	while(true)
	{
		self waittill("damage", n_damage, e_attacker, v_dir, v_loc, str_type, STR_MODEL, str_tag, str_part, w_weapon);
		if(IsPlayer(e_attacker) && str_type == "MOD_MELEE")
		{	
			e_attacker.judge_indices[garg_num] = (e_attacker.judge_indices[garg_num] + 1) % e_attacker.gargoyle_gums[garg_num].size;
			notif = "judge_display_update" + garg_num;
			e_attacker notify(notif);
		}
	}
}

function bribe_hintstring_think(player)
{
	player endon("disconnect");

	prev_bribe_active = true;
	prev_max_bribes = true;

	while(true)
	{
		bribe_active = level array::contains(level.gargoyle_bribes_active, self) || (! level.gargoyle_first_bribe_taken && self.target == "bribe1_model");
		max_bribes = player.bribe_count >= 3;

		if(bribe_active != prev_bribe_active || max_bribes != prev_max_bribes)
		{
			prev_bribe_active = bribe_active;
			prev_max_bribes = max_bribes;
			if(! bribe_active)
			{
				self SetHintStringForPlayer(player, &"ZM_ABBEY_EMPTY");
			}
			else if(max_bribes)
			{
				self SetHintStringForPlayer(player, &"ZM_ABBEY_TRIAL_BRIBE_PICKUP_MAX");
			}
			else
			{
				self SetHintStringForPlayer(player, &"ZM_ABBEY_TRIAL_BRIBE_PICKUP");
			}
		}
		wait(0.05);
	}
}

function bribe_think()
{
	model = GetEnt(self.target, "targetname");
	fx_spot = Spawn("script_model", model.origin + (0, 0, BRIBE_OFFSET));
	active = true;
	self SetCursorHint("HINT_NOICON");

	while(true)
	{
		if(level array::contains(level.gargoyle_bribes_active, self) || (! level.gargoyle_first_bribe_taken && self.target == "bribe1_model"))
		{ 
			active = true;
			model SetVisibleToAll();
			fx_spot = Spawn("script_model", model.origin + (0, 0, BRIBE_OFFSET));
			fx_spot SetModel("tag_origin");
			PlayFXOnTag("custom/pistol_glint", fx_spot, "tag_origin");

			self waittill("trigger", player);
			while(player.bribe_count >= BRIBE_MAX_PLAYER)
			{
				self waittill("trigger", player);
			}
			if(level.gargoyle_first_bribe_taken)
			{
				ArrayRemoveValue(level.gargoyle_bribes_active, self);
			}
			level.gargoyle_first_bribe_taken = true;
			player PlaySound("zmb_buildable_pickup");
			player.bribe_count += 1;
			player clientfield::set_player_uimodel("bribeCount", player.bribe_count);
		}
		else if(active)
		{
			active = false;
			model SetInvisibleToAll();
			fx_spot Delete();
		}
		wait(0.05);
	}
}

function bribe_manager()
{
	while(! level.gargoyle_first_bribe_taken)
	{
		wait(0.05);
	}

	while(true)
	{
		for(i = 0; i < BRIBE_WAIT; i++)
		{
			level waittill("start_of_round");
		}

		if(level.gargoyle_bribes_active.size < BRIBE_MAX)
		{
			available_bribes = level array::filter(level.gargoyle_bribes, false, &bribe_filter);
			level array::add(level.gargoyle_bribes_active, level array::random(available_bribes));
		}
	}
}

function bribe_filter(val)
{
	return ! level array::contains(level.gargoyle_bribes_active, val);
}