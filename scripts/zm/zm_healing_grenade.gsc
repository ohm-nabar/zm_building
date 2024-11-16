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
#using scripts\zm\aats\_zm_aat_turned;

#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\shared\ai\zombie_utility;

#using scripts\zm\zm_juggernog_potions;

#precache ( "fx", "electric/fx_elec_sparks_burst_sm_physx_wind" );
#precache ( "fx", "custom/healing_grenade" );


// MAIN
//*****************************************************************************

function main()
{
	zm_utility::register_tactical_grenade_for_level( "zm_healing_grenade" );
	level.healingGrenade = GetWeapon( "zm_healing_grenade" );
	level.healingElectricEffect = "electric/fx_elec_sparks_burst_sm_physx_wind";

	level.zombie_weapons_callbacks[level.weaponZMCymbalMonkey] = &player_give_cymbal_monkey;
	zm_weapons::register_zombie_weapon_callback( level.healingGrenade, &player_give_healing_grenade);
	callback::on_connect( &on_player_connect );
	callback::on_laststand( &on_laststand );
}

function player_give_cymbal_monkey()
{
	self endon("disconnect");

	if ( isdefined( self zm_utility::get_player_tactical_grenade() ) )
	{
		self TakeWeapon( self zm_utility::get_player_tactical_grenade() );
	}
		
	self giveweapon( level.weaponZMCymbalMonkey );
	self zm_utility::set_player_tactical_grenade( level.weaponZMCymbalMonkey );
	self thread _zm_weap_cymbal_monkey::player_handle_cymbal_monkey();
}

function player_give_healing_grenade()
{
	self endon("disconnect");

	if ( isdefined( self zm_utility::get_player_tactical_grenade() ) )
	{
		self TakeWeapon( self zm_utility::get_player_tactical_grenade() );
	}
		
	self giveweapon( level.healingGrenade );
	self zm_utility::set_player_tactical_grenade( level.healingGrenade );
}

function on_player_connect()
{
	self flag::init(#"solo_healing_grenade");
	self.healing_vox_enabled = true;
	self thread check_thrown();
	self thread pullback_sound();
}


function check_thrown()
{
	self endon("disconnect");
	while(1)
	{
		self waittill( "grenade_fire", grenade, weapName );
		if( weapName == level.healingGrenade)
		{
			self PlaySoundOnTag("healing_throw", "tag_weapon_right");
			wait(0.05);
			level thread spawn_aura(grenade, self);
		}
		else
		{
			wait(0.05);
		}		
	}
}

function spawn_aura(grenade, reviver)
{
	grenade waittill("stationary");

	fx_pos = Spawn("script_model", grenade.origin);
	fx_pos SetModel("tag_origin");
	PlayFXOnTag("custom/healing_grenade", fx_pos, "tag_origin");
	PlaySoundAtPosition("healing_aura", grenade.origin);

	while( isdefined(grenade) && isdefined(reviver) )
	{
		//IPrintLn("Checking...");
		players = GetPlayers();
		for( i = 0; i < players.size; i++ )
		{
			players[i] thread players_check(grenade, reviver);
		}

		zombies = GetAISpeciesArray("axis", "all");
		for(i = 0; i < zombies.size; i++)
		{
			zombies[i] thread zombie_check(grenade, reviver);
		}

		wait(0.05);
	}
	
	fx_pos Delete();

	if(isdefined(reviver))
	{	
		reviver.healing_vox_enabled = true;
	}
}

function players_check(grenade, reviver)
{
	self endon("disconnect");

	if((self laststand::player_is_in_laststand() && DistanceSquared(grenade.origin, self.origin) <= 90000))
	{
		if(level flag::get("solo_game"))
		{
			self flag::set(#"solo_healing_grenade");
		}
		self thread zm_laststand::remote_revive( reviver );
		self zm_juggernog_potions::change_jug_resistance_level(true, 1);
		for(i = 0; i < self.perksToGiveBack.size; i++)
        {
        	self zm_perks::give_perk(self.perksToGiveBack[i], false);
        }
		if(reviver.healing_vox_enabled)
		{
			reviver zm_audio::create_and_play_dialog( "general", "healing_grenade" );
			reviver.healing_vox_enabled = false;
		}
	}	
}

function zombie_check(grenade, player)
{
	self endon("death");

	if(IS_TRUE(self.completed_emerging_into_playable_area) && (! self.healingElectric || ! IsDefined(self.healingElectric)) && self.targetname != "zombie_choker" && self.targetname != "zombie_cloak" && self.targetname != "zombie_escargot" && DistanceSquared(grenade.origin, self.origin) <= 90000)
	{
		self zm_aat_turned::result("death", player, "MOD_UNKNOWN", level.healingGrenade);
	}
}

function on_laststand()
{
	self endon("disconnect");

    self.perksToGiveBack = self zm_perks::get_perk_array();
    self waittill("player_revived");
    self.perksToGiveBack = [];
}

function pullback_sound()
{
	self endon("disconnect");

	while(true)
	{
		self waittill("grenade_pullback", weapName);
		if(weapName == level.healingGrenade)
		{
			self PlaySoundOnTag("healing_windup", "tag_weapon_right");
		}
	}
}

