#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#precache( "client_fx", "custom/trident_linger" );
#precache( "client_fx", "custom/trident_glow" );

#namespace zm_trident;

REGISTER_SYSTEM( "zm_trident", &__init__, undefined )
	
function __init__()
{
	clientfield::register( "actor", "trident_linger", VERSION_SHIP, 1, "int", &trident_linger, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "allplayers", "trident_glow", VERSION_SHIP, 2, "int", &trident_glow, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
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