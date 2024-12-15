// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#using scripts\zm\zm_perk_upgrades;

#namespace zm_bgb_challenge_rejected;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_challenge_rejected
	Checksum: 0xFE62B444
	Offset: 0x1F0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_challenge_rejected", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_challenge_rejected
	Checksum: 0x5EB6920C
	Offset: 0x230
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_challenge_rejected", "activated", 1, undefined, undefined, &validation, &activation);
}



function get_upgradeable_perks()
{
	upgradeable_perks = [];
	if(! isdefined(self.perks_active))
	{
		return upgradeable_perks;
	}

	foreach(perk in self.perks_active)
	{
		if(! self zm_perk_upgrades::IsPerkUpgradeActive(perk))
		{
			array::add(upgradeable_perks, perk);
		}
	}

	return upgradeable_perks;
}

/*
	Name: validation
	Namespace: zm_bgb_challenge_rejected
	Checksum: 0x528443D1
	Offset: 0x658
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function validation()
{
	upgradeable_perks = self get_upgradeable_perks();
	return upgradeable_perks.size > 0;
}

/*
	Name: activation
	Namespace: zm_bgb_challenge_rejected
	Checksum: 0xE94CB83F
	Offset: 0x688
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	upgradeable_perks = self get_upgradeable_perks();
	self zm_perk_upgrades::givePerkUpgrade(array::random(upgradeable_perks));
}

