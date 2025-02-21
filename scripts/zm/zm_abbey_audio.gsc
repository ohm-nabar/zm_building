#using scripts\shared\music_shared;

#using scripts\zm\_zm_audio;
#using scripts\zm\zm_room_manager;

#define PLAYTYPE_REJECT 1
#define PLAYTYPE_QUEUE 2
#define PLAYTYPE_ROUND 3
#define PLAYTYPE_SPECIAL 4
#define PLAYTYPE_GAMEEND 5

function main()
{
	if(GetDvarString("ui_mapname") == "zm_building")
	{
		level zm_audio::musicState_Create("cue_redroom", PLAYTYPE_SPECIAL, "cue_redroom");
		level zm_audio::musicState_Create("cue_choir", PLAYTYPE_SPECIAL, "cue_choir");

		//level thread create_ambience_think("Water Tower", "cue_redroom");
		//level thread create_ambience_think("Staminarch", "cue_choir");
		level thread create_ambience_think("Clean Room", "cue_choir");
	}
	else
	{
		level zm_audio::musicState_Create("cue_redroom", PLAYTYPE_SPECIAL, "cue_redroom");
		level zm_audio::musicState_Create("cue_choir", PLAYTYPE_SPECIAL, "cue_choir");
		level zm_audio::musicState_Create("cue_airfield", PLAYTYPE_SPECIAL, "cue_airfield");
		level zm_audio::musicState_Create("cue_beach", PLAYTYPE_SPECIAL, "cue_beach");
		level zm_audio::musicState_Create("cue_courtroom", PLAYTYPE_SPECIAL, "cue_courtroom");
		level zm_audio::musicState_Create("cue_knighthall", PLAYTYPE_SPECIAL, "cue_knighthall");
		level zm_audio::musicState_Create("cue_lab", PLAYTYPE_SPECIAL, "cue_lab");
		level zm_audio::musicState_Create("cue_merveille", PLAYTYPE_SPECIAL, "cue_merveille");
		//zm_audio::musicState_Create("cue_prison", PLAYTYPE_SPECIAL, "cue_prison");

		level thread create_ambience_think("Red Room", "cue_redroom");
		level thread create_ambience_think("Choir", "cue_choir");
		level thread create_ambience_think("Airfield", "cue_airfield");
		level thread create_ambience_think("No Man's Land", "cue_beach");
		level thread create_ambience_think("Courtroom", "cue_courtroom");
		level thread create_ambience_think("Knight's Hall", "cue_knighthall");
		level thread create_ambience_think("Merveille de Verite", "cue_merveille");
		level thread create_ambience_think("URM Laboratory", "cue_lab");
		//thread create_ambience_think("Antimatter Dungeon", "cue_prison");
	}
	
	level zm_audio::musicState_Create("shadow_breach", PLAYTYPE_SPECIAL, "shadow_breach");
	level zm_audio::musicState_Create("ascendance", PLAYTYPE_SPECIAL, "ascendance");
	level zm_audio::musicState_Create("blood_gene1_mx", PLAYTYPE_SPECIAL, "blood_gene1_mx");
	level zm_audio::musicState_Create("blood_gene2_mx", PLAYTYPE_SPECIAL, "blood_gene2_mx");
	level zm_audio::musicState_Create("blood_gene3_mx", PLAYTYPE_SPECIAL, "blood_gene3_mx");
	level zm_audio::musicState_Create("blood_gene4_mx", PLAYTYPE_SPECIAL, "blood_gene4_mx");
	level zm_audio::musicState_Create("antiverse_amb_0", PLAYTYPE_SPECIAL, "antiverse_amb_0");
	level zm_audio::musicState_Create("antiverse_amb_1", PLAYTYPE_SPECIAL, "antiverse_amb_1");
	level zm_audio::musicState_Create("antiverse_amb_2", PLAYTYPE_SPECIAL, "antiverse_amb_2");
	level zm_audio::musicState_Create("antiverse_amb_3", PLAYTYPE_SPECIAL, "antiverse_amb_3");
	level zm_audio::musicState_Create("antiverse_amb_4", PLAYTYPE_SPECIAL, "antiverse_amb_4");
	level zm_audio::musicState_Create("antiverse_amb_5", PLAYTYPE_SPECIAL, "antiverse_amb_5");
	level zm_audio::musicState_Create("abbey_timer", PLAYTYPE_SPECIAL, "abbey_timer");
	
	//level thread testeroo();
}

function create_ambience_think(room_name, room_cue)
{
	while(! (isdefined(level.abbey_rooms) && zm_room_manager::is_any_player_in_room(level.abbey_rooms[room_name])))
	{
		wait(0.05);
	}

	if(isdefined(level.musicSystem.currentState) && IsSubStr(level.musicSystem.currentState, "blood_gene"))
	{
		level zm_audio::sndMusicSystem_StopAndFlush();
		level music::setmusicstate("none");
	}

	level thread zm_audio::sndMusicSystem_PlayState(room_cue);
}

function testeroo() 
{
	level waittill("initial_blackscreen_passed");

	while(true)
	{
		if(isdefined(level.musicState))
		{
			IPrintLn(level.musicState);
		}
		wait(1.5);
	}
}

