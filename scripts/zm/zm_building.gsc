#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_flamethrower;
#using scripts\zm\_zm_zonemgr;

#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\zombie;

//Perks
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_electric_cherry;

//Powerups
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
//#using scripts\zm\_zm_powerup_weapon_minigun;

//Traps
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_trap_fire;
#using scripts\zm\_hb21_sym_zm_trap_turret;
#using scripts\zm\_hb21_zm_trap_flogger;
#using scripts\zm\_hb21_zm_trap_centrifuge;
#using scripts\zm\_hb21_zm_trap_flinger;
#using scripts\zm\_hb21_sym_zm_trap_chain;
#using scripts\zm\_hb21_sym_zm_trap_fan;
#using scripts\zm\_hb21_sym_zm_trap_acid;
#using scripts\zm\_hb21_sym_zm_trap_gate;

//Needed for damage override
#using scripts\zm\zm_usermap;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_bgb_token;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;

//Custom Scripts
#using scripts\zm\zm_bloodgenerator;
#using scripts\zm\zm_perk_upgrades;
#using scripts\zm\zm_perk_upgrades_effects;
#using scripts\zm\custom_gg_machine;
#using scripts\zm\zm_healing_grenade;
#using scripts\zm\_zm_perk_doubletaporiginal; 
#using scripts\zm\_zm_perk_poseidonspunch;
#using scripts\zm\_zm_perk_phdlite;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\zm_starting_pistol_choose; 
#using scripts\zm\zm_ai_shadowpeople; 
#using scripts\zm\zm_shadow_perks; 
#using scripts\zm\zm_challenges;
#using scripts\zm\zm_abbey_inventory;
#using scripts\zm\zm_pause;
#using scripts\zm\zm_high_round_health;
#using scripts\zm\zm_diedrich;
#using scripts\zm\zm_abbey_dialogue;
#using scripts\zm\zm_tides;
#using scripts\zm\zm_juggernog_potions;
#using scripts\zm\zm_room_manager;
#using scripts\zm\zm_abbey_quest;
#using scripts\zm\zm_trident;
#using scripts\zm\zm_variable_pricing;
#using scripts\zm\zm_revive_icon;
#using scripts\zm\rs_o_jump_pad;
#using scripts\zm\zm_blueprints;
#using scripts\zm\zm_solo_revive;
#using scripts\zm\zm_antiverse;
#using scripts\zm\zm_abbey_quick_revive;

// NOVA
#using scripts\shared\spawner_shared;
#using scripts\zm\_hb21_zm_behavior;
#using scripts\zm\_zm_ai_quad;


#using scripts\zm\zm_abbey_audio;
#using scripts\zm\zm_abbey_boss;

#using scripts\zm\zm_klauser;
#using scripts\zm\zm_flashlight;
#using scripts\zm\zm_no_hud;

// Sphynx's Console Commands
#using scripts\Sphynx\commands\_zm_commands;
#using scripts\Sphynx\commands\_zm_name_checker;

// Abbey Teleporter
#using scripts\zm\zm_abbey_teleporter;

// Custom Gums
#using scripts\zm\bgbs\_zm_bgb_aftertaste_blood;
#using scripts\zm\bgbs\_zm_bgb_challenge_rejected;

#insert scripts\zm\_zm_perks.gsh;

function main()
{
	//SetGametypeSetting("startRound", 12);
	//level.default_laststandpistol = GetWeapon("ray_gun");

	zm_usermap::main();
	level.dog_round_track_override = &zm_ai_shadowpeople::dog_round_tracker;
	zm::register_actor_damage_callback( &damage_adjustment );
	zm::register_player_damage_callback ( &player_damage_adjustment );
	
	level.initial_quick_revive_power_off = true;
	level.player_starting_points = 500000;
	level.start_weapon = GetWeapon("bare_hands_t7");
	level.perk_purchase_limit = 4;
	level.zombie_powerup_weapon[ "minigun" ] = GetWeapon( "bloodgun_dm" );

	zm_utility::register_lethal_grenade_for_level( "frag_grenade_potato_masher" );
	level.zombie_lethal_grenade_player_init = GetWeapon( "frag_grenade_potato_masher" );
	/*
	level._custom_perks = array::exclude( level._custom_perks, level._custom_perks[PERK_SLEIGHT_OF_HAND] );
	level._custom_perks = array::exclude( level._custom_perks, level._custom_perks[PERK_DOUBLETAP2] );
	level._custom_perks = array::exclude( level._custom_perks, level._custom_perks[PERK_DEAD_SHOT] );
	*/
		//SetDvar( "bg_falldamageminheight", "200" );
	//SetDvar( "bg_falldamagemaxheight", "350" );
	//level.aat_in_use = false;
	//level.overridePlayerDamage		= &player_damage_override;
	level thread zm_abbey_audio::main();
	level thread zm_bloodgenerator::main();
	level thread zm_klauser::main();
	//level thread zm_perk_upgrades::main();
	level thread zm_perk_upgrades_effects::main();
	level thread zm_healing_grenade::main();
	level thread zm_starting_pistol_choose::main();
	//level thread zm_ai_shadowpeople::main();
	level thread zm_shadow_perks::main();
	//level thread custom_gg_machine::main();
	//level thread zm_challenges::main();
	//level thread zm_abbey_inventory::main();
	level thread zm_pause::main();
	level thread zm_high_round_health::main();
	level thread zm_diedrich::main();
	//level thread zm_abbey_dialogue::main();
	//level thread zm_tides::main();
	level thread zm_juggernog_potions::main();
	level thread zm_room_manager::main();
	//level thread zm_abbey_quest::main();
	//level thread zm_trident::main();
	level thread zm_variable_pricing::main();
	level thread zm_abbey_boss::main();
	level thread zm_revive_icon::main();
	level thread zm_solo_revive::main();
	level thread zm_no_hud::main();
	level thread zm_antiverse::main();
	level thread zm_abbey_quick_revive::main();
	
	level thread zm_castle_vox();
	level._zombie_custom_add_weapons =&custom_add_weapons;
	
	//Setup the levels Zombie Zone Volumes
	level.zones = [];
	level.zone_manager_init_func =&usermap_test_zone_init;

	init_zones = [];
	init_zones[0] = "start_zone";
	init_zones[1] = "antiverse";
	level thread zm_zonemgr::manage_zones( init_zones );

	level.pathdist_type = PATHDIST_ORIGINAL;
	spare_change();
	spawner::add_archetype_spawn_function( "zombie", &test );
	spawner::add_archetype_spawn_function( "zombie", &zombie_unpush );
	spawner::add_archetype_spawn_function( "zombie", &zombie_custom_melee_speed );
	zm_flamethrower::init();
	//testeroo();
}

function test()
{
    self hb21_zm_behavior::enable_side_step();
}

function zombie_custom_melee_speed()
{
    self endon( "death" );

    while( isdefined( self ) )
    {
		if(isdefined(self.targetname) && (self.targetname == "zombie_choker" || self.targetname == "zombie_cloak" || self.targetname == "zombie_escargot"))
		{
			return;
		}

        if( ZombieBehavior::zombieShouldMeleeCondition( self ) )
        {
            if( self.zombie_move_speed != "walk" )
            {
                self.prev_zombie_move_speed = self.zombie_move_speed;
                self.zombie_move_speed = "walk";
            }
        }
        else
        {
            // he has attacked, make sure to reset him
            if( isdefined( self.prev_zombie_move_speed ) )
            {
                self.zombie_move_speed = self.prev_zombie_move_speed;
                self.prev_zombie_move_speed = undefined;
            }
        }
        WAIT_SERVER_FRAME;
    }
}

function zombie_unpush()
{
	self endon( "death" );

	while(isdefined(self))
	{
		self PushActors(false);
		wait(0.05);
	}
}

function spare_change( str_trigger = "audio_bump_trigger", str_sound = "zmb_perks_bump_bottle" )
{
	// Check under the machines for change
	a_t_audio = GetEntArray( str_trigger, "targetname" );
	foreach( t_audio_bump in a_t_audio )
	{
		if ( t_audio_bump.script_sound === str_sound )
		{
			t_audio_bump thread check_for_change();
		}
	}
}

function check_for_change()//self = trigger
{
	self endon( "death" );
	
	while( true )
	{
		self waittill( "trigger", player );

		if ( player GetStance() == "prone" )
		{	
			// Standard Coins
			num_quarters = RandomIntRange(0, 7);
			num_dimes = RandomIntRange(0, 6);
			num_nickels = RandomIntRange(0, 5);

			// Rare Coins
			num_dollars = RandomIntRange(1, 100);
			num_half_dollars = RandomIntRange(1, 200);
			num_pennies = RandomIntRange(1, 400);

			zm_utility::play_sound_at_pos( "purchase", player.origin );
			player add_change(100, num_dollars, 1);
			player add_change(50, num_half_dollars, 2);
			player add_change(25, num_quarters);
			player add_change(10, num_dimes);
			player add_change(5, num_nickels);
			player add_change(1, num_pennies, 4);		
			break;
		}

		wait 0.1;
	}
}

function add_change(denomination, amount, cutoff)
{
	if(isdefined(cutoff) && amount > cutoff)
	{
		return;
	}

	for(i = 0; i < amount; i++)
	{
		wait(0.05);
		self add_to_player_score(denomination);
	}
}

// need to bypass zm_score's rounding
function add_to_player_score( points )
{
	if( !isdefined( points ) || level.intermission )
	{
		return;
	}
	
	self.score += points;
	self.pers["score"] = self.score;
	self IncrementPlayerStat("scoreEarned", points);
	level notify( "earned_points", self, points );
	
	self.score_total += points;
	level.score_total += points; // also add to all players' running total score
}

function damage_adjustment(  inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType  )
{
    if (isPlayer( attacker ) && attacker.shadowDouble)
	{
		return Int(damage * 0.75);
	}

	if(isPlayer(attacker) && attacker HasPerk(PERK_DEAD_SHOT) && zm_utility::is_headshot( weapon, sHitLoc, meansofdeath ))
	{
		return Int(damage * 1.5);
	}

	return -1;
}

function player_damage_adjustment(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	if(sMeansOfDeath == "MOD_FALLING")
	{
		return iDamage * 2;
	}
	
	return -1;
}

function usermap_test_zone_init()
{
	//zm_zonemgr::zone_init( "boss_zone" );
	zm_zonemgr::add_adjacent_zone( "start_zone", "wtower", "enter_wtower");
	zm_zonemgr::add_adjacent_zone( "wtower", "dirty", "enter_dirty");
	zm_zonemgr::add_adjacent_zone( "wtower", "clean", "enter_clean");
	zm_zonemgr::add_adjacent_zone( "clean", "downstairs", "enter_downstairs");
	zm_zonemgr::add_adjacent_zone( "downstairs", "paproom", "enter_paproom");
	zm_zonemgr::add_adjacent_zone( "start_zone", "staminarch", "enter_staminarch");
	level flag::init( "always_on" );
	level flag::set( "always_on" );
}	

function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_levelcommon_weapons.csv", 1);
}

function zm_castle_vox()
{
	zm_audio::loadPlayerVoiceCategories("gamedata/audio/zm/zm_castle_vox.csv");
}

function testeroo()
{
	while(1)
	{
		traps = GetEntArray( "zombie_trap", "targetname" );
		IPrintLn("hello!");
		IPrintLn(traps.size);
		wait(0.5);
	}
}


