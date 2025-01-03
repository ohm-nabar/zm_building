#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_zm_utility;
#using scripts\shared\callbacks_shared;
#using scripts\zm\_zm;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\scene_shared;
#using scripts\zm\_zm_spawner;
#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_perk_electric_cherry;

#insert scripts\shared\version.gsh;
#insert scripts\shared\shared.gsh;

#precache( "fx", "custom/whirlpool" );
#precache( "fx", "custom/water_rings" );
#precache( "fx", "custom/fx_trail_blood_soul_zmb" );

#precache( "model", "vm_trident" );

#namespace zm_trident;

REGISTER_SYSTEM( "zm_trident", &__init__, undefined )
	
function __init__()
{
	clientfield::register( "actor", "trident_linger", VERSION_SHIP, 1, "int" );
	clientfield::register( "allplayers", "trident_glow", VERSION_SHIP, 2, "int");

    level.abbey_trident = GetWeapon("zm_trident");

    level.abbey_pitchfork = GetWeapon("zm_pitchfork");

    level.trident_statue_radius = 275;
    level.trident_charge_radius = 65;
    level.trident_pulse_radius = 100;

	level.trident_cooldown_time = 10;

    level.pitchfork_melee_damage = 2702;
    level.trident_melee_damage = 2702;

    level.pitchfork_upgrading = false;

    level.trident_upgrade_kills = 25;

    level.pack_a_punch.custom_validation = &pitchfork_pack_block;

    level.trident_shell_activated = false;
	level.trident_init_room = "Choir";
	if(GetDvarString("ui_mapname") == "zm_building")
	{
		level.trident_init_room = "Clean Room";
	}

    statue_trig_init = GetEnt("poseidon_statue_trigger_init", "targetname");
    statue_trig_init thread upgrade_quest_init_think();

    statue_trig = GetEnt("poseidon_statue_trigger", "targetname");
    statue_trig thread upgrade_quest_think();

    callback::on_connect( &on_player_connect );
    zm::register_actor_damage_callback( &damage_adjustment );
    zm_weapons::add_custom_limited_weapon_check( &pitchfork_statue_check );
}

function on_player_connect()
{
	self.trident_power_level = 0;
	self.trident_melee_kills = 0;

	//self EnableInvulnerability();

	self thread watch_trident_fired();
	self thread monitor_trident_fired();
	self thread monitor_trident_used();
	self thread monitor_trident_melee_streaks();
	self thread monitor_trident_melee_reset();
	self thread monitor_trident_melee_used();
	self thread monitor_trident_fx();
	//self thread display_trident_power_level();
	//self thread testeroo();
}

function monitor_trident_used()
{
	self endon( "disconnect" );
	
	while (true)
	{
		weapon = self GetCurrentWeapon();
		if ( self IsFiring() && ! self IsMeleeing() && isdefined(weapon) && weapon == level.abbey_trident )
		{
			alias_name = "trident_fire" + RandomIntRange(1, 4);
			self PlaySound(alias_name);
			while (self IsFiring())
			{
				wait(0.05);
			}
		}
		wait(0.05);
	}
}

function monitor_trident_melee_used()
{
	self endon( "disconnect" );
	
	while (true)
	{
		weapon = self GetCurrentWeapon();
		if ( self IsMeleeing() && isdefined(weapon) && (weapon == level.abbey_pitchfork || weapon == level.abbey_trident) )
		{
			alias_name = "trident_melee_" + RandomIntRange(1, 4);
			self PlaySound(alias_name);
			while(self MeleeButtonPressed() || self IsMeleeing())
			{
				wait(0.05);
			}
		}
		wait(0.05);
	}
}

function pitchfork_statue_check(weapon)
{
	if(isdefined(weapon) && weapon == level.abbey_pitchfork && level.pitchfork_upgrading)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

function pitchfork_pack_block(player)
{
	weapon = player GetCurrentWeapon();
	if(isdefined(weapon) && weapon == level.abbey_pitchfork)
	{
		return false;
	}

	return true;
}

function damage_adjustment(  inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType  )
{
	if (isPlayer( attacker ) && isdefined(level.abbey_trident) && isdefined(weapon) && weapon == level.abbey_trident && meansofdeath == "MOD_PROJECTILE")
	{
		if(self.targetname == "zombie_cloak" || self.targetname == "zombie_escargot")
		{
			return Int(self.maxhealth/6);
		}

		return self.health + 666;
	}

	if (isPlayer( attacker ) && meansofdeath == "MOD_MELEE")
	{

		if(isdefined(level.abbey_pitchfork) && isdefined(weapon) && weapon == level.abbey_pitchfork)
		{
			if(self.targetname == "zombie_cloak" || self.targetname == "zombie_escargot")
			{
				return Int(self.maxhealth/10);
			}
			else
			{
				return level.pitchfork_melee_damage;
			}
		}

		if(isdefined(level.abbey_trident) && isdefined(weapon) && weapon == level.abbey_trident)
		{
			if(self.targetname == "zombie_cloak" || self.targetname == "zombie_escargot")
			{
				if(attacker.trident_power_level == 0)
				{
					return Int(self.maxhealth/5);
				}
				else if(attacker.trident_power_level == 1)
				{
					return Int(self.maxhealth/4);
				}
				else if(attacker.trident_power_level == 2)
				{
					return Int(self.maxhealth/3);
				}
				else
				{
					return Int(self.maxhealth/2);
				}
			}
			else
			{
				if(attacker.trident_power_level == 0)
				{
					if(IS_TRUE(self.trident_melee_weak))
					{
						attacker.trident_melee_kills += 1;
						return self.health + 666;
					}
					if (level.trident_melee_damage >= self.health)
					{
						attacker.trident_melee_kills += 1;
					}
					return level.trident_melee_damage;
				}
				else if(attacker.trident_power_level == 1)
				{
					attacker.trident_melee_kills += 1;
					return self.health + 666;
				}
				else if(attacker.trident_power_level == 2)
				{
					attacker.trident_melee_kills += 1;
					level thread water_pulse(self.origin, attacker, false);
					return self.health + 666;
				}
				else
				{
					attacker.trident_melee_kills += 1;
					level thread water_pulse(self.origin, attacker, true);
					return self.health + 666;
				}
			}
		}
	}
	return -1;
}

function water_pulse(origin, attacker, should_kill)
{
	PlayFX("custom/water_rings", origin + (0, 0, 45));
	zombies = zombie_utility::get_round_enemy_array();
	for(i = 0; i < 20; i++)
	{
		for(j = 0; j < zombies.size; j++)
		{
			if( Distance(zombies[j].origin, origin) < level.trident_pulse_radius )
			{
				if((isdefined(zombies[j].targetname) && (zombies[j].targetname == "zombie_escargot" || zombies[j].targetname == "zombie_cloak")) || (isdefined(self.animname) && self.animname == "quad_zombie"))
				{
					continue;
				}
				else if(should_kill)
				{
					//IPrintLn("real damage");
					zombies[j] DoDamage( zombies[j].health + 666, origin, attacker );
				}
				else
				{
					zombies[j].trident_shocked = true;
					zombies[j] thread zm_perk_electric_cherry::electric_cherry_stun();
					zombies[j] thread monitor_stun();
				}
			}
		}
		wait(0.05);
	}
}

function monitor_stun()
{
	self endon("death");

	self clientfield::set("trident_linger", 1);
	self util::waittill_any("stun_fx_end", "death");
	self.trident_shocked = false;
	
	while (IS_TRUE(self.trident_shocked) || IS_TRUE(self.trident_slowdown))
	{
		wait(0.05);
	}
	
	self clientfield::set( "trident_linger", 0 );
}

function monitor_trident_melee_streaks()
{
	self endon("disconnect");

	while(true)
	{
		start_kills = self.trident_melee_kills;

		while(self.trident_melee_kills < start_kills + 1)
		{
			wait(0.05);
		}

		//IPrintLn("Kill 1");

		success = true;
		for(i = 2; i <= 5; i++)
		{
			counter = 0;
			while(self.trident_melee_kills < start_kills + i && counter <= 40) // 40 = 2 / 0.05
			{
				counter++;
				wait(0.05);
			}
			if(self.trident_melee_kills < start_kills + i)
			{ 
				success = false;
				break;
			}
			//IPrintLn("Kill " + i);
		}

		if(success)
		{
			self.trident_power_level = Min(self.trident_power_level + 1, 3);
			if(self.trident_power_level < 3)
			{
				self PlaySound("trident_upgrade");
			}
			else
			{
				self PlaySound("trident_upgrade_max");
			}
			//IPrintLn("Pentakill, trident power level is now " + self.trident_power_level);
		}

		wait(0.05);
	}
}

function monitor_trident_melee_reset()
{
	self endon("disconnect");

	while(true)
	{
		start_kills = self.trident_melee_kills;
		for(i = 0; i < level.trident_cooldown_time; i += 0.05)
		{
			if (self.trident_melee_kills > start_kills)
			{
				break;
			}
			wait(0.05);
		}
		
		if(start_kills == self.trident_melee_kills)
		{
			//IPrintLn("Resetting trident power level");
			if(self.trident_power_level > 0)
			{	
				self PlaySound("trident_reset");
			}
			self.trident_power_level = 0;
		}
	}
}

function display_trident_power_level()
{
	self endon("disconnect");

	power_level_hud = NewClientHudElem(self);
	power_level_hud.alignX = "center";
	power_level_hud.alignY = "bottom";
	power_level_hud.horzAlign = "fullscreen";
	power_level_hud.vertAlign = "fullscreen";
	power_level_hud.x = 320;
	power_level_hud.y = 400;
	power_level_hud.fontscale = level.challenge_fontscale;
	power_level_hud.alpha = 0;
	power_level_hud.color = (1,1,1);
	power_level_hud.foreground = true;
	power_level_hud.hidewheninmenu = true;

	prev_power_level = -1;
	trident_put_away = true;
	while(true)
	{
		weapon = self GetCurrentWeapon();
		if (isdefined(weapon) && weapon == level.abbey_trident && (self.trident_power_level != prev_power_level || trident_put_away))
		{
			prev_power_level = self.trident_power_level;
			trident_put_away = false;
			power_level_hud SetText("Power Level " + self.trident_power_level);
			power_level_hud.alpha = 1;
		}
		if(isdefined(weapon) && weapon != level.abbey_trident && ! trident_put_away)
		{
			trident_put_away = true;
			power_level_hud.alpha = 0;
		}
		wait(0.05);
	}

}

function monitor_trident_fx()
{
	self endon("disconnect");

	prev_power_level = 0;
	has_reset = false;
	while(true)
	{
		weapon = self GetCurrentWeapon();
		while(isdefined(weapon) && weapon == level.abbey_trident)
		{
			if(self.trident_power_level != prev_power_level || has_reset)
			{
				self clientfield::set( "trident_glow", Int(self.trident_power_level) );
				prev_power_level = self.trident_power_level;
			}
			has_reset = false;
			weapon = self GetCurrentWeapon();
			wait(0.05);
		}

		if(! has_reset)
		{
			self clientfield::set( "trident_glow", 0 );
			has_reset = true;
		}
		wait(0.05);
	}
}

function upgrade_quest_think()
{
	self SetCursorHint("HINT_NOICON");
	statue = GetEnt(self.target, "targetname");
	weapon = GetEnt(statue.target, "targetname");

	while(true)
	{
		level.pitchfork_upgrading = false;
		weapon SetInvisibleToAll();
		self SetHintString(&"ZM_ABBEY_TRIDENT_SEEK");
		upgrading_player = undefined;

		while(true)
		{
			self waittill("trigger", player);
			upgrading_player = player;
			player_weapon = upgrading_player GetCurrentWeapon();
			if(! zm_utility::is_player_valid(upgrading_player) || IS_TRUE(upgrading_player.isInBloodMode))
			{
				continue;
			}
			if(isdefined(player_weapon) && player_weapon == level.abbey_pitchfork)
			{
				break;
			}
			self SetHintString(&"ZM_ABBEY_TRIDENT_REJECT");
			wait(1);
			self SetHintString(&"ZM_ABBEY_TRIDENT_SEEK");
		}

		level.pitchfork_upgrading = true;
		self SetHintString(&"ZM_ABBEY_TRIDENT_CHARGE");

		upgrading_player zm_weapons::weapon_take(player_weapon);

		weapon SetModel("vm_trident");
		weapon SetVisibleToAll();

		kills = 0;
		should_terminate = false;

		while(kills < level.trident_upgrade_kills)
		{
			if( ! isdefined(upgrading_player) )
			{
				should_terminate = true;
				wait(0.05);
				break;
			}
			upgrading_player waittill(#"potential_challenge_kill", origin);
			if(Distance(origin, statue.origin) <= level.trident_statue_radius) {
				statue thread soul_fx(origin);
				kills++;
			}
		}

		if(should_terminate)
		{
			wait(0.05);
			continue;
		}

		weapon SetModel("vm_trident");
		self SetHintString(&"ZM_ABBEY_TAKE_WEAPON", level.abbey_trident.displayname);

		while(isdefined(upgrading_player))
		{
			self waittill("trigger", player);
			if(player == upgrading_player && zm_utility::is_player_valid(upgrading_player) && ! IS_TRUE(upgrading_player.isInBloodMode))
			{
				break;
			}
		}

		if(isdefined(upgrading_player))
		{
			upgrading_player zm_weapons::weapon_give(level.abbey_trident);
		}
		wait(0.05);
	}
}

function upgrade_quest_init_think()
{
	self SetCursorHint("HINT_NOICON");
	statue = GetEnt(self.target, "targetname");
	weapon = GetEnt(statue.target, "targetname");
	weapon SetInvisibleToAll();

	while(! level.trident_shell_activated)
	{
		wait(0.05);
	}

	weapon SetVisibleToAll();
	self SetHintString(&"ZM_ABBEY_TAKE_WEAPON", level.abbey_pitchfork.displayname);

	self waittill("trigger", player);
	while(! zm_utility::is_player_valid(player) || IS_TRUE(player.isInBloodMode))
	{
		self waittill("trigger", player);
	}
	player zm_weapons::weapon_give(level.abbey_pitchfork);
	weapon SetInvisibleToAll();
	self SetHintString(&"ZM_ABBEY_EMPTY");
}

function soul_fx(origin)
{
	//IPrintLn("spawning the fx");
	fxCarrier = Spawn("script_model", origin + (0, 0, 40));
	fxCarrier SetModel("tag_origin");
	PlayFXOnTag("custom/fx_trail_blood_soul_zmb", fxCarrier, "tag_origin");
	
	dist = Distance(origin, self.origin);
	travelTime = dist * 0.01;

	fxCarrier MoveTo(self.origin + (0, 0, 40) , 0.5);
	
	wait(0.5);
	fxCarrier Delete();
}

//from Harry Bo21's staff code
function watch_trident_fired()
{
	self endon( "disconnect" );
	
	while ( 1 )
	{
		self waittill( #"trident_fired", e_projectile, str_weapon);
		fire_angles = vectorToAngles( self getWeaponForwardDir() );
		fire_origin = self getWeaponMuzzlePoint();
		e_projectile thread trident_position_source( self, str_weapon);
	}
}

function trident_position_source( player, str_weapon)
{
	self util::waittill_any( "grenade_bounce", "stationary", "death", "explode" );

	//IPrintLn("DONEZO");
	
	/*
	if ( !isDefined( self ) )
		return;
	*/

	v_pos = self.origin;
	v_pos += (0, 0, 10);
	//IPrintLn(v_pos);

	//PlaySoundAtPosition("trident_whirlpool", v_pos, player);
	fx_loc = Spawn("script_model", v_pos);
	fx_loc SetModel("tag_origin");
	PlayFXOnTag("custom/whirlpool", fx_loc, "tag_origin");
	fx_loc PlaySoundOnTag("trident_whirlpool", "tag_origin");

	for(i = 0; i < 250; i++)
	{
		zombies = zombie_utility::get_round_enemy_array();
		for(j = 0; j < zombies.size; j++)
		{
			if( Distance(zombies[j].origin, v_pos) < level.trident_charge_radius )
			{
				if(zombies[j].targetname == "zombie_escargot" || zombies[j].targetname == "zombie_cloak")
				{
					continue;
				}
				else
				{
					//IPrintLn("real damage");
					zombies[j] thread slowdown();
				}
			}
		}
		wait(0.05);
	}

	fx_loc Delete();
}

function slowdown()
{
	self endon("death");

	if(IS_TRUE(self.trident_slowdown))
	{
		return;
	}

	self.trident_slowdown = true;
	self thread check_for_death();
	self ASMSetAnimationRate(0.1);
	self clientfield::set( "trident_linger", 1 );
	self.trident_melee_weak = true;
	wait(10);
	self ASMSetAnimationRate(1);
	self.trident_slowdown = false;
	self.trident_melee_weak = false;

	while (IS_TRUE(self.trident_shocked) || IS_TRUE(self.trident_slowdown))
	{
		wait(0.05);
	}

	self clientfield::set( "trident_linger", 0 );
}

function check_for_death()
{
	self waittill("death");
	self ASMSetAnimationRate(1);
	self clientfield::set( "trident_linger", 0 );
}

//from Harry Bo21's staff code
function monitor_trident_fired()
{
	self endon( "disconnect" );
	
	while ( 1 )
	{
		self waittill( "missile_fire", e_projectile, str_weapon );
		
		if ( isdefined(str_weapon) && str_weapon != level.abbey_trident )
		{
			continue;
		}

		self notify( #"trident_fired", e_projectile, str_weapon);
	}
}


function testeroo()
{
	//self thread testerootoo();
	while(true) 
	{
		IPrintLn(self IsMeleeing());
		wait(0.5);
	}
}

function testerootoo()
{
	level waittill("start_of_round");
	wait(30);
	self SetMoveSpeedScale(0);
}