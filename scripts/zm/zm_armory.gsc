#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;

#namespace zm_armory;

REGISTER_SYSTEM( "zm_armory", &__init__, undefined )

function __init__()
{
	panzerwurmine_trigs = GetEntArray("panzerwurmine_use", "targetname");
	crossbow_trigs = GetEntArray("crossbow_use", "targetname");
	level.panzerwurfmine_cost = PANZERWURFMINE_COST_BASE;

	level array::thread_all(panzerwurmine_trigs, panzerwurmine_think);
	level array::thread_all(crossbow_trigs, crossbow_think);
	level thread panzerwurfmine_cost_scale();

	level callback::on_connect(&on_player_connect);
}

function on_player_connect(){}

function panzerwurfmine_cost_scale()
{
	while(level.panzerwurfmine_cost < PANZERWURFMINE_COST_MAX)
	{
		for(i = 0; i < 10; i++)
		{
			level waittill("start_of_round");
		}
		level.panzerwurfmine_cost *= 2;
	}
}

function panzerwurfmine_hintstring_think()
{
	hintstring_state = -1;
	prev_cost = level.panzerwurfmine_cost;
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
		else if(self.recharge_time > 60 && hintstring_state != 1)
		{
			hintstring_state = 1;
			minutes = Int(self.recharge_time / 60) + 1;
			self SetCursorHint("HINT_NOICON");
			self SetHintString("ZM_ABBEY_PANZERWURFMINE_RECHARGE", minutes);
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
		if(player.score < level.panzerwurfmine_cost);
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
}