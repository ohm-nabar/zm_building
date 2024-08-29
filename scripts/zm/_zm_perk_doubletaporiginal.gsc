#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#insert scripts\zm\_zm_perk_doubletaporiginal.gsh;
#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_utility.gsh;

//#precache( "material", QUICK_REVIVE_SHADER );
//#precache( "string", "ZOMBIE_PERK_QUICKREVIVE" );
//#precache( "fx", "zombie/fx_perk_quick_revive_zmb" );
#precache( "material", "specialty_doubletap_zombies" ); // CHANGE THIS TO YOUR PERK SHADER

#precache( "string", "ZM_ABBEY_PERK_DOUBLETAP_ORIGINAL" );

#namespace zm_perk_doubletaporiginal;

REGISTER_SYSTEM( "doubletaporiginal", &__init__, undefined )

// QUICK REVIVE ( QUICK REVIVE )

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	enable_custom_perk_for_level();
	//level.check_quickrevive_hotjoin = &check_quickrevive_for_hotjoin;
}

function enable_custom_perk_for_level()
{	
	// register quick revive perk for level
	zm_perks::register_perk_basic_info( PERK_DOUBLE_TAP, "doubletaporiginal", DOUBLE_TAP_PERK_COST, &"ZM_ABBEY_PERK_DOUBLETAP_ORIGINAL", GetWeapon( DOUBLE_TAP_BOTTLE_WEAPON ) );
	zm_perks::register_perk_precache_func( PERK_DOUBLE_TAP, &custom_perk_precache );
	zm_perks::register_perk_clientfields( PERK_DOUBLE_TAP, &custom_perk_register_clientfield, &custom_perk_set_clientfield );
	zm_perks::register_perk_machine( PERK_DOUBLE_TAP, &custom_perk_machine_setup );
	zm_perks::register_perk_threads( PERK_DOUBLE_TAP, &give_custom_perk, &take_custom_perk );
	zm_perks::register_perk_host_migration_params( PERK_DOUBLE_TAP, DOUBLE_TAP_RADIANT_MACHINE_NAME, DOUBLE_TAP_MACHINE_LIGHT_FX );
	//zm_perks::register_perk_machine_power_override( PERK_DOUBLE_TAP, &turn_revive_on ); // custom power function gets threaded here
	//level flag::init( "solo_revive" );
	
}

function custom_perk_precache()
{
	// PRECACHE SHIT HERE
	/* 
	if( IsDefined(level.quick_revive_precache_override_func) )
	{
		[[ level.quick_revive_precache_override_func ]]();
		return;
	}
	
	level._effect[QUICK_REVIVE_MACHINE_LIGHT_FX] = "zombie/fx_perk_quick_revive_zmb";
	*/

	level.machine_assets[PERK_DOUBLE_TAP] = SpawnStruct();
	level.machine_assets[PERK_DOUBLE_TAP].weapon = GetWeapon( DOUBLE_TAP_BOTTLE_WEAPON );
	level.machine_assets[PERK_DOUBLE_TAP].off_model = DOUBLE_TAP_MACHINE_DISABLED_MODEL;
	level.machine_assets[PERK_DOUBLE_TAP].on_model = DOUBLE_TAP_MACHINE_ACTIVE_MODEL;	
}

function custom_perk_register_clientfield()
{
	clientfield::register( "clientuimodel", PERK_CLIENTFIELD_DOUBLE_TAP, VERSION_SHIP, 2, "int" );
}

function custom_perk_set_clientfield( state )
{
	self clientfield::set_player_uimodel( PERK_CLIENTFIELD_DOUBLE_TAP, state );
}

function custom_perk_machine_setup( use_trigger, perk_machine, bump_trigger, collision )
{
	use_trigger.script_sound = "mus_perks_doubletap_jingle";
	use_trigger.script_string = "tap_perk";
	use_trigger.script_label = "mus_perks_doubletap_sting";
	use_trigger.target = DOUBLE_TAP_RADIANT_MACHINE_NAME;
	perk_machine.script_string = "tap_perk";
	perk_machine.targetname = DOUBLE_TAP_RADIANT_MACHINE_NAME;
	if( IsDefined( bump_trigger ) )
	{
		bump_trigger.script_string = "tap_perk";
	}
}

function give_custom_perk()
{
	// quick revive in solo gives an extra life
	// give perk here
	self SetPerk(PERK_DOUBLE_TAP);
	self thread checkCustomPerk();
	//self thread custom_perk_shader::add_custom_perk_shader( self, "specialty_doubletap_zombies" ); // CHANGE THIS TO YOUR PERK SHADER

	trigger = GetEnt(PERK_DOUBLE_TAP, "script_noteworthy"); // CHANGE THIS TO YOUR PERK MACHINE NAME
	trigger SetHintStringForPlayer(self, "");
	
}

function take_custom_perk( b_pause, str_perk, str_result )
{
	// take perk here
	self UnSetPerk(PERK_DOUBLE_TAP);
	trigger = GetEnt(PERK_DOUBLE_TAP, "script_noteworthy");
	trigger SetHintStringForPlayer(self, "Hold ^3[{+activate}]^7 for Double Tap Root Beer [Cost: 2000]"); // CHANGE THIS TO YOUR HINTSTRING ABOVE
}


function checkCustomPerk()
{
	while(1)
	{
		if(self HasPerk(PERK_DOUBLE_TAP))
		{
			if(! self HasPerk("specialty_rof"))
			{
				self SetPerk("specialty_rof");
			}
		}
		if(! self HasPerk(PERK_DOUBLE_TAP))
		{
			if(self HasPerk("specialty_rof"))
			{
				self UnSetPerk("specialty_rof");
			}

		}
		wait(0.05);
	}
}