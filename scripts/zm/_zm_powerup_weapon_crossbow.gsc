#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\archetype_shared\archetype_shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\ai\zombie_death;

#using scripts\zm\_zm;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#insert scripts\zm\_zm_powerups.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache( "material", "specialty_giant_crossbow_zombies" );

#namespace zm_powerup_weapon_crossbow;

REGISTER_SYSTEM( "zm_powerup_weapon_crossbow", &__init__, undefined )

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	zm_powerups::register_powerup( "crossbow", &grab_crossbow );
	zm_powerups::register_powerup_weapon( "crossbow", &crossbow_countdown );
	zm_powerups::powerup_set_prevent_pick_up_if_drinking( "crossbow", true );
	zm_powerups::powerup_set_statless_powerup( "crossbow" );
	zm_powerups::set_weapon_ignore_max_ammo( "crossbow" );

	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "crossbow", "zombie_pickup_minigun", &"ZOMBIE_POWERUP_MINIGUN", &func_should_drop_crossbow, POWERUP_ONLY_AFFECTS_GRABBER, !POWERUP_ANY_TEAM, !POWERUP_ZOMBIE_GRABBABLE, undefined, "powerup_crossbow", "zombie_powerup_crossbow_time", "zombie_powerup_crossbow_on" );
		level.zombie_powerup_weapon[ "crossbow" ] = GetWeapon( "zm_crossbow" );
	}
	
	callback::on_connect( &init_player_zombie_vars);
	zm::register_actor_damage_callback( &crossbow_damage_adjust );
}

function grab_crossbow( player )
{	
	level thread crossbow_weapon_powerup( player );

	if( IsDefined( level._grab_crossbow ) )
	{
		level thread [[ level._grab_crossbow ]]( player );
	}
}

//	Creates zombie_vars that need to be tracked on an individual basis rather than as
//	a group.
function init_player_zombie_vars()
{	
	self.zombie_vars[ "zombie_powerup_crossbow_on" ] = false; // crossbow
	self.zombie_vars[ "zombie_powerup_crossbow_time" ] = 0;
}

function func_should_drop_crossbow()
{
	return false;
}

//******************************************************************************
// Crossbow powerup
//******************************************************************************
function crossbow_weapon_powerup( ent_player, time )
{
	ent_player endon( "disconnect" );
	ent_player endon( "death" );
	ent_player endon( "player_downed" );
	
	if ( !IsDefined( time ) )
	{
		time = 30;
	}
	if(isDefined(level._crossbow_time_override))
	{
		time = level._crossbow_time_override;
	}

	// Just replenish the time if it's already active
	if ( ent_player.zombie_vars[ "zombie_powerup_crossbow_on" ] && 
		 (level.zombie_powerup_weapon[ "crossbow" ] == ent_player GetCurrentWeapon() || (IsDefined(ent_player.has_powerup_weapon[ "crossbow" ]) && ent_player.has_powerup_weapon[ "crossbow" ]) ))
	{
		if ( ent_player.zombie_vars["zombie_powerup_crossbow_time"] < time )
		{
			ent_player.zombie_vars["zombie_powerup_crossbow_time"] = time;
		}
		return;
	}
	
	// make sure weapons are replaced properly if the player is downed
	level._zombie_crossbow_powerup_last_stand_func = &crossbow_powerup_last_stand;
	
	stance_disabled = false;
	//powerup cannot be switched to if player is in prone
	if( ent_player GetStance() === "prone" )
	{
		ent_player AllowCrouch( false );
		ent_player AllowProne( false );
		stance_disabled = true;
		
		while( ent_player GetStance() != "stand" )
		{
			WAIT_SERVER_FRAME;
		}
	}
	
	zm_powerups::weapon_powerup( ent_player, time, "crossbow", true );
	
	if( stance_disabled )
	{
		ent_player AllowCrouch( true );
		ent_player AllowProne( true );
	}
}

function crossbow_powerup_last_stand()
{
	zm_powerups::weapon_watch_gunner_downed( "crossbow" );
}

function crossbow_countdown( ent_player, str_weapon_time )
{
	while ( ent_player.zombie_vars[str_weapon_time] > 0)
	{
		WAIT_SERVER_FRAME;
		ent_player.zombie_vars[str_weapon_time] = ent_player.zombie_vars[str_weapon_time] - 0.05;
	}	
}

function crossbow_weapon_powerup_off()
{
	self.zombie_vars["zombie_powerup_crossbow_time"] = 0;
}

function crossbow_damage_adjust(  inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType  ) //self is an enemy
{
	if ( weapon.name != "zm_crossbow" )
	{
		// Don't affect damage dealt if the weapon isn't the crossbow, allow other damage callbacks to be evaluated - mbettelman 1/28/2016
		return -1;
	}
	if ( ! (isdefined(self.targetname) && (self.targetname == "zombie_cloak" || self.targetname == "zombie_escargot")))
	{
		return self.health + 666;
	}

	return -1;
}

