#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;

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
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_powerups;

#insert scripts\zm\_zm_perk_poseidonspunch.gsh;
#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_utility.gsh;
#using scripts\shared\ai\zombie_utility;

#using scripts\zm\zm_abbey_inventory;
#using scripts\zm\zm_perk_upgrades;

#using scripts\zm\_zm_weap_thundergun;

//#precache( "material", QUICK_REVIVE_SHADER );
//#precache( "string", "ZOMBIE_PERK_QUICKREVIVE" );
//#precache( "fx", "zombie/fx_perk_quick_revive_zmb" );
#precache( "material", "specialty_poseidon_zombies" ); // CHANGE THIS TO YOUR PERK SHADER
#precache( "material", "poseidon_damage" );
#precache( "material", "poseidon_double" );
#precache( "material", "poseidon_insta" );
#precache( "material", "poseidon_max" );
#precache( "material", "poseidon_speed" );

#precache( "fx", "water/fx_water_splash_xxxlg" );

#precache( "string", "ZM_ABBEY_PERK_POSEIDON_PUNCH" );

#namespace zm_perk_poseidonspunch;

REGISTER_SYSTEM( "poseidonspunch", &__init__, undefined )

// QUICK REVIVE ( QUICK REVIVE )

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	clientfield::register( "clientuimodel", "poseidonCharge", VERSION_SHIP, 1, "int" );

	level.poseidon_recharge_time = 10;
	enable_custom_perk_for_level();
	callback::on_connect( &on_player_connect );
	zm::register_zombie_damage_override_callback( &zombie_damage_override );
	//thread testeroo();
	//level.check_quickrevive_hotjoin = &check_quickrevive_for_hotjoin;
}


function on_player_connect()
{
	self.poseidon_zombie_deaths_until_drop = RandomIntRange(4, 15);
	self.poseidon_ready = true;
	self.is_poseidon_blessed = false;
}

function zombie_damage_override( willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType )
{
	if ( IS_EQUAL(meansofdeath,"MOD_MELEE") && IsDefined(attacker) && IsPlayer(attacker) && attacker HasPerk( PERK_POSEIDON_PUNCH ) && attacker.poseidon_ready )
	{
		attacker thread poseidon_knockdown();
	}
	return false;
}
function enable_custom_perk_for_level()
{	
	// register quick revive perk for level
	zm_perks::register_perk_basic_info( PERK_POSEIDON_PUNCH, "poseidonspunch", POSEIDON_PUNCH_COST, &"ZM_ABBEY_PERK_POSEIDON_PUNCH", GetWeapon( POSEIDON_PUNCH_BOTTLE_WEAPON ) );
	zm_perks::register_perk_precache_func( PERK_POSEIDON_PUNCH, &custom_perk_precache );
	zm_perks::register_perk_clientfields( PERK_POSEIDON_PUNCH, &custom_perk_register_clientfield, &custom_perk_set_clientfield );
	zm_perks::register_perk_machine( PERK_POSEIDON_PUNCH, &custom_perk_machine_setup );
	zm_perks::register_perk_threads( PERK_POSEIDON_PUNCH, &give_custom_perk, &take_custom_perk );
	zm_perks::register_perk_host_migration_params( PERK_POSEIDON_PUNCH, POSEIDON_PUNCH_RADIANT_MACHINE_NAME, POSEIDON_PUNCH_MACHINE_LIGHT_FX );
	//zm_perks::register_perk_machine_power_override( PERK_POSEIDON_PUNCH, &turn_revive_on ); // custom power function gets threaded here
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

	level.machine_assets[PERK_POSEIDON_PUNCH] = SpawnStruct();
	level.machine_assets[PERK_POSEIDON_PUNCH].weapon = GetWeapon( POSEIDON_PUNCH_BOTTLE_WEAPON );
	level.machine_assets[PERK_POSEIDON_PUNCH].off_model = POSEIDON_PUNCH_MACHINE_DISABLED_MODEL;
	level.machine_assets[PERK_POSEIDON_PUNCH].on_model = POSEIDON_PUNCH_MACHINE_ACTIVE_MODEL;	
}

function custom_perk_register_clientfield()
{
	clientfield::register( "clientuimodel", PERK_CLIENTFIELD_POSEIDON_PUNCH, VERSION_SHIP, 2, "int" );
}

function custom_perk_set_clientfield( state )
{
	self clientfield::set_player_uimodel( PERK_CLIENTFIELD_POSEIDON_PUNCH, state );
}

function custom_perk_machine_setup( use_trigger, perk_machine, bump_trigger, collision )
{
	use_trigger.script_sound = "mus_perks_pp_jingle";
	use_trigger.script_string = "";
	use_trigger.script_label = "mus_perks_pp_sting";
	use_trigger.target = POSEIDON_PUNCH_RADIANT_MACHINE_NAME;
	perk_machine.script_string = "";
	perk_machine.targetname = POSEIDON_PUNCH_RADIANT_MACHINE_NAME;
	if( IsDefined( bump_trigger ) )
	{
		bump_trigger.script_string = "";
	}
}

function give_custom_perk()
{
	// quick revive in solo gives an extra life
	// give perk here
	self SetPerk(PERK_POSEIDON_PUNCH);
	self thread checkCustomPerk();
	//self thread custom_perk_shader::add_custom_perk_shader( self, "specialty_poseidon_zombies" ); // CHANGE THIS TO YOUR PERK SHADER

	trigger = GetEnt(PERK_POSEIDON_PUNCH, "script_noteworthy"); // CHANGE THIS TO YOUR PERK MACHINE NAME
	trigger SetHintStringForPlayer(self, &"ZM_ABBEY_EMPTY");
	
}

function take_custom_perk( b_pause, str_perk, str_result )
{
	// take perk here
	self UnSetPerk(PERK_POSEIDON_PUNCH);
	trigger = GetEnt(PERK_POSEIDON_PUNCH, "script_noteworthy");
	trigger SetHintStringForPlayer(self, "Hold ^3[{+activate}]^7 for Poseidon's Punch [Cost: 3000]"); // CHANGE THIS TO YOUR HINTSTRING ABOVE
}

function checkCustomPerk()
{
	self endon("disconnect");

	self clientfield::set_player_uimodel("poseidonCharge", 1);
}

function poseidon_knockdown()
{
	self endon("disconnect");
	alias_name = "pp_melee" + RandomIntRange(1, 4);
	self PlaySound(alias_name);
	PlayFXOnTag("water/fx_water_splash_xxxlg", self, "tag_weapon_right");
	self thread poseidon_recharge_time();
	zombies = GetAISpeciesArray("axis", "all");
	foreach(zombie in zombies)
	{
		is_shadow_boss = false;
		if(isdefined(zombie.targetname) && (zombie.targetname == "zombie_cloak" || zombie.targetname == "zombie_escargot"))
		{
			is_shadow_boss = true;
		}
		if(IS_TRUE(zombie.completed_emerging_into_playable_area) && ! is_shadow_boss && DistanceSquared(self.origin, zombie.origin) <= POSEIDON_RADIUS && ! IS_TRUE(zombie.poseidon_knockdown))
		{
			zombie PlaySound("pp_knockback");
			if(isdefined(zombie.animname) && zombie.animname == "quad_zombie")
			{
				zombie thread quad_stun();
			}
			else
			{
				zombie zm_weap_thundergun::thundergun_knockdown_zombie(self, false);
			}
			zombie thread mark_zombie();
			if(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_POSEIDON_PUNCH))
			{
				self.health += 15;
			}
		}
	}
}

function quad_stun()
{
	self endon("death");

	loop_time = POSEIDON_QUAD_KNOCKDOWN_TIME * 20;
	for(i = 0; i < loop_time; i++)
	{
		self ASMSetAnimationRate(0);
		wait(0.05);
	}
	
	if(! IS_TRUE(self.trident_slowdown))
	{
		self ASMSetAnimationRate(1);
	}
	else
	{
		self ASMSetAnimationRate(0.1);
	}
}

function mark_zombie()
{
	self endon("death");

	self.poseidon_knockdown = true;
	wait(5);
	self.poseidon_knockdown = false;
}

function poseidon_recharge_time()
{
	self endon("disconnect");
	//self PlaySoundToPlayer("pp_recharge", self);
	self.poseidon_ready = false;
	self clientfield::set_player_uimodel("poseidonCharge", 0);
	wait(level.poseidon_recharge_time);
	self.poseidon_ready = true;
	self clientfield::set_player_uimodel("poseidonCharge", 1);
	self PlaySoundToPlayer("pp_active", self);
}

function poseidon_melee_iframes()
{
	self endon("disconnect");

	while(true)
	{
		if(self IsMeleeing() && self HasPerk(PERK_POSEIDON_PUNCH) && self.poseidon_ready)
		{
			while (self IsMeleeing())
			{
				self EnableInvulnerability();
				wait(0.05);
			}
			self DisableInvulnerability();
		}
	}
}