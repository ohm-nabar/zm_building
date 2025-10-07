#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;

#insert scripts\shared\shared.gsh;

#using scripts\zm\aats\_zm_aat_turned;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_ai_shadowpeople;
#using scripts\zm\zm_juggernog_potions;

#insert scripts\zm\zm_armory.gsh;

#precache( "fx", "custom/healing_grenade" );
#precache( "fx", "dlc3/stalingrad/fx_cymbal_monkey_radial_pulse" );

#define HEALING_GRENADE_RADIUS 300
#define TURNED_KILL_RADIUS_SQ 50
#define MAX_TURNED_ZOMBIES 3
#define MAX_TURNED_ZOMBIES_UPGRADED 8

// MAIN
//*****************************************************************************

function main()
{
	zm_utility::register_tactical_grenade_for_level( "zm_healing_grenade" );
	level.healingGrenade = GetWeapon( "zm_healing_grenade" );
	level.healingGrenadeUpgraded = GetWeapon( "zm_healing_grenade_up" );
	level._effect["monkey_bass"] 	= "dlc3/stalingrad/fx_cymbal_monkey_radial_pulse";

	level.zombie_weapons_callbacks[level.weaponZMCymbalMonkey] = &player_give_cymbal_monkey;
	level.zombie_weapons_callbacks[level.w_cymbal_monkey_upgraded] = &player_give_cymbal_monkey_up;
	level zm_weapons::register_zombie_weapon_callback( level.healingGrenade, &player_give_healing_grenade);
	level zm_weapons::register_zombie_weapon_callback( level.healingGrenadeUpgraded, &player_give_healing_grenade_up);
	level callback::on_connect( &on_player_connect );
	level callback::on_laststand( &on_laststand );
}

function player_give_cymbal_monkey()
{
	self endon("disconnect");

	if ( isdefined( self zm_utility::get_player_tactical_grenade() ) )
	{
		self TakeWeapon( self zm_utility::get_player_tactical_grenade() );
	}
	
	if(self.b_has_upgraded_cymbal_monkey)
	{
		self GiveWeapon( level.w_cymbal_monkey_upgraded );
		self zm_utility::set_player_tactical_grenade( level.w_cymbal_monkey_upgraded );
	}
	else
	{
		self GiveWeapon( level.weaponZMCymbalMonkey );
		self zm_utility::set_player_tactical_grenade( level.weaponZMCymbalMonkey );
	}
	
	self thread _zm_weap_cymbal_monkey::player_handle_cymbal_monkey();
}

function player_give_cymbal_monkey_up()
{
	self endon("disconnect");

	if ( isdefined( self zm_utility::get_player_tactical_grenade() ) )
	{
		self TakeWeapon( self zm_utility::get_player_tactical_grenade() );
	}
	
	// If we got it from Crate Power, set upgrade to true
	self.b_has_upgraded_cymbal_monkey = true;

	self GiveWeapon( level.w_cymbal_monkey_upgraded );
	self zm_utility::set_player_tactical_grenade( level.w_cymbal_monkey_upgraded );

	self thread _zm_weap_cymbal_monkey::player_handle_cymbal_monkey();
}

function player_give_healing_grenade()
{
	self endon("disconnect");

	if ( isdefined( self zm_utility::get_player_tactical_grenade() ) )
	{
		self TakeWeapon( self zm_utility::get_player_tactical_grenade() );
	}

	if(self.b_has_upgraded_healing_grenade)
	{
		self GiveWeapon( level.healingGrenadeUpgraded );
		self zm_utility::set_player_tactical_grenade( level.healingGrenadeUpgraded );
	}
	else
	{
		self GiveWeapon( level.healingGrenade );
		self zm_utility::set_player_tactical_grenade( level.healingGrenade );
	}
}

function player_give_healing_grenade_up()
{
	self endon("disconnect");

	if ( isdefined( self zm_utility::get_player_tactical_grenade() ) )
	{
		self TakeWeapon( self zm_utility::get_player_tactical_grenade() );
	}

	// If we got it from Crate Power, set upgrade to true
	self.b_has_upgraded_healing_grenade = true;

	self GiveWeapon( level.healingGrenadeUpgraded );
	self zm_utility::set_player_tactical_grenade( level.healingGrenadeUpgraded );
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
		if( weapName == level.healingGrenade || weapName == level.healingGrenadeUpgraded )
		{
			self PlaySoundOnTag("healing_throw", "tag_weapon_right");
			wait(0.05);
			level thread spawn_aura(grenade, self, weapName);
		}
		else
		{
			wait(0.05);
		}		
	}
}

function spawn_aura(grenade, reviver, weapon)
{
	grenade waittill("stationary");

	fx_pos = Spawn("script_model", grenade.origin);
	fx_pos SetModel("tag_origin");
	PlayFXOnTag("custom/healing_grenade", fx_pos, "tag_origin");
	PlaySoundAtPosition("healing_aura", grenade.origin);

	max_turned = MAX_TURNED_ZOMBIES;
	if(weapon == level.healingGrenadeUpgraded)
	{
		max_turned = MAX_TURNED_ZOMBIES_UPGRADED;
	}

	grenade.zombies_turned = 0;

	while( isdefined(grenade) && isdefined(reviver) )
	{
		players = GetPlayers();
		for( i = 0; i < players.size; i++ )
		{
			players[i] thread players_check(grenade, reviver);
		}

		zombies = GetAISpeciesArray("axis", "all");
		closest_zombies = level array::get_all_closest(grenade.origin, GetAITeamArray( "axis" ), undefined, undefined, HEALING_GRENADE_RADIUS);
		foreach(zombie in closest_zombies)
		{
			if(grenade.zombies_turned < max_turned)
			{
				zombie zombie_check(grenade, reviver);
			}
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

	radius_sq = HEALING_GRENADE_RADIUS * HEALING_GRENADE_RADIUS;
	if((self laststand::player_is_in_laststand() && DistanceSquared(grenade.origin, self.origin) <= radius_sq))
	{
		if(level flag::get("solo_game"))
		{
			self flag::set(#"solo_healing_grenade");
		}
		else if(self == reviver)
		{
			return;
		}
		self thread zm_laststand::remote_revive( reviver );
		self zm_juggernog_potions::maintain_jug_resistance_level();
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

function upgrade_kills_track(zombie)
{
	self endon("disconnect");

	prev_turned_kills = 0;
	while(isdefined(zombie))
	{
		if(zombie.n_aat_turned_zombie_kills > prev_turned_kills)
		{
			kill_diff = zombie.n_aat_turned_zombie_kills - prev_turned_kills;
			prev_turned_kills = zombie.n_aat_turned_zombie_kills;
			if(self.healing_grenade_upgrade_kills < HEALING_UPGRADE_KILLS)
			{
				self.healing_grenade_upgrade_kills += kill_diff;
				if(self.healing_grenade_upgrade_kills >= HEALING_UPGRADE_KILLS)
				{
					IPrintLn("Healing Grenade upgrade ready!");
				}
			}
		}
		wait(0.05);
	}
}

function extra_validation()
{
	if(! (isdefined(self) && IsAlive(self)))
	{
		return false;
	}
	if(IS_EQUAL(self.team, "allies"))
	{
		return false;
	}

	return true;
}

function zombie_check(grenade, player)
{
	self endon("death");

	if(self zm_aat_turned::turned_zombie_validation() && self extra_validation() && ! self zm_ai_shadowpeople::is_shadow_person())
	{
		zombies = GetAISpeciesArray("axis", "all");
		ArrayRemoveValue(zombies, self);
		foreach(zombie in zombies)
		{
			if(DistanceSquared(self.origin, zombie.origin) <= TURNED_KILL_RADIUS_SQ)
			{
				zombie DoDamage(zombie.health + 666, grenade.origin, player, player);
			}
		}
		self zm_aat_turned::result("death", player, "MOD_UNKNOWN", level.healingGrenade);

		if(player.healing_grenade_upgrade_kills < HEALING_UPGRADE_KILLS)
		{
			player thread upgrade_kills_track(self);
		}
		grenade.zombies_turned += 1;
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

