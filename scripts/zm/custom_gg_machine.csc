#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace custom_gg_machine;

REGISTER_SYSTEM( "custom_gg_machine", &__init__, undefined )
	
function __init__()
{
	clientfield::register( "toplayer", "gum.eaten", VERSION_SHIP, 5, "int", &gum_eaten, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function gum_eaten(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "gum.eaten" );
	SetUIModelValue( model, newVal );
}