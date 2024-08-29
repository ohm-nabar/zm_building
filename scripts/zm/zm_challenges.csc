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
	clientfield::register( "clientuimodel", "trialProgress", VERSION_SHIP, 5, "float", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "clientuimodel", "trialReward", VERSION_SHIP, 2, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "clientuimodel", "trialTimer", VERSION_SHIP, 2, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "clientuimodel", "trialName", VERSION_SHIP, 6, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	/*
	clientfield::register( "clientuimodel", "soloChallengeUpdate", VERSION_SHIP, 13, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT  );
	clientfield::register( "clientuimodel", "soloQueueUpdate", VERSION_SHIP, 2, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT  );
	clientfield::register( "clientuimodel", "teamChallengeUpdate", VERSION_SHIP, 13, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT  );
	clientfield::register( "clientuimodel", "teamQueueUpdate", VERSION_SHIP, 2, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT  );
	*/
}