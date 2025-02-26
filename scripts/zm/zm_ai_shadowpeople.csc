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
	clientfield::register( "clientuimodel", "shadowPerks", VERSION_SHIP, 3, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	visionset_mgr::register_visionset_info("abbey_shadow", VERSION_SHIP, 1, undefined, "abbey_shadow");
}