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
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#using scripts\shared\ai\zombie_utility;

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

#using scripts\zm\zm_usermap;

#using scripts\zm\_zm_laststand;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\demo_shared;

#precache( "fx", "custom/pistol_glint" );

#precache( "string", "ZM_ABBEY_TAKE_WEAPON" );

//*****************************************************************************
// MAIN
//*****************************************************************************

function main()
{
	//level.zombie_last_stand = &laststand_give_pistol;

	bloodhound = GetWeapon("s4_topbreak");
	colt = GetWeapon("s4_1911");
	luger = GetWeapon("s4_klauser");
	cz = GetWeapon("s4_machinepistol");

	pistol_pickup_trigs = GetEntArray("pistol_pickup", "targetname");

	for(i = 0; i < pistol_pickup_trigs.size; i++)
	{
		name = "";

		if(pistol_pickup_trigs[i].script_noteworthy == "bloodhound")
		{
			name = bloodhound.displayname;
		}
		else if(pistol_pickup_trigs[i].script_noteworthy == "colt")
		{
			name = colt.displayname;
		}
		else if(pistol_pickup_trigs[i].script_noteworthy == "luger")
		{
			name = luger.displayname;
		}
		else
		{
			name = cz.displayname;
		}

		pistol_pickup_trigs[i] SetHintString(&"ZM_ABBEY_TAKE_WEAPON", name);
		pistol_pickup_trigs[i] thread pistol_pickup_think();
	}

	level.default_laststandpistol = GetWeapon("s4_1911");
	level.laststandpistol = level.default_laststandpistol;
	level.default_solo_laststandpistol = GetWeapon("s4_1911_rdw_up");

	thread pistol_rank();
	callback::on_connect( &on_player_connect );
}

function on_player_connect()
{
	self.startingpistol = level.start_weapon;
	//self.w_min_last_stand_pistol_override = GetWeapon( "smg_standard" );
	self thread take_starting_gun(); //takes "starting gun" if player has any other gun, gives starting pistol if starting pistol is determined
	self thread laststandpistol_override();
	//self thread testeroo();
}

function laststandpistol_override()
{
	self endon("disconnect");
	
	self.w_min_last_stand_pistol_override = level.start_weapon;
	
	while(true)
	{
		if( level flag::get( "solo_game" ) && self.startingpistol != level.start_weapon && self.w_min_last_stand_pistol_override != zm_weapons::get_upgrade_weapon( self.startingpistol ) )
		{
			self.w_min_last_stand_pistol_override = zm_weapons::get_upgrade_weapon(self.startingpistol);
			//IPrintLn(self.w_min_last_stand_pistol_override.displayname);
		}
		if( ! level flag::get( "solo_game" ) && self.startingpistol != level.start_weapon && self.w_min_last_stand_pistol_override != self.startingpistol )
		{
			self.w_min_last_stand_pistol_override = self.startingpistol;
			//IPrintLn(self.w_min_last_stand_pistol_override.displayname);
		}
		wait(0.05);
	}

}

function pistol_rank()
{
	level.pistol_values[ 0 ] = level.default_laststandpistol;
	level.pistol_values[ 1 ] = GetWeapon("s4_ratt");
	level.pistol_values[ 2 ] = GetWeapon( "s4_klauser" );
	level.pistol_values[ 3 ] = GetWeapon( "s4_machinepistol" );
	level.pistol_values[ 4 ] = GetWeapon( "s4_topbreak" );
	level.pistol_value_solo_replace_below = 4;  // EO: anything scoring lower than this should be replaced
	level.pistol_values[ 5 ] = level.default_solo_laststandpistol;
	level.pistol_values[ 6 ] = GetWeapon( "s4_klauser_up" );
	level.pistol_values[ 7 ] = GetWeapon( "s4_machinepistol_rdw_up" );
	level.pistol_values[ 8 ] = GetWeapon( "s4_topbreak_rdw_up" );
	level.pistol_values[ 9 ] = GetWeapon( "zm_diedrich" );
	level.pistol_values[ 10 ] = GetWeapon( "zm_diedrich_upgraded" );
}

function take_starting_gun()
{
	self endon("disconnect");

	while(true)
	{
		if(self HasWeapon(level.start_weapon) && self.startingpistol != level.start_weapon)
		{
			self TakeWeapon(level.start_weapon);
			self GiveWeapon(self.startingpistol);
		}
		wait(0.05);
	}
}


function pistol_pickup_think()
{
	bloodhound = GetWeapon("s4_topbreak");
	colt = GetWeapon("s4_1911");
	luger = GetWeapon("s4_klauser");
	cz = GetWeapon("s4_machinepistol");

	// x = top and bottom (bottom is bigger x)
	// y = left and right (right is bigger y)
	pistol_model = GetEnt(self.target, "targetname");

	while(true)
	{
		fx_spot = Spawn("script_model", pistol_model.origin + (0, -10, -7));
		fx_spot SetModel("tag_origin");
		PlayFXOnTag("custom/pistol_glint", fx_spot, "tag_origin");
		self waittill("trigger", player);
		if(player.startingpistol == level.start_weapon)
		{
			if(self.script_noteworthy == "bloodhound")
			{
				player.startingpistol = bloodhound;
			}
			else if(self.script_noteworthy == "colt")
			{
				player.startingpistol = colt;
			}
			else if(self.script_noteworthy == "luger")
			{
				player.startingpistol = luger;
			}
			else
			{
				player.startingpistol = cz;
			}

			if(player HasWeapon(level.start_weapon))
			{
				player TakeWeapon(level.start_weapon);
				player GiveWeapon(player.startingpistol);
				player SwitchToWeapon(player.startingpistol);
			}
			else
			{
				player zm_weapons::weapon_give(player.startingpistol);
			}
			
			pistol_pickup_trigs = GetEntArray("pistol_pickup", "targetname");
			foreach(trig in pistol_pickup_trigs)
			{
				trig SetHintStringForPlayer(player, "");
			}

			fx_spot Delete();
			pistol_model SetInvisibleToAll();
			self SetHintString("");

			player waittill("disconnect");

			pistol_model SetVisibleToAll();

			hintstring = "Press ^3[{+activate}]^7 to take ";
			if(self.script_noteworthy == "bloodhound")
			{
				hintstring += bloodhound.displayname;
			}
			else if(self.script_noteworthy == "colt")
			{
				hintstring += colt.displayname;
			}
			else if(self.script_noteworthy == "luger")
			{
				hintstring += luger.displayname;
			}
			else
			{
				hintstring += cz.displayname;
			}
			self SetHintString(hintstring);

			//fx_spot = Spawn("script_model", pistol_model.origin);
			//PlayFXOnTag("custom/fx_buried_booze_candy_spawn", fx_spot, "tag_origin");
		}
		wait(0.05);
	}
}

function testeroo()
{
	while(true)
	{
		weapon = self GetCurrentWeapon();
		IPrintLn(weapon.name);
		wait(2);
	}
}