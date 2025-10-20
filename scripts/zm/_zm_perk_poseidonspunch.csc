#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm_perks;

#insert scripts\zm\_zm_perk_poseidonspunch.gsh;
#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache( "client_fx", "water/fx_water_splash_xxxlg" );

#namespace zm_perk_poseidonspunch;

REGISTER_SYSTEM( "zm_perk_poseidonspunch", &__init__, undefined )

// QUICK REVIVE ( QUICK REVIVE )
	
function __init__()
{
	level clientfield::register( "clientuimodel", "poseidonCharge", VERSION_SHIP, 1, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "allplayers", "poseidon_splash", VERSION_SHIP, 1, "int", &poseidon_splash, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	level enable_custom_perk_for_level();
}

function enable_custom_perk_for_level()
{
	// register custom functions for hud/lua
	level zm_perks::register_perk_clientfields( PERK_POSEIDON_PUNCH, &custom_perk_client_field_func, &custom_perk_callback_func );
	level zm_perks::register_perk_effects( PERK_POSEIDON_PUNCH, POSEIDON_PUNCH_MACHINE_LIGHT_FX );
	level zm_perks::register_perk_init_thread( PERK_POSEIDON_PUNCH, &init_custom_perk );
}

function init_custom_perk()
{
	/*
	if( IS_TRUE(level.enable_magic) )
	{
		level._effect[QUICK_REVIVE_MACHINE_LIGHT_FX]	= "zombie/fx_perk_quick_revive_zmb";
	}	
	*/
}

function custom_perk_client_field_func()
{
	level clientfield::register( "clientuimodel", PERK_CLIENTFIELD_POSEIDON_PUNCH, VERSION_SHIP, 2, "int", undefined, !CF_HOST_ONLY, CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function custom_perk_callback_func()
{
}

function poseidon_splash(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.fx))
  	{
        DeleteFX(localClientNum, self.fx);
  		self.fx = undefined;
    }
  	if(newVal == 1)
  	{
    	self.fx = PlayFXOnTag(localClientNum, "water/fx_water_splash_xxxlg", self, "tag_weapon_right");
  	}
}