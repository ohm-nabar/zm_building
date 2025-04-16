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

#precache( "triggerstring", "ZM_ABBEY_TAKE_WEAPON" );

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
		weapon = undefined;

		if(pistol_pickup_trigs[i].script_noteworthy == "bloodhound")
		{
			weapon = bloodhound;
		}
		else if(pistol_pickup_trigs[i].script_noteworthy == "colt")
		{
			weapon = colt;
		}
		else if(pistol_pickup_trigs[i].script_noteworthy == "luger")
		{
			weapon = luger;
		}
		else
		{
			weapon = cz;
		}

		pistol_pickup_trigs[i] SetCursorHint("HINT_WEAPON", weapon);
		pistol_pickup_trigs[i] SetHintString(&"ZM_ABBEY_TAKE_WEAPON");
		pistol_pickup_trigs[i] thread pistol_pickup_think(weapon);
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

	pistol_clip = 0;
	pistol_stock = 0;	

	while(true)
	{
		if(self.startingpistol != level.start_weapon)
		{
			if(self HasWeapon(self.startingpistol) && ! level.in_antiverse)
			{
				pistol_clip = self GetWeaponAmmoClip(self.startingpistol);
				pistol_stock = self GetWeaponAmmoStock(self.startingpistol);
			}
			else if(! self HasWeapon(self.startingpistol) && self GetCurrentWeapon() != level.weaponNone)
			{
				pistol_clip = self.startingpistol.clipsize;
				pistol_stock = self.startingpistol.startammo - pistol_clip;
			}

			if(self HasWeapon(level.start_weapon))
			{
				self TakeWeapon(level.start_weapon);
				self GiveWeapon(self.startingpistol);
			}
		}

		if(self GetCurrentWeapon() == level.weaponNone)
		{
			self TakeWeapon(level.weaponNone);
			self GiveWeapon(self.startingpistol);
			if(self.startingpistol != level.start_weapon)
			{
				self SetWeaponAmmoClip(self.startingpistol, pistol_clip);
				self SetWeaponAmmoStock(self.startingpistol, pistol_stock);
			}
		}
		wait(0.05);
	}
}


function pistol_pickup_think(weapon)
{
	while(!(level flag::exists("initial_blackscreen_passed") && level flag::get("initial_blackscreen_passed")))
	{
		wait(0.05);
	}

	pistol_model = GetEnt(self.target, "targetname");
	exploder_name = self.script_noteworthy + "_exploder";
	while(true)
	{
		level exploder::exploder(exploder_name);
		self waittill("trigger", player);
		if(player.startingpistol == level.start_weapon)
		{
			player.startingpistol = weapon;

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
				trig SetInvisibleToPlayer(player, true);
			}

			pistol_model SetInvisibleToAll();
			level exploder::stop_exploder(exploder_name);
			self SetCursorHint("HINT_NOICON");
			self SetHintString(&"ZM_ABBEY_EMPTY");

			player waittill("disconnect");

			pistol_model SetVisibleToAll();
			level exploder::exploder(exploder_name);

			self SetCursorHint("HINT_WEAPON", weapon);
			self SetHintString(&"ZM_ABBEY_TAKE_WEAPON");
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