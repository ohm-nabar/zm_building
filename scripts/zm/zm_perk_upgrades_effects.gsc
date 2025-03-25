
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm_magicbox;
#using scripts\zm\zm_perk_upgrades;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_perk_poseidonspunch.gsh;
#insert scripts\zm\_zm_perk_doubletaporiginal.gsh;

#namespace zm_perk_upgrades_effects;

REGISTER_SYSTEM_EX( "zm_perk_upgrades_effects", &__init__, &__main__, undefined )

// MAIN
//*****************************************************************************

function __init__()
{
	clientfield::register( "clientuimodel", "muleIndicator", VERSION_SHIP, 1, "int" );

	callback::on_connect( &on_player_connect );
}

function __main__()
{
	level.perk_lost_func = &perk_lost_callback;
}

function perk_lost_callback(perk)
{
	if(perk == PERK_ADDITIONAL_PRIMARY_WEAPON && self.hasMule2 && ! self.shadowMule)
	{
		self.hasGivenGunBack = false;
		if(self.gunToGiveBack == level.weaponNone)
		{
			debug_str = "No Mule Kick return weapon set on down (weaponNone)";
		}
		else
		{
			debug_str = "Mule Kick return weapon set on down (" + self.gunToGiveBack.displayName + ")";
		}
		/# PrintLn(debug_str); #/
	}
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
	
	while(true)
	{
		if(self.hasGivenGunBack && self zm_perk_upgrades::IsPerkUpgradeActive(PERK_ADDITIONAL_PRIMARY_WEAPON) && ! self laststand::player_is_in_laststand())
		{
			mule_kick_gun = self zm_perk_upgrades::return_additionalprimaryweapon();
			if(mule_kick_gun != self.gunToGiveBack)
			{
				if(mule_kick_gun == level.weaponNone)
				{
					debug_str = "Mule Kick return weapon is now weaponNone";
				}
				else
				{
					debug_str = "Mule Kick return weapon is now " + mule_kick_gun.displayName;
				}
				/# PrintLn(debug_str); #/
				self.gunToGiveBack = mule_kick_gun;
				self.gunToGiveBackClip = self GetWeaponAmmoClip(self.gunToGiveBack);
				self.gunToGiveBackStock = self GetWeaponAmmoStock(self.gunToGiveBack);
			}
		}

		if(self zm_perk_upgrades::IsPerkUpgradeActive(PERK_ADDITIONAL_PRIMARY_WEAPON) && ! self.hasGivenGunBack && (self GetWeaponsListPrimaries()).size < 3 &&
		self.gunToGiveBack != level.weaponNone && ! self HasWeapon(self.gunToGiveBack) && self zm_magicbox::can_buy_weapon() && ! self.isInBloodMode) 
		{
			debug_str = "Returning " + self.gunToGiveBack.displayName;
			/# PrintLn(debug_str); #/
			self notify("third_gun_returned");
			self.hasGivenGunBack = true;
			self GiveWeapon(self.gunToGiveBack);
			self SetWeaponAmmoClip(self.gunToGiveBack, self.gunToGiveBackClip);
			self SetWeaponAmmoStock(self.gunToGiveBack, self.gunToGiveBackStock);
		}
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

		if(! level.is_coop_paused)
		{
			if(result == "quick2_revive_boost")
			{
				self.quick2_player SetMoveSpeedScale(1.5);
			}
			self SetMoveSpeedScale(1.5);
		}

		wait(2.5);
		if(! level.is_coop_paused)
		{
			if(result == "quick2_revive_boost")
			{
				self.quick2_player SetMoveSpeedScale(1);
			}
			self SetMoveSpeedScale(1);
		}
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