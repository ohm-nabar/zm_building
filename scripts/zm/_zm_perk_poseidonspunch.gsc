#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\ai\zombie_utility;

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

#using scripts\zm\zm_abbey_inventory;
#using scripts\zm\zm_ai_shadowpeople;
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
	level clientfield::register( "clientuimodel", "poseidonCharge", VERSION_SHIP, 1, "int" );
	level clientfield::register( "allplayers", "poseidon_splash", VERSION_SHIP, 1, "int" );

	level.poseidon_dot = Cos(POSEIDON_ANGLE);
	level.poseidon_recharge_time = 10;
	level enable_custom_perk_for_level();
	level callback::on_connect( &on_player_connect );
	level zm::register_player_damage_callback( &player_damage_override );
	level zm::register_zombie_damage_override_callback( &zombie_damage_override );
}


function on_player_connect()
{
	self.poseidon_zombie_deaths_until_drop = RandomIntRange(4, 15);
	self.poseidon_ready = true;
	self.is_poseidon_blessed = false;
}

function player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if(IS_TRUE(self.poseidon_invulnerable))
	{
		return 0;
	}

	return -1;
}

function zombie_damage_override( willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType )
{
	if ( IS_EQUAL(meansofdeath,"MOD_MELEE") && IsDefined(attacker) && IsPlayer(attacker) && attacker HasPerk( PERK_POSEIDON_PUNCH ) && attacker.poseidon_ready )
	{
		attacker thread poseidon_knockdown(self, willBeKilled);
	}
	return false;
}
function enable_custom_perk_for_level()
{	
	// register quick revive perk for level
	level zm_perks::register_perk_basic_info( PERK_POSEIDON_PUNCH, "poseidonspunch", POSEIDON_PUNCH_COST, &"ZM_ABBEY_PERK_POSEIDON_PUNCH", GetWeapon( POSEIDON_PUNCH_BOTTLE_WEAPON ) );
	level zm_perks::register_perk_precache_func( PERK_POSEIDON_PUNCH, &custom_perk_precache );
	level zm_perks::register_perk_clientfields( PERK_POSEIDON_PUNCH, &custom_perk_register_clientfield, &custom_perk_set_clientfield );
	level zm_perks::register_perk_machine( PERK_POSEIDON_PUNCH, &custom_perk_machine_setup );
	level zm_perks::register_perk_threads( PERK_POSEIDON_PUNCH, &give_custom_perk, &take_custom_perk );
	level zm_perks::register_perk_host_migration_params( PERK_POSEIDON_PUNCH, POSEIDON_PUNCH_RADIANT_MACHINE_NAME, POSEIDON_PUNCH_MACHINE_LIGHT_FX );
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
	level clientfield::register( "clientuimodel", PERK_CLIENTFIELD_POSEIDON_PUNCH, VERSION_SHIP, 2, "int" );
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

function poseidon_filter(zombie)
{
	return (isdefined(zombie) && IS_TRUE(zombie.completed_emerging_into_playable_area) && self zm_utility::is_player_looking_at(zombie.origin, level.poseidon_dot, false) && ! zombie zm_ai_shadowpeople::is_shadow_boss());
}

function poseidon_knockdown(start_zombie, willBeKilled)
{
	self endon("disconnect");
	alias_name = "pp_melee" + RandomIntRange(1, 4);
	self PlaySound(alias_name);
	self clientfield::set("poseidon_splash", 1);
	self thread poseidon_recharge_time();
	zombies = GetAISpeciesArray("axis", "all");
	exclude_zombies = self array::filter(zombies, false, &poseidon_filter);
	closest_zombies = level array::get_all_closest(start_zombie.origin, exclude_zombies, undefined, POSEIDON_MAX_ZOMBIES, POSEIDON_RADIUS);
	foreach(zombie in closest_zombies)
	{
		zombie PlaySound("pp_knockback");
		if(IsAlive(zombie))
		{
			if(IS_EQUAL(zombie.animname, "quad_zombie"))
			{
				zombie thread quad_stun();
			}
			else
			{
				zombie zm_weap_thundergun::thundergun_knockdown_zombie(self, false);
			}
			zombie thread mark_zombie();
		}
		if(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_POSEIDON_PUNCH))
		{
			if(self.health + POSEIDON_HEALTH <= self.maxHealth)
			{
				self.health += POSEIDON_HEALTH;
			}
			else
			{
				self.health = self.maxHealth;
			}
			self thread player_soul_fx(zombie.origin);
		}
	}

	if(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_POSEIDON_PUNCH) && self.health > POSEIDON_REDSCREEN_THRESHOLD)
	{
		self.stopFlashingBadlyTime = 0;
	}
}

function player_soul_fx(zombie_origin)
{
	self endon("disconnect");

	fx_model = Spawn("script_model", zombie_origin + (0, 0, 40));
	fx_model SetModel("tag_origin");
	fx_model clientfield::set("fx_floating_orb_glow", 1);

	for(i = 0.05; i <= 0.75; i += 0.05)
	{
		wait(0.05);
		origin_diff = (self.origin + (0, 0, 40)) - fx_model.origin;
		origin_dest = fx_model.origin + VectorScale(origin_diff, (i / 0.5));
		fx_model MoveTo(origin_dest, 0.05);
	}

	fx_model Delete();
}

function quad_stun()
{
	loop_time = POSEIDON_KNOCKDOWN_TIME * 20;
	for(i = 0; i < loop_time && isdefined(self) && ! self IsRagdoll(); i++)
	{
		self ASMSetAnimationRate(0);
		wait(0.05);
	}
	
	if(isdefined(self))
	{
		if(! (IS_TRUE(self.trident_slowdown) || IS_TRUE(self.trident_shocked)) || self IsRagdoll())
		{
			self ASMSetAnimationRate(1);
		}
		else if(! IS_TRUE(self.trident_shocked))
		{
			self ASMSetAnimationRate(0.1);
		}
	}
}

function mark_zombie()
{
	self endon("death");

	self SetPlayerCollision(false);
	self.poseidon_knockdown = true;
	if(IS_EQUAL(self.animname, "quad_zombie"))
	{
		wait(POSEIDON_KNOCKDOWN_TIME);
	}
	else
	{
		for(i = 0; i < POSEIDON_KNOCKDOWN_TIME; i += 0.05)
		{
			if(IS_TRUE(self.trident_slowdown))
			{
				wait(0.5);
			}
			else
			{
				wait(0.05);
			}
		}
	}
	self SetPlayerCollision(true);
	self.poseidon_knockdown = false;
}

function poseidon_recharge_time()
{
	self endon("disconnect");
	//self PlaySoundToPlayer("pp_recharge", self);
	self.poseidon_ready = false;
	self clientfield::set_player_uimodel("poseidonCharge", 0);
	for(i = 0; i < level.poseidon_recharge_time && self HasPerk(PERK_POSEIDON_PUNCH); i += 0.05)
	{
		wait(0.05);
		while(level.is_coop_paused)
		{
			wait(0.05);
		}
	}
	self.poseidon_ready = true;
	self clientfield::set_player_uimodel("poseidonCharge", 1);
	self clientfield::set("poseidon_splash", 0);
	if(self HasPerk(PERK_POSEIDON_PUNCH))
	{
		self PlaySoundToPlayer("pp_active", self);
	}
}

function poseidon_melee_iframes()
{
	self endon("disconnect");

	while(true)
	{
		if(self IsMeleeing() && self HasPerk(PERK_POSEIDON_PUNCH) && self.poseidon_ready)
		{
			self.poseidon_invulnerable = true;
			while (self IsMeleeing())
			{
				wait(0.05);
			}
			self.poseidon_invulnerable = false;
		}
	}
}