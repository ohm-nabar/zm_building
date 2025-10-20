#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_blueprints;

REGISTER_SYSTEM( "zm_blueprints", &__init__, undefined )
	
function __init__()
{
	level clientfield::register( "clientuimodel", "weaponBPUpdate", VERSION_SHIP, 3, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	level clientfield::register( "clientuimodel", "perkBPUpdate", VERSION_SHIP, 3, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}