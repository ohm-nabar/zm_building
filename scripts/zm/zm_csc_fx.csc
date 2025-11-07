#using scripts\shared\ai\zombie_death;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#precache( "client_fx", "custom/fx_trail_blood_soul_zmb" );
#precache( "client_fx", "zombie/fx_trap_green_light_doa" );
#precache( "client_fx", "custom/healing_grenade" );
#precache( "client_fx", "custom/fx_zmb_shadow_explode" );
#precache( "client_fx", "custom/pistol_glint" );
#precache( "client_fx", "redspace/fx_launchpad_blue" );
#precache( "client_fx", "redspace/fx_launchpad_red" );
#precache( "client_fx", "dlc5/zmhd/fx_zombie_auto_turret_light" );
#precache( "client_fx", "dlc1/castle/fx_castle_electric_cherry_down" );
#precache( "client_fx", "dlc5/zmb_weapon/fx_area_effect" );

REGISTER_SYSTEM( "zm_csc_fx", &__init__, undefined )

// For shared FX and scripts without existing CSCs
function __init__()
{
    level clientfield::register( "scriptmover", "fx_floating_orb_glow", VERSION_SHIP, 1, "int", &fx_floating_orb_glow, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    level clientfield::register( "missile", "semtex_light", VERSION_SHIP, 1, "int", &semtex_light, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    level clientfield::register( "scriptmover", "healing_aura", VERSION_SHIP, 1, "int", &healing_aura, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    level clientfield::register( "actor", "diedrich_explo", VERSION_SHIP, 1, "int", &diedrich_explo, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "scriptmover", "pickup_glint", VERSION_SHIP, 1, "int", &pickup_glint, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "actor", "trap_flame", VERSION_SHIP, 1, "int", &trap_flame, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "scriptmover", "turret_light", VERSION_SHIP, 1, "int", &turret_light, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "allplayers", "cherry_explode", VERSION_SHIP, 1, "int", &cherry_explode, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
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

function semtex_light(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.fx))
  	{
        DeleteFX(localClientNum, self.fx);
  		self.fx = undefined;
    }
  	if(newVal == 1)
  	{
    	self.fx = PlayFXOnTag(localClientNum, "zombie/fx_trap_green_light_doa", self, "tag_origin");
  	}
}

function healing_aura(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.fx))
  	{
        DeleteFX(localClientNum, self.fx);
  		self.fx = undefined;
    }
  	if(newVal == 1)
  	{
    	self.fx = PlayFXOnTag(localClientNum, "custom/healing_grenade", self, "tag_origin");
  	}
	else
	{
		self.fx = PlayFXOnTag(localClientNum, "dlc5/zmb_weapon/fx_area_effect", self, "tag_origin");
	}
}

function diedrich_explo(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
  	if(newVal == 1)
  	{
    	PlayFX(localClientNum, "custom/fx_zmb_shadow_explode", self.origin);
  	}
}

function pickup_glint(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	if(isdefined(self.fx))
  	{
        DeleteFX(localClientNum, self.fx);
  		self.fx = undefined;
    }
  	if(newVal == 1)
  	{
    	self.fx = PlayFXOnTag(localClientNum, "custom/pistol_glint", self, "tag_origin");
  	}
}

function trap_flame(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
  	if(newVal == 1)
  	{
		self thread zombie_death::flame_death_fx(localClientNum);
    	PlayFXOnTag(localClientNum, level._effect["character_fire_death_torso"], self, "J_SpineLower");
  	}
}

function turret_light(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
  	if(newVal == 1)
  	{
    	PlayFXOnTag(localClientNum, "dlc5/zmhd/fx_zombie_auto_turret_light", self, "tag_origin");
  	}
}

function cherry_explode(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
  	if(newVal == 1)
  	{
    	PlayFX(localClientNum, "dlc1/castle/fx_castle_electric_cherry_down", self.origin);
  	}
}