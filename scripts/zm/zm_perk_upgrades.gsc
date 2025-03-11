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
#using scripts\zm\_zm_perks;

#using scripts\shared\system_shared;

#using scripts\zm\zm_abbey_inventory;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_perk_poseidonspunch.gsh;
#insert scripts\zm\_zm_perk_doubletaporiginal.gsh;
#insert scripts\zm\_zm_perk_phdlite.gsh;
#insert scripts\zm\zm_abbey_inventory.gsh;

#namespace zm_perk_upgrades;

REGISTER_SYSTEM( "zm_perk_upgrades", &__init__, undefined )

function __init__()
{
	level.get_player_perk_purchase_limit = &get_player_perk_purchase_limit;

	level.abbey_perk_indices = [];
	level.abbey_perk_indices[PERK_ADDITIONAL_PRIMARY_WEAPON] = 0;
	level.abbey_perk_indices[PERK_STAMINUP] = 1;
	level.abbey_perk_indices[PERK_QUICK_REVIVE] = 2;
	level.abbey_perk_indices[PERK_ELECTRIC_CHERRY] = 3;
	level.abbey_perk_indices[PERK_PHD_LITE] = 4;
	level.abbey_perk_indices[PERK_DOUBLE_TAP] = 5;
	level.abbey_perk_indices[PERK_POSEIDON_PUNCH] = 6;
	level.abbey_perk_indices[PERK_DEAD_SHOT] = 7;

	callback::on_connect( &on_player_connect );
	zm::register_zombie_damage_override_callback( &zombie_damage_override );
}

function on_player_connect() 
{
	self.hasJug2 = false;
	self.hasElectric2 = false;
	self.hasQuick2 = false;
	self.hasDouble2 = false;
	self.hasMule2 = false;
	self.hasStamin2 = false;
	self.hasPoseidon2 = false;
	self.hasPHD2 = false;
	self.hasDeadshot2 = false;

	self.isUpgradingJug = false;
	self.isUpgradingCherry = false;
	self.isUpgradingQuick = false;
	self.isUpgradingDouble = false;
	self.isUpgradingMule = false;
	self.isUpgradingStamin = false;
	self.isUpgradingPoseidon = false;
	self.isUpgradingPHD = false;
	self.isUpgradingDeadshot = false;

	self.jugUpgradeQuestDone = false;
	self.quickUpgradeQuestDone = false;
	self.cherryUpgradeQuestDone = false;
	self.muleUpgradeQuestDone = false;
	self.staminUpgradeQuestDone = false;
	self.doubleUpgradeQuestDone = false;
	self.poseidonUpgradeQuestDone = false;
	self.PHDUpgradeQuestDone = false;
	self.deadshotUpgradeQuestDone = false;

	self.jugChallengeActive = false;
	self.quickChallengeActive = false;
	self.cherryChallengeActive = false;
	self.muleChallengeActive = false;
	self.staminChallengeActive = false;
	self.doubleChallengeActive = false;
	self.poseidonChallengeActive = false;
	self.PHDChallengeActive = false;
	self.deadshotChallengeActive = false;

	self.cherry_kills = 0;

	self.jug_challenge_goal = 1;
	self.jug_challenge_progress = 0;

	self.cherry_challenge_goal = 10;
	self.cherry_challenge_progress = 0;

	self.stamin_challenge_goal = 5;
	self.stamin_challenge_progress = 0;

	self.double_challenge_goal = 3;
	self.double_challenge_progress = 0;

	self.mule_challenge_goal = 10;
	self.mule_challenge_progress = 0;

	self.poseidon_challenge_goal = 8;
	self.poseidon_challenge_progress = 0;

	self.quick_challenge_goal = 4;
	self.quick_challenge_progress = 0;

	self.PHD_challenge_goal = 8;
	self.PHD_challenge_progress = 0;

	self.deadshot_challenge_goal = 10;
	self.deadshot_challenge_progress = 0;

	self.perk_notif_sent = false;
	self.perk_notif2_sent = false;

	self thread electric_cherry_upgrade();
	self thread stamin_up_upgrade();
	self thread double_tap_upgrade();
	self thread mule_kick_upgrade();
	self thread poseidon_punch_upgrade();
	self thread quick_revive_upgrade();
	self thread phd_lite_upgrade();
	self thread deadshot_upgrade();
}

function zombie_damage_override(willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if ( isPlayer( attacker ) && willBeKilled )
	{
		if(IS_TRUE(self.poseidon_knockdown) && isdefined(attacker.blessedkills))
		{
			attacker.blessedkills++;
		}
		if(IS_TRUE(self.phd_damaged) && isdefined(attacker.slidekills))
		{
			attacker.slidekills++;
		}
	}
	else
	{
		self.phd_damaged = false;
	}
}

function get_player_perk_purchase_limit()
{
	return 4;
}

function givePerkUpgrade(perkname)
{
	self endon("disconnect");

	switch(perkname) {
		case PERK_JUGGERNOG:
			self.hasJug2 = true;
			break;
		case PERK_ELECTRIC_CHERRY:
			self.isUpgradingCherry = false;
			self.cherryChallengeActive = false;
			self.cherryUpgradeQuestDone = true;
			self.hasElectric2 = true;
			break;
		case PERK_QUICK_REVIVE:
			self.quickUpgradeQuestDone = true;
			self.isUpgradingQuick = false;
			self.quickChallengeActive = false;
			self.hasQuick2 = true;
			break;
		case PERK_ADDITIONAL_PRIMARY_WEAPON:
			self.isUpgradingMule = false;
			self.muleChallengeActive = false;
			self.muleUpgradeQuestDone = true;
			self.hasMule2 = true;
			break;
		case PERK_STAMINUP:
			self.isUpgradingStamin = false;
			self.staminChallengeActive = false;
			self.staminUpgradeQuestDone = true;
			self.hasStamin2 = true;
			break;
		case PERK_PHD_LITE:
			self.isUpgradingPHD = false;
			self.PHDChallengeActive = false;
			self.PHDUpgradeQuestDone = true;
			self.hasPHD2 = true;
			break;
		case PERK_POSEIDON_PUNCH:
			self.isUpgradingPoseidon = false;
			self.poseidonChallengeActive = false;
			self.poseidonUpgradeQuestDone = true;
			self.hasPoseidon2 = true;
			break;
		case PERK_DOUBLE_TAP:
			self.isUpgradingDouble = false;
			self.doubleChallengeActive = false;
			self.doubleUpgradeQuestDone = true;
			self.hasDouble2 = true;
			break;
		case PERK_DEAD_SHOT:
			self.isUpgradingDeadshot = false;
			self.deadshotChallengeActive = false;
			self.deadshotUpgradeQuestDone = true;
			self.hasDeadshot2 = true;
			break;
	}
}

function IsPerkUpgradeActive(perkname) 
{
	self endon("disconnect");

	if(! self HasPerk(perkname)) 
	{
		return false;
	}

	switch(perkname) {
		case PERK_JUGGERNOG:
			return self.hasJug2;
			break;
		case PERK_ELECTRIC_CHERRY:
			return self.hasElectric2;
			break;
		case PERK_QUICK_REVIVE:
			return self.hasQuick2;
			break;
		case PERK_ADDITIONAL_PRIMARY_WEAPON:
			return self.hasMule2;
			break;
		case PERK_STAMINUP:
			return self.hasStamin2;
			break;
		case PERK_PHD_LITE:
			return self.hasPHD2;
			break;
		case PERK_POSEIDON_PUNCH:
			return self.hasPoseidon2;
			break;
		case PERK_DOUBLE_TAP:
			return self.hasDouble2;
			break;
		case PERK_DEAD_SHOT:
			return self.hasDeadshot2;
			break;
	}

	return false;
}

function has_no_perk_upgrades()
{
	return ! (self.hasElectric2 || self.hasQuick2 || self.hasMule2 || self.hasStamin2 || self.hasPHD2 || self.hasPoseidon2 || self.hasDouble2 || self.hasDeadshot2);
}

function electric_cherry_upgrade() 
{
	self endon("disconnect");

	failedByTime = false;
	while(! self.cherryUpgradeQuestDone) 
	{
		//IPrintLn("Looping");
		if(self HasPerk(PERK_ELECTRIC_CHERRY) && ! self.isUpgradingCherry)
		{
			self.isUpgradingCherry = true;
			self.cherryChallengeActive = true;

			if(! self.perk_notif_sent || (! self.perk_notif2_sent && level.active_generators.size >= 4 && self has_no_perk_upgrades()))
			{
				self.perk_notif_sent = true;
				if(level.active_generators.size >= 4 && self has_no_perk_upgrades())
				{
					self.perk_notif2_sent = true;
				}
				self thread zm_abbey_inventory::notifyText(NOTIF_PERK_QUEST, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK);
			}

			if(isdefined(level.next_dog_round) && level.round_number == level.next_dog_round)
			{
				while(self HasPerk(PERK_ELECTRIC_CHERRY) && ! level.shadow_vision_active)
				{
					wait(0.05);
				}
			}
			
			self.cherryChallengeActive = false;
			while(self HasPerk(PERK_ELECTRIC_CHERRY) && level.shadow_vision_active)
			{
				wait(0.05);
			}

			if(! failedByTime)
			{
				hasCherry = self HasPerk(PERK_ELECTRIC_CHERRY);

				if(isdefined(hasCherry) && !hasCherry)
				{
					self.isUpgradingCherry = false;
					wait(0.05);
					continue;
				}
			}

			failedByTime = false;

			//self IPrintLnBold("Electric Cherry Upgrade: Get 10 kills with Electric Cherry (Time limit: 2 rounds)");
			self.cherryChallengeActive = true;
			currentRound = level.round_number;
			current_cherry_kills = 0;
			if(isdefined(self.cherry_kills))
			{
				current_cherry_kills = self.cherry_kills;
			}

			//IPrintLn("current cherry kills " + self.cherry_kills);
			while(level.round_number < currentRound + 1)
			{
				self.cherry_challenge_progress = self.cherry_kills - current_cherry_kills;
				if(! self HasPerk(PERK_ELECTRIC_CHERRY))
				{
					break;
				}
				if(self.cherry_kills >= current_cherry_kills + self.cherry_challenge_goal)
				{
					self thread zm_abbey_inventory::notifyText(NOTIF_PERK_UP_CHERRY, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK_UP);
					self givePerkUpgrade(PERK_ELECTRIC_CHERRY);
					break;
				}
				//IPrintLn("current cherry kills " + self.cherry_kills);
				wait(0.05);
			}
			if(! self.cherryUpgradeQuestDone)
			{
				self.isUpgradingCherry = false;
				self.cherryChallengeActive = false;
				self.cherry_challenge_progress = 0;
				//self IPrintLnBold("Electric Cherry Upgrade Failed!");
				if(self HasPerk(PERK_ELECTRIC_CHERRY))
				{
					failedByTime = true;
				}
			}

		}
		wait(0.05);
	}
}

function double_tap_upgrade() 
{
	self endon("disconnect");

	failedByTime = false;
	while(! self.doubleUpgradeQuestDone) 
	{
		//IPrintLn("Looping");
		if(self HasPerk(PERK_DOUBLE_TAP) && ! self.isUpgradingDouble)
		{
			self.isUpgradingDouble = true;
			self.doubleChallengeActive = true;

			if(! self.perk_notif_sent || (! self.perk_notif2_sent && level.active_generators.size >= 4 && self has_no_perk_upgrades()))
			{
				self.perk_notif_sent = true;
				if(level.active_generators.size >= 4 && self has_no_perk_upgrades())
				{
					self.perk_notif2_sent = true;
				}
				self thread zm_abbey_inventory::notifyText(NOTIF_PERK_QUEST, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK);
			}

			if(isdefined(level.next_dog_round) && level.round_number == level.next_dog_round)
			{
				while(self HasPerk(PERK_DOUBLE_TAP) && ! level.shadow_vision_active)
				{
					wait(0.05);
				}
			}
			
			self.doubleChallengeActive = false;
			while(self HasPerk(PERK_DOUBLE_TAP) && level.shadow_vision_active)
			{
				wait(0.05);
			}

			if(! failedByTime)
			{
				//self IPrintLnBold("Gained Challenge: Double Tap Upgrade (Begins next round)");
				hasDouble = self HasPerk(PERK_DOUBLE_TAP);

				if(isdefined(hasDouble) && !hasDouble)
				{
					self.isUpgradingDouble = false;
					wait(0.05);
					continue;
				}
			}
			failedByTime = false;

			//self IPrintLnBold("Double Tap Upgrade: Get 5 kills in rapid succession 5 times (Time limit: 2 rounds)");
			self.doubleChallengeActive = true;
			currentRound = level.round_number;
			self.pentakills = 0;
			self thread checkForPentas();
			while(level.round_number < currentRound + 1)
			{
				self.double_challenge_progress = self.pentakills;
				if(! self HasPerk(PERK_DOUBLE_TAP))
				{
					break;
				}
				if(self.pentakills >= self.double_challenge_goal)
				{
					self thread zm_abbey_inventory::notifyText(NOTIF_PERK_UP_DOUBLE, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK_UP);
					self notify(#"doubleUpgradeSucceeded");
					self givePerkUpgrade(PERK_DOUBLE_TAP);
					break;
				}
				wait(0.05);
			}
			if(! self.doubleUpgradeQuestDone)
			{
				self.isUpgradingDouble = false;
				self.doubleChallengeActive = false;
				self.double_challenge_progress = 0;
				//self IPrintLnBold("Double Tap Upgrade Failed!");
				self notify(#"doubleUpgradeFailed");
				if(self HasPerk(PERK_DOUBLE_TAP))
				{
					failedByTime = true;
				}
			}

		}
		wait(0.05);
	}
}

function phd_lite_upgrade()
{
	self endon("disconnect");

	failedByTime = false;	
	while(! self.PHDUpgradeQuestDone) 
	{
		//IPrintLn("Looping");
		if(self HasPerk(PERK_PHD_LITE) && ! self.isUpgradingPHD)
		{
			self.isUpgradingPHD = true;
			self.PHDChallengeActive = true;

			if(! self.perk_notif_sent || (! self.perk_notif2_sent && level.active_generators.size >= 4 && self has_no_perk_upgrades()))
			{
				self.perk_notif_sent = true;
				if(level.active_generators.size >= 4 && self has_no_perk_upgrades())
				{
					self.perk_notif2_sent = true;
				}
				self thread zm_abbey_inventory::notifyText(NOTIF_PERK_QUEST, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK);
			}

			if(isdefined(level.next_dog_round) && level.round_number == level.next_dog_round)
			{
				while(self HasPerk(PERK_PHD_LITE) && ! level.shadow_vision_active)
				{
					wait(0.05);
				}
			}
			
			self.PHDChallengeActive = false;
			while(self HasPerk(PERK_PHD_LITE) && level.shadow_vision_active)
			{
				wait(0.05);
			}

			if(! failedByTime)
			{
				//self IPrintLnBold("Gained Challenge: Double Tap Upgrade (Begins next round)");
				hasPHD = self HasPerk(PERK_PHD_LITE);

				if(isdefined(hasPHD) && !hasPHD)
				{
					self.isUpgradingPHD = false;
					wait(0.05);
					continue;
				}
			}
			failedByTime = false;

			//self IPrintLnBold("Double Tap Upgrade: Get 5 kills in rapid succession 5 times (Time limit: 2 rounds)");
			self.PHDChallengeActive = true;
			currentRound = level.round_number;
			self.slidekills = 0;
			while(level.round_number < currentRound + 1)
			{
				self.PHD_challenge_progress = self.slidekills;
				if(! self HasPerk(PERK_PHD_LITE))
				{
					break;
				}
				if(self.slidekills >= self.PHD_challenge_goal)
				{
					self thread zm_abbey_inventory::notifyText(NOTIF_PERK_UP_PHD, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK_UP);
					self notify(#"PHDUpgradeSucceeded");
					self givePerkUpgrade(PERK_PHD_LITE);
					break;
				}
				wait(0.05);
			}
			if(! self.PHDUpgradeQuestDone)
			{
				self.isUpgradingPHD = false;
				self.PHDChallengeActive = false;
				self.PHD_challenge_progress = 0;
				//self IPrintLnBold("Double Tap Upgrade Failed!");
				self notify(#"PHDUpgradeFailed");
				if(self HasPerk(PERK_PHD_LITE))
				{
					failedByTime = true;
				}
			}
		}
		wait(0.05);
	}
}

function poseidon_punch_upgrade()
{
	self endon("disconnect");

	failedByTime = false;
	while(! self.poseidonUpgradeQuestDone) 
	{
		//IPrintLn("Looping");
		if(self HasPerk(PERK_POSEIDON_PUNCH) && ! self.isUpgradingPoseidon)
		{
			self.isUpgradingPoseidon = true;
			self.poseidonChallengeActive = true;

			if(! self.perk_notif_sent || (! self.perk_notif2_sent && level.active_generators.size >= 4 && self has_no_perk_upgrades()))
			{
				self.perk_notif_sent = true;
				if(level.active_generators.size >= 4 && self has_no_perk_upgrades())
				{
					self.perk_notif2_sent = true;
				}
				self thread zm_abbey_inventory::notifyText(NOTIF_PERK_QUEST, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK);
			}

			if(isdefined(level.next_dog_round) && level.round_number == level.next_dog_round)
			{
				while(self HasPerk(PERK_POSEIDON_PUNCH) && ! level.shadow_vision_active)
				{
					wait(0.05);
				}
			}
			
			self.poseidonChallengeActive = false;
			while(self HasPerk(PERK_POSEIDON_PUNCH) && level.shadow_vision_active)
			{
				wait(0.05);
			}

			if(! failedByTime)
			{
				hasPoseidon = self HasPerk(PERK_POSEIDON_PUNCH);

				if(isdefined(hasPoseidon) && !hasPoseidon)
				{
					self.isUpgradingPoseidon = false;
					wait(0.05);
					continue;
				}
			}
			failedByTime = false;
			//self IPrintLnBold("Double Tap Upgrade: Get 5 kills in rapid succession 5 times (Time limit: 2 rounds)");
			self.poseidonChallengeActive = true;
			currentRound = level.round_number;
			self.blessedkills = 0;
			while(level.round_number < currentRound + 1)
			{
				self.poseidon_challenge_progress = self.blessedkills;
				if(! self HasPerk(PERK_POSEIDON_PUNCH))
				{
					break;
				}
				if(self.blessedkills >= self.poseidon_challenge_goal)
				{
					//self IPrintLnBold("Double Tap Upgraded! (Effects: Increased damage)");
					self thread zm_abbey_inventory::notifyText(NOTIF_PERK_UP_POSEIDON, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK_UP);
					self notify(#"poseidonUpgradeSucceeded");
					self givePerkUpgrade(PERK_POSEIDON_PUNCH);
					break;
				}
				wait(0.05);
			}
			if(! self.poseidonUpgradeQuestDone)
			{
				self.isUpgradingPoseidon = false;
				self.poseidonChallengeActive = false;
				self.poseidon_challenge_progress = 0;
				//self IPrintLnBold("Double Tap Upgrade Failed!");
				self notify(#"poseidonUpgradeFailed");
				if(self HasPerk(PERK_POSEIDON_PUNCH))
				{
					failedByTime = true;
				}
			}
		}
		wait(0.05);
	}
}

function stamin_up_upgrade()
{
	self endon("disconnect");

	failedByTime = false;
	while(! self.staminUpgradeQuestDone) 
	{
		//IPrintLn("Looping");
		if(self HasPerk(PERK_STAMINUP) && ! self.isUpgradingStamin)
		{
			self.isUpgradingStamin = true;
			self.staminChallengeActive = true;

			if(! self.perk_notif_sent || (! self.perk_notif2_sent && level.active_generators.size >= 4 && self has_no_perk_upgrades()))
			{
				self.perk_notif_sent = true;
				if(level.active_generators.size >= 4 && self has_no_perk_upgrades())
				{
					self.perk_notif2_sent = true;
				}
				self thread zm_abbey_inventory::notifyText(NOTIF_PERK_QUEST, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK);
			}

			if(isdefined(level.next_dog_round) && level.round_number == level.next_dog_round)
			{
				while(self HasPerk(PERK_STAMINUP) && ! level.shadow_vision_active)
				{
					wait(0.05);
				}
			}
			
			self.staminChallengeActive = false;
			while(self HasPerk(PERK_STAMINUP) && level.shadow_vision_active)
			{
				wait(0.05);
			}

			if(! failedByTime)
			{
				//self IPrintLnBold("Gained Challenge: Double Tap Upgrade (Begins next round)");
				hasStamin = self HasPerk(PERK_STAMINUP);

				if(isdefined(hasStamin) && !hasStamin)
				{
					self.isUpgradingStamin = false;
					wait(0.05);
					continue;
				}
			}
			failedByTime = false;
			//self IPrintLnBold("Double Tap Upgrade: Get 5 kills in rapid succession 5 times (Time limit: 2 rounds)");
			self.staminChallengeActive = true;
			currentRound = level.round_number;
			self.sprintKills = 0;
			self thread checkForSprintKills();
			while(level.round_number < currentRound + 1)
			{
				self.stamin_challenge_progress = self.sprintKills;
				if(! self HasPerk(PERK_STAMINUP))
				{
					break;
				}
				if(self.sprintKills >= self.stamin_challenge_goal)
				{
					//self IPrintLnBold("Double Tap Upgraded! (Effects: Increased damage)");
					self thread zm_abbey_inventory::notifyText(NOTIF_PERK_UP_STAMIN, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK_UP);
					self notify(#"staminUpgradeSucceeded");
					self givePerkUpgrade(PERK_STAMINUP);
					break;
				}
				wait(0.05);
			}
			if(! self.staminUpgradeQuestDone)
			{
				self.isUpgradingStamin = false;
				self.staminChallengeActive = false;
				self.stamin_challenge_progress = 0;
				//self IPrintLnBold("Double Tap Upgrade Failed!");
				self notify(#"staminUpgradeFailed");
				if(self HasPerk(PERK_STAMINUP))
				{
					failedByTime = true;
				}
			}

		}
		wait(0.05);
	}
}

function mule_kick_upgrade() 
{
	self endon("disconnect");

	failedByTime = false;
	while(! self.muleUpgradeQuestDone) 
	{
		//IPrintLn("Looping");
		if(self HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON) && ! self.isUpgradingMule)
		{
			self.isUpgradingMule = true;
			self.muleChallengeActive = true;

			if(! self.perk_notif_sent || (! self.perk_notif2_sent && level.active_generators.size >= 4 && self has_no_perk_upgrades()))
			{
				self.perk_notif_sent = true;
				if(level.active_generators.size >= 4 && self has_no_perk_upgrades())
				{
					self.perk_notif2_sent = true;
				}
				self thread zm_abbey_inventory::notifyText(NOTIF_PERK_QUEST, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK);
			}

			if(isdefined(level.next_dog_round) && level.round_number == level.next_dog_round)
			{
				while(self HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON) && ! level.shadow_vision_active)
				{
					wait(0.05);
				}
			}
			
			self.muleChallengeActive = false;
			while(self HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON) && level.shadow_vision_active)
			{
				wait(0.05);
			}

			if(! failedByTime)
			{
				//self IPrintLnBold("Gained Challenge: Double Tap Upgrade (Begins next round)");
				hasMule = self HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON);

				if(isdefined(hasMule) && !hasMule)
				{
					self.isUpgradingMule = false;
					wait(0.05);
					continue;
				}
			}
			failedByTime = false;

			//self IPrintLnBold("Double Tap Upgrade: Get 5 kills in rapid succession 5 times (Time limit: 2 rounds)");
			self.muleChallengeActive = true;
			currentRound = level.round_number;
			self.thirdgunkills = 0;
			self thread checkForThirdGunKills();
			while(level.round_number < currentRound + 1)
			{
				self.mule_challenge_progress = self.thirdgunkills;
				if(! self HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON))
				{
					break;
				}
				if(self.thirdgunkills >= self.mule_challenge_goal)
				{
					//self IPrintLnBold("Double Tap Upgraded! (Effects: Increased damage)");
					self thread zm_abbey_inventory::notifyText(NOTIF_PERK_UP_MULE, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK_UP);
					self notify(#"muleUpgradeSucceeded");
					self givePerkUpgrade(PERK_ADDITIONAL_PRIMARY_WEAPON);
					break;
				}
				wait(0.05);
			}
			if(! self.muleUpgradeQuestDone)
			{
				self.isUpgradingMule = false;
				self.muleChallengeActive = false;
				self.mule_challenge_progress = 0;
				//self IPrintLnBold("Double Tap Upgrade Failed!");
				self notify(#"muleUpgradeFailed");
				if(self HasPerk(PERK_ADDITIONAL_PRIMARY_WEAPON))
				{
					failedByTime = true;
				}
			}
		}
		wait(0.05);
	}
}

function quick_revive_upgrade() 
{
	self endon("disconnect");

	failedByTime = false;
	while(! self.quickUpgradeQuestDone) 
	{
		//IPrintLn("Looping");
		if(self HasPerk(PERK_QUICK_REVIVE) && ! self.isUpgradingQuick)
		{
			self.isUpgradingQuick = true;
			self.quickChallengeActive = true;

			if(! self.perk_notif_sent || (! self.perk_notif2_sent && level.active_generators.size >= 4 && self has_no_perk_upgrades()))
			{
				self.perk_notif_sent = true;
				if(level.active_generators.size >= 4 && self has_no_perk_upgrades())
				{
					self.perk_notif2_sent = true;
				}
				self thread zm_abbey_inventory::notifyText(NOTIF_PERK_QUEST, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK);
			}

			if(isdefined(level.next_dog_round) && level.round_number == level.next_dog_round)
			{
				while(self HasPerk(PERK_QUICK_REVIVE) && ! level.shadow_vision_active)
				{
					wait(0.05);
				}
			}
			
			self.quickChallengeActive = false;
			while(self HasPerk(PERK_QUICK_REVIVE) && level.shadow_vision_active)
			{
				wait(0.05);
			}

			//self IPrintLnBold("Gained Challenge: Quick Revive Upgrade (Begins next round)");
			if(! failedByTime)
			{
				hasQuick = self HasPerk(PERK_QUICK_REVIVE);

				if(isdefined(hasQuick) && !hasQuick)
				{
					self.isUpgradingQuick = false;
					wait(0.05);
					continue;
				}
			}
			failedByTime = false;
			//IPrintLn(self.isUpgradingQuick);
			//self IPrintLnBold("Quick Revive Upgrade: Survive without downing (Time limit: 2 rounds)");
			self.quickChallengeActive = true;
			currentRound = level.round_number;
			self.lowHealthKills = 0;
			self thread checkForLowHealthKills();
			while(level.round_number < currentRound + 1)
			{
				self.quick_challenge_progress = self.lowHealthKills;
				if(! self HasPerk(PERK_QUICK_REVIVE))
				{
					break;
				}
				if(self.lowHealthKills >= self.quick_challenge_goal)
				{
					self thread zm_abbey_inventory::notifyText(NOTIF_PERK_UP_REVIVE, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK_UP);
					self notify(#"quickUpgradeSucceeded");
					self givePerkUpgrade(PERK_QUICK_REVIVE);
					break;
				}
				wait(0.05);
			}
			if(! self.quickUpgradeQuestDone)
			{
				self.isUpgradingQuick = false;
				self.quickChallengeActive = false;
				self.quick_challenge_progress = 0;
				self notify(#"quickUpgradeFailed");
				if(self HasPerk(PERK_QUICK_REVIVE))
				{
					failedByTime = true;
				}
			}

		}
		wait(0.05);
	}
}

function deadshot_upgrade() 
{
	self endon("disconnect");

	failedByTime = false;
	while(! self.deadshotUpgradeQuestDone) 
	{
		//IPrintLn("Looping");
		if(self HasPerk(PERK_DEAD_SHOT) && ! self.isUpgradingDeadshot)
		{
			self.isUpgradingDeadshot = true;
			self.deadshotChallengeActive = true;

			if(! self.perk_notif_sent || (! self.perk_notif2_sent && level.active_generators.size >= 4 && self has_no_perk_upgrades()))
			{
				self.perk_notif_sent = true;
				if(level.active_generators.size >= 4 && self has_no_perk_upgrades())
				{
					self.perk_notif2_sent = true;
				}
				self thread zm_abbey_inventory::notifyText(NOTIF_PERK_QUEST, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK);
			}

			if(isdefined(level.next_dog_round) && level.round_number == level.next_dog_round)
			{
				while(self HasPerk(PERK_DEAD_SHOT) && ! level.shadow_vision_active)
				{
					wait(0.05);
				}
			}
			
			self.deadshotChallengeActive = false;
			while(self HasPerk(PERK_DEAD_SHOT) && level.shadow_vision_active)
			{
				wait(0.05);
			}

			//self IPrintLnBold("Gained Challenge: Quick Revive Upgrade (Begins next round)");
			if(! failedByTime)
			{
				hasDeadshot = self HasPerk(PERK_DEAD_SHOT);

				if(isdefined(hasDeadshot) && !hasDeadshot)
				{
					self.isUpgradingDeadshot = false;
					wait(0.05);
					continue;
				}
			}
			failedByTime = false;
			//IPrintLn(self.isUpgradingQuick);
			//self IPrintLnBold("Quick Revive Upgrade: Survive without downing (Time limit: 2 rounds)");
			self.deadshotChallengeActive = true;
			currentRound = level.round_number;
			self.deadshotMindBlownKills = 0;
			while(level.round_number < currentRound + 1)
			{
				self.deadshot_challenge_progress = self.deadshotMindBlownKills;
				if(! self HasPerk(PERK_DEAD_SHOT))
				{
					break;
				}
				if(self.deadshotMindBlownKills >= self.deadshot_challenge_goal)
				{
					self thread zm_abbey_inventory::notifyText(NOTIF_PERK_UP_DEADSHOT, NOTIF_FLASH_RIGHT, NOTIF_ALERT_PERK_UP);
					self notify(#"deadshotUpgradeSucceeded");
					self givePerkUpgrade(PERK_DEAD_SHOT);
					self.deadshotMindBlownKills = undefined;
					break;
				}
				wait(0.05);
			}
			if(! self.deadshotUpgradeQuestDone)
			{
				self.isUpgradingDeadshot = false;
				self.deadshotChallengeActive = false;
				self.deadshot_challenge_progress = 0;
				self notify(#"deadshotUpgradeFailed");
				if(self HasPerk(PERK_DEAD_SHOT))
				{
					failedByTime = true;
				}
			}

		}
		wait(0.05);
	}
}

//function taken from Mule Kick gsc, but with the taking weapon and downing logic removed
function return_additionalprimaryweapon()
{
	self endon("disconnect");
	
	weapon_to_take = level.weaponNone;

	/*
	if ( IS_TRUE( self._retain_perks ) || ( IsDefined( self._retain_perks_array ) && IS_TRUE( self._retain_perks_array[ PERK_ADDITIONAL_PRIMARY_WEAPON ] ) ) )
	{
		return weapon_to_take;
	}
	*/

	primary_weapons_that_can_be_taken = [];

	primaryWeapons = self GetWeaponsListPrimaries();
	for ( i = 0; i < primaryWeapons.size; i++ )
	{
		if ( zm_weapons::is_weapon_included( primaryWeapons[i] ) || zm_weapons::is_weapon_upgraded( primaryWeapons[i] ) )
		{
			primary_weapons_that_can_be_taken[primary_weapons_that_can_be_taken.size] = primaryWeapons[i];
		}
	}

	pwtcbt = primary_weapons_that_can_be_taken.size;
	while ( pwtcbt >= 3 )
	{
		weapon_to_take = primary_weapons_that_can_be_taken[pwtcbt - 1];
		pwtcbt--;
		if ( weapon_to_take == self GetCurrentWeapon() )
		{
			//self SwitchToWeapon( primary_weapons_that_can_be_taken[0] );
		}
		//self TakeWeapon( weapon_to_take );
	}

	return weapon_to_take;
}

function checkForPentas() 
{
	self endon("disconnect");
	self endon(#"doubleUpgradeFailed");
	self endon(#"doubleUpgradeSucceeded");
	
	while(self.isUpgradingDouble && self.pentakills < self.double_challenge_goal)
	{
		start_kills = self.pers["kills"];
		while(self.pers["kills"] < start_kills + 1)
		{
			wait(0.05);
		}

		//IPrintLn("Kill 1");

		success = true;
		for(i = 2; i <= 5; i++)
		{
			counter = 0;
			while(self.pers["kills"] < start_kills + i && counter <= 40) // 40 = 2 / 0.05
			{
				counter++;
				wait(0.05);
			}
			if(self.pers["kills"] < start_kills + i)
			{ 
				success = false;
				break;
			}
			//IPrintLn("Kill " + i);
		}

		if (success)
		{
			self.pentakills++;
			//IPrintLn("pentakills: " + self.pentakills);
		}

		wait(0.05);
	}
}

function checkForThirdGunKills() 
{
	self endon("disconnect");
	self endon(#"muleUpgradeFailed");
	self endon(#"muleUpgradeSucceeded");

	while(self.isUpgradingMule && self.thirdgunkills < self.mule_challenge_goal)
	{
		self waittill("zom_kill");
		if (self GetCurrentWeapon() == self return_additionalprimaryweapon() && ! IS_TRUE(self.abbey_inventory_active))
		{
			//IPrintLn("WERE IN THE BIG LEAGUES NOW");
			self.thirdgunkills++;
		}
	}
}

function checkForLowHealthKills() 
{
	self endon("disconnect");
	self endon(#"quickUpgradeFailed");
	self endon(#"quickUpgradeSucceeded");

	while(self.isUpgradingQuick && self.lowHealthKills < self.quick_challenge_goal)
	{
		self waittill("zom_kill");
		if(self.health < 100 || (self.jug_resistance_level > 100 && self.health < 125))
		{
			self.lowHealthKills++;
		}
	}
}

function checkForSprintKills() 
{
	self endon("disconnect");
	self endon(#"staminUpgradeFailed");
	self endon(#"staminUpgradeSucceeded");

	wasSprinting = false;
	while(self.isUpgradingStamin && self.sprintKills < self.stamin_challenge_goal)
	{
		time_sprinted = 0;
		while (self IsSprinting())
		{
			//IPrintLn("WERE IN THE BIG LEAGUES NOW");
			wasSprinting = true;
			time_sprinted += 0.05;
			//IPrintLn(time_sprinted);
			wait(0.05);
		} 

		player_kills = self.pers["kills"];
		if(wasSprinting && time_sprinted >= 2) 
		{
			wasSprinting = false;
			for(i = 0; i < 40; i++) 
			{
				if(self IsSprinting())
				{
					break;
				}

				self.sprintKills = self.sprintKills + self.pers["kills"] - player_kills;
				player_kills = self.pers["kills"];
				//IPrintLn(self.sprintKills);
				wait(0.05);
			}
		}
		wait(0.05);
	}
}

function testeroo() 
{
	while (!self ActionSlotThreeButtonPressed())
	{
		//IPrintLn("waiting");
		wait(0.05);
	}
	IPrintLn("6");
	self givePerkUpgrade(PERK_ADDITIONAL_PRIMARY_WEAPON);
	self givePerkUpgrade(PERK_QUICK_REVIVE);
	self givePerkUpgrade(PERK_POSEIDON_PUNCH);
	self givePerkUpgrade(PERK_ELECTRIC_CHERRY);
	self givePerkUpgrade(PERK_DOUBLE_TAP);
	self givePerkUpgrade(PERK_STAMINUP);
	self givePerkUpgrade(PERK_PHD_LITE);
}