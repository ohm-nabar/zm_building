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
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_thundergun;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_perk_electric_cherry;
#using scripts\zm\zm_ai_shadowpeople;

#using scripts\Sphynx\_zm_sphynx_util;

#define TRIDENT_STATUE_RADIUS_SQ 202500 // 450^2
#define TRIDENT_PULSE_RADIUS_SQ 10000 // 100^2
#define TRIDENT_UPGRADE_KILLS 25

#define TRIDENT_MELEE_DAMAGE 2702 // Kills through Round 20
#define TRIDENT_STREAK_KILLS 5
#define TRIDENT_COOLDOWN_TIME 30
#define TRIDENT_WATER_PULSE_TIME 1
#define TRIDENT_WHIRLPOOL_RADIUS_SQ 8100 // 90^2
#define TRIDENT_WHIRLPOOL_TIME 8
#define TRIDENT_SLOWDOWN_TIME 8
#define TRIDENT_WHIRLPOOL_SCALAR 50
#define TRIDENT_FLING_ZOMBIES_MAX 4
#define TRIDENT_FLING_SCALAR 100
#define TRIDENT_FLING_RADIUS 100

#define ELECTRIC_CHERRY_STUN_CYCLES 4


#precache( "model", "isaypwn_trident_a_view_01" );
#precache( "model", "isaypwn_trident_b_upg_view_01" );

#precache( "triggerstring", "ZM_ABBEY_TRIDENT_SEEK" );
#precache( "triggerstring", "ZM_ABBEY_TRIDENT_REJECT" );
#precache( "triggerstring", "ZM_ABBEY_TRIDENT_CHARGE" );

#precache( "string", "ZM_ABBEY_TRIDENT_HINT" );

#namespace zm_trident;

REGISTER_SYSTEM_EX( "zm_trident", &__init__, &__main__, undefined )
	
function __init__()
{
	level clientfield::register( "actor", "trident_linger", VERSION_SHIP, 1, "int" );
	level clientfield::register( "allplayers", "trident_glow", VERSION_SHIP, 2, "int");
	level clientfield::register( "actor", "trident_ring", VERSION_SHIP, 1, "int");
	level clientfield::register( "scriptmover", "trident_whirlpool", VERSION_SHIP, 1, "int");
	level clientfield::register( "clientuimodel", "tridentClip", VERSION_SHIP, 1, "int");

    level.abbey_trident = GetWeapon("zm_trident");

    level.abbey_pitchfork = GetWeapon("zm_pitchfork");

	level.pitchfork_available = false;
    level.pitchfork_upgrading = false;

    level.pack_a_punch.custom_validation = &pitchfork_pack_block;

    level.trident_shell_activated = false;
	level.trident_init_room = "Merveille de Verite";
	if(GetDvarString("ui_mapname") == "zm_building")
	{
		level.trident_init_room = "Clean Room";
	}

    level callback::on_connect( &on_player_connect );
    level zm::register_actor_damage_callback( &damage_adjustment );
	level zm::register_zombie_damage_override_callback( &zombie_damage_override );
    level zm_weapons::add_custom_limited_weapon_check( &pitchfork_statue_check );
	level zm_weapons::register_zombie_weapon_callback( level.abbey_trident, &player_give_trident );
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
	if(isdefined(attacker) && IsPlayer(attacker) && weapon == level.abbey_trident)
	{
		if(willBeKilled)
		{
			self.no_powerups = true;
		}
		if(meansofdeath == "MOD_MELEE")
		{
			attacker thread preserve_ammo_on_melee();
		}
	}
	if(IS_TRUE(self.thundergun_death))
	{
		self.no_powerups = true;
	}
}

function preserve_ammo_on_melee()
{
	self endon("disconnect");

	stock_ammo = self GetWeaponAmmoStock(level.abbey_trident);
	if(self bgb::is_enabled( "zm_bgb_stock_option" ) && stock_ammo > 0)
	{
		stock_ammo_start = stock_ammo;
		while(stock_ammo == stock_ammo_start)
		{
			wait(0.05);
			stock_ammo = self GetWeaponAmmoStock(level.abbey_trident);
		}
		if(stock_ammo < stock_ammo_start)
		{
			self SetWeaponAmmoStock(level.abbey_trident, stock_ammo_start);
		}
	}
	else
	{
		clip_ammo = self GetWeaponAmmoClip(level.abbey_trident);
		if(clip_ammo == 0)
		{
			return;
		}
		while(clip_ammo > 0)
		{
			wait(0.05);
			clip_ammo = self GetWeaponAmmoClip(level.abbey_trident);
		}
		self SetWeaponAmmoClip(level.abbey_trident, 1);
	}
}

function on_player_connect()
{
	self.trident_power_level = 0;
	self.trident_melee_kills = 0;
	self clientfield::set_player_uimodel("tridentClip", 1);

	self thread monitor_trident();
	self thread monitor_trident_melee_streaks();
	self thread monitor_trident_melee_reset();
	self thread monitor_trident_fx();
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
	if (isPlayer( attacker ) && weapon == level.abbey_trident && meansofdeath == "MOD_PROJECTILE")
	{
		if(self zm_ai_shadowpeople::is_shadow_boss())
		{
			return Int(self.maxhealth/6);
		}

		return self.health + 666;
	}

	if (isPlayer( attacker ) && meansofdeath == "MOD_MELEE")
	{
		if(weapon == level.abbey_pitchfork)
		{
			if(self zm_ai_shadowpeople::is_shadow_boss())
			{
				return Int(self.maxhealth/10);
			}
			else
			{
				return TRIDENT_MELEE_DAMAGE;
			}
		}

		if(weapon == level.abbey_trident)
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
					if (TRIDENT_MELEE_DAMAGE >= self.health)
					{
						attacker.trident_melee_kills += 1;
					}
					return TRIDENT_MELEE_DAMAGE;
				}
				else if(attacker.trident_power_level == 1)
				{
					attacker.trident_melee_kills += 1;
					return self.health + 666;
				}
				else if(attacker.trident_power_level == 2)
				{
					attacker.trident_melee_kills += 1;
					self thread water_pulse(attacker, false);
					return self.health + 666;
				}
				else
				{
					attacker.trident_melee_kills += 1;
					self thread water_pulse(attacker, true);
					return self.health + 666;
				}
			}
		}
	}
	return -1;
}

function water_pulse(attacker, should_kill)
{
	self clientfield::set("trident_ring", 1);
	origin = self.origin;
	zombies = zombie_utility::get_round_enemy_array();
	for(i = 0; i < TRIDENT_WATER_PULSE_TIME; i += 0.05)
	{
		for(j = 0; j < zombies.size; j++)
		{
			if( isdefined(zombies[j]) && IsAlive(zombies[j]) && DistanceSquared(zombies[j].origin, origin) < TRIDENT_PULSE_RADIUS_SQ && ! zombies[j] zm_ai_shadowpeople::is_shadow_boss() )
			{
				if(should_kill)
				{
					//IPrintLn("real damage");
					zombies[j].no_powerups = true;
					zombies[j] DoDamage( zombies[j].health + 666, origin, attacker );
				}
				else
				{
					zombies[j].trident_shocked = true;
					if(IS_EQUAL(zombies[j].animname, "quad_zombie"))
					{
						zombies[j] thread quad_stun();
					}
					else
					{
						zombies[j] thread zm_perk_electric_cherry::electric_cherry_stun();
						zombies[j] thread monitor_stun();
					}
				}
			}
		}
		wait(0.05);
	}
	if(isdefined(self))
	{
		self clientfield::set("trident_ring", 0);
	}
}

function quad_stun()
{
	self ASMSetAnimationRate(0);
	self clientfield::set("trident_linger", 1);
	wait(ELECTRIC_CHERRY_STUN_CYCLES);
	if(isdefined(self) && ! IS_TRUE(self.trident_slowdown))
	{
		self.trident_shocked = false;
		self ASMSetAnimationRate(1);
		self clientfield::set("trident_linger", 0);
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

		while(self.trident_melee_kills < start_kills + TRIDENT_STREAK_KILLS && self HasWeapon(level.abbey_trident))
		{
			wait(0.05);
		}

		if(self HasWeapon(level.abbey_trident))
		{
			self.trident_power_level = self.trident_power_level + 1;
			switch(self.trident_power_level)
			{
				case 1:
					self notify(#"trident_cooldown_start");
				case 2:
					self PlaySound("trident_upgrade");
					break;
				case 3:
					self PlaySound("trident_upgrade_max");
					break;
			}
		}

		while(self.trident_power_level == 3)
		{
			wait(0.05);
		}
		wait(0.05);
	}
}

function monitor_trident_melee_reset()
{
	self endon("disconnect");

	while(true)
	{
		self waittill(#"trident_cooldown_start");
		for(i = 0; i < TRIDENT_COOLDOWN_TIME && self HasWeapon(level.abbey_trident); i += 0.05)
		{
			wait(0.05);
		}
		self PlaySound("trident_reset");
		self.trident_power_level = 0;
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
				self clientfield::set( "trident_glow", self.trident_power_level);
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

		while(kills < TRIDENT_UPGRADE_KILLS)
		{
			if( ! isdefined(self.upgrading_player) )
			{
				should_terminate = true;
				wait(0.05);
				break;
			}
			self.upgrading_player waittill(#"potential_challenge_kill", origin);
			if(DistanceSquared(origin, self.origin) <= TRIDENT_STATUE_RADIUS_SQ) {
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
	fxCarrier = Spawn("script_model", origin + (0, 0, 40));
	fxCarrier SetModel("tag_origin");
	fxCarrier clientfield::set("fx_floating_orb_glow", 1);
	fxCarrier MoveTo(self.origin, 0.5);
	wait(0.5);
	fxCarrier Delete();
}

function monitor_trident()
{
	self endon( "disconnect" );
	
	trident_clip = 0;
	allow_melee = true;
	while(true)
	{
		current_weapon = self GetCurrentWeapon();
		if(current_weapon == level.abbey_trident)
		{
			if(self GetWeaponAmmoClip(level.abbey_trident) == 1)
			{
				if(trident_clip == 0)
				{
					trident_clip = 1;
					self clientfield::set_player_uimodel("tridentClip", 1);
				}
			}
			else
			{
				trident_clip = 0;
			}

			if(! self.shadowPoseidon)
			{
				melee_cond = (self IsReloading() || self IsSlamming());
				if(melee_cond && allow_melee)
				{
					allow_melee = false;
					self AllowMelee(false);
				}
				else if(! melee_cond && ! allow_melee)
				{
					allow_melee = true;
					self AllowMelee(true);
				}
			}

			if(self IsSlamming())
			{
				// prevent immediate activation
				while(self IsOnGround())
				{
					wait(0.05);
				}
				while(! self IsOnGround())
				{
					wait(0.05);
				}
				self thread trident_create_whirlpool();
				while(self IsSlamming())
				{
					wait(0.05);
				}
			}
		}
		else if(current_weapon != level.abbey_trident && ! allow_melee && ! self.shadowPoseidon)
		{
			allow_melee = true;
			self AllowMelee(true);
		}
		wait(0.05);
	}
}

function zombie_filter(zombie)
{
	return (isdefined(zombie) && IsAlive(zombie) && ! zombie zm_ai_shadowpeople::is_shadow_boss() && IS_TRUE(zombie.completed_emerging_into_playable_area));
}

function trident_create_whirlpool()
{
	self endon("disconnect");

	forward_vector = VectorNormalize(AnglesToForward(self.angles));
	v_pos = self.origin + VectorScale(forward_vector, TRIDENT_WHIRLPOOL_SCALAR);

	zombies = GetAISpeciesArray("axis", "all");
	valid_zombies = level array::filter(zombies, false, &zombie_filter);
	slam_zombies = level array::get_all_closest(v_pos, valid_zombies, undefined, TRIDENT_FLING_ZOMBIES_MAX, TRIDENT_FLING_RADIUS);

	for(i = 0; i < slam_zombies.size; i++)
	{
		test_origin = slam_zombies[i] GetCentroid();
		fling_vec = VectorNormalize(v_pos - test_origin);
		fling_vec = (fling_vec[0], fling_vec[1], Abs(fling_vec[2]));
		fling_vec = VectorScale(fling_vec, TRIDENT_FLING_SCALAR);
		slam_zombies[i] thread zm_weap_thundergun::thundergun_fling_zombie(self, fling_vec, i);
	}

	if(self GetAmmoCount(level.abbey_trident) == 0)
	{
		return;
	}
	stock_ammo = self GetWeaponAmmoStock(level.abbey_trident);
	if(self bgb::is_enabled( "zm_bgb_stock_option" ) && stock_ammo > 0)
	{
		self SetWeaponAmmoStock(level.abbey_trident, stock_ammo - 1);
	}
	else
	{
		self SetWeaponAmmoClip(level.abbey_trident, 0);
		self clientfield::set_player_uimodel("tridentClip", 0);
	}

	fx_loc = Spawn("script_model", v_pos);
	fx_loc SetModel("tag_origin");
	fx_loc clientfield::set("trident_whirlpool", 1);
	fx_loc PlaySoundOnTag("trident_whirlpool", "tag_origin");
	fx_loc thread fx_loc_cleanup(self);

	for(i = 0; i < TRIDENT_WHIRLPOOL_TIME; i += 0.05)
	{
		zombies = zombie_utility::get_round_enemy_array();
		for(j = 0; j < zombies.size; j++)
		{
			if( isdefined(zombies[j]) && isdefined(zombies[j].origin) && isdefined(v_pos) && DistanceSquared(zombies[j].origin, v_pos) < TRIDENT_WHIRLPOOL_RADIUS_SQ )
			{
				if(zombies[j] zm_ai_shadowpeople::is_shadow_boss())
				{
					continue;
				}
				else
				{
					zombies[j] thread slowdown();
				}
			}
		}
		wait(0.05);
	}

	fx_loc notify("cleanup");
}

function fx_loc_cleanup(player)
{
	level util::waittill_any_ents_two(self, "cleanup", player, "disconnect");
	self Delete();
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
	wait(TRIDENT_SLOWDOWN_TIME);
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

function player_give_trident()
{
	self endon("disconnect");

	self thread zm_equipment::show_hint_text(&"ZM_ABBEY_TRIDENT_HINT", 5);
	self GiveWeapon(level.abbey_trident);
	self SwitchToWeapon(level.abbey_trident);
}