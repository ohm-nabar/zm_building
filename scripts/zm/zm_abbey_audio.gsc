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
	
	//thread testeroo();
}

function create_ambience_think(room_name, room_cue)
{
	while(! (isdefined(level.abbey_rooms) && zm_room_manager::is_any_player_in_room(level.abbey_rooms[room_name])))
	{
		wait(0.05);
	}

	level thread zm_audio::sndMusicSystem_PlayState(room_cue);
}

/*
function function_e12b1498()
{
	level endon("_zombie_game_over");
	self endon("disconnect");
	var_c041bd97 = [];
	switch(self.characterindex)
	{
		case 0:
		{
			str_player = "dempsey";
			var_c041bd97[1] = 2;
			var_c041bd97[2] = 2;
			var_c041bd97[3] = 1;
			break;
		}
		case 1:
		{
			str_player = "nikolai";
			var_c041bd97[1] = 2;
			var_c041bd97[2] = 3;
			var_c041bd97[3] = 1;
			break;
		}
		case 2:
		{
			str_player = "richtofen";
			var_c041bd97[1] = 2;
			var_c041bd97[2] = 1;
			var_c041bd97[3] = 1;
			break;
		}
		case 3:
		{
			str_player = "takeo";
			var_c041bd97[1] = 2;
			var_c041bd97[2] = 2;
			var_c041bd97[3] = 2;
			break;
		}
	}
	var_816a0127 = 1;
	while(var_816a0127 <= 3)
	{
		self waittill("player_downed");
		if(self hasPerk("specialty_quickrevive") && level.players.size > 1)
		{
			continue;
		}
		else
		{
			wait(0.1);
			self.isSpeaking = 1;
			level.sndVoxOverride = 1;
			self thread function_b3baa665();
			for(i = 0; i < var_c041bd97[var_816a0127]; i++)
			{
				str_vo = "vox_abcd_talk_" + str_player + "_" + var_816a0127 + "_" + i;
				self playsoundtoplayer(str_vo, self);
				var_5cd02106 = soundgetplaybacktime(str_vo);
				var_269117b2 = var_5cd02106 / 1000;
				wait(var_269117b2 + 0.5);
			}
			self function_8995134a();
			vo_clear_underwater (round 14 onwards)
			var_816a0127++;
		}
		while(isdefined(self.isSpeaking) && self.isSpeaking || (isdefined(level.sndVoxOverride) && level.sndVoxOverride))
		{
		}
	}
}
*/

function testeroo() 
{
	level waittill("initial_blackscreen_passed");

	prev_music_state = "";
	while(true)
	{
		if(isdefined(level.musicState) && level.musicState != prev_music_state)
		{
			IPrintLn(level.musicState);
			prev_music_state = level.musicState;
		}
		wait(0.05);
	}
}

