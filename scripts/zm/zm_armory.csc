#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#precache( "client_fx", "custom/fx_trail_blood_soul_zmb" );

#namespace zm_armory;

REGISTER_SYSTEM( "zm_armory", &__init__, undefined )

function __init__()
{
	level clientfield::register( "scriptmover", "fx_floating_orb_glow", VERSION_SHIP, 1, "int", &fx_floating_orb_glow, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function fx_floating_orb_glow(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.fx))
  	{
        DeleteFX(localClientNum, self.fx);
  		self.fx = undefined;
    }
  	if(newVal == 1)
  	{
    	self.fx = PlayFXOnTag(localClientNum, "custom/fx_trail_blood_soul_zmb", self, "tag_origin");
  	}
}