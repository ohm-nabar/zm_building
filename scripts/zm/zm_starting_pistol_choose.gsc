#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;

#insert scripts\shared\shared.gsh;

#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#using scripts\Sphynx\_zm_sphynx_util;

#precache( "fx", "custom/pistol_glint" );

#precache( "triggerstring", "ZM_ABBEY_TAKE_WEAPON" );

//*****************************************************************************
// MAIN
//*****************************************************************************

function main()
{
	weapon_arr = []; 
	weapon_arr["bloodhound"] = GetWeapon("s4_topbreak");
	weapon_arr["colt"] = GetWeapon("s4_1911");
	weapon_arr["luger"] = GetWeapon("s4_klauser");
	weapon_arr["cz"] = GetWeapon("s4_machinepistol");

	pistol_pickup_trigs = struct::get_array("pistol_pickup", "targetname");
	level array::thread_all(pistol_pickup_trigs, &pistol_pickup_think, weapon_arr);

	level.default_laststandpistol = GetWeapon("s4_1911");
	level.laststandpistol = level.default_laststandpistol;
	level.default_solo_laststandpistol = GetWeapon("s4_1911_rdw_up");

	level thread pistol_rank();
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

	while(!(level flag::exists("initial_blackscreen_passed") && level flag::get("initial_blackscreen_passed")))
	{
		wait(0.05);
	}

	pistol_clip = 0;
	pistol_stock = 0;
	failsafe_start_time = undefined;
	pap_triggers = zm_pap_util::get_triggers();

	while(true)
	{
		if(self.startingpistol != level.start_weapon)
		{
			if(self HasWeapon(self.startingpistol) && ! level.in_antiverse)
			{
				pistol_clip = self GetWeaponAmmoClip(self.startingpistol);
				pistol_stock = self GetWeaponAmmoStock(self.startingpistol);
			}
			if(self HasWeapon(level.start_weapon))
			{
				self TakeWeapon(level.start_weapon);
				self GiveWeapon(self.startingpistol);
			}
		}

		gun_in_pap = false;
		foreach(trigger in pap_triggers)
		{
			if(isdefined(trigger.pack_player) && trigger.pack_player == self)
			{
				gun_in_pap = true;
			}
		}

		weapons = self GetWeaponsListPrimaries();
		if(level zm_utility::is_player_valid(self) && (weapons.size == 0 || (weapons.size == 1 && weapons[0] != self.startingpistol)) && ! gun_in_pap)
		{
			str_debug = "engaging no weapons failsafe";

			/# PrintLn(str_debug); #/
			failsafe_start_time = undefined;
			self GiveWeapon(self.startingpistol);
			if(weapons.size == 0)
			{
				self SwitchToWeapon(self.startingpistol);
			}
			if(self.startingpistol != level.start_weapon)
			{
				self SetWeaponAmmoClip(self.startingpistol, pistol_clip);
				self SetWeaponAmmoStock(self.startingpistol, pistol_stock);
			}
		}
		wait(0.05);
	}
}

function pistol_prompt_and_visibility(player)
{
	struct = self.stub.related_parent;
	if(player.startingpistol != level.start_weapon || ! player zm_magicbox::can_buy_weapon() || struct.claimed)
	{
		self SetHintString(&"ZM_ABBEY_EMPTY");
		self SetCursorHint("HINT_NOICON");
		return false;
	}

	self SetHintString(&"ZM_ABBEY_TAKE_WEAPON");
	self SetCursorHint("HINT_WEAPON", struct.weapon);
	return true;
}

function pistol_pickup_think(weapon_arr)
{
	while(!(level flag::exists("initial_blackscreen_passed") && level flag::get("initial_blackscreen_passed")))
	{
		wait(0.05);
	}

	self.weapon = weapon_arr[self.script_noteworthy];
	self.claimed = false;
	pistol_model = GetEnt(self.target, "targetname");
	exploder_name = self.script_noteworthy + "_exploder";
	self zm_sphynx_util::create_unitrigger_for_player_specific(&"ZM_ABBEY_TAKE_WEAPON", undefined, &pistol_prompt_and_visibility);
	while(true)
	{
		level exploder::exploder(exploder_name);
		self waittill("trigger_activated", player);
		self.claimed = true;
		player.startingpistol = self.weapon;

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

		pistol_model SetInvisibleToAll();
		level exploder::stop_exploder(exploder_name);

		player waittill("disconnect");
		self.claimed = false;

		pistol_model SetVisibleToAll();
	}
}

function testeroo()
{
	while(true)
	{
		IPrintLn(self GetWeaponsListPrimaries().size);
		wait(1.5);
	}
}