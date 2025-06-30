#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#insert scripts\shared\shared.gsh;

#precache( "triggerstring", "ZM_ABBEY_PANZERWURFMINE_USE" );
#precache( "triggerstring", "ZM_ABBEY_PANZERWURFMINE_RECHARGE", "2" );
#precache( "triggerstring", "ZM_ABBEY_PANZERWURFMINE_RECHARGE_SINGULAR" );

#precache( "triggerstring", "ZM_ABBEY_CROSSBOW_USE" );
#precache( "triggerstring", "ZM_ABBEY_CROSSBOW_RECHARGE" );

#define PANZERWURFMINE_COST_BASE 500
#define PANZERWURFMINE_COST_MAX 512000
#define PANZERWURFMINE_COOLDOWN 120

#define CROSSBOW_RECHARGE_KILLS_BASE 25
#define CROSSBOW_RECHARGE_KILLS_UPGRADE 50

#namespace zm_armory;

REGISTER_SYSTEM( "zm_armory", &__init__, undefined )

function __init__()
{
	panzerwurfmine_trigs = GetEntArray("panzerwurfmine_use", "targetname");
	crossbow_trigs = GetEntArray("crossbow_use", "targetname");
	level.panzerwurfmine = GetWeapon("zm_panzerwurfmine");
	level.panzerwurfmine_up = GetWeapon("zm_panzerwurfmine_up");
	level.panzerwurfmine_cost = PANZERWURFMINE_COST_BASE;
	level.panzerwurfmine_start_of_round = [];
	level.crossbow_upgraded = false;
	level.crossbow_recharge_kills = CROSSBOW_RECHARGE_KILLS_BASE;
	level.crossbow_recharge_progress = CROSSBOW_RECHARGE_KILLS_BASE;
	for(i = 0; i < 5; i++)
	{
		level.panzerwurfmine_start_of_round[i] = false;
		level.crossbow_shooting_active[i] = false;
	}	

	level callback::on_connect(&on_player_connect);
	level zm::register_zombie_damage_override_callback( &zombie_damage_override );
	level zm_utility::register_lethal_grenade_for_level("zm_panzerwurfmine");
	level zm_utility::register_lethal_grenade_for_level("zm_panzerwurfmine_up");
	level zm_weapons::register_zombie_weapon_callback( level.panzerwurfmine, &player_give_panzerwurfmine );
	level zm_weapons::register_zombie_weapon_callback( level.panzerwurfmine_up, &player_give_panzerwurfmine );
	level array::thread_all(panzerwurfmine_trigs, &panzerwurfmine_think);
	level array::thread_all(crossbow_trigs, &crossbow_think);
	level thread panzerwurfmine_cost_scale();
}

function on_player_connect()
{
	self.b_has_upgraded_panzerwurfmine = false;
	self thread panzerwurfmine_award_grenade_skip();
}

function zombie_damage_override(willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if ((willBeKilled && ! IS_TRUE(self.marked_for_recycle))|| (isPlayer( attacker ) && level.zombie_vars[attacker.team]["zombie_insta_kill"]))
	{
		if(level.crossbow_recharge_progress < level.crossbow_recharge_kills)
		{
			level.crossbow_recharge_progress += 1;
		}
	}
}

function panzerwurfmine_award_grenade_skip()
{
	self endon("disconnect");

	while(true)
	{
		level waittill("end_of_round");
		if(self zm_weapons::has_weapon_or_upgrade(level.panzerwurfmine))
		{
			self.altbody = true;
		}
		level waittill("start_of_round");
		self.altbody = false;
	}
}

function player_give_panzerwurfmine()
{
	self endon("disconnect");

	if ( isdefined( self zm_utility::get_player_lethal_grenade() ) )
	{
		self TakeWeapon( self zm_utility::get_player_lethal_grenade() );
	}
	
	if(self.b_has_upgraded_panzerwurfmine)
	{
		self GiveWeapon( level.panzerwurfmine_up );
		self zm_utility::set_player_lethal_grenade( level.panzerwurfmine_up );
	}
	else
	{
		self GiveWeapon( level.panzerwurfmine );
		self zm_utility::set_player_lethal_grenade( level.panzerwurfmine );
	}
}

function panzerwurfmine_cost_scale()
{
	while(level.panzerwurfmine_cost < PANZERWURFMINE_COST_MAX)
	{
		for(i = 0; i < 10; i++)
		{
			level waittill("start_of_round");
			for(i = 0; i < 5; i++)
			{
				level.panzerwurfmine_start_of_round[i] = true;
			}
		}
		level.panzerwurfmine_cost *= 2;
	}
}

function panzerwurfmine_hintstring_think()
{
	while(! IS_EQUAL(level.round_number, 1))
	{
		wait(0.05);
	}

	hintstring_state = -1;
	prev_cost = level.panzerwurfmine_cost;
	prev_recharge_time = self.recharge_time;
	cost_weapons = array(GetWeapon("s4_1911"), GetWeapon("s2_mas38"), GetWeapon("zm_healing_grenade"), GetWeapon("s4_gorenko_rifle"), GetWeapon("s4_mg42"), GetWeapon("s4_machinepistol"), GetWeapon("s4_mk11"), GetWeapon("s4_owen_gun"), GetWeapon("s4_nz41"), GetWeapon("s4_ratt"), GetWeapon("zm_panzerwurfmine"));
	while(true)
	{
		if(self.recharge_time == 0 && (hintstring_state != 0 || level.panzerwurfmine_cost != prev_cost))
		{
			hintstring_state = 0;
			prev_cost = level.panzerwurfmine_cost;
			cost_index = Int(level.round_number / 10);
			cost_weapon = cost_weapons[cost_index];
			self SetCursorHint("HINT_WEAPON", cost_weapon);
			self SetHintString(&"ZM_ABBEY_PANZERWURFMINE_USE");
		}
		else if(self.recharge_time > 1 && (hintstring_state != 1 || self.recharge_time != prev_recharge_time))
		{
			hintstring_state = 1;
			prev_recharge_time = self.recharge_time;
			self SetCursorHint("HINT_NOICON");
			self SetHintString(&"ZM_ABBEY_PANZERWURFMINE_RECHARGE", self.recharge_time);
		}
		else if(self.recharge_time == 1 && hintstring_state != 2)
		{
			hintstring_state = 2;
			self SetCursorHint("HINT_NOICON");
			self SetHintString(&"ZM_ABBEY_PANZERWURFMINE_RECHARGE_SINGULAR");
		}
		wait(0.05);
	}
}

function panzerwurfmine_think()
{
	self.recharge_time = 0;
	self SetCursorHint("HINT_NOICON");
	self SetHintString(&"ZOMBIE_NEED_POWER");

	if(self.script_int > 0)
	{
		level waittill("power_on" + self.script_int);
	}

	self thread panzerwurfmine_hintstring_think();

	while(true)
	{
		self.recharge_time = 0;
		level.panzerwurfmine_start_of_round[self.script_int] = false;
		self waittill("trigger", player);

		if(! (zm_utility::is_player_valid(player) && player zm_magicbox::can_buy_weapon()) || (player zm_weapons::has_weapon_or_upgrade(level.panzerwurfmine) && player GetFractionMaxAmmo(player zm_utility::get_player_lethal_grenade()) == 1))
		{
			continue;
		}

		if(player.score < level.panzerwurfmine_cost)
		{
			player PlaySound("zmb_no_cha_ching");
			player zm_audio::create_and_play_dialog( "general", "outofmoney" );
			continue;
		}

		player PlaySound("zmb_cha_ching");
		player zm_score::minus_to_player_score(level.panzerwurfmine_cost);
		player zm_weapons::weapon_give(level.panzerwurfmine);

		self.recharge_time = Ceil(PANZERWURFMINE_COOLDOWN / 60);
		for(i = PANZERWURFMINE_COOLDOWN; i > 0 && ! level.panzerwurfmine_start_of_round[self.script_int]; i--)
		{
			while(level.is_coop_paused)
			{
				wait(0.05);
			}
			wait(1);
			if(i % 60 == 0)
			{
				self.recharge_time = Ceil(i / 60);
			}
		}
	}
}

function crossbow_hintstring_think()
{
	zombie_vars_defined = false;
	while(! zombie_vars_defined)
	{
		if(isdefined(level.players))
		{
			foreach(player in level.players)
			{
				if(isdefined(player.zombie_vars))
				{
					zombie_vars_defined = true;
					break;
				}
			}
		}
		wait(0.05);
	}

	hintstring_state = -1;
	while(true)
	{
		crossbow_on = false;
		foreach(player in level.players)
		{
			if(player.zombie_vars[ "zombie_powerup_crossbow_on" ] || player.zombie_vars[ "zombie_powerup_crossbow_up_on" ])
			{
				crossbow_on = true;
			}
		}
		if(crossbow_on && hintstring_state != 0)
		{
			hintstring_state = 0;
			self SetHintString(&"ZM_ABBEY_CROSSBOW_IN_USE");
		}
		else if(level.crossbow_recharge_progress < level.crossbow_recharge_kills && hintstring_state != 1)
		{
			hintstring_state = 1;
			self SetHintString(&"ZM_ABBEY_CROSSBOW_RECHARGE");
		}
		else if(! crossbow_on && level.crossbow_recharge_progress >= level.crossbow_recharge_kills && hintstring_state != 2)
		{
			hintstring_state = 2;
			self SetHintString(&"ZM_ABBEY_CROSSBOW_USE");
		}
		wait(0.05);
	}
}

function crossbow_souls_think()
{
	canister = GetEnt("crossbow_soulbox" + self.script_int, "targetname");
	target_canister = GetEnt("crossbow_soulbox_target" + self.script_int, "targetname");
	target_canister SetInvisibleToAll();
	if(! isdefined(canister))
	{
		IPrintLn("canister undefined");
	}
	original_pos = canister.origin;
	z_diff = target_canister.origin[2] - canister.origin[2];
	prev_prog = -CROSSBOW_RECHARGE_KILLS_BASE;
	while(true)
	{
		new_prog = level.crossbow_recharge_progress - prev_prog;
		prev_prog = level.crossbow_recharge_progress;
		if(new_prog > 0)
		{
			z_inc = (z_diff / level.crossbow_recharge_kills) * new_prog;
			canister MoveZ(z_inc, 0.05);
			IPrintLn("moving up");
		}
		else if(new_prog < 0)
		{
			canister MoveZ(-z_diff, 0.05);
			IPrintLn("moving down");
		}
		wait(0.05);
	}
}

function crossbow_think()
{
	self SetCursorHint("HINT_NOICON");
	self SetHintString(&"ZOMBIE_NEED_POWER");

	/*
	if(self.script_int == 1)
	{
		self thread crossbow_souls_think();
	}
	*/

	if(self.script_int > 0)
	{
		level waittill("power_on" + self.script_int);
	}

	self thread crossbow_hintstring_think();

	while(true)
	{
		self waittill("trigger", player);

		if(! (zm_utility::is_player_valid(player) && player zm_magicbox::can_buy_weapon()))
		{
			continue;
		}
		
		powerup_struct = Spawn("script_origin", player.origin);
		if(level.crossbow_upgraded)
		{
			powerup_struct.powerup_name = "crossbow_up";
		}
		else
		{
			powerup_struct.powerup_name = "crossbow";
		}
		powerup_struct.zombie_grabbable = false;
		powerup_struct.only_affects_grabber = true;
		powerup_struct.can_pick_up_in_last_stand = false;
		powerup_struct.powerup_team = player.team;
		powerup_struct.powerup_location = player.origin;
		powerup_struct.powerup_player = player;

		powerup_struct zm_powerups::powerup_grab(player.team);

		while(player.zombie_vars[ "zombie_powerup_crossbow_on" ] || player.zombie_vars[ "zombie_powerup_crossbow_up_on" ])
		{
			wait(0.05);
		}

		level.crossbow_recharge_progress = 0;
		while(level.crossbow_recharge_progress < level.crossbow_recharge_kills)
		{
			wait(0.05);
		}
	}
}