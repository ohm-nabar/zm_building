#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#precache( "client_fx", "custom/trident_linger" );
#precache( "client_fx", "custom/trident_glow" );
#precache( "client_fx", "custom/whirlpool" );
#precache( "client_fx", "custom/water_rings" );
#precache( "client_fx", "custom/fx_trail_blood_soul_zmb" );

#namespace zm_trident;

REGISTER_SYSTEM( "zm_trident", &__init__, undefined )
	
function __init__()
{
	level clientfield::register( "actor", "trident_linger", VERSION_SHIP, 1, "int", &trident_linger, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "allplayers", "trident_glow", VERSION_SHIP, 2, "int", &trident_glow, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "scriptmover", "trident_ring", VERSION_SHIP, 1, "int", &trident_ring, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "scriptmover", "trident_whirlpool", VERSION_SHIP, 1, "int", &trident_whirlpool, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "scriptmover", "fx_floating_orb_glow", VERSION_SHIP, 1, "int", &fx_floating_orb_glow, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "clientuimodel", "tridentClip", VERSION_SHIP, 1, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function trident_linger( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )//self = zombie
{
	if( newVal && ! isdefined( self.trident_linger ) )
	{
		//IPrintLnBold("lingering");
		self.trident_linger = PlayFxOnTag( localClientNum, "custom/trident_linger", self, "j_spinelower" );
	}
	else
	{
		if( isdefined( self.trident_linger ) )
		{
			DeleteFX( localClientNum, self.trident_linger );
			self.trident_linger = undefined;
		}
			
	}
}

function trident_glow( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )//self = zombie
{
	if( newVal >= 3 && ! isdefined( self.trident_glow3 ) )
	{
		self.trident_glow3 = PlayViewmodelFX( localClientNum, "custom/trident_glow", "tag_fx" );
	}
	if( newVal >= 2 && ! isdefined( self.trident_glow2 ) )
	{
		self.trident_glow2 = PlayViewmodelFX( localClientNum, "custom/trident_glow", "tag_fx_l" );
	}
	if( newVal >= 1 && ! isdefined( self.trident_glow ) )
	{
		self.trident_glow = PlayViewmodelFX( localClientNum, "custom/trident_glow", "tag_fx_r" );
	}
	if( newVal == 0 )
	{
		if( isdefined( self.trident_glow3 ) )
		{
			DeleteFX( localClientNum, self.trident_glow3, true );
			self.trident_glow3 = undefined;
		}
		if( isdefined( self.trident_glow2 ) )
		{
			DeleteFX( localClientNum, self.trident_glow2, true );
			self.trident_glow2 = undefined;
		}
		if( isdefined( self.trident_glow ) )
		{
			DeleteFX( localClientNum, self.trident_glow, true );
			self.trident_glow = undefined;
		}
	}
}

function trident_ring(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.fx))
  	{
        DeleteFX(localClientNum, self.fx);
  		self.fx = undefined;
    }
  	if(newVal == 1)
  	{
    	self.fx = PlayFXOnTag(localClientNum, "custom/water_rings", self, "tag_origin");
  	}
}

function trident_whirlpool(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.fx))
  	{
        DeleteFX(localClientNum, self.fx);
  		self.fx = undefined;
    }
  	if(newVal == 1)
  	{
    	self.fx = PlayFXOnTag(localClientNum, "custom/whirlpool", self, "tag_origin");
  	}
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