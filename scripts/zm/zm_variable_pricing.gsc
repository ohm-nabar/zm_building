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
#using scripts\zm\_zm_equipment;

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


// MAIN
//*****************************************************************************

function main()
{
	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 
	zombie_debris = GetEntArray( "zombie_debris", "targetname" );

	level.first_door = false;
	level.first_debris = false;

	foreach(door in zombie_doors)
	{
		door thread monitor_door_price();
	}

	foreach(debris in zombie_debris)
	{
		debris thread monitor_debris_price();
	}
}

function monitor_door_price()
{
	original_price = self.zombie_cost;
	while(isdefined(self))
	{
		players = GetPlayers();
		self.zombie_cost = original_price + (100 * (players.size - 1));
		self zm_utility::set_hint_string( self, "default_buy_door", self.zombie_cost );
		wait(0.05);
	}
}

function monitor_debris_price()
{
	original_price = self.zombie_cost;
	while(isdefined(self))
	{
		players = GetPlayers();
		self.zombie_cost = original_price + (100 * (players.size - 1));
		self zm_utility::set_hint_string( self, "default_buy_debris", self.zombie_cost );
		wait(0.05);
	}
}

function testeroo()
{
	while(true)
	{
		IPrintLn(self.zombie_cost);
		wait(2);
	}
}