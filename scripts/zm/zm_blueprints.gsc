#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm_equipment;
#using scripts\zm\zm_abbey_inventory;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_perk_poseidonspunch.gsh;
#insert scripts\zm\_zm_perk_phdlite.gsh;
#insert scripts\zm\zm_abbey_inventory.gsh;

#precache( "material", "splash_blueprints_healing" );
#precache( "material", "splash_blueprints_diedrich" );
#precache( "material", "splash_blueprints_phd" );
#precache( "material", "splash_blueprints_poseidon" );
#precache( "material", "splash_blueprints_trident" );

#namespace zm_blueprints;

REGISTER_SYSTEM( "zm_blueprints", &__init__, undefined )

function __init__() 
{
	level clientfield::register( "clientuimodel", "weaponBPUpdate", VERSION_SHIP, 3, "int" );
	level clientfield::register( "clientuimodel", "perkBPUpdate", VERSION_SHIP, 3, "int" );
	
	level callback::on_connect( &on_player_connect );
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
	self zm_abbey_inventory::notifyText(NOTIF_BLUEPRINT_WEAP_HEALING, NOTIF_FLASH_RIGHT, NOTIF_ALERT_BLUEPRINT);
}

function check_trident()
{
	self endon("disconnect");
	while(! self HasWeapon(GetWeapon("zm_trident")))
	{
		wait(0.05);
	}

	self.got_trident_blueprint = 1;
	self thread zm_equipment::show_hint_text(&"ZM_ABBEY_TRIDENT_HINT", 5);
	self clientfield::set_player_uimodel("weaponBPUpdate", self weapon_blueprints_code());
	self zm_abbey_inventory::notifyText(NOTIF_BLUEPRINT_WEAP_TRIDENT, NOTIF_FLASH_RIGHT, NOTIF_ALERT_BLUEPRINT);
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
	self zm_abbey_inventory::notifyText(NOTIF_BLUEPRINT_WEAP_DIEDRICH, NOTIF_FLASH_RIGHT, NOTIF_ALERT_BLUEPRINT);
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
	self zm_abbey_inventory::notifyText(NOTIF_BLUEPRINT_PERK_PHD, NOTIF_FLASH_RIGHT, NOTIF_ALERT_BLUEPRINT);
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
	self zm_abbey_inventory::notifyText(NOTIF_BLUEPRINT_PERK_POSEIDON, NOTIF_FLASH_RIGHT, NOTIF_ALERT_BLUEPRINT);
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
	self zm_abbey_inventory::notifyText(NOTIF_BLUEPRINT_PERK_DEADSHOT, NOTIF_FLASH_RIGHT, NOTIF_ALERT_BLUEPRINT);
}