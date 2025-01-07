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

#precache("material", "inventory_parchment");
#precache("material", "scroll_active");
#precache("material", "scroll_inactive");

#namespace zm_abbey_inventory;

#define CHALLENGE_INACTIVE 1
#define CHALLENGE_AWAITING 2
#define CHALLENGE_ACTIVE 3
#define CHALLENGE_COMPLETE 4

#define TAB_CHALLENGE 0
#define TAB_TRIAL 1
#define TAB_PERKBP 2
#define TAB_WEAPONBP 3

#precache( "eventstring", "notification_image_show" );
#precache( "eventstring", "notification_text_show" );
#precache( "eventstring", "notification_hide" );

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
	
	level.challenge_fontscale = 1;
	level.notify_fontscale = 2.2;
	level.left_challenge_x = 115;
	level.right_challenge_x = 345;

	level.open_inventory_prompt = 0;
	level.hud_toggle_prompt = 1;
	level.pause_prompt = 2;

	level.abbey_alert_neutral = "notification_neut";
	level.abbey_alert_pos = "notification_pos";
	level.abbey_alert_neg = "notification_neg";
	level.abbey_alert_garg = "gobble_activate";

	level.abbey_alert_indices = [];
	level.abbey_alert_indices["splash_blood_obtained"] = 0;
	level.abbey_alert_indices["splash_blood_team"] = 1;
	level.abbey_alert_indices["splash_blood_user"] = 2;
	level.abbey_alert_indices["splash_blueprints_diedrich"] = 3;
	level.abbey_alert_indices["splash_blueprints_healing"] = 4;
	level.abbey_alert_indices["splash_blueprints_phd"] = 5;
	level.abbey_alert_indices["splash_blueprints_poseidon"] = 6;
	level.abbey_alert_indices["splash_blueprints_trident"] = 7;
	level.abbey_alert_indices["splash_blueprints_deadshot"] = 8;
	level.abbey_alert_indices["splash_perk_complete_cherry"] = 9;
	level.abbey_alert_indices["splash_perk_complete_double"] = 10;
	level.abbey_alert_indices["splash_perk_complete_mule"] = 11;
	level.abbey_alert_indices["splash_perk_complete_phd"] = 12;
	level.abbey_alert_indices["splash_perk_complete_poseidon"] = 13;
	level.abbey_alert_indices["splash_perk_complete_quick"] = 14;
	level.abbey_alert_indices["splash_perk_complete_stamin"] = 15;
	level.abbey_alert_indices["splash_perk_complete_deadshot"] = 16;
	level.abbey_alert_indices["splash_perk_new_cherry"] = 17;
	level.abbey_alert_indices["splash_perk_new_double"] = 18;
	level.abbey_alert_indices["splash_perk_new_mule"]= 19;
	level.abbey_alert_indices["splash_perk_new_phd"] = 20;
	level.abbey_alert_indices["splash_perk_new_poseidon"] = 21;
	level.abbey_alert_indices["splash_perk_new_quick"] = 22;
	level.abbey_alert_indices["splash_perk_new_stamin"] = 23;
	level.abbey_alert_indices["splash_perk_new_deadshot"] = 24;
	level.abbey_alert_indices["splash_shadow_attack_generator1"] = 25;
	level.abbey_alert_indices["splash_shadow_attack_generator2"] = 26;
	level.abbey_alert_indices["splash_shadow_attack_generator3"] = 27;
	level.abbey_alert_indices["splash_shadow_attack_generator4"] = 28;
	level.abbey_alert_indices["splash_shadow_complete_generator1"] = 29;
	level.abbey_alert_indices["splash_shadow_complete_generator2"] = 30;
	level.abbey_alert_indices["splash_shadow_complete_generator3"] = 31;
	level.abbey_alert_indices["splash_shadow_complete_generator4"] = 32;
	level.abbey_alert_indices["splash_trial_aramis"] = 33;
	level.abbey_alert_indices["splash_trial_porthos"] = 34;
	level.abbey_alert_indices["splash_trial_dart"] = 35;
	level.abbey_alert_indices["splash_trial_athos"] = 36;
	level.abbey_alert_indices["splash_trial_mystery_box"] = 37;
	level.abbey_alert_indices["splash_trial_wallbuy"] = 38;
	level.abbey_alert_indices["splash_trial_weapon_class"] = 39;
	level.abbey_alert_indices["splash_trial_headshot"] = 40;
	level.abbey_alert_indices["splash_hud_toggle"] = 41;
	level.abbey_alert_indices["splash_pause"] = 42;
	level.abbey_alert_indices["splash_blood_activated"] = 43;
	level.abbey_alert_indices["splash_shadow_over"] = 44;

	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
}

function on_player_connect()
{
	self LUINotifyEvent(&"notification_hide", 0);
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

	/*
	scroll_icon = NewClientHudElem(self);
	scroll_icon.alignX = "right";
	scroll_icon.alignY = "bottom";
	scroll_icon.horzAlign = "fullscreen";
	scroll_icon.vertAlign = "fullscreen";
	scroll_icon.x = 630;
	scroll_icon.y = 430;
	scroll_icon.foreground = true;
	scroll_icon.hidewheninmenu = true;
	scroll_icon SetShader("scroll_inactive", 20, 30);

	while(true)
	{
		if( self.abbey_inventory_active )
		{
			scroll_icon SetShader("scroll_active", 20, 30);

			while( self.abbey_inventory_active )
			{
				wait(0.05);
			}
		}
		scroll_icon SetShader("scroll_inactive", 20, 30);
		wait(0.05);
	}
	*/
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
				while(self AdsButtonPressed())
				{
					wait(0.05);
				}
			}
			wait(0.05);
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

function notifyText(text, additionalPrompt, notificationSound, override=false)
{
	self endon("disconnect");

	if(override)
	{
		self notify(#"message_override");
	}
	notifyTextBody(text, additionalPrompt, notificationSound, override);
}

function notifyTextBody(text, additionalPrompt, notificationSound, override=false)
{
	self endon("disconnect");
	self endon(#"message_override");

	while(self.perkUpgradeTextActive)
	{
		wait(0.05);
	}

	if(text == "")
	{
		self additionalPrompt(additionalPrompt);
		return;
	}

	if(isdefined(notificationSound))
	{	
		self PlaySoundToPlayer(notificationSound, self);
	}

	self.perkUpgradeTextActive = true;
	self LUINotifyEvent(&"notification_image_show", 1, level.abbey_alert_indices[text]);
	/*
	message = NewHudElem();
	message.alignX = "center";
	meesage.alignY = "top";
	message.horzAlign = "center";
	message.vertAlign = "top";
	message.y = -100;
	message.alpha = 1;
	message.foreground = true;
	message.hidewheninmenu = true;
	message setShader(text, 300, 300);
	*/
	if(isdefined(additionalPrompt))
	{
		self thread additionalPrompt(additionalPrompt);
	}
	self thread destroy_on_override();
	
	wait(5);
	//message Destroy();
	self LUINotifyEvent(&"notification_hide", 0);
	self notify(#"message_finished");
	self.perkUpgradeTextActive = false;
}

function additionalPrompt(text)
{
	self endon("disconnect");

	/*
	message = NewClientHudElem(self);
	message.alignX = "center";
	meesage.alignY = "top";
	message.horzAlign = "fullscreen";
	message.vertAlign = "fullscreen";
	message.x = 320;
	message.y = 25;
	message.fontscale = level.notify_fontscale;
	message.alpha = 1;
	message.color = (1,1,1);
	message.foreground = true;
	message.hidewheninmenu = true;
	message setText(text);
	*/
	self LUINotifyEvent(&"notification_text_show", 1, text);
}

function destroy_on_override()
{
	self endon("disconnect");
	self endon(#"message_finished");

	self waittill(#"message_override");
	self LUINotifyEvent(&"notification_hide", 0);
	self.perkUpgradeTextActive = false;
	//message Destroy();
}

function testeroo() 
{
	while(true)
	{
		if(self.abbey_inventory_active)
		{
			IPrintLn("inventory active");
		}
		wait(0.05);
	}
}