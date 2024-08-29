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

//Traps
#using scripts\zm\_zm_trap_electric;

#using scripts\zm\zm_usermap;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_laststand;

#using scripts\zm\zm_perk_upgrades;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_perk_poseidonspunch.gsh;
#insert scripts\zm\_zm_perk_doubletaporiginal.gsh;

#precache( "eventstring", "mule_indicator" );

// MAIN
//*****************************************************************************

function main()
{
	callback::on_connect( &on_player_connect );
	callback::on_laststand( &on_laststand );
}

function on_player_connect()
{
	self thread double_upgrade_effects();
	self thread stamin_upgrade_effects();
	self thread cherry_upgrade_effects();
	self thread revive_upgrade_effects();
	self thread mule_upgrade_effects();
	//self.player_damage_override = &player_damage_override;
}

function double_upgrade_effects()
{
	self endon("disconnect");
	while(true)
	{
		if(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_DOUBLE_TAP) && ! self HasPerk(PERK_DOUBLETAP2))
		{
			self SetPerk(PERK_DOUBLETAP2);
		}
		if(! self zm_perk_upgrades::IsPerkUpgradeActive(PERK_DOUBLE_TAP) && self HasPerk(PERK_DOUBLETAP2))
		{
			self UnSetPerk(PERK_DOUBLETAP2);
		}
		wait(0.05);
	}
}

function stamin_upgrade_effects() 
{
	self endon("disconnect");
	while(true)
	{
		if(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_STAMINUP) && ! self HasPerk("specialty_unlimitedsprint")) 
		{
			self SetPerk("specialty_unlimitedsprint");
		}
		if(! self zm_perk_upgrades::IsPerkUpgradeActive(PERK_STAMINUP) && self HasPerk("specialty_unlimitedsprint"))
		{
			self UnSetPerk("specialty_unlimitedsprint");
		}
		wait(0.05);
	}
}

function cherry_upgrade_effects() 
{
	self endon("disconnect");
	while(true)
	{
		if(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_ELECTRIC_CHERRY) && ! self HasPerk(PERK_SLEIGHT_OF_HAND)) 
		{
			self SetPerk(PERK_SLEIGHT_OF_HAND);
		}
		if(! self zm_perk_upgrades::IsPerkUpgradeActive(PERK_ELECTRIC_CHERRY) && self HasPerk(PERK_SLEIGHT_OF_HAND))
		{
			self UnSetPerk(PERK_SLEIGHT_OF_HAND);
		}
		wait(0.05);
	}
}

function mule_upgrade_effects() 
{
	self endon("disconnect");
	self thread mule_third_gun_hud();
	self.hasGivenGunBack = true;
	self.gunToGiveBack = level.weaponNone;

	//testCounter = 0;
	
	while(true)
	{
		/*
		IPrintLn("Is upgrade active: ");
		IPrintLn(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_ADDITIONAL_PRIMARY_WEAPON));
		IPrintLn("Has gun been given back?: ");
		IPrintLn(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_ADDITIONAL_PRIMARY_WEAPON));
		wait(1);
		IPrintLn("Number of guns: : ");
		IPrintLn((self GetWeaponsListPrimaries()).size);
		IPrintLn("Is it weaponnone: ");
		IPrintLn(self.gunToGiveBack == level.weaponNone);
		wait(1);
		*/
		if(self.hasGivenGunBack && self HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON) && ! self laststand::player_is_in_laststand())
		{
			self.gunToGiveBack = self zm_perk_upgrades::return_additionalprimaryweapon();
 			self.gunToGiveBackClip = self GetWeaponAmmoClip(self.gunToGiveBack);
 			self.gunToGiveBackStock = self GetWeaponAmmoStock(self.gunToGiveBack);

 			/*
 			if(testCounter % 100 == 0)
 			{
 				IPrintLn(self.gunToGiveBack.name);
 				IPrintLn("Clip ammo:");
 				IPrintLn(self.gunToGiveBackClip);
 				IPrintLn("Stock ammo:");
 				IPrintLn(self.gunToGiveBackStock);
 			}
 			//*/
		}

		if(self HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON) && ! self.hasGivenGunBack && (self GetWeaponsListPrimaries()).size < 3 &&
		self.gunToGiveBack != level.weaponNone) 
		{
			//IPrintLn("Giving back: ");
			//IPrintLn(self.gunToGiveBack.name);
			self notify("third_gun_returned");
			self.hasGivenGunBack = true;
			self GiveWeapon(self.gunToGiveBack);
			self SetWeaponAmmoClip(self.gunToGiveBack, self.gunToGiveBackClip);
			self SetWeaponAmmoStock(self.gunToGiveBack, self.gunToGiveBackStock);

			self.gunToGiveBack = level.weaponNone;

			/*
			IPrintLn("Giving back: ");
			IPrintLn(self.gunToGiveBack.name);
			IPrintLn("Clip ammo:");
			IPrintLn(self.gunToGiveBackClip);
			IPrintLn("Stock ammo:");
			IPrintLn(self.gunToGiveBackStock);
			self.gunToGiveBack = level.weaponNone;
			//*/
		}
		//testCounter++;
		wait(0.05);
	}
}

function revive_upgrade_effects()
{
	self endon("disconnect");
	self.n_bleedout_time_multiplier = 1;

	//testCounter = 0;
	while(true)
	{
		if(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_QUICK_REVIVE) && self.n_bleedout_time_multiplier != 1.33) 
		{
			self.n_bleedout_time_multiplier = 1.33;
		}
		if(! self zm_perk_upgrades::IsPerkUpgradeActive(PERK_QUICK_REVIVE) && self.n_bleedout_time_multiplier == 1.33)
		{
			self.n_bleedout_time_multiplier = 1;
		}

		/*
		if(testCounter % 100 == 0)
		{
			IPrintLn("Bleedout timer: ");
			IPrintLn(self.n_bleedout_time_multiplier);
		}
		testCounter++;
		//*/
		wait(0.05);
	}
}

function mule_third_gun_hud()
{
	self endon("disconnect");

	/*
	third_gun_hud = NewClientHudElem(self);
	third_gun_hud.alignX = "right";
	third_gun_hud.alignY = "bottom";
	third_gun_hud.horzAlign = "fullscreen";
	third_gun_hud.vertAlign = "fullscreen";
	third_gun_hud.x = 582;
	third_gun_hud.y = 465;
	third_gun_hud.foreground = true;
	third_gun_hud.hidewheninmenu = true;
	third_gun_hud setShader("thirdguninfo", 16, 22);
	third_gun_hud.alpha = 0;
	*/

	showing_icon = false;

	while(true)
	{
		cur_weapon = self GetCurrentWeapon();
		if(self HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON) && ! IS_TRUE(self.abbey_inventory_active) && cur_weapon == self zm_perk_upgrades::return_additionalprimaryweapon() && !showing_icon)
		{
			self LUINotifyEvent(&"mule_indicator", 1, 1);
			showing_icon = true;
			//IPrintLn("Switched to 3rd gun");
			//third_gun_hud.alpha = 1;
		}
		else if(! (self HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON) && ! IS_TRUE(self.abbey_inventory_active) && self GetCurrentWeapon() == self zm_perk_upgrades::return_additionalprimaryweapon()) && showing_icon)
		{
			self LUINotifyEvent(&"mule_indicator", 1, 0);
			showing_icon = false;
			//IPrintLn("Switched away from 3rd gun");
			//third_gun_hud.alpha = 0;
		}
		wait(0.05);
	}
}


function on_laststand()
{
	self endon("disconnect");

	if(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_ADDITIONAL_PRIMARY_WEAPON))
	{
		self.hasGivenGunBack = false;
	}

 	if(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_QUICK_REVIVE) && GetPlayers().size == 1)
 	{
 		self waittill("player_revived");
 		self EnableInvulnerability();
		for(i = 0; i < 100; i++)
		{
			self.ignoreme = true;
			wait(0.05);
		}
		self.ignoreme = false;
		self DisableInvulnerability();
 	}
}