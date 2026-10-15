#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

#using scripts\shared\ai\systems\behavior_tree_utility;

#using scripts\Sphynx\_zm_sphynx_util;

#using scripts\zm\_zm_magicbox;
#using scripts\zm\zm_room_manager;

#insert scripts\shared\shared.gsh;

#define PRISON_GRAVITY_INTENSITY 175 // lower is stronger (higher jump)
#define PRISON_GRAVITY_TIME 90
#define PRISON_GRAVITY_COOLDOWN 30

#define PRISON_EARTHQUAKE_SCALE 0.75
#define PRISON_EARTHQUAKE_TIME 1.5
#define PRISON_EARTHQUAKE_RADIUS 1000

#precache( "triggerstring", "ZM_ABBEY_GRAVITY_USE" );
#precache( "triggerstring", "ZM_ABBEY_GRAVITY_ACTIVE" );
#precache( "triggerstring", "ZM_ABBEY_GRAVITY_COOLDOWN" );

REGISTER_SYSTEM( "zm_prison_gravity", &__init__, undefined )

function __init__()
{
	level flag::init("prison_lowg");
	level flag::init("prison_lowg_cooldown");

	level callback::on_spawned(&on_player_spawned);

	lowg_button = level struct::get("lowg_button", "targetname");
	lowg_button thread lowg_button_think();
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldMoveLowG", &should_move_lowg);
}

function should_move_lowg(entity)
{
	prison_room = level.abbey_rooms["Antimatter Dungeon"];
	if(GetDvarString("ui_mapname") == "zm_building")
	{
		prison_room = level.abbey_rooms["Water Tower"];
	}
	return (level flag::get("prison_lowg") && entity zm_room_manager::is_player_in_room(prison_room));
}

function lowg_button_prompt_and_visibility(player)
{
	if(level flag::get("prison_lowg"))
	{
		self SetHintString(&"ZM_ABBEY_GRAVITY_ACTIVE");
		return false;
	}
	else if(level flag::get("prison_lowg_cooldown"))
	{
		self SetHintString(&"ZM_ABBEY_GRAVITY_COOLDOWN");
		return false;
	}

	self SetHintString(&"ZM_ABBEY_GRAVITY_USE");
	return (player zm_magicbox::can_buy_weapon());
}

function lowg_button_think()
{
	level.prison_lowg_cooldown = false;
	self zm_sphynx_util::create_unitrigger_for_player_specific("Press &&1 to activate antigravity", undefined, &lowg_button_prompt_and_visibility);
	
	while(true)
	{
		self waittill("trigger_activated", player);
		level flag::set("prison_lowg");
		level exploder::exploder("prison_orb");
		Earthquake(PRISON_EARTHQUAKE_SCALE, PRISON_EARTHQUAKE_TIME, self.origin, PRISON_EARTHQUAKE_RADIUS);
		wait(PRISON_GRAVITY_TIME);
		Earthquake(PRISON_EARTHQUAKE_SCALE, PRISON_EARTHQUAKE_TIME, self.origin, PRISON_EARTHQUAKE_RADIUS);
		level exploder::stop_exploder("prison_orb");
		level flag::clear("prison_lowg");
		level flag::set("prison_lowg_cooldown");
		wait(PRISON_GRAVITY_COOLDOWN);
		level flag::clear("prison_lowg_cooldown");
	}
}

function on_player_spawned()
{
	SetDvar("bg_lowGravity", PRISON_GRAVITY_INTENSITY);
	self thread set_lowg();
	//self thread deathpit_check();
}

function choose_deathpit_lander(deathpits)
{
	self endon("disconnect");

	foreach(deathpit in deathpits)
	{
		if(self IsTouching(deathpit))
		{
			return level struct::get(deathpit.target, "targetname");
		}
	}

	return undefined;
}

function deathpit_check()
{
	self endon("disconnect");
	self endon("bled_out");

	deathpits = GetEntArray("prison_deathpit", "targetname");

	while(true)
	{
		deathpit_lander = self choose_deathpit_lander(deathpits);
		if(isdefined(deathpit_lander))
		{
			self SetVelocity(VectorScale((deathpit_lander.origin - self.origin), 5));
			while(isdefined(self choose_deathpit_lander(deathpits)))
			{
				wait(0.05);
			}
		}
		wait(0.05);
	}
}

function set_lowg() 
{
	self endon("disconnect");
	self endon("bled_out");

	prison_room = level.abbey_rooms["Antimatter Dungeon"];
	if(GetDvarString("ui_mapname") == "zm_building")
	{
		prison_room = level.abbey_rooms["Water Tower"];
	}

	while(true)
	{
		if(self zm_room_manager::is_player_in_room(prison_room) && level flag::get("prison_lowg") && ! self HasPerk("specialty_lowgravity"))
		{
			self SetPerk("specialty_lowgravity");
		}
		else if((! (self zm_room_manager::is_player_in_room(prison_room) && level flag::get("prison_lowg"))) && self HasPerk("specialty_lowgravity"))
		{
			self UnSetPerk("specialty_lowgravity");
		}
		wait(0.05);
	}
}