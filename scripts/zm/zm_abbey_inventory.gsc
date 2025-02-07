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

#insert scripts\zm\zm_abbey_inventory.gsh;

#namespace zm_abbey_inventory;

#define CHALLENGE_INACTIVE 1
#define CHALLENGE_AWAITING 2
#define CHALLENGE_ACTIVE 3
#define CHALLENGE_COMPLETE 4

#define TAB_CHALLENGE 0
#define TAB_TRIAL 1
#define TAB_PERKBP 2
#define TAB_WEAPONBP 3

#precache( "eventstring", "notification_show" );
#precache( "eventstring", "notification_flash" );
#precache( "eventstring", "notification_gargoyle" );
#precache( "eventstring", "notification_hide" );
#precache( "eventstring", "generator_visible" );

REGISTER_SYSTEM( "zm_abbey_inventory", &__init__, undefined )

function __init__()
{
	clientfield::register( "clientuimodel", "inventoryVisible", VERSION_SHIP, 1, "int" );
	clientfield::register( "clientuimodel", "currentTab", VERSION_SHIP, 2, "int" );
	clientfield::register( "clientuimodel", "cherryUpdate", VERSION_SHIP, 4, "int" );
	clientfield::register( "clientuimodel", "staminUpdate", VERSION_SHIP, 4, "int" );
	clientfield::register( "clientuimodel", "doubleUpdate", VERSION_SHIP, 3, "int" );
	clientfield::register( "clientuimodel", "muleUpdate", VERSION_SHIP, 4, "int" );
	clientfield::register( "clientuimodel", "poseidonUpdate", VERSION_SHIP, 4, "int" );
	clientfield::register( "clientuimodel", "quickUpdate", VERSION_SHIP, 4, "int" );
	clientfield::register( "clientuimodel", "PHDUpdate", VERSION_SHIP, 4, "int" );
	clientfield::register( "clientuimodel", "deadshotUpdate", VERSION_SHIP, 4, "int" );

	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
}

function on_player_connect()
{
	self.abbey_notif_active = false;
	self LUINotifyEvent(&"notification_hide", 0);
	self LUINotifyEvent(&"generator_visible", 1, 0);
}

function on_player_spawned()
{
	self.abbey_inventory_active = false;
	self.current_tab = TAB_CHALLENGE;
	self thread inventory_check();
	self thread inventory_tab_navigation();
	self thread scroll_icon_hud();

	self thread cherry_challenge_hud();
	self thread quick_challenge_hud();
	self thread mule_challenge_hud();
	self thread stamin_challenge_hud();
	self thread double_challenge_hud();
	self thread PHD_challenge_hud();
	self thread poseidon_challenge_hud();
	self thread deadshot_challenge_hud();
}

function scroll_icon_hud()
{
	self endon("disconnect");
	self endon("bled_out");

	while(! level flag::get("initial_blackscreen_passed"))
	{
		wait(0.05);
	}
}

function inventory_check()
{
	self endon( "disconnect" );
	self endon( "bled_out ");

	while(true)
	{
		if( self ActionSlotFourButtonPressed() )
		{
			self.abbey_inventory_active = ! self.abbey_inventory_active;
			
			if (self.abbey_inventory_active)
			{
				self PlaySoundToPlayer("journal_close", self);
				self clientfield::set_player_uimodel("inventoryVisible", 1);
				self DisableWeapons();
			}
			if(! self.abbey_inventory_active && ! level.is_coop_paused)
			{
				self PlaySoundToPlayer("journal_open", self);
				self clientfield::set_player_uimodel("inventoryVisible", 0);
				self EnableWeapons();
			}

			while( self ActionSlotFourButtonPressed() )
			{
				wait(0.05);
			}
		}
		wait(0.05);
	}
}

function inventory_tab_navigation()
{
	self endon( "disconnect" );
	self endon( "bled_out ");

	ads_allowed = true;

	while(true)
	{
		while(self.abbey_inventory_active)
		{
			if(self AttackButtonPressed())
			{
				if(self.current_tab == TAB_WEAPONBP)
				{
					self.current_tab = TAB_CHALLENGE;
				}
				else
				{
					self.current_tab += 1;
				}
				alias_name = "journal_flip" + RandomIntRange(1, 4);
				self PlaySoundToPlayer(alias_name, self);
				self clientfield::set_player_uimodel("currentTab", self.current_tab);
				while(self AttackButtonPressed())
				{
					wait(0.05);
				}
			}

			if(self AdsButtonPressed())
			{
				if(self.current_tab == TAB_CHALLENGE)
				{
					self.current_tab = TAB_WEAPONBP;
				}
				else
				{
					self.current_tab -= 1;
				}
				alias_name = "journal_flip" + RandomIntRange(1, 4);
				self PlaySoundToPlayer(alias_name, self);
				self clientfield::set_player_uimodel("currentTab", self.current_tab);

				ads_allowed = false;
				self AllowAds(false);
				while(self AdsButtonPressed())
				{
					wait(0.05);
				}
				ads_allowed = true;
				self AllowAds(true);
			}
			wait(0.05);
		}

		if(! ads_allowed)
		{
			ads_allowed = true;
			self AllowAds(true);
		}

		wait(0.05);
	}
}

function cherry_challenge_hud()
{
	self endon( "disconnect" );
	self endon( "bled_out ");

	while(! isdefined(self.cherry_challenge_progress))
	{
		wait(0.05);
	}

	while(! self.cherryUpgradeQuestDone)
	{
		status = CHALLENGE_INACTIVE;
		if( self.isUpgradingCherry )
		{
			status = CHALLENGE_AWAITING;
			if( self.cherryChallengeActive )
			{
				status = CHALLENGE_ACTIVE;
				self clientfield::set_player_uimodel("cherryUpdate", self.cherry_challenge_progress);
				util::wait_network_frame();
			}
		}

		self clientfield::set_player_uimodel("cherryUpdate", self.cherry_challenge_goal + status);
		util::wait_network_frame();
	}

	util::wait_network_frame();
	self clientfield::set_player_uimodel("cherryUpdate", self.cherry_challenge_goal + CHALLENGE_COMPLETE);
}

function stamin_challenge_hud()
{
	self endon( "disconnect" );
	self endon( "bled_out ");

	while(! isdefined(self.stamin_challenge_progress))
	{
		wait(0.05);
	}

	while(! self.staminUpgradeQuestDone)
	{
		status = CHALLENGE_INACTIVE;
		if( self.isUpgradingStamin )
		{
			status = CHALLENGE_AWAITING;
			if( self.staminChallengeActive )
			{
				status = CHALLENGE_ACTIVE;
				self clientfield::set_player_uimodel("staminUpdate", self.stamin_challenge_progress);
				util::wait_network_frame();
			}
		}

		self clientfield::set_player_uimodel("staminUpdate", self.stamin_challenge_goal + status);
		util::wait_network_frame();
	}

	util::wait_network_frame();
	self clientfield::set_player_uimodel("staminUpdate", self.stamin_challenge_goal + CHALLENGE_COMPLETE);
}

function double_challenge_hud()
{
	self endon( "disconnect" );
	self endon( "bled_out ");

	while(! isdefined(self.double_challenge_progress))
	{
		wait(0.05);
	}

	while(! self.doubleUpgradeQuestDone)
	{
		status = CHALLENGE_INACTIVE;
		if( self.isUpgradingDouble )
		{
			status = CHALLENGE_AWAITING;
			if( self.doubleChallengeActive )
			{
				status = CHALLENGE_ACTIVE;
				self clientfield::set_player_uimodel("doubleUpdate", self.double_challenge_progress);
				util::wait_network_frame();
			}
		}

		self clientfield::set_player_uimodel("doubleUpdate", self.double_challenge_goal + status);
		util::wait_network_frame();
	}

	util::wait_network_frame();
	self clientfield::set_player_uimodel("doubleUpdate", self.double_challenge_goal + CHALLENGE_COMPLETE);
}

function mule_challenge_hud()
{
	self endon( "disconnect" );
	self endon( "bled_out ");

	while(! isdefined(self.mule_challenge_progress))
	{
		wait(0.05);
	}

	while(! self.muleUpgradeQuestDone)
	{
		status = CHALLENGE_INACTIVE;
		if( self.isUpgradingMule )
		{
			status = CHALLENGE_AWAITING;
			if( self.muleChallengeActive )
			{
				status = CHALLENGE_ACTIVE;
				self clientfield::set_player_uimodel("muleUpdate", self.mule_challenge_progress);
				util::wait_network_frame();
			}
		}

		self clientfield::set_player_uimodel("muleUpdate", self.mule_challenge_goal + status);
		util::wait_network_frame();
	}

	util::wait_network_frame();
	self clientfield::set_player_uimodel("muleUpdate", self.mule_challenge_goal + CHALLENGE_COMPLETE);
}

function poseidon_challenge_hud()
{
	self endon( "disconnect" );
	self endon( "bled_out ");

	while(! isdefined(self.poseidon_challenge_progress))
	{
		wait(0.05);
	}

	while(! self.poseidonUpgradeQuestDone)
	{
		status = CHALLENGE_INACTIVE;
		if( self.isUpgradingPoseidon )
		{
			status = CHALLENGE_AWAITING;
			if( self.poseidonChallengeActive )
			{
				status = CHALLENGE_ACTIVE;
				self clientfield::set_player_uimodel("poseidonUpdate", self.poseidon_challenge_progress);
				util::wait_network_frame();
			}
		}

		self clientfield::set_player_uimodel("poseidonUpdate", self.poseidon_challenge_goal + status);
		util::wait_network_frame();
	}

	util::wait_network_frame();
	self clientfield::set_player_uimodel("poseidonUpdate", self.poseidon_challenge_goal + CHALLENGE_COMPLETE);
}

function quick_challenge_hud()
{
	self endon( "disconnect" );
	self endon( "bled_out ");

	while(! isdefined(self.quick_challenge_progress))
	{
		wait(0.05);
	}

	while(! self.quickUpgradeQuestDone)
	{
		status = CHALLENGE_INACTIVE;
		if( self.isUpgradingQuick )
		{
			status = CHALLENGE_AWAITING;
			if( self.quickChallengeActive )
			{
				status = CHALLENGE_ACTIVE;
				self clientfield::set_player_uimodel("quickUpdate", self.quick_challenge_progress);
				util::wait_network_frame();
			}
		}

		self clientfield::set_player_uimodel("quickUpdate", self.quick_challenge_goal + status);
		util::wait_network_frame();
	}

	util::wait_network_frame();
	self clientfield::set_player_uimodel("quickUpdate", self.quick_challenge_goal + CHALLENGE_COMPLETE);
}

function PHD_challenge_hud()
{
	self endon( "disconnect" );
	self endon( "bled_out ");

	while(! isdefined(self.PHD_challenge_progress))
	{
		wait(0.05);
	}

	while(! self.PHDUpgradeQuestDone)
	{
		status = CHALLENGE_INACTIVE;
		if( self.isUpgradingPHD )
		{
			status = CHALLENGE_AWAITING;
			if( self.PHDChallengeActive )
			{
				status = CHALLENGE_ACTIVE;
				self clientfield::set_player_uimodel("PHDUpdate", self.PHD_challenge_progress);
				util::wait_network_frame();
			}
		}

		self clientfield::set_player_uimodel("PHDUpdate", self.PHD_challenge_goal + status);
		util::wait_network_frame();
	}

	util::wait_network_frame();
	self clientfield::set_player_uimodel("PHDUpdate", self.PHD_challenge_goal + CHALLENGE_COMPLETE);
}

function deadshot_challenge_hud()
{
	self endon( "disconnect" );
	self endon( "bled_out ");

	while(! isdefined(self.deadshot_challenge_progress))
	{
		wait(0.05);
	}

	while(! self.deadshotUpgradeQuestDone)
	{
		status = CHALLENGE_INACTIVE;
		if( self.isUpgradingDeadshot )
		{
			status = CHALLENGE_AWAITING;
			if( self.deadshotChallengeActive )
			{
				status = CHALLENGE_ACTIVE;
				self clientfield::set_player_uimodel("deadshotUpdate", self.deadshot_challenge_progress);
				util::wait_network_frame();
			}
		}

		self clientfield::set_player_uimodel("deadshotUpdate", self.deadshot_challenge_goal + status);
		util::wait_network_frame();
	}

	util::wait_network_frame();
	self clientfield::set_player_uimodel("deadshotUpdate", self.deadshot_challenge_goal + CHALLENGE_COMPLETE);
}

function quick_reward_text()
{
	self endon( "disconnect" );
	self endon( "bled_out ");

	prev_size = -1;
	while(true)
	{
		if(prev_size != level.players.size)
		{
			prev_size = level.players.size;
		
			if(level.players.size == 1)
			{
				self clientfield::set_player_uimodel("quickReward", 1);
			}
			else
			{
				self clientfield::set_player_uimodel("quickReward", 0);
			}
		}
		util::wait_network_frame();
	}
}

function notifyText(notif, flash, notif_sound, gum, override=false)
{
	self endon("disconnect");

	if(override)
	{
		self notify(#"message_override");
	}
	self notifyTextBody(notif, flash, notif_sound, gum, override);
}

function notifyTextBody(notif, flash, notif_sound, gum, override=false)
{
	self endon("disconnect");
	self endon(#"message_override");

	while(self.abbey_notif_active)
	{
		wait(0.05);
	}

	if(isdefined(notif_sound))
	{	
		self PlaySoundToPlayer(notif_sound, self);
	}

	self.abbey_notif_active = true;

	notif_cf = notif;
	self LUINotifyEvent(&"notification_show", 1, notif);

	if(isdefined(flash))
	{
		self LUINotifyEvent(&"notification_flash", 1, flash);
	}

	if(isdefined(gum))
	{
		self LUINotifyEvent(&"notification_gargoyle", 1, gum);
	}

	self thread destroy_on_override();
	
	wait(5);
	
	self LUINotifyEvent(&"notification_hide", 0);
	self notify(#"message_finished");
	self.abbey_notif_active = false;
}

function destroy_on_override()
{
	self endon("disconnect");
	self endon(#"message_finished");

	self waittill(#"message_override");
	self LUINotifyEvent(&"notification_hide", 0);
	self.abbey_notif_active = false;
}

function notifyGenerator(generator_shadowed=false)
{
	self endon("disconnect");
	self endon(#"generator_override");

	if(generator_shadowed)
	{
		self PlaySoundToPlayer(NOTIF_ALERT_SP, self);
	}
	self LUINotifyEvent(&"generator_visible", 1, 1);

	self thread generator_destroy_on_override();
	
	wait(5);
	
	self LUINotifyEvent(&"generator_visible", 1, 0);
	self notify(#"generator_finished");
}

function generator_destroy_on_override()
{
	self endon("disconnect");
	self endon(#"generator_finished");

	self waittill(#"generator_override");
	self LUINotifyEvent(&"generator_visible", 1, 0);
}