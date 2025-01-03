#using scripts\shared\callbacks_shared;
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

#precache( "eventstring", "generator_shadowed" );
#precache( "eventstring", "shadow_perk_remove" );

function main()
{
	callback::on_connect( &on_player_connect );
	
	/*
	level._custom_perks = []; 
	level._custom_perks[level._custom_perks.size] = PERK_JUGGERNOG;
	level._custom_perks[level._custom_perks.size] = PERK_STAMINUP;
	level._custom_perks[level._custom_perks.size] = PERK_QUICK_REVIVE;
	level._custom_perks[level._custom_perks.size] = PERK_DOUBLE_TAP;
	level._custom_perks[level._custom_perks.size] = PERK_ELECTRIC_CHERRY;
	level._custom_perks[level._custom_perks.size] = PERK_PHD_LITE;
	level._custom_perks[level._custom_perks.size] = PERK_ADDITIONAL_PRIMARY_WEAPON;
	*/
	thread shadow_round_base_logic();
}

function on_player_connect()
{
	self.shadowPerks = [];
	self.get_revive_time = &get_revive_time;
	self.shadowQuick = false;
	self.shadowDouble = false;
	self LUINotifyEvent(&"shadow_perk_remove", 0);
}

function shadow_round_base_logic()
{
	while(true)
	{
		if(level flag::get( "dog_round" ))
		{
			/*
			for(i = 0; i < level.active_generators.size; i++)
			{
				zm_bloodgenerator::turn_generator_off(level.active_generators[i]);
			}
			*/

			vending_triggers = GetEntArray( "zombie_vending", "targetname" );

			for(i = 0; i < vending_triggers.size; i++)
			{
				vending_triggers[i] TriggerEnable(false);
 			}

			thread generator1_shadow_monitor();
			thread generator2_shadow_monitor();
			thread generator3_shadow_monitor();
			thread generator4_shadow_monitor();

			level waittill("last_ai_down");

			players = GetPlayers();
			for(i = 0; i < players.size; i++)
			{
				players[i] LUINotifyEvent(&"shadow_perk_remove", 0);
				if(level.num_gens_shadowed > 0)
				{
					players[i] thread zm_abbey_inventory::notifyText("splash_shadow_over", undefined, undefined, true);
				}
				players[i] thread giveBackShadowPerks();
			}

			/*
			reward_pos_1 = struct::get("reward_pos_1", "targetname");
			reward_pos_2 = struct::get("reward_pos_2", "targetname");
			IPrintLn("Reward at: ");
			IPrintLn(reward_pos_1.origin);
			zm_powerups::specific_powerup_drop( "full_ammo", reward_pos_1.origin);
			if(level.num_gens_shadowed == 0 || level.num_gens_shadowed == 4)
			{
				zm_powerups::specific_powerup_drop("free_perk", reward_pos_2.origin);
			}
			*/

			/*
			for(i = 0; i < level.active_generators.size; i++)
			{
				thread zm_bloodgenerator::turn_generator_on(level.active_generators[i], true);
			}
			*/

			players = GetPlayers();
			for(i = 0; i < vending_triggers.size; i++)
			{
				vending_triggers[i] TriggerEnable(true);
 			}

			level waittill("dog_round_ending");
			
		}
		wait(0.05);
	}
}

function giveBackShadowPerks()
{
	self endon("disconnect");
	
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
			self EnableWeaponCycling();
			self GiveWeapon(self.shadowThirdGun);
			self SetWeaponAmmoClip(self.shadowThirdGun, self.shadowThirdGunClip);
			self SetWeaponAmmoStock(self.shadowThirdGun, self.shadowThirdGunStock);
			self.shadowThirdGun = undefined;
			self.shadowThirdGunClip = undefined;
			self.shadowThirdGunStock = undefined;
		}
	}
	self.shadowPerks = [];
}

// a failsafe in case the player manages to re-obtain perks after they have been shadowed (the perks will be returned to the player at the end of the shadow round)
function monitor_has_shadowed_perk(perkname)
{
	self endon("disconnect");
	level endon("last_ai_down");

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
}

function generator1_shadow_monitor()
{
	level endon( "last_ai_down" );

	level waittill("generator1_shadowed");

	//zm_bloodgenerator::turn_generator_off("generator1");

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
	}
}


function generator2_shadow_monitor()
{
	level endon( "last_ai_down" );

	level waittill("generator2_shadowed");

	//zm_bloodgenerator::turn_generator_off("generator2");

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
		//players[i] thread shadow_juggernog_effects();
	}
}

function generator3_shadow_monitor()
{
	level endon( "last_ai_down" );

	level waittill("generator3_shadowed");

	//zm_bloodgenerator::turn_generator_off("generator3");

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		doublearray = []; doublearray[doublearray.size] = PERK_DOUBLE_TAP; doublearray[doublearray.size] = players[i] HasPerk(PERK_DOUBLE_TAP);

		players[i].shadowPerks[players[i].shadowPerks.size] = doublearray;
		players[i] notify(PERK_DOUBLE_TAP + "_stop");
		players[i] thread shadow_double_effects();
		players[i] thread monitor_has_shadowed_perk(PERK_DOUBLE_TAP);

		staminarray = []; staminarray[staminarray.size] = PERK_STAMINUP; staminarray[staminarray.size] = players[i] HasPerk(PERK_STAMINUP);
		
		players[i].shadowPerks[players[i].shadowPerks.size] = staminarray;
		players[i] notify(PERK_STAMINUP + "_stop");
		players[i] thread shadow_stamin_effects();
		players[i] thread monitor_has_shadowed_perk(PERK_STAMINUP);
		players[i] LUINotifyEvent(&"generator_shadowed", 1, 2);
	}
}

function generator4_shadow_monitor()
{
	level endon( "last_ai_down" );

	level waittill("generator4_shadowed");

	//zm_bloodgenerator::turn_generator_off("generator4");

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		mulearray = []; mulearray[mulearray.size] = PERK_ADDITIONAL_PRIMARY_WEAPON; mulearray[mulearray.size] = players[i] HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON);

		players[i].shadowPerks[players[i].shadowPerks.size] = mulearray;

		players[i].shadowThirdGun = players[i] zm_perk_upgrades::return_additionalprimaryweapon();
		players[i].shadowThirdGunClip = players[i] GetWeaponAmmoClip( players[i].shadowThirdGun );
		players[i].shadowThirdGunStock = players[i] GetWeaponAmmoStock( players[i].shadowThirdGun );

		players[i] TakeWeapon( players[i].shadowThirdGun );
		players[i] notify(PERK_ADDITIONAL_PRIMARY_WEAPON + "_stop");
		players[i] thread shadow_mule_effects();
		players[i] thread monitor_has_shadowed_perk(PERK_ADDITIONAL_PRIMARY_WEAPON);

		phdarray = []; phdarray[phdarray.size] = PERK_PHD_LITE; phdarray[phdarray.size] = players[i] HasPerk(PERK_PHD_LITE);
	
		players[i].shadowPerks[players[i].shadowPerks.size] = phdarray;
		players[i] notify(PERK_PHD_LITE + "_stop");
		players[i] thread shadow_PHD_effects();
		players[i] thread monitor_has_shadowed_perk(PERK_PHD_LITE);
		players[i] LUINotifyEvent(&"generator_shadowed", 1, 3);
	}
}

function shadow_poseidon_effects()
{
	self endon("disconnect");

	//self thread custom_perk_shader::add_custom_perk_shader_shadow("shadow_poseidon");

	self thread melee_curse();
}

function points_curse()
{
	self endon("disconnect");

	self thread zm_abbey_inventory::notifyText("You have been cursed by Poseidon. You will receive no points for the duration of the Shadow Breach");
	self thread poseidon_curse_hud("poseidon_shadow_double");

	self.no_shadow_points = true;
	level waittill("last_ai_down");
	self.no_shadow_points = false;
}

function melee_curse()
{
	self endon("disconnect");

	self AllowMelee(false);
	level waittill("last_ai_down");
	self AllowMelee(true);
}

function speed_curse()
{
	self endon("disconnect");

	self thread zm_abbey_inventory::notifyText("You have been cursed by Poseidon. Your speed will be decreased for the duration of the Shadow Breach");
	self thread poseidon_curse_hud("poseidon_shadow_speed");

	self SetMoveSpeedScale(0.8);
	level waittill("last_ai_down");
	self SetMoveSpeedScale(1);
}

function poseidon_curse_hud(shader)
{
	self endon("disconnect");

	index = -1;

	for(i = 0; i < self.shadowPerks.size; i++)
	{
		if(self.shadowPerks[i][0] == PERK_POSEIDON_PUNCH)
		{
			index = i;
			break;
		}
	}

	curseShader = NewClientHudElem( self ); 
	curseShader.alignX = "center"; 
	curseShader.alignY = "middle";
	curseShader.horzAlign = "fullscreen"; 
	curseShader.vertAlign = "fullscreen"; 
	curseShader.foreground = true;
	curseShader.hidewheninmenu = true;
	curseShader setShader( shader, 36, 48 );
	curseShader.y = level.shadow_perk_shadery;
	curseShader.x = 74 + ( index * 19 );

	level waittill("last_ai_down");

	curseShader Destroy();
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


function get_revive_time( e_revivee )
{
	reviveTime = 3;

	if ( self HasPerk( PERK_QUICK_REVIVE ) )
	{
		reviveTime = reviveTime / 2;
	}

	if( self.shadowQuick )
	{
		reviveTime = reviveTime * 2;
	}

	return reviveTime;
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

	self.should_end_shadow_mule = true;
}

function shadow_PHD_effects()
{
	self endon("disconnect");

	//self thread custom_perk_shader::add_custom_perk_shader_shadow("shadow_phd");

	self AllowSlide(false);
	level waittill( "last_ai_down" );
	self AllowSlide(true);
}

function shadow_deadshot_effects()
{
	self endon("disconnect");

	//self thread custom_perk_shader::add_custom_perk_shader_shadow("shadow_phd");

	self SetSpreadOverride(10);
	level waittill( "last_ai_down" );
	self ResetSpreadOverride();
}