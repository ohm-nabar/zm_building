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
#using scripts\shared\system_shared;

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
//#using scripts\zm\_zm_powerup_weapon_minigun;

//Traps
#using scripts\zm\_zm_trap_electric;

//Needed for damage override
#using scripts\zm\zm_usermap;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_bgb_token;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_bgb;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\shared\archetype_shared\archetype_shared.gsh;

#namespace zm_no_hud;

REGISTER_SYSTEM( "zm_no_hud", &__init__, undefined )

function __init__()
{
	clientfield::register( "clientuimodel", "abbeyNoHUD", VERSION_SHIP, 2, "int" );
	callback::on_connect( &on_player_connect );
}

function on_player_connect() {
	self.abbey_no_hud = false;
	self.abbey_no_waypoints = false;
	self thread check_no_hud();
}

function check_no_hud() 
{
	self endon("disconnect");

	while(! isdefined(level.shadow_transition_active))
	{
		wait(0.05);
	}
	while( true ) 
	{		
		if( self ActionSlotThreeButtonPressed() && ! level.shadow_transition_active ) 
		{
			if( self.abbey_no_hud && self.abbey_no_waypoints ) 
			{
				self.abbey_no_hud = false;
				self.abbey_no_waypoints = false;
				self util::show_hud(true);
				wait(0.5);
				self clientfield::set_player_uimodel("abbeyNoHUD", 0);
			}
			else if ( !self.abbey_no_hud && self.abbey_no_waypoints )
			{
				self.abbey_no_hud = true;
				self.abbey_no_waypoints = true;
				self clientfield::set_player_uimodel("abbeyNoHUD", 2);
				wait(0.5);
				self util::show_hud(false);
			}
			else
			{
				self.abbey_no_waypoints = true;
				self clientfield::set_player_uimodel("abbeyNoHUD", 1);
			}
		}
		wait(0.05);
	}
}