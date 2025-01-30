#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_perk_upgrades_effects;

REGISTER_SYSTEM( "zm_perk_upgrades_effects", &__init__, undefined )
	
function __init__()
{
	clientfield::register( "clientuimodel", "muleIndicator", VERSION_SHIP, 1, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}