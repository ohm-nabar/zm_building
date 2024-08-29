
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
#using scripts\zm\_zm_perks;

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

#using scripts\shared\hud_util_shared;

#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_zm_spawner;
#using scripts\shared\ai\zombie_shared;

#using scripts\zm\_zm_ai_dogs;

#using scripts\shared\system_shared;


#insert scripts\shared\ai\zombie.gsh;
#insert scripts\shared\ai\systems\gib.gsh;

#insert scripts\zm\_zm.gsh;
#insert scripts\zm\_zm_perks.gsh;

#define NO_DIALOGUE	0
#define DIALOGUE 1
#define DIALOGUE_STORY 2
#define DIALOGUE_STORY_MAIN_QUEST 3
#define READING_SPEED 0.3 // the average person takes 3 seconds to read 10 words, a pace of 200 WPM

function main() 
{
	callback::on_connect(&on_player_connect);
}

function on_player_connect()
{
	//self thread testeroo();
	self.dialogue_level = NO_DIALOGUE;

	self.subtitle_hud = NewClientHudElem(self);
	self.subtitle_hud.alignX = "left";
	self.subtitle_hud.alignY = "bottom";
	self.subtitle_hud.horzAlign = "fullscreen";
	self.subtitle_hud.vertAlign = "fullscreen";
	self.subtitle_hud.x = 600;
	self.subtitle_hud.y = 400;
	self.subtitle_hud.fontscale = 1.1;
	self.subtitle_hud.alpha = 0;
	self.subtitle_hud.foreground = true;
	self.subtitle_hud.hidewheninmenu = true;
	self.subtitle_hud.color = (1,1,1); 
}

/*
function player_talk(text, priority_level)
{
	if(priority_level <= self.dialogue_level)
	{
		return;
	}

	self.dialogue_level = priority_level;

	words = SplitArgs(text);

	waitTime = words.size * READING_SPEED;

	self.subtitle_hud SetText(text);
	self.subtitle_hud.alpha = 1;
	wait(2);
	self.subtitle_hud.alpha = 0;
}
*/

function testeroo()
{

}
