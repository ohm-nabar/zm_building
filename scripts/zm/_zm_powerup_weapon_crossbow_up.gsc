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

#namespace zm_powerup_weapon_crossbow_up;

REGISTER_SYSTEM( "zm_powerup_weapon_crossbow_up", &__init__, undefined )

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	zm_powerups::register_powerup( "crossbow_up", &grab_crossbow_up );
	zm_powerups::register_powerup_weapon( "crossbow_up", &crossbow_up_countdown );
	zm_powerups::powerup_set_prevent_pick_up_if_drinking( "crossbow_up", true );
	zm_powerups::powerup_set_statless_powerup( "crossbow_up" );
	zm_powerups::set_weapon_ignore_max_ammo( "crossbow_up" );

	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "crossbow_up", "zombie_pickup_minigun", &"ZOMBIE_POWERUP_MINIGUN", &func_should_drop_crossbow_up, POWERUP_ONLY_AFFECTS_GRABBER, !POWERUP_ANY_TEAM, !POWERUP_ZOMBIE_GRABBABLE, undefined, "powerup_crossbow_up", "zombie_powerup_crossbow_up_time", "zombie_powerup_crossbow_up_on" );
		level.zombie_powerup_weapon[ "crossbow_up" ] = GetWeapon( "zm_crossbow_up" );
	}
	
	callback::on_connect( &init_player_zombie_vars);
	zm::register_actor_damage_callback( &crossbow_up_damage_adjust );
}

function grab_crossbow_up( player )
{	
	level thread crossbow_up_weapon_powerup( player );

	if( IsDefined( level._grab_crossbow_up ) )
	{
		level thread [[ level._grab_crossbow_up ]]( player );
	}
}

//	Creates zombie_vars that need to be tracked on an individual basis rather than as
//	a group.
function init_player_zombie_vars()
{	
	self.zombie_vars[ "zombie_powerup_crossbow_up_on" ] = false; // awful lawton
	self.zombie_vars[ "zombie_powerup_crossbow_up_time" ] = 0;
}

function func_should_drop_crossbow_up()
{
	return false;
}

//******************************************************************************
// Awful Lawton powerup
//******************************************************************************
function crossbow_up_weapon_powerup( ent_player, time )
{
	ent_player endon( "disconnect" );
	ent_player endon( "death" );
	ent_player endon( "player_downed" );
	
	if ( !IsDefined( time ) )
	{
		time = 30;
	}
	if(isDefined(level._crossbow_up_time_override))
	{
		time = level._crossbow_up_time_override;
	}

	// Just replenish the time if it's already active
	if ( ent_player.zombie_vars[ "zombie_powerup_crossbow_up_on" ] && 
		 (level.zombie_powerup_weapon[ "crossbow_up" ] == ent_player GetCurrentWeapon() || (IsDefined(ent_player.has_powerup_weapon[ "crossbow_up" ]) && ent_player.has_powerup_weapon[ "crossbow_up" ]) ))
	{
		if ( ent_player.zombie_vars["zombie_powerup_crossbow_up_time"] < time )
		{
			ent_player.zombie_vars["zombie_powerup_crossbow_up_time"] = time;
		}
		return;
	}
	
	// make sure weapons are replaced properly if the player is downed
	level._zombie_crossbow_up_powerup_last_stand_func = &crossbow_up_powerup_last_stand;
	
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
	
	zm_powerups::weapon_powerup( ent_player, time, "crossbow_up", true );
	
	if( stance_disabled )
	{
		ent_player AllowCrouch( true );
		ent_player AllowProne( true );
	}
}

function crossbow_up_powerup_last_stand()
{
	zm_powerups::weapon_watch_gunner_downed( "crossbow_up" );
}

function crossbow_up_countdown( ent_player, str_weapon_time )
{
	while ( ent_player.zombie_vars[str_weapon_time] > 0)
	{
		WAIT_SERVER_FRAME;
		ent_player.zombie_vars[str_weapon_time] = ent_player.zombie_vars[str_weapon_time] - 0.05;
	}	
}

function crossbow_up_weapon_powerup_off()
{
	self.zombie_vars["zombie_powerup_crossbow_up_time"] = 0;
}

function crossbow_up_damage_adjust(  inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType  ) //self is an enemy
{
	if ( weapon.name != "zm_crossbow_up" )
	{
		// Don't affect damage dealt if the weapon isn't the awful lawton, allow other damage callbacks to be evaluated - mbettelman 1/28/2016
		return -1;
	}
	if ( ! (isdefined(self.targetname) && (self.targetname == "zombie_cloak" || self.targetname == "zombie_escargot")))
	{
		return self.health + 666;
	}

	return -1;
}

