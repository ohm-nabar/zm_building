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

#precache( "string", "ZM_ABBEY_BGB_SELECT" );
#precache( "string", "ZM_ABBEY_BGB_ACCEPT" );
#precache( "string", "ZM_ABBEY_BGB_NO_STOCK" );
#precache( "string", "ZM_ABBEY_BGB_ACTIVATE" );
#precache( "string", "ZM_ABBEY_BGB_NEXT_ROUND" );

#precache( "string", "ZM_ABBEY_BGB_STOCK_OPTION" );
#precache( "string", "ZM_ABBEY_BGB_SWORD_FLAY" );
#precache( "string", "ZM_ABBEY_BGB_TEMPORAL_GIFT" );
#precache( "string", "ZM_ABBEY_BGB_IN_PLAIN_SIGHT" );
#precache( "string", "ZM_ABBEY_BGB_IM_FEELIN_LUCKY" );
#precache( "string", "ZM_ABBEY_BGB_IMMOLATION_LIQUIDATION" );
#precache( "string", "ZM_ABBEY_BGB_PHOENIX_UP" );
#precache( "string", "ZM_ABBEY_BGB_POP_SHOCKS" );
#precache( "string", "ZM_ABBEY_BGB_CACHE_BACK" );
#precache( "string", "ZM_ABBEY_BGB_ON_THE_HOUSE" );
#precache( "string", "ZM_ABBEY_BGB_PROFIT_SHARING" );
#precache( "string", "ZM_ABBEY_BGB_WALL_POWER" );
#precache( "string", "ZM_ABBEY_BGB_CRATE_POWER" );
#precache( "string", "ZM_ABBEY_BGB_UNQUENCHABLE" );
#precache( "string", "ZM_ABBEY_BGB_ALCHEMICAL_ANTITHESIS" );
#precache( "string", "ZM_ABBEY_BGB_PERKAHOLIC" );

#precache( "string", "ZM_ABBEY_BGB_STOCK_OPTION_DESC" );
#precache( "string", "ZM_ABBEY_BGB_SWORD_FLAY_DESC" );
#precache( "string", "ZM_ABBEY_BGB_TEMPORAL_GIFT_DESC" );
#precache( "string", "ZM_ABBEY_BGB_IN_PLAIN_SIGHT_DESC" );
#precache( "string", "ZM_ABBEY_BGB_IM_FEELIN_LUCKY_DESC" );
#precache( "string", "ZM_ABBEY_BGB_IMMOLATION_LIQUIDATION_DESC" );
#precache( "string", "ZM_ABBEY_BGB_PHOENIX_UP_DESC" );
#precache( "string", "ZM_ABBEY_BGB_POP_SHOCKS_DESC" );
#precache( "string", "ZM_ABBEY_BGB_CACHE_BACK_DESC" );
#precache( "string", "ZM_ABBEY_BGB_ON_THE_HOUSE_DESC" );
#precache( "string", "ZM_ABBEY_BGB_PROFIT_SHARING_DESC" );
#precache( "string", "ZM_ABBEY_BGB_WALL_POWER_DESC" );
#precache( "string", "ZM_ABBEY_BGB_CRATE_POWER_DESC" );
#precache( "string", "ZM_ABBEY_BGB_UNQUENCHABLE_DESC" );
#precache( "string", "ZM_ABBEY_BGB_ALCHEMICAL_ANTITHESIS_DESC" );
#precache( "string", "ZM_ABBEY_BGB_PERKAHOLIC_DESC" );

#namespace custom_gg_machine;

REGISTER_SYSTEM( "custom_gg_machine", &__init__, undefined )

function __init__() 
{
	clientfield::register( "clientuimodel", "currentGGUpdate", VERSION_SHIP, 7, "int" );
	clientfield::register( "clientuimodel", "nextGGUpdate", VERSION_SHIP, 7, "int" );
	clientfield::register( "clientuimodel", "currentGGFaded", VERSION_SHIP, 3, "int" );
	clientfield::register( "clientuimodel", "GGEaten", VERSION_SHIP, 4, "int" );

	level.gg_selectors = GetEntArray("gg_selector", "targetname");
	for(i = 0; i < level.gg_selectors.size; i++)
	{
		level.gg_selectors[i] SetCursorHint("HINT_NOICON");
		level.gg_selectors[i] SetHintString(&"ZM_ABBEY_EMPTY");
		gumball = GetEnt(level.gg_selectors[i].target, "targetname");
		gumball SetInvisibleToAll();
	}
	callback::on_connect( &on_player_connect );
	level.gg_costs = [];
	level.gg_costs[level.gg_costs.size] = 0;
	level.gg_costs[level.gg_costs.size] = 250;
	level.gg_costs[level.gg_costs.size] = 500;

	level.gg_names = [];
	level.gg_names["zm_bgb_stock_option"] = &"ZM_ABBEY_BGB_STOCK_OPTION";
	level.gg_names["zm_bgb_sword_flay"] = &"ZM_ABBEY_BGB_SWORD_FLAY";
	level.gg_names["zm_bgb_temporal_gift"] = &"ZM_ABBEY_BGB_TEMPORAL_GIFT";
	level.gg_names["zm_bgb_in_plain_sight"] = &"ZM_ABBEY_BGB_IN_PLAIN_SIGHT";
	level.gg_names["zm_bgb_im_feelin_lucky"] = &"ZM_ABBEY_BGB_IM_FEELIN_LUCKY";
	level.gg_names["zm_bgb_immolation_liquidation"] = &"ZM_ABBEY_BGB_IMMOLATION_LIQUIDATION";
	level.gg_names["zm_bgb_phoenix_up"] = &"ZM_ABBEY_BGB_PHOENIX_UP";
	level.gg_names["zm_bgb_pop_shocks"] = &"ZM_ABBEY_BGB_POP_SHOCKS";
	level.gg_names["zm_bgb_cache_back"] = &"ZM_ABBEY_BGB_CACHE_BACK";
	level.gg_names["zm_bgb_on_the_house"] = &"ZM_ABBEY_BGB_ON_THE_HOUSE";
	level.gg_names["zm_bgb_profit_sharing"] = &"ZM_ABBEY_BGB_PROFIT_SHARING";
	level.gg_names["zm_bgb_wall_power"] = &"ZM_ABBEY_BGB_WALL_POWER";
	level.gg_names["zm_bgb_crate_power"] = &"ZM_ABBEY_BGB_CRATE_POWER";
	level.gg_names["zm_bgb_unquenchable"] = &"ZM_ABBEY_BGB_UNQUENCHABLE";
	level.gg_names["zm_bgb_alchemical_antithesis"] = &"ZM_ABBEY_BGB_ALCHEMICAL_ANTITHESIS";
	level.gg_names["zm_bgb_perkaholic"] = &"ZM_ABBEY_BGB_PERKAHOLIC";

	level.gg_descriptions = [];
	level.gg_descriptions["zm_bgb_stock_option"] = &"ZM_ABBEY_BGB_STOCK_OPTION_DESC";
	level.gg_descriptions["zm_bgb_sword_flay"] = &"ZM_ABBEY_BGB_SWORD_FLAY_DESC";
	level.gg_descriptions["zm_bgb_temporal_gift"] = &"ZM_ABBEY_BGB_TEMPORAL_GIFT_DESC";
	level.gg_descriptions["zm_bgb_in_plain_sight"] = &"ZM_ABBEY_BGB_IN_PLAIN_SIGHT_DESC";
	level.gg_descriptions["zm_bgb_im_feelin_lucky"] = &"ZM_ABBEY_BGB_IM_FEELIN_LUCKY_DESC";
	level.gg_descriptions["zm_bgb_immolation_liquidation"] = &"ZM_ABBEY_BGB_IMMOLATION_LIQUIDATION_DESC";
	level.gg_descriptions["zm_bgb_phoenix_up"] = &"ZM_ABBEY_BGB_PHOENIX_UP_DESC";
	level.gg_descriptions["zm_bgb_pop_shocks"] = &"ZM_ABBEY_BGB_POP_SHOCKS_DESC";
	level.gg_descriptions["zm_bgb_cache_back"] = &"ZM_ABBEY_BGB_CACHE_BACK_DESC";
	level.gg_descriptions["zm_bgb_on_the_house"] = &"ZM_ABBEY_BGB_ON_THE_HOUSE_DESC";
	level.gg_descriptions["zm_bgb_profit_sharing"] = &"ZM_ABBEY_BGB_PROFIT_SHARING_DESC";
	level.gg_descriptions["zm_bgb_wall_power"] = &"ZM_ABBEY_BGB_WALL_POWER_DESC";
	level.gg_descriptions["zm_bgb_crate_power"] = &"ZM_ABBEY_BGB_CRATE_POWER_DESC";
	level.gg_descriptions["zm_bgb_unquenchable"] = &"ZM_ABBEY_BGB_UNQUENCHABLE_DESC";
	level.gg_descriptions["zm_bgb_alchemical_antithesis"] = &"ZM_ABBEY_BGB_ALCHEMICAL_ANTITHESIS_DESC";
	level.gg_descriptions["zm_bgb_perkaholic"] = &"ZM_ABBEY_BGB_PERKAHOLIC_DESC";

	level.gg_all = [];
	level.gg_all[level.gg_all.size] = "zm_bgb_stock_option";
	level.gg_all[level.gg_all.size] = "zm_bgb_sword_flay";
	level.gg_all[level.gg_all.size] = "zm_bgb_temporal_gift";
	level.gg_all[level.gg_all.size] = "zm_bgb_in_plain_sight";
	level.gg_all[level.gg_all.size] = "zm_bgb_im_feelin_lucky";
	level.gg_all[level.gg_all.size] = "zm_bgb_immolation_liquidation";
	level.gg_all[level.gg_all.size] = "zm_bgb_phoenix_up";
	level.gg_all[level.gg_all.size] = "zm_bgb_pop_shocks";
	level.gg_all[level.gg_all.size] = "zm_bgb_cache_back";
	level.gg_all[level.gg_all.size] = "zm_bgb_on_the_house";
	level.gg_all[level.gg_all.size] = "zm_bgb_profit_sharing";
	level.gg_all[level.gg_all.size] = "zm_bgb_wall_power";
	level.gg_all[level.gg_all.size] = "zm_bgb_crate_power";
	level.gg_all[level.gg_all.size] = "zm_bgb_unquenchable";
	level.gg_all[level.gg_all.size] = "zm_bgb_alchemical_antithesis";
	level.gg_all[level.gg_all.size] = "zm_bgb_perkaholic";

	level.perkaholic_unlocked = false;

	thread gg_prices_set();
	gg_machines = GetEntArray("gg_machine", "targetname");
	array::thread_all(gg_machines, &gg_think);
	//thread testeroo();
}

function on_player_connect()
{
	self.gg_array_current = [];
	self.gg_array_next = [];
	self.gg_quantities = [];
	
	self.gg_array_current[self.gg_array_current.size] = "zm_bgb_stock_option";
	self.gg_array_current[self.gg_array_current.size] = "zm_bgb_sword_flay";
	self.gg_array_current[self.gg_array_current.size] = "zm_bgb_temporal_gift";
	self.gg_array_current[self.gg_array_current.size] = "zm_bgb_in_plain_sight";
	self.gg_array_current[self.gg_array_current.size] = "zm_bgb_im_feelin_lucky";

	self.gg_array_cycle = array::randomize(self.gg_array_current);
	
	self.gg_array_next[self.gg_array_next.size] = "zm_bgb_stock_option";
	self.gg_array_next[self.gg_array_next.size] = "zm_bgb_sword_flay";
	self.gg_array_next[self.gg_array_next.size] = "zm_bgb_temporal_gift";
	self.gg_array_next[self.gg_array_next.size] = "zm_bgb_in_plain_sight";
	self.gg_array_next[self.gg_array_next.size] = "zm_bgb_im_feelin_lucky";

	self.gg_quantities = [];
	self.gg_quantities["zm_bgb_stock_option"] = 1;
	self.gg_quantities["zm_bgb_sword_flay"] = 1;
	self.gg_quantities["zm_bgb_temporal_gift"] = 1;
	self.gg_quantities["zm_bgb_in_plain_sight"] = 1;
	self.gg_quantities["zm_bgb_im_feelin_lucky"] = 1;
	self.gg_quantities["zm_bgb_immolation_liquidation"] = 0;
	self.gg_quantities["zm_bgb_phoenix_up"] = 0;
	self.gg_quantities["zm_bgb_pop_shocks"] = 0;
	self.gg_quantities["zm_bgb_cache_back"] = 0;
	self.gg_quantities["zm_bgb_on_the_house"] = 0;
	self.gg_quantities["zm_bgb_profit_sharing"] = 0;
	self.gg_quantities["zm_bgb_wall_power"] = 0;
	self.gg_quantities["zm_bgb_crate_power"] = 0;
	self.gg_quantities["zm_bgb_unquenchable"] = 0;
	self.gg_quantities["zm_bgb_alchemical_antithesis"] = 0;
	self.gg_quantities["zm_bgb_perkaholic"] = 0;

	self.gg_cycle_index = 0;
	self.gg_cost_index = 0;
	self.prev_gg_cost_indices = [];

	self.just_reset_gg_cycle = false;

	for(i = 0; i < level.gg_selectors.size; i++)
	{
		self thread gg_selector_hintstring(level.gg_selectors[i]);
		self thread gg_selector_think(level.gg_selectors[i]);
	}

	self thread gg_prices_reset();
	self thread set_gg_current_hud();
	self thread set_gg_next_hud();
	self thread gg_hud_reset();
}


function set_gg_current_hud()
{
	self endon("disconnect");

	while(! level flag::get("initial_blackscreen_passed"))
	{
		wait(0.05);
	}

	for(i = 0; i < self.gg_array_current.size; i++)
	{
		gg_index = -1;
		for(j = 0; j < level.gg_all.size; j++)
		{
			if(self.gg_array_current[i] == level.gg_all[j])
			{
				gg_index = j;
				break;
			}
		}
		if(gg_index != -1)
		{
			self clientfield::set_player_uimodel("currentGGUpdate", (16 * i) + gg_index);
		}
		util::wait_network_frame();
	}
}

function set_gg_next_hud()
{
	self endon("disconnect");

	while(! level flag::get("initial_blackscreen_passed"))
	{
		wait(0.05);
	}

	for(i = 0; i < self.gg_array_next.size; i++)
	{
		self set_gg_next_hud_unit(i);
		util::wait_network_frame();
	}
}

function set_gg_next_hud_unit(next_index)
{
	self endon("disconnect");

	gg_index = -1;
	for(j = 0; j < level.gg_all.size; j++)
	{
		if(self.gg_array_next[next_index] == level.gg_all[j])
		{
			gg_index = j;
			break;
		}
	}
	if(gg_index != -1)
	{	
		self clientfield::set_player_uimodel("nextGGUpdate", (16 * next_index) + gg_index);
	}
}

function add_to_solo_gums()
{
	self.gg_quantities["zm_bgb_stock_option"] += 2;
	self.gg_quantities["zm_bgb_sword_flay"] += 2;
	self.gg_quantities["zm_bgb_in_plain_sight"] += 2;
	self.gg_quantities["zm_bgb_pop_shocks"] += 2;
	self.gg_quantities["zm_bgb_wall_power"] += 2; 
	self.gg_quantities["zm_bgb_crate_power"] += 2;
	self.gg_quantities["zm_bgb_unquenchable"] += 2;
	self.gg_quantities["zm_bgb_alchemical_antithesis"] += 2;
}

function add_to_team_gums()
{
	self.gg_quantities["zm_bgb_temporal_gift"] += 2;
	self.gg_quantities["zm_bgb_im_feelin_lucky"] += 2;
	self.gg_quantities["zm_bgb_immolation_liquidation"] += 2;
	self.gg_quantities["zm_bgb_phoenix_up"] += 2;
	self.gg_quantities["zm_bgb_cache_back"] += 2;
	self.gg_quantities["zm_bgb_on_the_house"] += 2;
	self.gg_quantities["zm_bgb_profit_sharing"] += 2;
}

function add_to_all_gums()
{
	self.gg_quantities["zm_bgb_stock_option"] += 2;
	self.gg_quantities["zm_bgb_sword_flay"] += 2;
	self.gg_quantities["zm_bgb_in_plain_sight"] += 2;
	self.gg_quantities["zm_bgb_pop_shocks"] += 2;
	self.gg_quantities["zm_bgb_wall_power"] += 2; 
	self.gg_quantities["zm_bgb_crate_power"] += 2;
	self.gg_quantities["zm_bgb_unquenchable"] += 2;
	self.gg_quantities["zm_bgb_alchemical_antithesis"] += 2;
	self.gg_quantities["zm_bgb_temporal_gift"] += 2;
	self.gg_quantities["zm_bgb_im_feelin_lucky"] += 2;
	self.gg_quantities["zm_bgb_immolation_liquidation"] += 2;
	self.gg_quantities["zm_bgb_phoenix_up"] += 2;
	self.gg_quantities["zm_bgb_cache_back"] += 2;
	self.gg_quantities["zm_bgb_on_the_house"] += 2;
	self.gg_quantities["zm_bgb_profit_sharing"] += 2;
}

function gg_selector_think(gg_selector)
{
	self endon("disconnect");
	gg_slot = Int(gg_selector.script_noteworthy);

	gumball = GetEnt(gg_selector.target, "targetname");

	gum_name = self.gg_array_next[gg_slot];
	gumWeapon = GetWeapon("zombie_bgb_grab");
	gumStruct = zm_bgb_custom_util::lookupGobblgum(gum_name);

	weapon_options = self GetBuildKitWeaponOptions( gumWeapon, gumStruct.camoIndex );
	display_ball = zm_utility::spawn_weapon_model(gumWeapon, "wpn_t7_zmb_bubblegum_view", gumball.origin, gumball.angles, weapon_options);
	display_ball SetScale(2.5);
	display_ball SetInvisibleToAll();
	display_ball SetVisibleToPlayer(self);

	while(true)
	{
		gg_selector waittill("trigger", player);
		if(player != self)
		{
			continue;
		}
		self PlaySound("gobble_switch");
		index = -1;
		for(i = 0; i < level.gg_all.size; i++)
		{
			if(level.gg_all[i] == gum_name)
			{
				index = i;
				break;
			}
		}

		next_index_valid = false;
		while(! next_index_valid)
		{
			next_index = (index + 1) % level.gg_all.size;
			next_index_valid = true;
			for(i = 0; i < self.gg_array_next.size && next_index_valid; i++)
			{
				if(self.gg_array_next[i] == level.gg_all[next_index] || (level.gg_all[next_index] == "zm_bgb_perkaholic" && ! level.perkaholic_unlocked))
				{
					index = next_index;
					next_index_valid = false;
				}

			}
		}
		
		self.gg_array_next[gg_slot] = level.gg_all[next_index];

		gum_name = self.gg_array_next[gg_slot];
		gumStruct = zm_bgb_custom_util::lookupGobblgum(gum_name);
		display_ball Delete();
		weapon_options = self GetBuildKitWeaponOptions( gumWeapon, gumStruct.camoIndex );
		display_ball = zm_utility::spawn_weapon_model(gumWeapon, "wpn_t7_zmb_bubblegum_view", gumball.origin, gumball.angles, weapon_options);
		display_ball SetScale(2.5);
		display_ball SetInvisibleToAll();
		display_ball SetVisibleToPlayer(self);

		self set_gg_next_hud_unit(gg_slot);
		wait(0.05);
	}
}

function gg_selector_hintstring(gg_selector)
{
	self endon("disconnect");
	gg_slot = Int(gg_selector.script_noteworthy);

	prev_gum_name = "";
	prev_gum_desc = "";
	prev_gum_quantity = -1;
	while(true)
	{
		gum_name = self.gg_array_next[gg_slot];
		gum_desc = level.gg_descriptions[gum_name];
		gum_quantity = self.gg_quantities[gum_name];
		if(gum_name == "zm_bgb_perkaholic")
		{
			gum_quantity = "Infinite!";
		}
		
		if(prev_gum_name != gum_name || prev_gum_desc != gum_desc || prev_gum_quantity != gum_quantity)
		{
			gg_selector SetHintStringForPlayer(self, &"ZM_ABBEY_BGB_SELECT", gum_desc, gum_quantity);
			prev_gum_name = gum_name;
			prev_gum_desc = gum_desc;
			prev_gum_quantity = gum_quantity;
		}
		wait(0.05);
	}
}

function gg_hud_reset()
{
	self endon("disconnect");
	
	while ( !level flag::exists( "initial_blackscreen_passed" ) )
	{
		wait(0.05);
	}

	if ( !level flag::get( "initial_blackscreen_passed" ) )
	{
		level flag::wait_till( "initial_blackscreen_passed" );
	}

	self LUINotifyEvent(&"GGReset", 0);
}

function gg_prices_reset()
{
	self endon("disconnect");

	while(true)
	{
		level waittill( "start_of_round" );
		self.gg_cost_index = 0;
		wait(0.05);
	}
}

function gg_prices_set()
{
	while(true)
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
		level.gg_costs[1] = level.gg_costs[1] * 2;
		level.gg_costs[2] = level.gg_costs[1] * 2;
		level waittill( "end_of_round" );
	}
}

function selectGum() {
	gumToReturn = self.gg_array_cycle[self.gg_cycle_index];
	self.gg_cycle_index = self.gg_cycle_index + 1;
	self.gg_cost_index = self.gg_cost_index + 1;
	if(self.gg_cycle_index >= self.gg_array_cycle.size)
	{
		// LUA- RESET CYCLE
		self.gg_cycle_index = 0;
		for(i = 0; i < self.gg_array_next.size; i++)
		{
			self.gg_array_current[i] = self.gg_array_next[i];
		}
		self.gg_array_cycle = array::randomize(self.gg_array_current);
		self thread set_gg_current_hud();
		self.just_reset_gg_cycle = true;
	}
	else if(gumToReturn != "invalid")
	{
		currentIndex = -1;
		for(i = 0; i < self.gg_array_current.size; i++)
		{
			if(gumToReturn == self.gg_array_current[i])
			{
				currentIndex = i;
				break;
			}
		}
		if(currentIndex != -1)
		{	
			self clientfield::set_player_uimodel("currentGGFaded", currentIndex);
			util::wait_network_frame();
		}
	}

	//IPrintLn("selected gumball number " + self.gg_cycle_index + " in the cycle with name " + gumToReturn + " and quantity " + self.gg_quantities[gumToReturn]);

	return (self.gg_quantities[gumToReturn] > 0 ? gumToReturn : "invalid");
}

// logic for gum machines
function gg_think() {
	self SetCursorHint( "HINT_NOICON" );

	self.gum_in_progress = false;

	gumball = GetEnt(self.target, "targetname");
	gumball SetInvisibleToAll();

	self thread gg_set_hintstring();

	while(true) {
		self waittill("trigger", player);
		cost_index = player.gg_cost_index;
		costs = level.gg_costs;

		if(! (zm_utility::is_player_valid(player)) || ! zm_perks::vending_trigger_can_player_use(player) || cost_index >= costs.size)
		{
			wait(0.05);
			continue;
		}
		if(player.score < costs[cost_index])
		{
			player playSound("no_cha_ching"); // no idea if this sound exists, or if this function is right
			wait(0.05);
			continue;
		}

		player zm_audio::create_and_play_dialog("bgb", "buy");
		self.gum_in_progress = true;

		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			self SetHintStringForPlayer(players[i], &"ZM_ABBEY_EMPTY");
		}

		player zm_score::minus_to_player_score(costs[cost_index]);
		self PlaySound("gobble_activate");

		wait(2.5);
		player PlaySound("gobble_disappear");

		gumFunc = player selectGum();
		
		gumStruct = zm_bgb_custom_util::lookupGobblgum(gumFunc);
		name = gumStruct.displayName;
		/*
		color = gumStruct.colourValue;
		if(gumFunc == -1)
		{
			color = "white";
		}
		*/
		//gumball SetModel(level.gg_models[gumFunc]);
		//gumball SetVisibleToAll();

		gumWeapon = GetWeapon("zombie_bgb_grab");
		weapon_options = player GetBuildKitWeaponOptions( gumWeapon, gumStruct.camoIndex );
		display_ball = zm_utility::spawn_weapon_model(gumWeapon, "wpn_t7_zmb_bubblegum_view", gumball.origin, gumball.angles, weapon_options);
		display_ball SetScale(1.25);
		PlayFXOnTag("custom/fx_trail_blood_soul_zmb", display_ball, "tag_origin");

		if(gumFunc == "invalid")
		{
			self SetHintStringForPlayer(player, &"ZM_ABBEY_BGB_NO_STOCK");
		}
		else
		{
			self SetHintStringForPlayer(player, &"ZM_ABBEY_BGB_ACCEPT", name);
			//IPrintLn("gg icon name: " + self.gg_icon_name);
		}

		if(gumFunc == "invalid")
		{
			wait(5);
			player zm_score::add_to_player_score(costs[cost_index]);
		}
		else
		{
			self thread check_for_gobblegum_eaten(player, gumFunc, gumStruct, display_ball);
			wait(5);
			self notify ( "time_up" );
		}

		if(isdefined(display_ball))
		{
			display_ball Delete();
		}
		//gumball SetInvisibleToAll();
		self.gum_in_progress = false;
		wait(0.05);
	}
}

function check_for_gobblegum_eaten(player, gumFunc, gumStruct, gumball)
{
	self endon("time_up");

	gg_index = -1;
	for(j = 0; j < level.gg_all.size; j++)
	{
		if(gumFunc == level.gg_all[j])
		{
			gg_index = j;
			break;
		}
	}

	while(true)
	{
		self waittill("trigger", user);
		if( user == player && zm_perks::vending_trigger_can_player_use(player) && gg_index != -1 )
		{
			name = gumStruct.displayName;
			player thread zm_bgb_custom_util::giveGobbleGum(gumStruct);
		
			player.gg_quantities[gumFunc] = player.gg_quantities[gumFunc] - 1;
			player clientfield::set_player_uimodel("GGEaten", gg_index);
			self SetHintStringForPlayer(player, &"ZM_ABBEY_EMPTY");
			gumball Delete();
			//gumball SetInvisibleToAll();
			util::wait_network_frame();
			break;
		}
		wait(0.05);
	}
}

function gg_set_hintstring()
{
	level waittill("initial_blackscreen_passed");
	
	while(true)
	{
		if(! self.gum_in_progress)
		{
			foreach(player in level.players)
			{
				if(! array::contains(GetArrayKeys(player.prev_gg_cost_indices), self))
				{
					player.prev_gg_cost_indices[self] = -1;
				}
				if(player.prev_gg_cost_indices[self] != player.gg_cost_index)
				{
					if(player.gg_cost_index >= level.gg_costs.size)
					{
						self SetHintStringForPlayer(player, &"ZM_ABBEY_BGB_NEXT_ROUND");
					}
					else
					{
						self SetHintStringForPlayer(player, &"ZM_ABBEY_BGB_ACTIVATE", level.gg_costs[player.gg_cost_index]);
					}
					player.prev_gg_cost_indices[self] = player.gg_cost_index;
				}
			}
		}
		wait(0.05);
	}
}

function testeroo()
{
	level waittill("all_players_connected");
	players = GetPlayers();
	player = players[0];
	while(true)
	{
		level waittill("end_of_round");
		IPrintLn("end of round");

		level waittill("start_of_round");
		IPrintLn("start of round");
	}
}