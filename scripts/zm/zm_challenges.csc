#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_challenges;

REGISTER_SYSTEM( "zm_challenges", &__init__, undefined )
	
function __init__()
{
	clientfield::register( "toplayer", "trials.tier1", VERSION_SHIP, 7, "int", &trial_tier1, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.tier2", VERSION_SHIP, 13, "int", &trial_tier2, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.tier3", VERSION_SHIP, 5, "int", &trial_tier3, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	
	clientfield::register( "toplayer", "trials.aramis", VERSION_SHIP, 4, "float", &trial_aramis, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.porthos", VERSION_SHIP, 8, "float", &trial_porthos, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.dart", VERSION_SHIP, 8, "float", &trial_dart, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.athos", VERSION_SHIP, 8, "float", &trial_athos, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	clientfield::register( "toplayer", "trials.aramisRandom", VERSION_SHIP, 4, "int", &trial_aramis_random, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.porthosRandom", VERSION_SHIP, 4, "int", &trial_porthos_random, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.dartRandom", VERSION_SHIP, 4, "int", &trial_dart_random, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.athosRandom", VERSION_SHIP, 4, "int", &trial_athos_random, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	clientfield::register( "clientuimodel", "athosTrial", VERSION_SHIP, 5, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "clientuimodel", "athosWaypoints", VERSION_SHIP, 1, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "clientuimodel", "shadowTrial", VERSION_SHIP, 1, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	clientfield::register( "toplayer", "trials.playerCountChange", VERSION_SHIP, 1, "int", &trial_player_count_change, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function trial_tier1(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.tier1" );
	SetUIModelValue( model, newVal );
}

function trial_tier2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.tier2" );
	SetUIModelValue( model, newVal );
}

function trial_tier3(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.tier3" );
	SetUIModelValue( model, newVal );
}

function trial_aramis(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.aramis" );
	SetUIModelValue( model, newVal );
}

function trial_porthos(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.porthos" );
	SetUIModelValue( model, newVal );
}

function trial_dart(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.dart" );
	SetUIModelValue( model, newVal );
}

function trial_athos(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.athos" );
	SetUIModelValue( model, newVal );
}

function trial_aramis_random(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.aramisRandom" );
	SetUIModelValue( model, newVal );
}

function trial_porthos_random(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.porthosRandom" );
	SetUIModelValue( model, newVal );
}

function trial_dart_random(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.dartRandom" );
	SetUIModelValue( model, newVal );
}

function trial_athos_random(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.athosRandom" );
	SetUIModelValue( model, newVal );
}

function trial_player_count_change(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.playerCountChange" );
	SetUIModelValue( model, newVal );
}