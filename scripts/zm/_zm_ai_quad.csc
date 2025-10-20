#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;
#insert scripts\zm\_zm_ai_quad.gsh;

#namespace zm_ai_quad; 

#precache( "client_fx", "shadow/fx_quad_teleport_in_shadow" );
#precache( "client_fx", "shadow/fx_quad_teleport_out_shadow" );
#precache( "client_fx", "shadow/fx_zombie_quad_trail_shadow" );
#precache( "client_fx", "shadow/fx_zombie_quad_gas_shadow" );

REGISTER_SYSTEM_EX( "zm_ai_quad", &__init__, &__main__, undefined )

// ============================== INITIALIZE ==============================

function __init__()
{
	level clientfield::register( "actor", "quad_phase", VERSION_SHIP, 2, "int", &quad_phase, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "scriptmover", "quad_trail", VERSION_SHIP, 1, "int", &quad_trail, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "scriptmover", "quad_explo", VERSION_SHIP, 1, "int", &quad_explo, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function __main__()
{
	level visionset_mgr::register_overlay_info_style_blur( "zm_ai_quad_blur", 21000, 1, 0.1, 0.5, 4 );
}

function quad_phase(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.fx))
  	{
        DeleteFX(localClientNum, self.fx);
  		self.fx = undefined;
    }
  	if(newVal == 0)
  	{
    	self.fx = PlayFXOnTag(localClientNum, "shadow/fx_quad_teleport_in_shadow", self, "j_spine4");
  	}
	else
	{
		self.fx = PlayFXOnTag(localClientNum, "shadow/fx_quad_teleport_out_shadow", self, "j_spine4");
	}
}

function quad_trail(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.fx))
  	{
        DeleteFX(localClientNum, self.fx);
  		self.fx = undefined;
    }
  	if(newVal == 1)
  	{
    	self.fx = PlayFXOnTag(localClientNum, "shadow/fx_zombie_quad_trail_shadow", self, "j_spine4");
  	}
}

function quad_explo(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
  	if(newVal == 1)
  	{
    	PlayFX(localClientNum, "shadow/fx_zombie_quad_gas_shadow", self.origin);
  	}
}