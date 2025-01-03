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
#using scripts\zm\_zm_bgb;

#using scripts\zm\zm_usermap;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_perks;

#using scripts\shared\system_shared;

#using scripts\zm\zm_abbey_inventory;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_perk_poseidonspunch.gsh;
#insert scripts\zm\_zm_perk_phdlite.gsh;

#precache( "material", "splash_blueprints_healing" );
#precache( "material", "splash_blueprints_diedrich" );
#precache( "material", "splash_blueprints_phd" );
#precache( "material", "splash_blueprints_poseidon" );
#precache( "material", "splash_blueprints_trident" );

#namespace zm_blueprints;

REGISTER_SYSTEM( "zm_blueprints", &__init__, undefined )

function __init__() 
{
	clientfield::register( "clientuimodel", "weaponBPUpdate", VERSION_SHIP, 3, "int" );
	clientfield::register( "clientuimodel", "perkBPUpdate", VERSION_SHIP, 3, "int" );
	
	callback::on_connect( &on_player_connect );
}

function on_player_connect()
{
	self.got_healing_blueprint = 0;
	self.got_trident_blueprint = 0;
	self.got_diedrich_blueprint = 0;

	self.got_phd_blueprint = 0;
	self.got_poseidon_blueprint = 0;
	self.got_deadshot_blueprint = 0;

	while(! (level flag::exists("initial_blackscreen_passed") && level flag::get("initial_blackscreen_passed")))
	{
		wait(0.05);
	}

	self thread check_healing();
	self thread check_trident();
	self thread check_diedrich();
	self thread check_phd();
	self thread check_poseidon();
	self thread check_deadshot();
}

function weapon_blueprints_code()
{
	self endon("disconnect");

	return (self.got_healing_blueprint * 4) + (self.got_trident_blueprint * 2) + self.got_diedrich_blueprint;
}

function perk_blueprints_code()
{
	self endon("disconnect");
	
	return (self.got_phd_blueprint * 4) + (self.got_poseidon_blueprint * 2) + self.got_deadshot_blueprint;
}

function check_healing()
{
	self endon("disconnect");

	while(! self HasWeapon(GetWeapon("zm_healing_grenade")))
	{
		wait(0.05);
	}

	self.got_healing_blueprint = 1;
	self clientfield::set_player_uimodel("weaponBPUpdate", self weapon_blueprints_code());
	self zm_abbey_inventory::notifyText("splash_blueprints_healing", level.open_inventory_prompt, level.abbey_alert_pos);
}

function check_trident()
{
	self endon("disconnect");
	while(! self HasWeapon(GetWeapon("zm_trident")))
	{
		wait(0.05);
	}

	self.got_trident_blueprint = 1;
	self clientfield::set_player_uimodel("weaponBPUpdate", self weapon_blueprints_code());
	self zm_abbey_inventory::notifyText("splash_blueprints_trident", level.open_inventory_prompt, level.abbey_alert_pos);
}

function check_diedrich()
{
	self endon("disconnect");
	while(! self HasWeapon(GetWeapon("zm_diedrich")) && ! self HasWeapon(GetWeapon("zm_diedrich_upgraded")))
	{
		wait(0.05);
	}

	self.got_diedrich_blueprint = 1;
	self clientfield::set_player_uimodel("weaponBPUpdate", self weapon_blueprints_code());
	self zm_abbey_inventory::notifyText("splash_blueprints_diedrich", level.open_inventory_prompt, level.abbey_alert_pos);
}

function check_phd()
{
	self endon("disconnect");
	while(! self HasPerk(PERK_PHD_LITE))
	{
		wait(0.05);
	}
	self.got_phd_blueprint = 1;
	self clientfield::set_player_uimodel("perkBPUpdate", self perk_blueprints_code());
	self zm_abbey_inventory::notifyText("splash_blueprints_phd", level.open_inventory_prompt, level.abbey_alert_pos);
}

function check_poseidon()
{
	self endon("disconnect");
	while(! self HasPerk(PERK_POSEIDON_PUNCH))
	{
		wait(0.05);
	}
	self.got_poseidon_blueprint = 1;
	self clientfield::set_player_uimodel("perkBPUpdate", self perk_blueprints_code());
	self zm_abbey_inventory::notifyText("splash_blueprints_poseidon", level.open_inventory_prompt, level.abbey_alert_pos);
}

function check_deadshot()
{
	self endon("disconnect");
	while(! self HasPerk(PERK_DEAD_SHOT))
	{
		wait(0.05);
	}
	self.got_deadshot_blueprint = 1;
	self clientfield::set_player_uimodel("perkBPUpdate", self perk_blueprints_code());
	self zm_abbey_inventory::notifyText("splash_blueprints_deadshot", level.open_inventory_prompt, level.abbey_alert_pos);
}