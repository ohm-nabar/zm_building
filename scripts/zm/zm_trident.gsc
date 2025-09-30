#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai\zombie_utility;

#insert scripts\shared\version.gsh;
#insert scripts\shared\shared.gsh;

#using scripts\zm\_zm;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_perk_electric_cherry;
#using scripts\zm\zm_ai_shadowpeople;

#using scripts\Sphynx\_zm_sphynx_util;

#precache( "fx", "custom/whirlpool" );
#precache( "fx", "custom/water_rings" );
#precache( "fx", "custom/fx_trail_blood_soul_zmb" );

#precache( "model", "isaypwn_trident_a_view_01" );
#precache( "model", "isaypwn_trident_b_upg_view_01" );

#precache( "triggerstring", "ZM_ABBEY_TRIDENT_SEEK" );
#precache( "triggerstring", "ZM_ABBEY_TRIDENT_REJECT" );
#precache( "triggerstring", "ZM_ABBEY_TRIDENT_CHARGE" );

#namespace zm_trident;

REGISTER_SYSTEM_EX( "zm_trident", &__init__, &__main__, undefined )
	
function __init__()
{
	clientfield::register( "actor", "trident_linger", VERSION_SHIP, 1, "int" );
	clientfield::register( "allplayers", "trident_glow", VERSION_SHIP, 2, "int");

    level.abbey_trident = GetWeapon("zm_trident");

    level.abbey_pitchfork = GetWeapon("zm_pitchfork");

    level.trident_statue_radius_sq = 450 * 450;
    level.trident_charge_radius_sq = 65 * 65;
    level.trident_pulse_radius_sq = 100 * 100;

	level.trident_cooldown_time = 10;

    level.pitchfork_melee_damage = 2702;
    level.trident_melee_damage = 2702;

	level.pitchfork_available = false;
    level.pitchfork_upgrading = false;

    level.trident_upgrade_kills = 25;

    level.pack_a_punch.custom_validation = &pitchfork_pack_block;

    level.trident_shell_activated = false;
	level.trident_init_room = "Merveille de Verite";
	if(GetDvarString("ui_mapname") == "zm_building")
	{
		level.trident_init_room = "Clean Room";
	}

    callback::on_connect( &on_player_connect );
    zm::register_actor_damage_callback( &damage_adjustment );
	zm::register_zombie_damage_override_callback( &zombie_damage_override );
    zm_weapons::add_custom_limited_weapon_check( &pitchfork_statue_check );
}

function __main__()
{
	statue_trig_init = struct::get("poseidon_statue_trigger_init", "targetname");
    statue_trig_init thread upgrade_quest_init_think();

    statue_trig = struct::get("poseidon_statue_trigger", "targetname");
    statue_trig thread upgrade_quest_think();
}

function zombie_damage_override(willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if(willBeKilled && isdefined(attacker) && IsPlayer(attacker) && isdefined(weapon) && weapon == level.abbey_trident)
	{
		self.no_powerups = true;
	}
}

function on_player_connect()
{
	self.trident_power_level = 0;
	self.trident_melee_kills = 0;

	self thread watch_trident_fired();
	self thread monitor_trident_fired();
	self thread monitor_trident_melee_streaks();
	self thread monitor_trident_melee_reset();
	self thread monitor_trident_fx();
	//self thread display_trident_power_level();
	//self thread testeroo();
}

function pitchfork_statue_check(weapon)
{
	if(isdefined(weapon) && weapon == level.abbey_pitchfork)
	{
		if(level.pitchfork_available || level.pitchfork_upgrading)
		{
			return 1;
		}

		foreach(player in level.players)
		{
			if(player HasWeapon(level.abbey_trident))
			{
				return 1;
			}
			else if(isdefined(player.gunToGiveBack) && (player.gunToGiveBack == level.abbey_pitchfork || player.gunToGiveBack == level.abbey_trident))
			{
				return 1;
			}
			else if(isdefined(player.shadowThirdGun) && (player.shadowThirdGun == level.abbey_pitchfork || player.shadowThirdGun == level.abbey_trident))
			{
				return 1;
			}
		}
	}
	
	return 0;
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
		if(self zm_ai_shadowpeople::is_shadow_boss())
		{
			return Int(self.maxhealth/6);
		}

		return self.health + 666;
	}

	if (isPlayer( attacker ) && meansofdeath == "MOD_MELEE")
	{
		if(isdefined(level.abbey_pitchfork) && isdefined(weapon) && weapon == level.abbey_pitchfork)
		{
			if(self zm_ai_shadowpeople::is_shadow_boss())
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
			if(self zm_ai_shadowpeople::is_shadow_boss())
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
			if( isdefined(zombies[j]) && IsAlive(zombies[j]) && DistanceSquared(zombies[j].origin, origin) < level.trident_pulse_radius_sq )
			{
				if(zombies[j] zm_ai_shadowpeople::is_shadow_boss() || (isdefined(zombies[j].animname) && zombies[j].animname == "quad_zombie"))
				{
					continue;
				}
				else if(should_kill)
				{
					//IPrintLn("real damage");
					zombies[j].no_powerups = true;
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

function statue_prompt_and_visibility(player)
{
	struct = self.stub.related_parent;

	if(level.pitchfork_upgrading)
	{
		if(struct.weapon_ready)
		{
			if(! (player zm_magicbox::can_buy_weapon() && player == struct.upgrading_player))
			{
				self SetCursorHint("HINT_NOICON");
				self SetHintString(&"ZM_ABBEY_EMPTY");
				return false;
			}
			self SetCursorHint("HINT_WEAPON", level.abbey_trident);
			self SetHintString(&"ZM_ABBEY_TAKE_WEAPON");
			return true;
		}
		self SetCursorHint("HINT_NOICON");
		self SetHintString(&"ZM_ABBEY_TRIDENT_CHARGE");
		return false;
	}
	if(struct.weapon_rejected)
	{
		self SetCursorHint("HINT_NOICON");
		self SetHintString(&"ZM_ABBEY_TRIDENT_REJECT");
		return false;
	}

	self SetCursorHint("HINT_NOICON");
	self SetHintString(&"ZM_ABBEY_TRIDENT_SEEK");
	return true;
}

function upgrade_quest_think()
{
	self zm_sphynx_util::create_unitrigger_for_player_specific(&"ZM_ABBEY_TRIDENT_SEEK", undefined, &statue_prompt_and_visibility);
	weapon_struct = struct::get("poseidon_weapon", "targetname");

	while(true)
	{
		self.weapon_ready = false;
		self.weapon_rejected = false;
		level.pitchfork_upgrading = false;
		self.upgrading_player = undefined;
		player_weapon = level.weaponNone;

		while(player_weapon != level.abbey_pitchfork)
		{
			self waittill("trigger_activated", player);
			self.upgrading_player = player;
			player_weapon = self.upgrading_player GetCurrentWeapon();

			if(player_weapon != level.abbey_pitchfork)
			{
				self.weapon_rejected = true;
				wait(1);
				self.weapon_rejected = false;
			}
		}

		level.pitchfork_upgrading = true;

		self.upgrading_player zm_weapons::weapon_take(player_weapon);

		weapon = Spawn("script_model", weapon_struct.origin);
		weapon.angles = weapon_struct.angles;
		weapon SetModel("isaypwn_trident_a_view_01");

		kills = 0;
		should_terminate = false;

		while(kills < level.trident_upgrade_kills)
		{
			if( ! isdefined(self.upgrading_player) )
			{
				should_terminate = true;
				wait(0.05);
				break;
			}
			self.upgrading_player waittill(#"potential_challenge_kill", origin);
			if(DistanceSquared(origin, self.origin) <= level.trident_statue_radius_sq) {
				self thread soul_fx(origin);
				kills++;
			}
		}

		if(should_terminate)
		{
			wait(0.05);
			continue;
		}

		PlaySoundAtPosition("trident_complete_sting", self.origin);
		weapon SetModel("isaypwn_trident_b_upg_view_01");
		self.weapon_ready = true;

		level util::waittill_any_ents_two(self, "trigger_activated", self.upgrading_player, "disconnect");

		weapon Delete();
		if(isdefined(self.upgrading_player))
		{
			self.upgrading_player zm_weapons::weapon_give(level.abbey_trident);
		}
		wait(0.05);
	}
}

function statue_init_prompt_and_visibility(player)
{
	if(! (level.pitchfork_available && player zm_magicbox::can_buy_weapon()))
	{
		self SetCursorHint("HINT_NOICON");
		self SetHintString(&"ZM_ABBEY_EMPTY");
		return false;
	}

	self SetCursorHint("HINT_WEAPON", level.abbey_pitchfork);
	self SetHintString(&"ZM_ABBEY_TAKE_WEAPON");
	return true;
}

function upgrade_quest_init_think()
{
	self zm_sphynx_util::create_unitrigger_for_player_specific(&"ZM_ABBEY_EMPTY", undefined, &statue_init_prompt_and_visibility);
	weapon_struct = struct::get("poseidon_weapon_init", "targetname");

	while(! level.trident_shell_activated)
	{
		wait(0.05);
	}

	weapon = Spawn("script_model", weapon_struct.origin);
	weapon.angles = weapon_struct.angles;
	weapon SetModel("isaypwn_trident_a_view_01");

	PlaySoundAtPosition("trident_escargot_sting", self.origin);
	
	level.pitchfork_available = true;

	self waittill("trigger_activated", player);
	player zm_weapons::weapon_give(level.abbey_pitchfork);
	weapon Delete();
	level.pitchfork_available = false;
}

function soul_fx(origin)
{
	//IPrintLn("spawning the fx");
	fxCarrier = Spawn("script_model", origin + (0, 0, 40));
	fxCarrier SetModel("tag_origin");
	PlayFXOnTag("custom/fx_trail_blood_soul_zmb", fxCarrier, "tag_origin");
	fxCarrier MoveTo(self.origin, 0.5);
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
			if( isdefined(zombies[j]) && isdefined(zombies[j].origin) && isdefined(v_pos) && DistanceSquared(zombies[j].origin, v_pos) < level.trident_charge_radius_sq )
			{
				if(zombies[j] zm_ai_shadowpeople::is_shadow_boss())
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