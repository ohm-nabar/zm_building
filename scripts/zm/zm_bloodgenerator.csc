#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\zm\_zm;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_bloodgenerator;

REGISTER_SYSTEM( "zm_bloodgenerator", &__init__, undefined )

function __init__()
{
	clientfield::register( "clientuimodel", "bloodVial", VERSION_SHIP, 4, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}