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

#insert scripts\zm\_zm_perk_phdlite.gsh;
#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_utility.gsh;
#using scripts\shared\ai\zombie_utility;

#using scripts\zm\zm_perk_upgrades;

//#precache( "material", QUICK_REVIVE_SHADER );
//#precache( "string", "ZOMBIE_PERK_QUICKREVIVE" );
#precache( "fx", "explosions/fx_exp_rocket_default" );
#precache( "material", "specialty_phdlite_zombies" ); // CHANGE THIS TO YOUR PERK SHADER

#precache( "string", "ZM_ABBEY_PERK_PHD_LITE" );

#namespace zm_perk_phdlite;

REGISTER_SYSTEM( "zm_perk_phdlite", &__init__, undefined )

// QUICK REVIVE ( QUICK REVIVE )

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	enable_custom_perk_for_level();
	level.quad_gas_immune_func = &quad_gas_immune_func;
	//thread testeroo();
	//level.check_quickrevive_hotjoin = &check_quickrevive_for_hotjoin;
}

function quad_gas_immune_func()
{
	return (self HasPerk(PERK_PHD_LITE) ? 1 : 0);
}

function enable_custom_perk_for_level()
{	
	// register quick revive perk for level
	zm_perks::register_perk_basic_info( PERK_PHD_LITE, "phdlite", PHD_LITE_COST, &"ZM_ABBEY_PERK_PHD_LITE", GetWeapon( PHD_LITE_BOTTLE_WEAPON ) );
	zm_perks::register_perk_precache_func( PERK_PHD_LITE, &custom_perk_precache );
	zm_perks::register_perk_clientfields( PERK_PHD_LITE, &custom_perk_register_clientfield, &custom_perk_set_clientfield );
	zm_perks::register_perk_machine( PERK_PHD_LITE, &custom_perk_machine_setup );
	zm_perks::register_perk_threads( PERK_PHD_LITE, &give_custom_perk, &take_custom_perk );
	zm_perks::register_perk_host_migration_params( PERK_PHD_LITE, PHD_LITE_RADIANT_MACHINE_NAME, PHD_LITE_MACHINE_LIGHT_FX );

	zm_perks::register_perk_damage_override_func(&phd_damage_override);
	//zm_perks::register_perk_machine_power_override( PERK_PHD_LITE, &turn_revive_on ); // custom power function gets threaded here
	//level flag::init( "solo_revive" );
	
}

function phd_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if(! self HasPerk(PERK_PHD_LITE))
		return undefined;

	switch(sMeansOfDeath)
		{
			case "MOD_BURNED":
			case "MOD_ELECTOCUTED":
			case "MOD_FALLING":
				iDamage = 0;
				return 0;

			default:
				break;
		}

	if(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_PHD_LITE))
	{
		switch(sMeansOfDeath)
		{
			case "MOD_BURNED":
			case "MOD_ELECTOCUTED":
			case "MOD_EXPLOSIVE":
			case "MOD_EXPLOSIVE_SPLASH":
			case "MOD_FALLING":
			case "MOD_GRENADE":
			case "MOD_GRENADE_SPLASH":
			case "MOD_IMPACT":
				iDamage = 0;
				return 0;

			default:
				break;
		}

		
		if(!isdefined(weapon))
			return undefined;

		switch(weapon.name)
		{
			case "bouncingbetty":
			case "cymbal_monkey":
			case "frag_grenade":
			case "launcher_multi":
			case "launcher_multi_upgraded":
			case "launcher_standard":
			case "launcher_standard_upgraded":
			case "octobomb":
			case "octobomb_upgraded":
			case "pistol_standard_upgraded":
			case "pistol_standardlh_upgraded":
			case "pistol_revolver38_upgraded":
			case "pistol_revolver38lh_upgraded":
			case "ray_gun":
			case "ray_gun_upgraded":
			case "raygun_mark3":
			case "raygun_mark3lh":
			case "raygun_mark3_upgraded":
			case "raygun_mark3lh_upgraded":
			case "tesla_gun":
			case "tesla_gun_upgraded":
			case "zm_diedrich":
			case "zm_diedrich_upgraded":
				iDamage = 0;
				return 0;

			default:
				break;
		}
		
	}

	return undefined;
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

	level.machine_assets[PERK_PHD_LITE] = SpawnStruct();
	level.machine_assets[PERK_PHD_LITE].weapon = GetWeapon( PHD_LITE_BOTTLE_WEAPON );
	level.machine_assets[PERK_PHD_LITE].off_model = PHD_LITE_MACHINE_DISABLED_MODEL;
	level.machine_assets[PERK_PHD_LITE].on_model = PHD_LITE_MACHINE_ACTIVE_MODEL;	
}

function custom_perk_register_clientfield()
{
	clientfield::register( "clientuimodel", PERK_CLIENTFIELD_PHD_LITE, VERSION_SHIP, 2, "int" );
}

function custom_perk_set_clientfield( state )
{
	self clientfield::set_player_uimodel( PERK_CLIENTFIELD_PHD_LITE, state );
}

function custom_perk_machine_setup( use_trigger, perk_machine, bump_trigger, collision )
{
	use_trigger.script_sound = "mus_perks_phd_jingle";
	use_trigger.script_string = "tap_perk";
	use_trigger.script_label = "mus_perks_phd_sting";
	use_trigger.target = PHD_LITE_RADIANT_MACHINE_NAME;
	perk_machine.script_string = "tap_perk";
	perk_machine.targetname = PHD_LITE_RADIANT_MACHINE_NAME;
	if( IsDefined( bump_trigger ) )
	{
		bump_trigger.script_string = "tap_perk";
	}
}

function give_custom_perk()
{
	// quick revive in solo gives an extra life
	// give perk here
	self SetPerk(PERK_PHD_LITE);
	self thread phd_slide_think();
	//self thread custom_perk_shader::add_custom_perk_shader( self, "specialty_phdlite_zombies" ); // CHANGE THIS TO YOUR PERK SHADER

	trigger = GetEnt(PERK_PHD_LITE, "script_noteworthy"); // CHANGE THIS TO YOUR PERK MACHINE NAME
	trigger SetHintStringForPlayer(self, "");
	
}

function take_custom_perk( b_pause, str_perk, str_result )
{
	// take perk here
	self UnSetPerk(PERK_PHD_LITE);
	trigger = GetEnt(PERK_PHD_LITE, "script_noteworthy");
	trigger SetHintStringForPlayer(self, "Hold ^3[{+activate}]^7 for PhD Slider [Cost: 2000]"); // CHANGE THIS TO YOUR HINTSTRING ABOVE
}

function phd_slide_think() 
{
	self endon("disconnect");

	while(true)
	{
		if(self HasPerk(PERK_PHD_LITE) && self IsOnSlide())
		{
			start_pos = self GetOrigin();
			while(self IsOnSlide())
			{
				wait(0.05);
			}
			self thread phd_slide_iframes();

			end_pos = self GetOrigin();
			slide_dist = DistanceSquared(start_pos, end_pos);

			should_explode = false;
			zombie_origin = undefined;
			zombies = GetAISpeciesArray("axis", "all");
			foreach(zombie in zombies)
			{
				zombie_origin = zombie GetOrigin();
				z_diff = Abs(zombie_origin[2] - end_pos[2]);
				dist = Distance2DSquared(end_pos, zombie_origin);
				if(z_diff < PHD_LITE_Z_DIFF && dist < PHD_LITE_POS_DIFF)
				{
					should_explode = true;
					break;
				}
			}
			
			if(should_explode)
			{
				PlayFX("explosions/fx_exp_rocket_default", zombie_origin);
				PlaySoundAtPosition( "zmb_phdflop_explo", zombie_origin );
				max_damage = PHD_LITE_MAX_DAMAGE * (slide_dist / PHD_LITE_MAX_SLIDE);
				foreach(zombie in zombies)
				{
					dist = DistanceSquared(zombie_origin, zombie GetOrigin());
					if(dist < PHD_LITE_RADIUS)
					{
						damage = max_damage * (1 - (dist / PHD_LITE_RADIUS));
						zombie.phd_damaged = true;
						zombie DoDamage(damage, zombie_origin, self, self, "none", "MOD_EXPLOSIVE", 0 );
						//IPrintLn(damage);
					}
				}
			}
		}
		wait(0.05);
	}
}

function phd_slide_iframes()
{
	self endon("disconnect");

	time = PHD_LITE_IFRAME_TIME * 20;
	for(i = 0; i < time; i++)
	{
		self EnableInvulnerability();
		wait(0.05);
	}
	
	self DisableInvulnerability();
}

function testeroo()
{
	level waittill("all_players_connected");
	players = GetPlayers();

	while(true)
	{
		IPrintLn(players[0].health);
		wait(0.5);
	}
}