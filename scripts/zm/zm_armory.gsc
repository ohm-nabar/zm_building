#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_armory;

#define PANZERWURFMINE_COST_BASE 500
#define PANZERWURFMINE_COST_MAX 512000
#define PANZERWURFMINE_COOLDOWN 120

REGISTER_SYSTEM( "zm_armory", &__init__, undefined )

function __init__()
{
	panzerwurmine_trigs = GetEntArray("panzerwurmine_use", "targetname");
	crossbow_trigs = GetEntArray("crossbow_use", "targetname");
	level.panzerwurfmine = GetWeapon("zm_panzerwurfmine");
	level.panzerwurfmine_up = GetWeapon("zm_panzerwurfmine_up");
	level.panzerwurfmine_cost = PANZERWURFMINE_COST_BASE;
	level.panzerwurfmine_start_of_round = false;

	level callback::on_connect(&on_player_connect);
	level zm_utility::register_lethal_grenade_for_level("zm_panzerwurfmine");
	level zm_utility::register_lethal_grenade_for_level("zm_panzerwurfmine_up");
	level zm_weapons::register_zombie_weapon_callback( level.panzerwurfmine, &player_give_panzerwurfmine );
	level zm_weapons::register_zombie_weapon_callback( level.panzerwurfmine_up, &player_give_panzerwurfmine );
	level array::thread_all(panzerwurmine_trigs, panzerwurmine_think);
	level array::thread_all(crossbow_trigs, crossbow_think);
	level thread panzerwurfmine_cost_scale();
}

function on_player_connect()
{
	self.b_has_upgraded_panzerwurfmine = false;
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
			level.panzerwurfmine_start_of_round = true;
		}
		level.panzerwurfmine_cost *= 2;
	}
}

function panzerwurfmine_hintstring_think()
{
	hintstring_state = -1;
	prev_cost = level.panzerwurfmine_cost;
	prev_recharge_time = self.recharge_time;
	cost_weapons = array(GetWeapon("s2_mas38"), GetWeapon("s4_machinepistol"), GetWeapon("zm_healing_grenade"), GetWeapon("s4_gorenko_rifle"), GetWeapon("s4_mg42"), GetWeapon("s4_machinepistol"), GetWeapon("s4_mk11"), GetWeapon("s4_owen_gun"), GetWeapon("s4_nz41"), GetWeapon("s4_ratt"), GetWeapon("zm_panzerwurfmine"));
	while(true)
	{
		if(self.recharge_time == 0 && (hintstring_state != 0 || level.panzerwurfmine_cost != prev_cost))
		{
			hintstring_state = 0;
			prev_cost = level.panzerwurfmine_cost;
			cost_index = Int(level.round_number / 10);
			weapon = cost_weapons[cost_index];
			self SetCursorHint("HINT_WEAPON", weapon);
			self SetHintString("ZM_ABBEY_PANZERWURFMINE_USE");
		}
		else if(self.recharge_time > 1 && (hintstring_state != 1 || self.recharge_time != prev_recharge_time))
		{
			hintstring_state = 1;
			prev_recharge_time = self.recharge_time;
			self SetCursorHint("HINT_NOICON");
			self SetHintString("ZM_ABBEY_PANZERWURFMINE_RECHARGE", self.recharge_time);
		}
		else if(hintstring_state != 2)
		{
			hintstring_state = 2;
			self SetCursorHint("HINT_NOICON");
			self SetHintString("ZM_ABBEY_PANZERWURFMINE_RECHARGE_SINGULAR");
		}
		wait(0.05);
	}
}

function panzerwurmine_think()
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
		self waittill("trigger", player);

		if(! (zm_utility::is_player_valid(player) && player zm_magicbox::can_buy_weapon()))
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

		self.recharge_time = Int(PANZERWURFMINE_COOLDOWN / 60) + 1;
		for(i = PANZERWURFMINE_COOLDOWN; i > 0 && ! level.panzerwurfmine_start_of_round; i--)
		{
			while(level.is_coop_paused)
			{
				wait(0.05);
			}
			wait(1);
			if(i % 60 == 0)
			{
				self.recharge_time = Int(i / 60) + 1;
			}
		}
		self.recharge_time = 0;
		level.panzerwurfmine_start_of_round = false;
	}
}

function crossbow_think()
{
	self SetCursorHint("HINT_NOICON");
	self SetHintString(&"ZOMBIE_NEED_POWER");

	if(self.script_int > 0)
	{
		level waittill("power_on" + self.script_int);
	}

	self SetHintString(&"ZM_ABBEY_CROSSBOW_USE");
}