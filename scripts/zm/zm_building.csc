#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm_weapons;

//Perks
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
//#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
//#using scripts\zm\_zm_perk_sleight_of_hand;
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
#using scripts\zm\_zm_trap_fire;
#using scripts\zm\_hb21_zm_trap_centrifuge;
#using scripts\zm\_hb21_sym_zm_trap_fan;
#using scripts\zm\_hb21_sym_zm_trap_acid;

#using scripts\zm\zm_usermap;

// NOVA
#using scripts\zm\_zm_ai_quad;

#using scripts\zm\_zm_perk_doubletaporiginal;
#using scripts\zm\_zm_perk_poseidonspunch;

#using scripts\zm\_zm_perk_phdlite;

#using scripts\zm\zm_ai_shadowpeople;
 
#using scripts\zm\zm_perk_upgrades;

#using scripts\zm\zm_abbey_inventory;
#using scripts\zm\zm_challenges;
#using scripts\zm\zm_trident;
#using scripts\zm\custom_gg_machine;
#using scripts\zm\zm_blueprints;
#using scripts\zm\zm_hud_gasweapon_handler;
#using scripts\zm\zm_flashlight;
#using scripts\zm\zm_juggernog_potions;

// Sphynx's Console Commands
#using scripts\Sphynx\commands\_zm_commands;

// Abbey Teleporter
#using scripts\zm\zm_abbey_teleporter;

// Custom Gums
#using scripts\zm\bgbs\_zm_bgb_aftertaste_blood;
#using scripts\zm\bgbs\_zm_bgb_challenge_rejected;

#precache( "client_fx", "custom/magic_box_og/fx_weapon_box_open_glow_og" );
#precache( "client_fx", "custom/magic_box_og/fx_weapon_box_marker_fl_og" );

function main()
{
	LuiLoad( "ui.uieditor.menus.hud.t7hud_zm_custom" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_ammowidget.zmammo_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_ammowidget.zmammo_attachmentinfo_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_ammowidget.zmammo_prop_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_ammowidget.zmammo_clipinfo_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_ammowidget.zmammo_clip_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_ammowidget.zmammo_total_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_ammowidget.zmammo_equipcontainer_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_ammowidget.zmammo_equiptac_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_ammowidget.zmammo_dpadiconbgm_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_score.zmscr_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_score.zmscr_listinglg_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_score.zmscr_listingsm_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_score.zmscr_pluspointscontainer_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_score.zmscr_pluspoints_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_revive.zm_revive_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_notiffactory.zmnotif1factory_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_notiffactory.zmnotifbgb_containerfactory_abbey" );
	LuiLoad( "ui.uieditor.widgets.scoreboard.cp.scoreboardwidgetcp_abbey" );
	LuiLoad( "ui.uieditor.widgets.scoreboard.cp.scoreboardheaderwidgetcp_abbey" );
	LuiLoad( "ui.uieditor.widgets.scoreboard.scoreboardpingheader_abbey" );
	LuiLoad( "ui.uieditor.widgets.scoreboard.scoreboardrowwidget_abbey" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_ammowidget.zmammo_bbgummeterwidget_fix" );
	LuiLoad( "ui.uieditor.widgets.mphudwidgets.cursorhint_image_fix" );
	LuiLoad( "ui.uieditor.widgets.hud.zm_cursorhint.zmcursorhint_fix" );

	//LuiLoad( "ui.uieditor.widgets.hud.zm_perks.LogicalZMPerksContainerFactory" );
	//LuiLoad( "ui.uieditor.widgets.hud.zm_perks.LogicalZMPerkListItemFactory" );

	level._effect["chest_light"] = "custom/magic_box_og/fx_weapon_box_open_glow_og";
	level._effect["chest_light_closed"] = "custom/magic_box_og/fx_weapon_box_marker_fl_og"; 
	zm_usermap::main();

	include_weapons();
	
	util::waitforclient( 0 );
}

function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_levelcommon_weapons.csv", 1);
}