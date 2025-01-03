#using scripts\zm\_zm_audio;
#using scripts\zm\zm_room_manager;

#define PLAYTYPE_REJECT 1
#define PLAYTYPE_QUEUE 2
#define PLAYTYPE_ROUND 3
#define PLAYTYPE_SPECIAL 4
#define PLAYTYPE_GAMEEND 5

function main()
{
	zm_audio::musicState_Create("cue_redroom", PLAYTYPE_SPECIAL, "cue_redroom");
	zm_audio::musicState_Create("cue_choir", PLAYTYPE_SPECIAL, "cue_choir");
	zm_audio::musicState_Create("shadow_breach", PLAYTYPE_SPECIAL, "shadow_breach");
	zm_audio::musicState_Create("ascendance", PLAYTYPE_SPECIAL, "ascendance");
	zm_audio::musicState_Create("blood_gene1_mx", PLAYTYPE_SPECIAL, "blood_gene1_mx");
	zm_audio::musicState_Create("blood_gene2_mx", PLAYTYPE_SPECIAL, "blood_gene2_mx");
	zm_audio::musicState_Create("blood_gene3_mx", PLAYTYPE_SPECIAL, "blood_gene3_mx");
	zm_audio::musicState_Create("blood_gene4_mx", PLAYTYPE_SPECIAL, "blood_gene4_mx");
	zm_audio::musicState_Create("antiverse_amb_0", PLAYTYPE_SPECIAL, "antiverse_amb_0");
	zm_audio::musicState_Create("antiverse_amb_1", PLAYTYPE_SPECIAL, "antiverse_amb_1");
	zm_audio::musicState_Create("antiverse_amb_2", PLAYTYPE_SPECIAL, "antiverse_amb_2");
	zm_audio::musicState_Create("antiverse_amb_3", PLAYTYPE_SPECIAL, "antiverse_amb_3");
	zm_audio::musicState_Create("antiverse_amb_4", PLAYTYPE_SPECIAL, "antiverse_amb_4");
	zm_audio::musicState_Create("antiverse_amb_5", PLAYTYPE_SPECIAL, "antiverse_amb_5");

	thread redroom_ambience_think();
	thread choir_ambience_think();
	//thread testeroo();
}

function redroom_ambience_think()
{
	while(! (isdefined(level.abbey_rooms) && isdefined(level.abbey_rooms["Water Tower"])))
	{
		wait(0.05);
	}

	while(! zm_room_manager::is_room_active(level.abbey_rooms["Water Tower"]))
	{
		wait(0.05);
	}
	level thread zm_audio::sndMusicSystem_PlayState("cue_redroom");
}

function choir_ambience_think()
{
	while(! (isdefined(level.abbey_rooms) && isdefined(level.abbey_rooms["Staminarch"])))
	{
		wait(0.05);
	}

	while(! zm_room_manager::is_room_active(level.abbey_rooms["Staminarch"]))
	{
		//IPrintLn("triggered lol");
		wait(0.05);
	}
	level thread zm_audio::sndMusicSystem_PlayState("cue_choir");
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

