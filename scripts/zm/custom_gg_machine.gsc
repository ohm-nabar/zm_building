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

	level.gargoyle_judges = GetEntArray("gargoyle_judge", "targetname");
	level array::thread_all(level.gargoyle_judges, &judge_think);

	level.gargoyle_bribes = GetEntArray("abbey_bribe", "targetname");
	level array::thread_all(level.gargoyle_bribes, &bribe_think);

	level.gargoyle_bribes_active = [];
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
	for(i = 0; i < 4; i++)
	{
		self.judge_indices[i] = 0;
	}

	self.judge_display_balls = [];
	self thread display_balls_cleanup();

	self.bribe_count = 0;
	self.lua_decrement_quantity_queue_pos = 0;

	level array::thread_all(level.gargoyle_judges, &player_judge_setup, self);
	level array::thread_all(level.gargoyle_judges, &judge_hintstring_think, self);
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

	while(true)
	{
		index = player.judge_indices[garg_num];
		gum = player.gargoyle_gums[garg_num][index];
		gum_struct = zm_bgb_custom_util::lookup_gobblegum(gum);
		displayName = gum_struct.displayName;
		quantity = player.gg_quantities[gum];
		bribe_count = player.bribe_count;

		if(displayName != prev_displayName || quantity != prev_quantity || bribe_count != prev_bribe_count)
		{
			prev_displayName = displayName;
			prev_quantity = quantity;
			prev_bribe_count = bribe_count;
			bribe_cost = zm_bgb_custom_util::gg_bribe_cost(gum);
			hintstring = "Press ^3[{+activate}]^7 for " + gum_struct.displayName + " [Quantity: " + quantity + "]" + "\nMelee for next GargoyleGum";
			if(quantity == 0 && bribe_count >= bribe_cost)
			{
				hintstring = "Press ^3[{+activate}]^7 to Bribe for " + gum_struct.displayName + " [Cost: " + bribe_cost + "]" + "\nMelee for next GargoyleGum";
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
			player clientfield::set_player_uimodel("bribeCount", player.bribe_count);
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

function bribe_think()
{
	model = GetEnt(self.target, "targetname");
	fx_spot = Spawn("script_model", model.origin + (0, 0, BRIBE_OFFSET));
	active = true;

	while(true)
	{
		if(level array::contains(level.gargoyle_bribes_active, self))
		{ 
			active = true;

			self SetHintString("Press ^3[{+activate}]^7 for Bribe");
			model SetVisibleToAll();
			fx_spot = Spawn("script_model", model.origin + (0, 0, BRIBE_OFFSET));
			fx_spot SetModel("tag_origin");
			PlayFXOnTag("custom/pistol_glint", fx_spot, "tag_origin");

			self waittill("trigger", player);
			while(player.bribe_count >= BRIBE_MAX_PLAYER)
			{
				self waittill("trigger", player);
			}
			player PlaySound("zmb_buildable_pickup");
			player.bribe_count += 1;
			player clientfield::set_player_uimodel("bribeCount", player.bribe_count);
			ArrayRemoveValue(level.gargoyle_bribes_active, self);
		}
		else if(active)
		{
			active = false;

			self SetCursorHint("HINT_NOICON");
			self SetHintString("");
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
		level waittill("start_of_round");
		
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