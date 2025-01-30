
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\zm_perk_upgrades;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_perk_poseidonspunch.gsh;
#insert scripts\zm\_zm_perk_doubletaporiginal.gsh;

#namespace zm_perk_upgrades_effects;

REGISTER_SYSTEM( "zm_perk_upgrades_effects", &__init__, undefined )

// MAIN
//*****************************************************************************

function __init__()
{
	clientfield::register( "clientuimodel", "muleIndicator", VERSION_SHIP, 1, "int" );

	callback::on_connect( &on_player_connect );
	callback::on_laststand( &on_laststand );
}

function on_player_connect()
{
	self thread double_upgrade_effects();
	self thread stamin_upgrade_effects();
	self thread cherry_upgrade_effects();
	self thread mule_upgrade_effects();
	self thread quick_upgrade_effects();
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

function mule_third_gun_hud()
{
	self endon("disconnect");

	showing_icon = false;

	while(true)
	{
		cur_weapon = self GetCurrentWeapon();
		if(self HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON) && ! IS_TRUE(self.abbey_inventory_active) && cur_weapon == self zm_perk_upgrades::return_additionalprimaryweapon() && !showing_icon)
		{
			self clientfield::set_player_uimodel("muleIndicator", 1);
			showing_icon = true;
		}
		else if(! (self HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON) && ! IS_TRUE(self.abbey_inventory_active) && self GetCurrentWeapon() == self zm_perk_upgrades::return_additionalprimaryweapon()) && showing_icon)
		{
			self clientfield::set_player_uimodel("muleIndicator", 0);
			showing_icon = false;
		}
		wait(0.05);
	}
}

function quick_upgrade_effects()
{
	self endon("disconnect");

	self thread quick2_heal_check();
	self thread quick2_reviver_check();
	while(true)
	{
		result = self util::waittill_any_return("quick2_heal_boost", "quick2_revive_boost");
		if(result == "quick2_revive_boost")
		{
			self.quick2_player SetMoveSpeedScale(1.5);
		}
		self SetMoveSpeedScale(1.5);

		wait(2.5);
		if(result == "quick2_revive_boost")
		{
			self.quick2_player SetMoveSpeedScale(1);
		}
		self SetMoveSpeedScale(1);
	}
}

function quick2_heal_check()
{
	self endon("disconnect");

	prev_health = self.health;
	while(true)
	{
		if(self.health > prev_health && self zm_perk_upgrades::IsPerkUpgradeActive(PERK_QUICK_REVIVE))
		{
			self notify("quick2_heal_boost");
			while(self.health < self.maxHealth)
			{
				wait(0.05);
			}
		}

		prev_health = self.health;
		wait(0.05);
	}
}

function quick2_reviver_check()
{
	self endon("disconnect");

	while(true)
	{
		self waittill("player_revived", reviver);
		if(reviver != self && reviver zm_perk_upgrades::IsPerkUpgradeActive(PERK_QUICK_REVIVE))
		{
			reviver.quick2_player = self;
			reviver notify("quick2_revive_boost");
		}
	}
}


function on_laststand()
{
	self endon("disconnect");

	if(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_ADDITIONAL_PRIMARY_WEAPON))
	{
		self.hasGivenGunBack = false;
	}
}