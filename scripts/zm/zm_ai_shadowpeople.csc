#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\zm\_zm;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#precache( "client_fx", "shadow/cloak_shadowing" );
#precache( "client_fx", "shadow/fx_zmb_smokey_death" );
#precache( "client_fx", "zombie/fx_dog_lightning_buildup_zmb" );

#namespace zm_ai_shadowpeople;

REGISTER_SYSTEM( "zm_ai_shadowpeople", &__init__, undefined )

function __init__()
{
	level clientfield::register( "clientuimodel", "shadowPerks", VERSION_SHIP, 3, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "actor", "cloak_shadowing", VERSION_SHIP, 1, "int", &cloak_shadowing, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "actor", "shadow_death", VERSION_SHIP, 1, "int", &shadow_death, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "scriptmover", "lightning_spawn", VERSION_SHIP, 1, "int", &lightning_spawn, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	level visionset_mgr::register_visionset_info("abbey_shadow", VERSION_SHIP, 1, undefined, "abbey_shadow");
}

function cloak_shadowing(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		PlayFXOnTag(localClientNum, "shadow/cloak_shadowing", self, "tag_weapon_right");
	}
}


function shadow_death(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		PlayFX(localClientNum, "shadow/fx_zmb_smokey_death", self.origin + (0, 0, 40));
	}
}

function lightning_spawn(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(newVal == 1)
	{
		PlayFX(localClientNum, "zombie/fx_dog_lightning_buildup_zmb", self.origin);
	}
}