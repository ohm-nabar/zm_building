// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_utility;

#using scripts\zm\zm_juggernog_potions;

#namespace zm_bgb_aftertaste_blood;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_aftertaste_blood
	Checksum: 0xCF8D4385
	Offset: 0x1D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_aftertaste_blood", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_aftertaste_blood
	Checksum: 0xE0ECA87A
	Offset: 0x218
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_aftertaste_blood", "rounds", 3, &event, undefined, undefined, undefined);
}

/*
	Name: event
	Namespace: zm_bgb_aftertaste_blood
	Checksum: 0x7705807E
	Offset: 0x348
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function event()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("bgb_update");

	self thread watch_death_machine();
	while(true)
	{
		self waittill("player_downed");
		self bgb::do_one_shot_use(1);
		self zm_juggernog_potions::maintain_jug_resistance_level();
	}
}

function watch_death_machine()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("bgb_update");

	dm_kills = 0;
	prev_kills = self.pers["kills"];
	prev_health = self.health;
	while(true)
	{
		if(self.health < prev_health)
		{
			dm_kills = 0;
		}

		dm_kills += (self.pers["kills"] - prev_kills);

		if(dm_kills >= 15)
		{
			dm_kills = 0;
			while(! zm_utility::is_player_valid(self) || ! self zm_magicbox::can_buy_weapon())
			{
				wait(0.05);
			}
			level thread zm_powerup_weapon_minigun::grab_minigun(self);
			self util::waittill_any("minigun_time_over", "player_downed");
		}

		prev_kills = self.pers["kills"];
		prev_health = self.health;
		wait(0.05);
	}
}

