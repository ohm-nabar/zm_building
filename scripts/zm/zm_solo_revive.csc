#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_solo_revive;

REGISTER_SYSTEM( "zm_solo_revive", &__init__, undefined )
	
function __init__()
{
	clientfield::register( "clientuimodel", "soloLivesUpdate", VERSION_SHIP, 2, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}