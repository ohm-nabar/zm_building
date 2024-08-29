#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_zm_utility;
#using scripts\shared\callbacks_shared;
#using scripts\zm\_zm;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\scene_shared;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_perks;

#using scripts\zm\zm_room_manager;
#using scripts\zm\zm_ai_shadowpeople;

#insert scripts\shared\shared.gsh;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_perk_poseidonspunch.gsh;
#insert scripts\zm\_zm_perk_doubletaporiginal.gsh;
#insert scripts\zm\_zm_perk_phdlite.gsh;

#precache( "fx", "custom/shadow_explode_mpd" );

function main() 
{
	level.hitmarkersound = "mpl_hit_alert";
	level.hitmarkershader = "damage_feedback";
	level.main_quest_objective = "Activate all 4 Blood Generators";

	level.artifact_shield = GetEnt("artifact_shield", "targetname");
	level.artifact_shield SetInvisibleToAll();

	radio_tower_activate = GetEnt("radio_tower_activate", "targetname");
	radio_tower_activate SetCursorHint("HINT_NOICON");

	antidote_chamber_activate = GetEnt("antidote_chamber_activate", "targetname");
	antidote_chamber_activate SetCursorHint("HINT_NOICON");

	antidote_chamber_trigs = GetEntArray("antidote_chamber_trig", "targetname");

	foreach(trig in antidote_chamber_trigs)
	{
		trig SetCursorHint("HINT_NOICON");
	}

	//zm::register_zombie_damage_override_callback( &zombie_damage_override );
	while (! level flag::get("power_on"))
	{
		wait(0.05);
	}
	level.main_quest_objective = "Activate the radio tower";
	step_0();

	//thread testeroo();
    //callback::on_connect( &on_player_connect );
}

function on_player_connect() {}

function zombie_damage_override(willBeKilled, inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType)
{
	if ( isPlayer( attacker ) && willBeKilled && weapon != level.bloodgun)
	{
		level notify ("player_killed_zombie", self.origin);
	}
}

function step_0()
{
	IPrintLnBold("Step 0");
	radio_tower_activate = GetEnt("radio_tower_activate", "targetname");
	radio_tower_activate thread radio_tower_manage_hintstring();

	radio_tower_activate waittill("trigger", player);
	while (level.round_number == level.next_dog_round || level flag::get("dog_round"))
	{
		radio_tower_activate waittill("trigger", player);
	}

	level notify("radio_tower_begin");
	radio_tower_activate SetHintString("");

	level.in_unpausable_ee_sequence = true;
	level flag::clear( "spawn_zombies" );
	prev_zombie_total = level.zombie_total;
	level.zombie_total = 100;
	level.zombie_respawns = 100;

	zombies = GetAiTeamArray( level.zombie_team );
	for(i = 0; i < zombies.size; i++)
	{
		zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
	}

	level.no_powerups = true;
	level.cloak_health = 7030; // change
	level.choker_health = 10;

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i].inhibit_scoring_from_zombies = true;
	}

	counter = 120;
	level.radio_tower_safe = true;

	thread infinite_choker_spawn_radio();
	thread cloak_spawn_sequence_radio(radio_tower_activate);

	while(counter > 0 && level.radio_tower_safe)
	{
		counter -= 0.05;
		wait(0.05);
	}

	level notify("radio_tower_ended");

	zombies = GetAiTeamArray( level.zombie_team );
	for(i = 0; i < zombies.size; i++)
	{
		zombies[i] dodamage( zombies[i].health + 666, zombies[i].origin );
	}

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i].inhibit_scoring_from_zombies = false;
	}

	level.in_unpausable_ee_sequence = false;
	level.zombie_total = prev_zombie_total;
	level.zombie_respawns = prev_zombie_total;
	level flag::set("spawn_zombies");

	if(counter <= 0)
	{
		thread step_1();
	}
	else
	{
		radio_tower_activate SetHintString("Come back next round!");
		level waittill("start_of_round");
		thread step_0();
	}

}


function step_1()
{
	level.main_quest_objective = "Open the secret door";
	IPrintLnBold("Step 1");

	cover = GetEnt("main_quest_secret_door_cover", "targetname");
	cover Delete();

	door = GetEnt("main_quest_secret_door", "targetname");
	damage_trigger = GetEnt("main_quest_secret_door_trig", "targetname");

	while(true)
	{
		damage_trigger waittill( "damage", amount, attacker, direction_vec, point, type, tagName, ModelName, Partname, weapon );
		if(weapon == GetWeapon("frag_grenade"))
		{
			break;
		}
	}
	
	door Delete();

	thread step_2();
}

function step_2()
{
	IPrintLnBold("Step 2");

	level.main_quest_objective = "Kill an Escargot by the secret room";
	secret_room_volume = GetEnt("clean", "targetname");

	while(true)
	{
		level waittill("escargot_killed", origin);
		ent = Spawn("script_model", origin);
		ent SetModel("tag_origin");
		if(ent IsTouching(secret_room_volume))
		{
			ent Delete();
			break;
		}
	}
	
	thread step_3();
}

function step_3()
{
	IPrintLnBold("Step 3");
	level.main_quest_objective = "Fill the antidote chambers";

	level.antidote_blood_filled = 0;

	blocker_clips = GetEntArray("antidote_blocker_clip", "targetname");
	antidote_chamber_room = "Water Tower";
	antidote_chamber_zoneset = level.abbey_rooms[antidote_chamber_room];
	antidote_chamber_activate = GetEnt("antidote_chamber_activate", "targetname");
	antidote_chamber_activate thread antidote_manage_hintstring();

	while(true)
	{
		antidote_chamber_activate waittill("trigger", player);

		if (level.round_number == level.next_dog_round || level flag::get("dog_round"))
		{
			continue;
		}

		players = GetPlayers();
		foreach(p in players)
		{
			if(! p zm_room_manager::is_player_in_room(antidote_chamber_zoneset) )
			{
				continue;
			}
		}

		break;
	}

	antidote_chamber_activate SetHintString("");

	foreach(clip in blocker_clips)
	{
		clip_dest = GetEnt(clip.target, "targetname");
		clip MoveTo(clip_dest.origin, 0.05);
	}

	thread KeepSpawning();
	thread InfiniteBloodGun();

	antidote_chamber_trigs = GetEntArray("antidote_chamber_trig", "targetname");

	foreach(trig in antidote_chamber_trigs)
	{
		trig thread antidote_wait_for_blood();
	}

	while(level.antidote_blood_filled < antidote_chamber_trigs.size)
	{
		wait(0.05);
	}

	level notify("antidotes_completed");
	foreach(clip in blocker_clips)
	{
		clip Delete();
	}

	thread step_4();
}

function step_4()
{
	IPrintLnBold("Step 4");
	level.main_quest_objective = "In the secret room, summon the artifact with the Atlantean weapon";

	damage_trigger = GetEnt("main_quest_secret_room_trig", "targetname");

	while(true)
	{
		damage_trigger waittill( "damage", amount, attacker, direction_vec, point, type, tagName, ModelName, Partname, weapon );
		if(weapon == GetWeapon("zm_trident") || weapon == GetWeapon("zm_trident_upgraded"))
		{
			break;
		}
	}

	thread boss_fight();

}

function boss_fight()
{
	IPrintLnBold("We're not done yet");
	level.main_quest_objective = "Destroy the artifact";
	level.main_quest_objective = "Have fun!";
}

function radio_tower_manage_hintstring()
{
	level endon("radio_tower_begin");

	while(true)
	{
		if(level.round_number == level.next_dog_round || level flag::get("dog_round"))
		{
			self SetHintString("");
		}
		else
		{
			self SetHintString("Press ^3[{+activate}]^7 to activate the radio tower");
		}
		wait(0.05);
	}
}

function antidote_manage_hintstring()
{
	level endon("antidote_begin");

	while(true)
	{
		if(level.round_number == level.next_dog_round || level flag::get("dog_round"))
		{
			self SetHintString("");
		}
		else
		{
			self SetHintString("Press ^3[{+activate}]^7 to begin filling the antidote chambers [All players must be in the room]");
		}
		wait(0.05);
	}
}

function give_all_perks()
{
	self endon("disconnect");

	self zm_perks::give_perk(PERK_QUICK_REVIVE, false);
	self zm_perks::give_perk(PERK_STAMINUP, false);
	self zm_perks::give_perk(PERK_ADDITIONAL_PRIMARY_WEAPON, false);
	self zm_perks::give_perk(PERK_ELECTRIC_CHERRY, false);
	self zm_perks::give_perk(PERK_PHD_LITE, false);
	self zm_perks::give_perk(PERK_DOUBLE_TAP, false);
	self zm_perks::give_perk(PERK_POSEIDON_PUNCH, false);
}

function health_test_display()
{
	health = NewClientHudElem(self);
	health.alignX = "right";
	meesage.alignY = "top";
	health.horzAlign = "right";
	health.vertAlign = "top";
	health.fontscale = 2;
	health.alpha = 1;
	health.color = (1,1,1);
	health.hidewheninmenu = true;
	health SetText("Health: " + level.artifact_health);

	while(level.artifact_health > 0)
	{
		health SetText("Health: " + level.artifact_health);
		wait(0.05);
	}

	health Destroy();
}

function register_damage()
{
	level endon("boss_killed");

	while(true)
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, tagName, ModelName, Partname, weapon );
		if(! level.boss_immune)
		{
			damage = amount;

			level.artifact_health -= damage;
			attacker thread hitmarker();
		}
	}
}

function hitmarker()
{
	self thread playHitSound ( level.hitmarkersound);
	self.hud_damagefeedback setShader( level.hitmarkershader, 24, 48 );
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime(1);
	self.hud_damagefeedback.alpha = 0;
}

function playHitSound (alert)
{
	self endon ("disconnect");
	
	if (self.hitSoundTracker)
	{
		self.hitSoundTracker = false;
		
		self playlocalsound(alert);

		wait .05;	// waitframe
		self.hitSoundTracker = true;
	}
}	


function manage_shield()
{
	level endon("boss_killed");

	while(true)
	{
		if(level.num_cloaks_protecting > 0 || level.in_escargot_boss_phase)
		{
			shield_up();
		}
		else
		{
			shield_down();
		}

		wait(0.05);
	}
}

function shield_up()
{
	level.artifact_shield SetVisibleToAll();
	level.boss_immune = true;
}

function shield_down()
{
	level.artifact_shield SetInvisibleToAll();
	level.boss_immune = false;
}

function cloak_spawn_sequence_radio(trigger)
{
	level endon("radio_tower_ended");

	level.current_cloak_target_pos = trigger.origin;
	//IPrintLn(artifact_volume.origin);

	while(true)
	{
		cloak = zm_ai_shadowpeople::cloak_spawn_ee_radio(trigger);
		//cloak.v_zombie_custom_goal_pos = trigger.origin;

		cloak thread disable_radio_tower();

		players = GetPlayers();
		cloak_wait_time_low = 7 - ( 0.5 * (players.size - 1) );
		cloak_wait_time_high = 12 - ( 0.5 * (players.size - 1) );
		time_to_wait = randomintrange(cloak_wait_time_low * 2, cloak_wait_time_high * 2);
		wait(time_to_wait / 2);
	}
}

function disable_radio_tower()
{
	radio_tower_volume = GetEnt("radio_tower_volume", "targetname");
	while(! self IsTouching(radio_tower_volume) && IsAlive(self))
	{
		//IPrintLn("trying to reach volume");
		IPrintLn(level.current_cloak_target_pos);
		IPrintLn(self.v_zombie_custom_goal_pos);
		wait(0.05);
	}

	if(! IsAlive(self))
	{
		//IPrintLn("died");
		return;
	}

	self notify("goal_reached");
	self.ignoreall = false; 
	self.v_zombie_custom_goal_pos = undefined;
	self SetGoal(undefined);

	self AnimScripted("cloak_conjuring", self.origin, self.angles, "cloak_conjuring");

	counter = 5;
	while(IsAlive(self) && counter > 0)
	{
		counter -= 0.05;
		wait(0.05);
	}

	if(counter == 0)
	{
		level.radio_tower_safe = false;
	}
}

function infinite_choker_spawn_radio()
{
	level endon("radio_tower_ended");

	players = GetPlayers();
	choker_wait_time = 1.25 - ( 0.25 * (players.size - 1) );

	while(true)
	{
		thread zm_ai_shadowpeople::choker_spawn_ee_radio(randomintrange( 0, players.size ));
		wait(choker_wait_time);
	}
}

function antidote_wait_for_blood()
{
	self SetHintString("Press ^3[{+activate}]^7 to insert Blood Vial");
	while(true)
	{
		self waittill("trigger", player);
		if(level.hasVial)
		{
			break;
		}
	}

	self SetHintString("");
	level.hasVial = false;
	level.antidote_blood_filled += 1;
}



//courtesy of MakeCents
function KeepSpawning()
{
	level endon("antidotes_completed");

	while(1)
	{
		wait(0.05);
		if(level.zombie_total<25)
		{
			level.zombie_total=25;
			level.zombie_respawns=25;
		}		
	}
}

function InfiniteBloodGun()
{
	level endon("antidotes_completed");

	while(1)
	{
		wait(0.05);
		if(level.blood_uses>0)
		{
			level.blood_uses=0;
		}		
	}
}

function testeroo()
{
	level waittill("all_players_connected");

	wait(60);
	level notify("radio_built");
}