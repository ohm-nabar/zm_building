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
	clientfield::register( "toplayer", "gum.eaten", VERSION_SHIP, 5, "int" );

	level.gg_all = [];
	array::add(level.gg_all, "zm_bgb_stock_option");
	array::add(level.gg_all, "zm_bgb_sword_flay");
	array::add(level.gg_all, "zm_bgb_temporal_gift");
	array::add(level.gg_all, "zm_bgb_in_plain_sight");
	array::add(level.gg_all, "zm_bgb_im_feelin_lucky");
	array::add(level.gg_all, "zm_bgb_immolation_liquidation");
	array::add(level.gg_all, "zm_bgb_phoenix_up");
	array::add(level.gg_all, "zm_bgb_pop_shocks");
	array::add(level.gg_all, "zm_bgb_challenge_rejected");
	array::add(level.gg_all, "zm_bgb_on_the_house");
	array::add(level.gg_all, "zm_bgb_profit_sharing");
	array::add(level.gg_all, "zm_bgb_flavor_hexed");
	array::add(level.gg_all, "zm_bgb_crate_power");
	array::add(level.gg_all, "zm_bgb_unquenchable");
	array::add(level.gg_all, "zm_bgb_alchemical_antithesis");
	array::add(level.gg_all, "zm_bgb_extra_credit");
	array::add(level.gg_all, "zm_bgb_head_drama");
	array::add(level.gg_all, "zm_bgb_aftertaste_blood");
	array::add(level.gg_all, "zm_bgb_perkaholic");

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

	level.gargoyle_judges = GetEntArray("gargoyle_judge", "targetname");
	array::thread_all(level.gargoyle_judges, &judge_think);
	callback::on_connect( &on_player_connect );
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

	while(true)
	{
		index = player.judge_indices[garg_num];
		gum = player.gargoyle_gums[garg_num][index];
		gum_struct = zm_bgb_custom_util::lookup_gobblegum(gum);
		displayName = gum_struct.displayName;
		quantity = player.gg_quantities[gum];

		if(displayName != prev_displayName || quantity != prev_quantity)
		{
			prev_displayName = displayName;
			prev_quantity = quantity;
			hintstring = "Press ^3[{+activate}]^7 for " + MakeLocalizedString(gum_struct.displayName) + " [Quantity: " + quantity + "]" + "\nMelee for next GargoyleGum";
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
		if(! (zm_utility::is_player_valid(player)) || ! zm_perks::vending_trigger_can_player_use(player) || quantity == 0)
		{
			wait(0.05);
			continue;
		}

		player zm_audio::create_and_play_dialog("bgb", "buy");

		gum_struct = zm_bgb_custom_util::lookup_gobblegum(gum);
		player thread zm_bgb_custom_util::give_gobblegum(gum_struct);

		player.gg_quantities[gum] -= 1;

		cf_val = (garg_num * 4) + index;
		player clientfield::set_to_player("gum.eaten", cf_val);
		util::wait_network_frame();
		player clientfield::set_to_player("gum.eaten", 16);
		util::wait_network_frame();

		wait(0.05);
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