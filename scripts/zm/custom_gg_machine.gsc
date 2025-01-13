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

#precache( "string", "ZMUI_BGB_SELECT" );
#precache( "string", "ZMUI_BGB_ACCEPT" );
#precache( "string", "ZMUI_BGB_NO_STOCK" );
#precache( "string", "ZMUI_BGB_ACTIVATE" );
#precache( "string", "ZMUI_BGB_NEXT_ROUND" );

#precache( "string", "ZMUI_BGB_STOCK_OPTION" );
#precache( "string", "ZMUI_BGB_SWORD_FLAY" );
#precache( "string", "ZMUI_BGB_TEMPORAL_GIFT" );
#precache( "string", "ZMUI_BGB_IN_PLAIN_SIGHT" );
#precache( "string", "ZMUI_BGB_IM_FEELIN_LUCKY" );
#precache( "string", "ZMUI_BGB_IMMOLATION_LIQUIDATION" );
#precache( "string", "ZMUI_BGB_PHOENIX_UP" );
#precache( "string", "ZMUI_BGB_POP_SHOCKS" );
#precache( "string", "ZMUI_BGB_ON_THE_HOUSE" );
#precache( "string", "ZMUI_BGB_PROFIT_SHARING" );
#precache( "string", "ZMUI_BGB_FLAVOR_HEXED" );
#precache( "string", "ZMUI_BGB_UNQUENCHABLE" );
#precache( "string", "ZMUI_BGB_ALCHEMICAL_ANTITHESIS" );
#precache( "string", "ZMUI_BGB_AFTERTASTE_BLOOD" );
#precache( "string", "ZMUI_BGB_CHALLENGE_REJECTED" );
#precache( "string", "ZMUI_BGB_PERKAHOLIC" );

#namespace custom_gg_machine;

REGISTER_SYSTEM( "custom_gg_machine", &__init__, undefined )

function __init__() 
{
	clientfield::register( "clientuimodel", "gumEaten", VERSION_SHIP, 5, "int" );
	clientfield::register( "clientuimodel", "bribeCount", VERSION_SHIP, 2, "int" );

	level.gg_all = array("zm_bgb_stock_option", "zm_bgb_sword_flay", "zm_bgb_temporal_gift", "zm_bgb_in_plain_sight", "zm_bgb_im_feelin_lucky", "zm_bgb_immolation_liquidation", "zm_bgb_phoenix_up", "zm_bgb_pop_shocks", "zm_bgb_challenge_rejected", "zm_bgb_on_the_house", "zm_bgb_profit_sharing", "zm_bgb_flavor_hexed", "zm_bgb_crate_power", "zm_bgb_unquenchable", "zm_bgb_alchemical_antithesis", "zm_bgb_extra_credit", "zm_bgb_head_drama", "zm_bgb_aftertaste_blood", "zm_bgb_perkaholic");

	level.gg_names = [];
	level.gg_names["zm_bgb_stock_option"] = MakeLocalizedString(&"ZMUI_BGB_STOCK_OPTION");
	level.gg_names["zm_bgb_sword_flay"] = MakeLocalizedString(&"ZMUI_BGB_SWORD_FLAY");
	level.gg_names["zm_bgb_temporal_gift"] = MakeLocalizedString(&"ZMUI_BGB_TEMPORAL_GIFT");
	level.gg_names["zm_bgb_in_plain_sight"] = MakeLocalizedString(&"ZMUI_BGB_IN_PLAIN_SIGHT");
	level.gg_names["zm_bgb_im_feelin_lucky"] = MakeLocalizedString(&"ZMUI_BGB_IM_FEELIN_LUCKY");
	level.gg_names["zm_bgb_immolation_liquidation"] = MakeLocalizedString(&"ZMUI_BGB_IMMOLATION_LIQUIDATION");
	level.gg_names["zm_bgb_phoenix_up"] = MakeLocalizedString(&"ZMUI_BGB_PHOENIX_UP");
	level.gg_names["zm_bgb_pop_shocks"] = MakeLocalizedString(&"ZMUI_BGB_POP_SHOCKS");
	level.gg_names["zm_bgb_challenge_rejected"] = MakeLocalizedString(&"ZMUI_BGB_CHALLENGE_REJECTED");
	level.gg_names["zm_bgb_on_the_house"] = MakeLocalizedString(&"ZMUI_BGB_ON_THE_HOUSE");
	level.gg_names["zm_bgb_profit_sharing"] = MakeLocalizedString(&"ZMUI_BGB_PROFIT_SHARING");
	level.gg_names["zm_bgb_flavor_hexed"] = MakeLocalizedString(&"ZMUI_BGB_FLAVOR_HEXED");
	level.gg_names["zm_bgb_crate_power"] = MakeLocalizedString(&"ZMUI_BGB_CRATE_POWER");
	level.gg_names["zm_bgb_unquenchable"] = MakeLocalizedString(&"ZMUI_BGB_UNQUENCHABLE");
	level.gg_names["zm_bgb_alchemical_antithesis"] = MakeLocalizedString(&"ZMUI_BGB_ALCHEMICAL_ANTITHESIS");
	level.gg_names["zm_bgb_extra_credit"] = MakeLocalizedString(&"ZMUI_BGB_EXTRA_CREDIT");
	level.gg_names["zm_bgb_head_drama"] = MakeLocalizedString(&"ZMUI_BGB_HEAD_DRAMA");
	level.gg_names["zm_bgb_aftertaste_blood"] = MakeLocalizedString(&"ZMUI_BGB_AFTERTASTE_BLOOD");
	level.gg_names["zm_bgb_perkaholic"] = MakeLocalizedString(&"ZMUI_BGB_PERKAHOLIC");

	aramis_dialogue = array(&"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS0", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS1", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS2", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS3", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS4", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS10", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS15", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS25");
	porthos_dialogue = array(&"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS0", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS1", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS2", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS3", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS4", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS10", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS15", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS25");
	dart_dialogue = array(&"ZM_ABBEY_TRIAL_DIALOGUE_DART0", &"ZM_ABBEY_TRIAL_DIALOGUE_DART1", &"ZM_ABBEY_TRIAL_DIALOGUE_DART2", &"ZM_ABBEY_TRIAL_DIALOGUE_DART3", &"ZM_ABBEY_TRIAL_DIALOGUE_DART4", &"ZM_ABBEY_TRIAL_DIALOGUE_DART10", &"ZM_ABBEY_TRIAL_DIALOGUE_DART15", &"ZM_ABBEY_TRIAL_DIALOGUE_DART25");
	athos_dialogue = array(&"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS0", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS1", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS2", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS3", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS4", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS10", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS15", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS25");

	aramis_dialogue_bribe = array(&"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE1", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE2", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE3", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE4", &"ZM_ABBEY_TRIAL_DIALOGUE_ARAMIS_BRIBE5");
	porthos_dialogue_bribe = array(&"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE1", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE2", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE3", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE4", &"ZM_ABBEY_TRIAL_DIALOGUE_PORTHOS_BRIBE5");
	dart_dialogue_bribe = array(&"ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE1", &"ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE2", &"ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE3", &"ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE4", &"ZM_ABBEY_TRIAL_DIALOGUE_DART_BRIBE5");
	athos_dialogue_bribe = array(&"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE1", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE2", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE3", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE4", &"ZM_ABBEY_TRIAL_DIALOGUE_ATHOS_BRIBE5");

	level.gargoyle_dialogue = array(aramis_dialogue, porthos_dialogue, dart_dialogue, athos_dialogue);
	level.gargoyle_dialogue_bribe = array(aramis_dialogue_bribe, porthos_dialogue_bribe, dart_dialogue_bribe, athos_dialogue_bribe);
	level.gargoyle_prefixes = array(&"ZM_ABBEY_TRIAL_ARAMIS_NAME_SHORT", &"ZM_ABBEY_TRIAL_PORTHOS_NAME", &"ZM_ABBEY_TRIAL_DART_NAME", &"ZM_ABBEY_TRIAL_ATHOS_NAME");

	level.gargoyle_judges = GetEntArray("gargoyle_judge", "targetname");
	level array::thread_all(level.gargoyle_judges, &judge_think);

	level.gargoyle_bribes = GetEntArray("abbey_bribe", "targetname");
	level array::thread_all(level.gargoyle_bribes, &bribe_think);

	level.gargoyle_bribes_active = [];
	level.gargoyle_first_bribe_taken = false;
	level thread bribe_manager();

	level callback::on_connect( &on_player_connect );
}

function on_player_connect()
{
	self.gg_quantities = [];
	foreach(gum in level.gg_all)
	{
		self.gg_quantities[gum] = 0;
	}

	self.judge_indices = [];
	self.judge_dialogue = [];
	for(i = 0; i < 4; i++)
	{
		self.judge_indices[i] = 0;
		prefix = MakeLocalizedString(&"ZM_ABBEY_TRIAL_ARAMIS_NAME");
		if(i != 0)
		{
			prefix = MakeLocalizedString(level.gargoyle_prefixes[i]);
		}
		self.judge_dialogue[i] = prefix + MakeLocalizedString(level.gargoyle_dialogue[i][0]);
		self thread judge_dialogue_think(i);
	}

	self.judge_display_balls = [];
	self thread display_balls_cleanup();

	self.bribe_count = 0;
	self.lua_decrement_quantity_queue_pos = 0;

	level array::thread_all(level.gargoyle_judges, &player_judge_setup, self);
	level array::thread_all(level.gargoyle_judges, &judge_hintstring_think, self);
	level array::thread_all(level.gargoyle_bribes, &bribe_hintstring_think, self);
}

function judge_dialogue_think(garg_num)
{
	self endon("disconnect");

	prefix = MakeLocalizedString(level.gargoyle_prefixes[garg_num]);
	num_trials_completed = 0;
	num_bribes_given = 0;

	while(true)
	{
		result = self util::waittill_any_return("trial_complete" + garg_num, "bribe_given" + garg_num);
		if(result == "trial_complete" + garg_num)
		{
			num_trials_completed += 1;
			if(num_trials_completed < 10)
			{
				trial_index = Int(Min(num_trials_completed, 4));
				self.judge_dialogue[garg_num] = prefix + MakeLocalizedString(level.gargoyle_dialogue[garg_num][trial_index]);
			}
			else if(num_trials_completed >= 10 && num_trials_completed < 15)
			{
				self.judge_dialogue[garg_num] = prefix + MakeLocalizedString(level.gargoyle_dialogue[garg_num][5]);
			}
			else if(num_trials_completed >= 15 && num_trials_completed < 25)
			{
				self.judge_dialogue[garg_num] = prefix + MakeLocalizedString(level.gargoyle_dialogue[garg_num][6]);
			}
			else
			{
				self.judge_dialogue[garg_num] = prefix + MakeLocalizedString(level.gargoyle_dialogue[garg_num][7]);
			}
		}
		else
		{
			num_bribes_given += 1;
			bribe_index = Int(Min((num_bribes_given - 1), 4));
			self.judge_dialogue[garg_num] = prefix + MakeLocalizedString(level.gargoyle_dialogue_bribe[garg_num][bribe_index]);
		}
	}
}

function player_judge_setup(player)
{
	player endon("disconnect");

	while(! isdefined(player.gargoyle_gums))
	{
		wait(0.05);
	}

	self gargoyle_display_update(player);
}

function gargoyle_display_update(player)
{
	garg_num = self.script_int;
	garg_name = self.script_string;

	gumball = GetEnt(garg_name + "_gumball", "targetname");
	index = player.judge_indices[garg_num];
	gum = player.gargoyle_gums[garg_num][index];
	gum_struct = zm_bgb_custom_util::lookup_gobblegum(gum);

	if(isdefined(player.judge_display_balls[garg_name]))
	{
		player.judge_display_balls[garg_name] Delete();
	}

	player.judge_display_balls[garg_name] = player zm_bgb_custom_util::create_gg_model_for_player(gum_struct, gumball.origin, gumball.angles); 
}

function judge_hintstring_think(player)
{
	player endon("disconnect");

	garg_num = self.script_int;
	garg_name = self.script_string;

	prev_displayName = "";
	prev_quantity = -1;
	prev_bribe_count = -1;
	prev_dialogue = "";

	while(true)
	{
		index = player.judge_indices[garg_num];
		gum = player.gargoyle_gums[garg_num][index];
		gum_struct = zm_bgb_custom_util::lookup_gobblegum(gum);
		displayName = gum_struct.displayName;
		quantity = player.gg_quantities[gum];
		bribe_count = player.bribe_count;
		dialogue = player.judge_dialogue[garg_num];

		if(displayName != prev_displayName || quantity != prev_quantity || bribe_count != prev_bribe_count || dialogue != prev_dialogue)
		{
			prev_displayName = displayName;
			prev_quantity = quantity;
			prev_bribe_count = bribe_count;
			bribe_cost = zm_bgb_custom_util::gg_bribe_cost(gum);
			hintstring = MakeLocalizedString(&"ZM_ABBEY_TRIAL_HINTSTRING_START") + gum_struct.displayName + MakeLocalizedString(&"ZM_ABBEY_TRIAL_HINTSTRING_VALUE") + quantity + "]" + MakeLocalizedString(&"ZM_ABBEY_TRIAL_HINTSTRING_NEXT") + dialogue;
			if(quantity == 0 && bribe_count >= bribe_cost)
			{
				hintstring = MakeLocalizedString(&"ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_START") + gum_struct.displayName + MakeLocalizedString(&"ZM_ABBEY_TRIAL_HINTSTRING_BRIBE_VALUE") + bribe_cost + "]" + MakeLocalizedString(&"ZM_ABBEY_TRIAL_HINTSTRING_NEXT") + dialogue;
			}
			
			self SetHintStringForPlayer(player, hintstring);
		}
		wait(0.05);
	}
}

function display_balls_cleanup()
{
	self waittill("disconnect");

	foreach(display_ball in self.judge_display_balls)
	{
		display_ball Delete();
	}
}

// logic for gum machines
function judge_think() 
{
	self SetCursorHint( "HINT_NOICON" );

	garg_num = self.script_int;
	garg_name = self.script_string;

	gumball = GetEnt(garg_name + "_gumball", "targetname");
	gumball SetInvisibleToAll();
	
	tag_origin = Spawn("script_model", gumball.origin);
	tag_origin SetModel("tag_origin");
	PlayFXOnTag("custom/fx_trail_blood_soul_zmb", tag_origin, "tag_origin");

	model = GetEnt(garg_name + "_model", "targetname");
	model thread judge_model_think(garg_num);

	while(true) {
		self waittill("trigger", player);

		index = player.judge_indices[garg_num];
		gum = player.gargoyle_gums[garg_num][index];
		quantity = player.gg_quantities[gum];
		bribe_cost = zm_bgb_custom_util::gg_bribe_cost(gum);
		if(! (zm_utility::is_player_valid(player)) || ! zm_perks::vending_trigger_can_player_use(player) || (quantity == 0 && player.bribe_count < bribe_cost))
		{
			wait(0.05);
			continue;
		}

		player zm_audio::create_and_play_dialog("bgb", "buy");

		gum_struct = zm_bgb_custom_util::lookup_gobblegum(gum);
		player thread zm_bgb_custom_util::give_gobblegum(gum_struct);

		if(quantity > 0)
		{	
			player.gg_quantities[gum] -= 1;

			cf_val = (garg_num * 4) + index + 1;
			player thread lua_decrement_quantity(cf_val);
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

function lua_decrement_quantity(cf_val)
{
	self endon("disconnect");

	queue_pos = self.lua_decrement_quantity_queue_pos;
	while(queue_pos > 0)
	{
		self waittill(#"lua_decrement_quantity_queue_pop");
		queue_pos -= 1;
	}

	self.lua_decrement_quantity_queue_pos += 1;

	while(self clientfield::get_player_uimodel("gumEaten") != cf_val)
	{
		self clientfield::set_player_uimodel("gumEaten", cf_val);
		util::wait_network_frame();
	}
	while(self clientfield::get_player_uimodel("gumEaten") != EATEN_CF_NEUTRAL)
	{
		self clientfield::set_player_uimodel("gumEaten", EATEN_CF_NEUTRAL);
		util::wait_network_frame();
	}

	self notify(#"lua_decrement_quantity_queue_pop");
	self.lua_decrement_quantity_queue_pos -= 1;
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
			level array::thread_all(level.gargoyle_judges, &judge_hivemind, garg_num, e_attacker);
		}
	}
}

function judge_hivemind(garg_num, player)
{
	if(self.script_int != garg_num)
	{
		return;
	}

	self gargoyle_display_update(player);
}

function bribe_hintstring_think(player)
{
	player endon("disconnect");

	prev_bribe_active = true;
	prev_max_bribes = true;

	while(true)
	{
		bribe_active = level array::contains(level.gargoyle_bribes_active, self);
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
		if(level array::contains(level.gargoyle_bribes_active, self))
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
			level.gargoyle_first_bribe_taken = true;
			player PlaySound("zmb_buildable_pickup");
			player.bribe_count += 1;
			player clientfield::set_player_uimodel("bribeCount", player.bribe_count);
			ArrayRemoveValue(level.gargoyle_bribes_active, self);
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
	while(true)
	{
		if(level.gargoyle_bribes_active.size < BRIBE_MAX)
		{
			available_bribes = level array::filter(level.gargoyle_bribes, false, &bribe_filter);
			level array::add(level.gargoyle_bribes_active, level array::random(available_bribes));
		}
		while(! level.gargoyle_first_bribe_taken)
		{
			wait(0.05);
		}
		for(i = 0; i < BRIBE_WAIT; i++)
		{
			level waittill("start_of_round");
		}
	}
}

function bribe_filter(val)
{
	return ! level array::contains(level.gargoyle_bribes_active, val);
}