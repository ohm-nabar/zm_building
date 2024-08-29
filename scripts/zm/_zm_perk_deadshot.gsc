#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\ai\zombie_utility;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm;
#using scripts\zm\_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_lightning_chain;

#insert scripts\zm\_zm_perk_deadshot.gsh;
#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_utility.gsh;

#using scripts\zm\zm_perk_upgrades;

#precache( "material", DEADSHOT_SHADER );
#precache( "fx", "_t6/misc/fx_zombie_cola_dtap_on" );

#precache( "string", "ZM_ABBEY_PERK_DEADSHOT_DOUBLE" );

#namespace zm_perk_deadshot;

REGISTER_SYSTEM( "zm_perk_deadshot", &__init__, undefined )

// DEAD SHOT ( DEADSHOT DAIQUIRI )

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	level.deadshot_mind_blown_chance = 10; // in percentage
	level.deadshot_mind_blown_limit = 8;
	level.deadshot_upgraded_mind_blown_limit = 16;
	level.deadshot_chain_params = lightning_chain::create_lightning_chain_params(0, 1, 300, 20, 100, 0.11, 10, 0, 4, 1, 0, undefined, 1, 1);
	enable_deadshot_perk_for_level();
	callback::on_connect( &on_player_connect );
	zm::register_zombie_damage_override_callback( &zombie_damage_override );
}

function on_player_connect()
{
	self thread mind_blown_think();
}

function zombie_damage_override(willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if ( isPlayer( attacker ) && willBeKilled && attacker HasPerk(PERK_DEAD_SHOT) && zm_utility::is_headshot( weapon, sHitLoc, meansofdeath ) )
	{
		attacker notify(#"deadshot_headshot_kill");
	}
}

function enable_deadshot_perk_for_level()
{	
	// register sleight of hand perk for level
	zm_perks::register_perk_basic_info( PERK_DEAD_SHOT, "deadshot", DEADSHOT_PERK_COST, &"ZM_ABBEY_PERK_DEADSHOT_DOUBLE", GetWeapon( DEADSHOT_PERK_BOTTLE_WEAPON ) );
	zm_perks::register_perk_precache_func( PERK_DEAD_SHOT, &deadshot_precache );
	zm_perks::register_perk_clientfields( PERK_DEAD_SHOT, &deadshot_register_clientfield, &deadshot_set_clientfield );
	zm_perks::register_perk_machine( PERK_DEAD_SHOT, &deadshot_perk_machine_setup );
	zm_perks::register_perk_threads( PERK_DEAD_SHOT, &give_deadshot_perk, &take_deadshot_perk );
	zm_perks::register_perk_host_migration_params( PERK_DEAD_SHOT, DEADSHOT_RADIANT_MACHINE_NAME, DEADSHOT_MACHINE_LIGHT_FX );
}

function deadshot_precache()
{
	if( IsDefined(level.deadshot_precache_override_func) )
	{
		[[ level.deadshot_precache_override_func ]]();
		return;
	}
	
	level._effect[DEADSHOT_MACHINE_LIGHT_FX] = "_t6/misc/fx_zombie_cola_dtap_on";
	
	level.machine_assets[PERK_DEAD_SHOT] = SpawnStruct();
	level.machine_assets[PERK_DEAD_SHOT].weapon = GetWeapon( DEADSHOT_PERK_BOTTLE_WEAPON );
	level.machine_assets[PERK_DEAD_SHOT].off_model = DEADSHOT_MACHINE_DISABLED_MODEL;
	level.machine_assets[PERK_DEAD_SHOT].on_model = DEADSHOT_MACHINE_ACTIVE_MODEL;
}

function deadshot_register_clientfield()
{
	clientfield::register("toplayer", "deadshot_perk", VERSION_SHIP, 1, "int");
	clientfield::register( "clientuimodel", PERK_CLIENTFIELD_DEAD_SHOT, VERSION_SHIP, 2, "int" );
}

function deadshot_set_clientfield( state )
{
	self clientfield::set_player_uimodel( PERK_CLIENTFIELD_DEAD_SHOT, state );
}

function deadshot_perk_machine_setup( use_trigger, perk_machine, bump_trigger, collision )
{
	use_trigger.script_sound = "mus_perks_deadshot_jingle";
	use_trigger.script_string = "deadshot_perk";
	use_trigger.script_label = "mus_perks_deadshot_sting";
	use_trigger.target = DEADSHOT_RADIANT_MACHINE_NAME;
	perk_machine.script_string = "deadshot_vending";
	perk_machine.targetname = DEADSHOT_RADIANT_MACHINE_NAME;
	if(IsDefined(bump_trigger))
	{
		bump_trigger.script_string = "deadshot_vending";
	}
}

function give_deadshot_perk()
{
	self clientfield::set_to_player( "deadshot_perk", 1);
}

function take_deadshot_perk( b_pause, str_perk, str_result )
{
	self clientfield::set_to_player( "deadshot_perk", 0);
}

function mind_blown_think()
{
	self endon("disconnect");

	cos45 = Cos(45);
	cos75 = Cos(75);
	while(true)
	{
		self waittill(#"deadshot_headshot_kill");

		if(RandomIntRange(0, 100) > level.deadshot_mind_blown_chance)
		{
			continue;
		}

		zombies = GetAISpeciesArray("axis", "all");
		
		zombies_out_of_sight1 = self CantSeeEntities(zombies, cos45, true);
		zombies_in_sight_temp = array::exclude(zombies, zombies_out_of_sight1);

		zombies_out_of_sight2 = self CantSeeEntities(zombies_in_sight_temp, cos75, false);
		zombies_in_sight = array::exclude(zombies_in_sight_temp, zombies_out_of_sight2);

		count = 0;
		limit = (zm_perk_upgrades::IsPerkUpgradeActive(PERK_DEAD_SHOT) ? level.deadshot_upgraded_mind_blown_limit : level.deadshot_mind_blown_limit);
		foreach ( zombie in zombies_in_sight )
		{
			if(!IsAlive(zombie) || zombie.targetname == "zombie_cloak" || zombie.targetname == "zombie_escargot")
			{
				continue;
			}
			self thread blow_mind(zombie);
			if(isdefined(self.deadshotMindBlownKills))
			{
				self.deadshotMindBlownKills += 1;
			}
			count += 1;
			if(count >= limit)
			{
				break;
			}
		}
	}
}

function blow_mind(ai)
{
	ai.marked_for_death = 1;
	ai.var_85934541 = 1;
	ai.no_powerups = 1;
	ai.deathpoints_already_given = 1;
	ai.tesla_head_gib_func = &zombie_head_gib;
	ai lightning_chain::arc_damage(ai, self, 1, level.deadshot_chain_params);
}

function zombie_head_gib()
{
	self endon("death");
	self clientfield::set("zm_bgb_mind_ray_fx", 1);
	wait(RandomFloatRange(0.65, 2.5));
	self clientfield::set("zm_bgb_mind_pop_fx", 1);
	self PlaySoundOnTag("zmb_bgb_mindblown_pop", "tag_eye");
	self zombie_utility::zombie_head_gib();
}
