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

#using scripts\zm\zm_usermap;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;

#using scripts\shared\system_shared;

#insert scripts\zm\_zm_perks.gsh;

#precache( "eventstring", "quick_lives" );


function main()
{
	level.get_player_perk_purchase_limit = &get_player_perk_purchase_limit;
	callback::on_connect( &on_player_connect );
}

function get_player_perk_purchase_limit()
{
	return (self solo_lives_check() ? 5 : 4);
}

function on_player_connect()
{
	self LUINotifyEvent(&"quick_lives", 1, 0);
	if(self IsHost())
	{
		self thread give_quick_revive();
	}
}

function give_quick_revive()
{
	self endon("disconnect"); // prolly not needed but who cares

	level waittill( "start_of_round" );

	while(! isdefined(level.solo_lives_given))
	{
		wait(0.05);
	}

	solo_game_prev = is_solo_game();
	while(level.solo_lives_given < 3)
	{
		if(is_solo_game() && ! self HasPerk(PERK_QUICK_REVIVE) && ! self laststand::player_is_in_laststand())
		{
			self LUINotifyEvent(&"quick_lives", 1, 3 - level.solo_lives_given);
			self zm_perks::give_perk(PERK_QUICK_REVIVE, false);
		}
		
		if(! solo_game_prev && is_solo_game() && self HasPerk(PERK_QUICK_REVIVE))
		{
			self zm_score::add_to_player_score(1500);
		}

		if(solo_game_prev && ! is_solo_game())
		{
			if(self HasPerk(PERK_QUICK_REVIVE))
			{
				self notify(PERK_QUICK_REVIVE + "_stop");
			}
			self LUINotifyEvent(&"quick_lives", 1, 0);
		}

		solo_game_prev = is_solo_game();
		wait(0.05);
	}
}

function solo_lives_check()
{
	return is_solo_game() && isdefined(level.solo_lives_given) && level.solo_lives_given < 3;
}

function is_solo_game()
{
	return level flag::exists("solo_game") &&  level flag::get("solo_game");
}