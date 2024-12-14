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
	
	clientfield::register( "toplayer", "trials.aramis", VERSION_SHIP, 5, "float", &trial_aramis, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.porthos", VERSION_SHIP, 5, "float", &trial_porthos, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.dart", VERSION_SHIP, 5, "float", &trial_dart, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.athos", VERSION_SHIP, 5, "float", &trial_athos, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

	clientfield::register( "toplayer", "trials.aramis.random", VERSION_SHIP, 2, "int", &trial_aramis_random, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.porthos.random", VERSION_SHIP, 2, "int", &trial_porthos_random, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.dart.random", VERSION_SHIP, 2, "int", &trial_dart_random, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "toplayer", "trials.athos.random", VERSION_SHIP, 2, "int", &trial_athos_random, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
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
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.aramis.random" );
	SetUIModelValue( model, newVal );
}

function trial_porthos_random(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.porthos.random" );
	SetUIModelValue( model, newVal );
}

function trial_dart_random(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.dart.random" );
	SetUIModelValue( model, newVal );
}

function trial_athos_random(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
	model = CreateUIModel( GetUIModelForController( localClientNum ), "trials.athos.random" );
	SetUIModelValue( model, newVal );
}