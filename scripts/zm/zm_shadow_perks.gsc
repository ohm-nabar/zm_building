#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_powerups;

#using scripts\zm\zm_usermap;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_perk_electric_cherry;
#using scripts\shared\math_shared;

#using scripts\zm\zm_perk_upgrades;
#using scripts\zm\zm_bloodgenerator;
#using scripts\zm\zm_abbey_inventory;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_perk_poseidonspunch.gsh;
#insert scripts\zm\_zm_perk_doubletaporiginal.gsh;
#insert scripts\zm\_zm_perk_phdlite.gsh;
#insert scripts\zm\zm_abbey_inventory.gsh;

#precache( "eventstring", "generator_shadowed" );
#precache( "eventstring", "generator_unshadowed" );

function main()
{
	callback::on_connect( &on_player_connect );
	
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	level.generator_vending_triggers = array(array(), array(), array(), array());
	foreach(trigger in vending_triggers)
	{
		if(trigger.script_noteworthy == "specialty_quickrevive" || trigger.script_noteworthy == "specialty_electriccherry")
		{
			array::add(level.generator_vending_triggers[0], trigger);
		}
		else if(trigger.script_noteworthy == "specialty_holdbreath" || trigger.script_noteworthy == "specialty_deadshot")
		{
			array::add(level.generator_vending_triggers[1], trigger);
		}
		else if(trigger.script_noteworthy == "specialty_staminup" || trigger.script_noteworthy == "specialty_additionalprimaryweapon")
		{
			array::add(level.generator_vending_triggers[2], trigger);
		}
		else if(trigger.script_noteworthy == "specialty_jetpack" || trigger.script_noteworthy == "specialty_disarmexplosive")
		{
			array::add(level.generator_vending_triggers[3], trigger);
		}
	}

	thread shadow_round_base_logic();
}

function on_player_connect()
{
	self.shadowPerks = [];
	self.shadowQuick = false;
	self.shadowDouble = false;
	self.shadowPHD = false;
	self.shadowMule = false;
	self LUINotifyEvent(&"generator_unshadowed", 0);
}

function disable_machines(gen_num)
{
	foreach(trigger in level.generator_vending_triggers[gen_num])
	{
		trigger TriggerEnable(false);
	}
}

function enable_machines(gen_num)
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	foreach(trigger in vending_triggers)
	{
		trigger TriggerEnable(true);
	}
}

function shadow_round_base_logic()
{
	while(true)
	{
		if(level flag::get( "dog_round" ))
		{
			level thread generator1_shadow_monitor();
			level thread generator2_shadow_monitor();
			level thread generator3_shadow_monitor();
			level thread generator4_shadow_monitor();

			level waittill("last_ai_down");

			players = GetPlayers();
			for(i = 0; i < players.size; i++)
			{
				players[i] LUINotifyEvent(&"generator_unshadowed", 0);
				players[i] clientfield::set_player_uimodel("shadowPerks", 0);
				if(level.num_gens_shadowed > 0)
				{
					players[i] thread zm_abbey_inventory::notifyGenerator();
				}
				players[i] thread giveBackShadowPerks();
			}

			level thread enable_machines();

			level waittill("dog_round_ending");
			
		}
		wait(0.05);
	}
}

function giveBackShadowPerks()
{
	self endon("disconnect");

	while(level.in_antiverse)
	{
		wait(0.05);
	}
	
	for(j = 0; j < self.shadowPerks.size; j++)
	{
		if(! self.shadowPerks[j][1])
		{
			continue;
		}

		//IPrintLn("Giving " + self.shadowPerks[j][0]);
		self zm_perks::give_perk(self.shadowPerks[j][0], false);
		wait(0.1);

		if(self.shadowPerks[j][0] == PERK_ADDITIONAL_PRIMARY_WEAPON)
		{
			if(self.shadowThirdGun == level.weaponNone)
			{
				debug_str = "Not returning (shadow) a weapon (weaponNone)";
			}
			else
			{
				debug_str = "Returning (shadow) " + self.shadowThirdGun.displayName;
				self EnableWeaponCycling();
				self GiveWeapon(self.shadowThirdGun);
				self SetWeaponAmmoClip(self.shadowThirdGun, self.shadowThirdGunClip);
				self SetWeaponAmmoStock(self.shadowThirdGun, self.shadowThirdGunStock);
				self.shadowThirdGun = undefined;
				self.shadowThirdGunClip = undefined;
				self.shadowThirdGunStock = undefined;
			}
			/# PrintLn(debug_str); #/
		}
	}
	self.shadowPerks = [];
}

// a failsafe in case the player manages to re-obtain perks after they have been shadowed (the perks will be returned to the player at the end of the shadow round)
function monitor_has_shadowed_perk(perkname)
{
	self endon("disconnect");
	level endon("last_ai_down");

	while(true)
	{
		while(! self HasPerk(perkname))
		{
			wait(0.05);
		}

		self notify(perkname + "_stop");
		for(j = 0; j < self.shadowPerks.size; j++)
		{
			if (self.shadowPerks[j][0] == perkname)
			{
				self.shadowPerks[j][1] = true;
			}
		}
		wait(0.05);
	}
}

function generator1_shadow_monitor()
{
	level endon( "last_ai_down" );

	level waittill("generator1_shadowed");

	level thread disable_machines(0);

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		quickarray = []; quickarray[quickarray.size] = PERK_QUICK_REVIVE; quickarray[quickarray.size] = players[i] HasPerk(PERK_QUICK_REVIVE);
		players[i].shadowPerks[players[i].shadowPerks.size] = quickarray;
		players[i] notify(PERK_QUICK_REVIVE + "_stop");
		players[i] thread monitor_has_shadowed_perk(PERK_QUICK_REVIVE);
		players[i] thread shadow_revive_effects();
		
		electricarray = []; electricarray[electricarray.size] = PERK_ELECTRIC_CHERRY; electricarray[electricarray.size] = players[i] HasPerk(PERK_ELECTRIC_CHERRY);
		players[i].shadowPerks[players[i].shadowPerks.size] = electricarray;
		players[i] notify(PERK_ELECTRIC_CHERRY + "_stop");
		players[i] thread shadow_cherry_effects();
		players[i] thread monitor_has_shadowed_perk(PERK_ELECTRIC_CHERRY);
		players[i] LUINotifyEvent(&"generator_shadowed", 1, 0);
		players[i] clientfield::set_player_uimodel("shadowPerks", 1);
	}
}


function generator2_shadow_monitor()
{
	level endon( "last_ai_down" );

	level waittill("generator2_shadowed");

	level thread disable_machines(1);

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		poseidonarray = []; poseidonarray[poseidonarray.size] = PERK_POSEIDON_PUNCH; poseidonarray[poseidonarray.size] = players[i] HasPerk(PERK_POSEIDON_PUNCH);

		//IPrintLn("Jug is being shadowed");
		players[i].shadowPerks[players[i].shadowPerks.size] = poseidonarray;
		players[i] notify(PERK_POSEIDON_PUNCH + "_stop");
		players[i] thread shadow_poseidon_effects();
		players[i] thread monitor_has_shadowed_perk(PERK_POSEIDON_PUNCH);

		deadshotarray = []; deadshotarray[deadshotarray.size] = PERK_DEAD_SHOT; deadshotarray[deadshotarray.size] = players[i] HasPerk(PERK_DEAD_SHOT);

		players[i].shadowPerks[players[i].shadowPerks.size] = deadshotarray;
		players[i] notify(PERK_DEAD_SHOT + "_stop");
		players[i] thread shadow_deadshot_effects();
		players[i] thread monitor_has_shadowed_perk(PERK_DEAD_SHOT);
		players[i] LUINotifyEvent(&"generator_shadowed", 1, 1);
		players[i] clientfield::set_player_uimodel("shadowPerks", 2);
	}
}

function generator3_shadow_monitor()
{
	level endon( "last_ai_down" );

	level waittill("generator3_shadowed");

	level thread disable_machines(2);

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		mulearray = []; mulearray[mulearray.size] = PERK_ADDITIONAL_PRIMARY_WEAPON; mulearray[mulearray.size] = players[i] HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON);

		players[i].shadowPerks[players[i].shadowPerks.size] = mulearray;
		players[i].shadowMule = true;

		players[i].shadowThirdGun = players[i] zm_perk_upgrades::return_additionalprimaryweapon();
		players[i].shadowThirdGunClip = players[i] GetWeaponAmmoClip( players[i].shadowThirdGun );
		players[i].shadowThirdGunStock = players[i] GetWeaponAmmoStock( players[i].shadowThirdGun );

		if(players[i].shadowThirdGun == level.weaponNone)
		{
			debug_str = "Mule Kick return weapon (shadow) is now weaponNone";
		}
		else
		{
			debug_str = "Mule Kick return weapon (shadow) is now " + players[i].shadowThirdGun.displayName;
		}
		/# PrintLn(debug_str); #/

		players[i] TakeWeapon( players[i].shadowThirdGun );
		players[i] notify(PERK_ADDITIONAL_PRIMARY_WEAPON + "_stop");
		players[i] thread shadow_mule_effects();
		players[i] thread monitor_has_shadowed_perk(PERK_ADDITIONAL_PRIMARY_WEAPON);

		staminarray = []; staminarray[staminarray.size] = PERK_STAMINUP; staminarray[staminarray.size] = players[i] HasPerk(PERK_STAMINUP);
		
		players[i].shadowPerks[players[i].shadowPerks.size] = staminarray;
		players[i] notify(PERK_STAMINUP + "_stop");
		players[i] thread shadow_stamin_effects();
		players[i] thread monitor_has_shadowed_perk(PERK_STAMINUP);
		players[i] LUINotifyEvent(&"generator_shadowed", 1, 2);
		players[i] clientfield::set_player_uimodel("shadowPerks", 3);
	}
}

function generator4_shadow_monitor()
{
	level endon( "last_ai_down" );

	level waittill("generator4_shadowed");

	level thread disable_machines(3);

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		doublearray = []; doublearray[doublearray.size] = PERK_DOUBLE_TAP; doublearray[doublearray.size] = players[i] HasPerk(PERK_DOUBLE_TAP);

		players[i].shadowPerks[players[i].shadowPerks.size] = doublearray;
		players[i] notify(PERK_DOUBLE_TAP + "_stop");
		players[i] thread shadow_double_effects();
		players[i] thread monitor_has_shadowed_perk(PERK_DOUBLE_TAP);

		phdarray = []; phdarray[phdarray.size] = PERK_PHD_LITE; phdarray[phdarray.size] = players[i] HasPerk(PERK_PHD_LITE);
	
		players[i].shadowPerks[players[i].shadowPerks.size] = phdarray;
		players[i] notify(PERK_PHD_LITE + "_stop");
		players[i] thread shadow_PHD_effects();
		players[i] thread monitor_has_shadowed_perk(PERK_PHD_LITE);
		players[i] LUINotifyEvent(&"generator_shadowed", 1, 3);
		players[i] clientfield::set_player_uimodel("shadowPerks", 4);
	}
}

function shadow_poseidon_effects()
{
	self endon("disconnect");

	self AllowMelee(false);
	level waittill("last_ai_down");
	self AllowMelee(true);
}

function shadow_cherry_effects()
{
	self endon("disconnect");
	level endon( "last_ai_down" );

	//self thread custom_perk_shader::add_custom_perk_shader_shadow("shadow_cherry");

	min_damage = 10;
	max_damage = 45;
	self.wait_on_reload = [];
	while(true)
	{
		self waittill("reload_start");
					
		current_weapon = self GetCurrentWeapon();

		if( IsInArray( self.wait_on_reload, current_weapon ) )
		{
			continue;	
		}
		
		// Add this weapon to the list so we know it needs to be reloaded before the perk can be used for again
		self.wait_on_reload[self.wait_on_reload.size] = current_weapon;
		
		// Get the percentage of bullets left in the clip at the time the weapon is reloaded
		n_clip_current = self GetWeaponAmmoClip( current_weapon );
		n_clip_max = current_weapon.clipSize;
		n_fraction = n_clip_current/n_clip_max;

		perk_dmg = math::linear_map( n_fraction, 1.0, 0.0, min_damage, max_damage );
		
		// Kick off a thread that will tell us when the weapon has been reloaded.
		self thread check_for_reload_complete( current_weapon );

		self thread zm_perk_electric_cherry::electric_cherry_reload_fx( n_fraction );
		self PlaySound( "zmb_cherry_explode" );
		self DoDamage( perk_dmg, self.origin+(0,0,20));

		wait(0.05);
	}
}

function check_for_reload_complete( weapon ) // self = player
{
	self endon( "death" );
	self endon( "disconnect" );
	//self endon( "weapon_change_complete" );
	self endon( "player_lost_weapon_" + weapon.name );
	level endon( "last_ai_down" );
	
	// Thread to watch for the case where this weapon gets replaced
	self thread weapon_replaced_monitor( weapon );
	
	while( 1 )
	{
		// Wait for the player to complete a reload
		self waittill( "reload" );
		
		// If the weapon that just got reloaded is the same as the one that was used for the electric cherry perk
		// Kill off this thread and remove this weapon's name from the player's wait_on_reload list
		// This allows the player to use the Electric Cherry Reload Attack with this weapon again!
		current_weapon = self GetCurrentWeapon();
		if( current_weapon == weapon )
		{
			ArrayRemoveValue( self.wait_on_reload, weapon );
			self notify( "weapon_reload_complete_" + weapon.name );
			break;
		}
	}
}

function weapon_replaced_monitor( weapon ) // self = player
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "weapon_reload_complete_" + weapon.name );
	level endon( "last_ai_down" );
	
	while( 1 )
	{
		// Wait for the player to change weapons (swap weapon, wall buy, magic box, etc.)
		self waittill( "weapon_change" );
		
		// If the weapon that we previously used for the Electric Cherry Reload Attack is no longer equipped
		// Kill off this thread and remove this weapon's name from the player's wait_on_reload list
		// This handles the case when a player cancels a reload, then replaces this weapon
		// Ensures that when the player re-aquires the weapon, he has a fresh start and can use the Electric Cherry perk immediately.
		primaryWeapons = self GetWeaponsListPrimaries();
		if( !IsInArray( primaryWeapons, weapon ) )
		{
			self notify( "player_lost_weapon_" + weapon.name );
			ArrayRemoveValue( self.wait_on_reload, weapon );
			break;
		}
	}
}

function shadow_double_effects()
{
	self endon("disconnect");

	//self thread custom_perk_shader::add_custom_perk_shader_shadow("shadow_double");

	self.shadowDouble = true;
	level waittill("last_ai_down");
	self.shadowDouble = false;
}

function shadow_revive_effects()
{
	self endon("disconnect");

	//self thread custom_perk_shader::add_custom_perk_shader_shadow("shadow_quick");

	self.shadowQuick = true;
	level waittill("last_ai_down");
	self.shadowQuick = false;
}

function shadow_solo_revive_effects()
{
	/*
	level endon("last_ai_down");

	while(true)
	{
		if(laststand::player_is_in_laststand())
		{
			self zm_utility::create_zombie_point_of_interest( 1536, 96, 10000 );
			self waittill("player_revived");
			self zm_utility::deactivate_zombie_point_of_interest();
		}
		wait(0.05);
	}
	*/
}


function shadow_stamin_effects()
{
	self endon("disconnect");

	//self thread custom_perk_shader::add_custom_perk_shader_shadow("shadow_stamin");

	self AllowSprint(false);
	level waittill("last_ai_down");
	self AllowSprint(true);	
}

function shadow_mule_effects()
{
	self endon("disconnect");
	
	self.should_end_shadow_mule = false;

	self thread mule_dummy_function();

	//self thread custom_perk_shader::add_custom_perk_shader_shadow("shadow_mule");

	//IPrintLn("we at least got to the start of this function- mule");
	while(! self.should_end_shadow_mule)
	{
		//IPrintLn("Still running the mule loop");
		current_weapon = self GetCurrentWeapon();
		if(! self zm_magicbox::can_buy_weapon()) {
			wait(0.05);
			continue;
		}
		else if(self GetWeaponAmmoClip(current_weapon) == 0 && self GetWeaponAmmoStock(current_weapon) == 0)
		{
			self EnableWeaponCycling();
			//IPrintLn("Can cycle");
		}
		else
		{
			self DisableWeaponCycling();
			//IPrintLn("Can't cycle");
		}
		wait(0.05);
	}

	self EnableWeaponCycling();
}

function mule_dummy_function()
{
	self endon("disconnect");

	level waittill("last_ai_down");

	self.shadowMule = false;
	self.should_end_shadow_mule = true;
}

function shadow_PHD_effects()
{
	self endon("disconnect");

	//self thread custom_perk_shader::add_custom_perk_shader_shadow("shadow_phd");

	self.shadowPHD = true;
	level waittill( "last_ai_down" );
	self.shadowPHD = false;
}

function shadow_deadshot_effects()
{
	self endon("disconnect");

	//self thread custom_perk_shader::add_custom_perk_shader_shadow("shadow_phd");

	self SetSpreadOverride(10);
	level waittill( "last_ai_down" );
	self ResetSpreadOverride();
}