#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;

#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_perks;

#using scripts\shared\system_shared;

#using scripts\zm\zm_bgb_custom_util;
#using scripts\zm\zm_challenges;

#using scripts\Sphynx\_zm_sphynx_util;

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
		gumballs = struct::get_array("gumball" + i, "targetname");
		models = GetEntArray("gargoyle" + i, "targetname");
		level.judge_gumballs[i] = gumballs;
		level array::thread_all(models, &judge_model_think, i);
	}

	level.gargoyle_bribes_active = [];
	level.gargoyle_first_bribe_taken = false;

	gargoyle_judges = struct::get_array("gargoyle_judge", "targetname");
	level array::thread_all(gargoyle_judges, &judge_think);

	gargoyle_judges_dialogue = struct::get_array("gargoyle_judge_dialogue", "targetname");
	level array::thread_all(gargoyle_judges_dialogue, &zm_sphynx_util::create_unitrigger_for_player_specific, &"ZM_ABBEY_EMPTY", 113, &judge_dialogue_prompt_and_visibility);

	level.gargoyle_bribes = struct::get_array("abbey_bribe", "targetname");
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
		self.smallest_gumballs = [];
		self thread find_closest_gumball(i, level.judge_gumballs[i]);
		self thread judge_display_ball_think(i);
	}

	self.bribe_count = 0;
	self.eating_gum = false;
}

function find_closest_gumball(garg_num, gumballs)
{
	self endon("disconnect");

	while(! (level flag::exists("initial_blackscreen_passed") && level flag::get("initial_blackscreen_passed")))
	{
		wait(0.05);
	}

	smallest_gumball = undefined;
	prev_smallest_gumball = undefined;
	while(true)
	{
		smallest_dist = undefined;
		foreach(gumball in gumballs)
		{
			dist = DistanceSquared(gumball.origin, self.origin);
			if(! isdefined(smallest_dist) || dist < smallest_dist)
			{
				smallest_dist = dist;
				smallest_gumball = gumball;
			}
		}

		self.smallest_gumballs[garg_num] = smallest_gumball;

		wait(0.05);
	}
}

function judge_display_ball_think(garg_num)
{
	self endon("disconnect");

	while(! (level flag::exists("initial_blackscreen_passed") && level flag::get("initial_blackscreen_passed")))
	{
		wait(0.05);
	}

	notif = "judge_display_update" + garg_num;
	display_ball = undefined;
	while(true)
	{
		index = self.judge_indices[garg_num];
		gum = self.gargoyle_gums[garg_num][index];
		gum_struct = level zm_bgb_custom_util::lookup_gobblegum(gum);

		if(isdefined(display_ball))
		{
			display_ball Delete();
		}

		display_ball = self zm_bgb_custom_util::create_gg_model_for_player(gum_struct, (0, 0, 0), (0, 0, 0));

		display_ball thread display_ball_cleanup(self);
		display_ball thread display_ball_move(garg_num, self);
		self waittill(notif);
	}
}

function display_ball_move(garg_num, player)
{
	player endon("disconnect");

	garg_names = [];
	garg_names[0] = "Aramis";
	garg_names[1] = "Porthos";
	garg_names[2] = "Dart";
	garg_names[3] = "Athos";

	garg_name = garg_names[garg_num];

	prev_smallest_gumball = undefined;
	while(isdefined(self))
	{
		smallest_gumball = player.smallest_gumballs[garg_num];
		if(! isdefined(prev_smallest_gumball) || smallest_gumball != prev_smallest_gumball)
		{
			if(isdefined(smallest_gumball))
			{
				prev_smallest_gumball = smallest_gumball;
				self.origin = smallest_gumball.origin;
				self.angles = smallest_gumball.angles;
			}
		}
		wait(0.05);
	}
}

function display_ball_cleanup(player)
{
	while(isdefined(self))
	{
		if(! isdefined(player))
		{
			self Delete();
		}
		wait(0.05);
	}
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

function judge_dialogue_prompt_and_visibility(player)
{
	garg_num = self.stub.related_parent.script_int;
	self SetHintString(player.judge_dialogue[garg_num]);
	return false;
}

function judge_prompt_and_visibility(player)
{
	garg_num = self.stub.related_parent.script_int;
	index = player.judge_indices[garg_num];
	gum = player.gargoyle_gums[garg_num][index];
	display_name = level.gg_names[gum];
	color = level zm_bgb_custom_util::gg_color_value(gum);
	bribe_cost = level zm_bgb_custom_util::gg_bribe_cost(gum);

	if(player.eating_gum)
	{
		self SetHintString(player.judge_dialogue[garg_num]);
		return false;
	}
	if(! player zm_magicbox::can_buy_weapon())
	{
		self SetHintString(&"ZM_ABBEY_EMPTY");
		return false;
	}
	if(player.gg_available[gum])
	{
		self SetHintString(level.gg_hintstrings[color], display_name);
		return true;
	}
	if(player.bribe_count >= bribe_cost)
	{
		self SetHintString(level.gg_hintstrings_bribe[color], display_name, bribe_cost);
		return true;
	}

	self SetHintString(level.gg_hintstrings_unavailable[color], display_name);
	return false;
}

// logic for gum machines
function judge_think() 
{
	self zm_sphynx_util::create_unitrigger_for_player_specific(&"ZM_ABBEY_EMPTY", undefined, &judge_prompt_and_visibility);

	garg_num = self.script_int;
	while(true) {
		self waittill("trigger_activated", player);

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

function bribe_prompt_and_visibility(player)
{
	struct = self.stub.related_parent;
	bribe_active = level array::contains(level.gargoyle_bribes_active, struct) || (! level.gargoyle_first_bribe_taken && struct.target == "bribe1_model");

	if(! (bribe_active && player zm_magicbox::can_buy_weapon()))
	{
		self SetHintString(&"ZM_ABBEY_EMPTY");
		return false;
	}
	else if(player.bribe_count >= BRIBE_MAX)
	{
		self SetHintString(&"ZM_ABBEY_TRIAL_BRIBE_PICKUP_MAX");
		return false;
	}
	
	self SetHintString(&"ZM_ABBEY_TRIAL_BRIBE_PICKUP");
	return true;
}

function bribe_think()
{
	model = GetEnt(self.target, "targetname");
	fx_spot = undefined;
	self.active = true;
	self zm_sphynx_util::create_unitrigger_for_player_specific(&"ZM_ABBEY_EMPTY", undefined, &bribe_prompt_and_visibility);

	while(true)
	{
		if(level array::contains(level.gargoyle_bribes_active, self) || (! level.gargoyle_first_bribe_taken && self.target == "bribe1_model"))
		{ 
			self.active = true;
			model SetVisibleToAll();
			fx_spot = Spawn("script_model", model.origin + (0, 0, BRIBE_OFFSET));
			fx_spot SetModel("tag_origin");
			PlayFXOnTag("custom/pistol_glint", fx_spot, "tag_origin");

			self waittill("trigger_activated", player);
			if(level.gargoyle_first_bribe_taken)
			{
				ArrayRemoveValue(level.gargoyle_bribes_active, self);
			}
			level.gargoyle_first_bribe_taken = true;
			player PlaySound("zmb_buildable_pickup");
			player.bribe_count += 1;
			player clientfield::set_player_uimodel("bribeCount", player.bribe_count);
		}
		else if(self.active)
		{
			self.active = false;
			model SetInvisibleToAll();
			if(isdefined(fx_spot))
			{
				fx_spot Delete();
			}
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