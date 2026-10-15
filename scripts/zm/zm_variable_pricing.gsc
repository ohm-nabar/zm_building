#using scripts\zm\_zm_utility;

#insert scripts\shared\shared.gsh;

// MAIN
//*****************************************************************************

function main()
{
	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 
	zombie_debris = GetEntArray( "zombie_debris", "targetname" );

	level.first_door = false;
	level.first_debris = false;

	foreach(door in zombie_doors)
	{
		if(IS_EQUAL(door.script_noteworthy, "local_electric_door"))
		{
			door thread monitor_door_power();
		}
		else
		{
			door thread monitor_door_price();
		}
	}

	foreach(debris in zombie_debris)
	{
		if(! isdefined(debris.script_int))
		{
			debris thread monitor_debris_price();
		}
	}
}

function monitor_door_power()
{
	self SetHintString(&"ZOMBIE_NEED_POWER");
	level waittill("power_on" + self.script_int);
	self notify("local_power_on");
}

function monitor_door_price()
{
	original_price = self.zombie_cost;
	while(isdefined(self))
	{
		players = GetPlayers();
		self.zombie_cost = original_price + (100 * (players.size - 1));
		self zm_utility::set_hint_string( self, "default_buy_door", self.zombie_cost );
		wait(0.05);
	}
}

function monitor_debris_price()
{
	original_price = self.zombie_cost;
	while(isdefined(self))
	{
		players = GetPlayers();
		self.zombie_cost = original_price + (100 * (players.size - 1));
		self zm_utility::set_hint_string( self, "default_buy_debris", self.zombie_cost );
		wait(0.05);
	}
}

function testeroo()
{
	while(true)
	{
		IPrintLn(self.zombie_cost);
		wait(2);
	}
}