#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\zm\_zm;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;


#precache( "client_fx", "shadow/shadow_zombie_eyes" );
#precache( "client_fx", "shadow/shadow_zombie_cloak_eyes" );

#namespace zm_ai_shadowpeople;

REGISTER_SYSTEM( "zm_ai_shadowpeople", &__init__, undefined )

function __init__()
{
	//clientfield::register( "actor", "shadow_choker_fx", VERSION_SHIP, 1, "int", &shadow_choker_fx, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	//clientfield::register( "actor", "shadow_wizard_fx", VERSION_SHIP, 1, "int", &shadow_wizard_fx, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	visionset_mgr::register_visionset_info("abbey_shadow", VERSION_SHIP, 1, undefined, "abbey_shadow");
}

function shadow_choker_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )//self = shadow person
{
	if( newVal )
	{
		//self._eyeglow_fx_override = "shadow/shadow_zombie_eyes";
		//self zm::createZombieEyes( localClientNum );
		//self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, zm::get_eyeball_on_luminance(), self zm::get_eyeball_color() );
		self.shadow_eye_glow_fx = PlayFxOnTag( localClientNum, "shadow/shadow_zombie_eyes", self, "j_eyeball_le" );
	}
	else
	{
		//self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, zm::get_eyeball_off_luminance(), self zm::get_eyeball_color() );
		//self zm::deleteZombieEyes(localClientNum);
		
		if( isdefined( self.shadow_eye_glow_fx ) )
		{
			DeleteFX( localClientNum, self.shadow_eye_glow_fx );
		}
			
	}
}

function shadow_wizard_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )//self = shadow wizard
{
	if( newVal )
	{
		//self._eyeglow_fx_override = "shadow/shadow_zombie_eyes";
		//self zm::createZombieEyes( localClientNum );
		//self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, zm::get_eyeball_on_luminance(), self zm::get_eyeball_color() );
		self.shadow_eye_glow_fx = PlayFxOnTag( localClientNum, "shadow/shadow_zombie_cloak_eyes", self, "j_eyeball_le" );
	}
	else
	{
		//self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, zm::get_eyeball_off_luminance(), self zm::get_eyeball_color() );
		//self zm::deleteZombieEyes(localClientNum);
		
		if( isdefined( self.shadow_eye_glow_fx ) )
		{
			DeleteFX( localClientNum, self.shadow_eye_glow_fx );
		}
			
	}
}