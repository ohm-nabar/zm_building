#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_utility;

#using scripts\Sphynx\_zm_sphynx_util;

#precache( "model", "collision_wall_128x128x10" );
#precache( "model", "zm_abbey_teleporter_lights_off" );
#precache( "model", "zm_abbey_teleporter_lights_on" );

#precache( "triggerstring", "ZM_ABBEY_TELEPORTER_OFFLINE" );
#precache( "triggerstring", "ZM_ABBEY_TELEPORTER_ACTIVATE" );
#precache( "triggerstring", "ZM_ABBEY_TELEPORTER_SYNCHRONIZE", "0" );
#precache( "triggerstring", "ZM_ABBEY_TELEPORTER_SYNCHRONIZE", "1" );
#precache( "triggerstring", "ZM_ABBEY_TELEPORTER_SYNCHRONIZE", "2" );
#precache( "triggerstring", "ZM_ABBEY_TELEPORTER_SYNCHRONIZE", "3" );
#precache( "triggerstring", "ZM_ABBEY_TELEPORTER_SYNCHRONIZING", "1" );
#precache( "triggerstring", "ZM_ABBEY_TELEPORTER_SYNCHRONIZING", "2" );
#precache( "triggerstring", "ZM_ABBEY_TELEPORTER_SYNCHRONIZING", "3" );

REGISTER_SYSTEM_EX( "zm_abbey_teleporter", &__init__, &__main__, undefined )

function __init__()
{	
	// DCS: added to fix non-attacking dogs.
	//level.dog_melee_range = 130;
	//level thread dog_blocker_clip();

	level.teleport = [];
	level.active_links = 0;
	level.current_links = 0;
	level.countdown = 0;

	level.teleport_delay = 2;
	level.active_timer = -1;
	level.teleport_time = 0;
	level.link_time = 45;

	// use this array to convert a teleport_pad index to a, b, or c
	level.teleport_pad_names = [];
	level.teleport_pad_names[0] = "a";
	level.teleport_pad_names[1] = "c";
	level.teleport_pad_names[2] = "b";

	level flag::init( "teleporter_pad_link_1" );
	level flag::init( "teleporter_pad_link_2" );
	level flag::init( "teleporter_pad_link_3" );
	level flag::init( "teleporter_pad_link_4" );

	visionset_mgr::register_info( "overlay", "zm_castle_teleport", VERSION_SHIP, 61, 1, true );
}


function __main__()
{
	// Get the Pad triggers
	for ( i=0; i<8; i++ )
	{
		trig = struct::get( "trigger_teleport_pad_" + i, "targetname");
		if ( IsDefined(trig) )
		{
			level.teleporter_pad_trig[i] = trig;
			level.teleporter_pad_trig[i].index = i;
			level.teleporter_pad_trig[i] thread teleport_pad_think();
		}
	}
	
	//mp_downhill_fx::SetDvar( "factoryAftereffectOverride", "-1" );
	//SetSavedDvar( "zombiemode_path_minz_bias", 13 );
	level.no_dog_clip = true;
	
	level.teleport_ae_funcs = [];
	
	if( !IsSplitscreen() )
	{
		level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_abbey_teleporter::teleport_aftereffect_fov;
	}
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_abbey_teleporter::teleport_aftereffect_shellshock;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_abbey_teleporter::teleport_aftereffect_shellshock_electric;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_abbey_teleporter::teleport_aftereffect_bw_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_abbey_teleporter::teleport_aftereffect_red_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_abbey_teleporter::teleport_aftereffect_flashy_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &zm_abbey_teleporter::teleport_aftereffect_flare_vision;

	portals = GetEntArray("shadow_portal", "targetname");
	lights = GetEntArray("shadow_portal_lights", "targetname");

	level array::thread_all(portals, &portal_think);
	level array::thread_all(lights, &lights_think);
}

function portal_think()
{
	self SetInvisibleToAll();
	while(level.current_links < 4)
	{
		wait(0.05);
	}
	self SetVisibleToAll();
}

function lights_think()
{
	level waittill("initial_blackscreen_passed");

	exploder_name = "shadow_portal_light" + self.script_int;
	exploder_red_name = "shadow_portal_light_red" + self.script_int;
	while(level.current_links < 4)
	{
		self SetModel("zm_abbey_teleporter_lights_off");
		level exploder::exploder(exploder_red_name);
		level exploder::stop_exploder(exploder_name);
		while( (! (isdefined(level.teleport[self.script_int]) && level.teleport[self.script_int] == "timer_on")) && level.current_links < 4 )
		{
			wait(0.05);
		}
		self SetModel("zm_abbey_teleporter_lights_on");
		level exploder::stop_exploder(exploder_red_name);
		level exploder::exploder(exploder_name);
		while(level.teleport[self.script_int] == "timer_on" && level.current_links < 4)
		{
			wait(0.05);
		}
	}
	self PlaySound("teleport_link_all");
}

function teleport_prompt_and_visibility(player)
{
	index = self.stub.related_parent.index;
	teleport_state = level.teleport[index];

	if(! player zm_magicbox::can_buy_weapon() || teleport_state == "teleporting")
	{
		self SetHintString(&"ZM_ABBEY_EMPTY");
		return false;
	}
	if(teleport_state == "active")
	{
		self SetHintString(&"ZM_ABBEY_TELEPORTER_ACTIVATE");
		return true;
	}
	if(! (level flag::exists("power_on") && level flag::get("power_on")))
	{
		self SetHintString(&"ZM_ABBEY_TELEPORTER_OFFLINE");
		return false;
	}
	if(teleport_state == "waiting")
	{
		self SetHintString(&"ZM_ABBEY_TELEPORTER_SYNCHRONIZE", level.current_links);
		return true;
	}

	self SetHintString(&"ZM_ABBEY_TELEPORTER_SYNCHRONIZING", level.current_links);
	return false;
}

//-------------------------------------------------------------------------------
// handles turning on the pad and waiting for link
//-------------------------------------------------------------------------------
function teleport_pad_think()
{
	self zm_sphynx_util::create_unitrigger_for_player_specific(&"ZM_ABBEY_TELEPORTER_OFFLINE", undefined, &teleport_prompt_and_visibility);

	if(self.index > 3)
	{
		active = true;
	
		// init the pad
		level.teleport[self.index] = "active";

		self.teleport_active = true;
	}
	else
	{
		active = false;
	
		// init the pad
		level.teleport[self.index] = "waiting";
		level flag::wait_till( "power_on" );
		self.teleport_active = false;
	}

	while ( !active )
	{
		self waittill( "trigger_activated" );

		level.current_links += 1;
		level.teleport[self.index] = "timer_on";
		if(level.current_links < 4)
		{
			PlaySoundAtPosition("teleport_link_sting", self.origin);
		}
		
		// start the countdown back to the core
		self thread teleport_pad_countdown();
		
		while (level.current_links > 0 && level.current_links < 4)
		{
			wait( 0.05 );
		}

		// core was activated in time
		if ( level.current_links == 4 )
		{
			self stop_countdown();
			active = true;
			level.teleport[self.index] = "active";
										
			//AUDIO
			level util::clientNotify( "tp" + self.index );	// Teleporter #
			self thread player_teleporting();
		}
		else
		{
			level.teleport[self.index] = "waiting";
		}
		wait( 0.05 );
	}

	self thread teleport_pad_active_think();
}

//-------------------------------------------------------------------------------
// updates the teleport pad timer
//-------------------------------------------------------------------------------
function teleport_pad_countdown()
{
	level endon( #"stop_countdown" );

	if ( level.active_timer < 0 )
	{
		level.active_timer = self.index;
	}

	level.countdown++;

	if(level.current_links == 1)
	{
		self thread sndCountdown();
	}
	level util::clientNotify( "TRf" );	// Teleporter receiver map light flash

	// start timer for all players
	//	Add a second for VO sync
	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread start_timer( level.link_time+1, #"stop_countdown" );
	}
	wait( level.link_time+1 );

	if ( level.active_timer == self.index )
	{
		level.active_timer = -1;
	}

	// ran out of time to activate teleporter
	level.teleport[self.index] = "timer_off";
	should_end_timer = true;
	for(i = 0; i < level.teleport.size; i++)
	{
		if(level.teleport[i] == "timer_on")
		{
			should_end_timer = false;
			break;
		}
	}
	if(should_end_timer)
	{
		level.current_links = 0;
		level util::clientNotify( "TRs" );	// Stop flashing the receiver map light
	}
	
	level.countdown--;
}

function start_timer( time, stop_notify )
{
	self notify ("stop_prev_timer");
	self endon ("stop_prev_timer");
	self endon ("disconnect");

	if( !isdefined( self.stopwatch_elem ) )
	{
		self.stopwatch_elem = newClientHudElem(self);
		self.stopwatch_elem.horzAlign = "left";
		self.stopwatch_elem.vertAlign = "top";
		self.stopwatch_elem.alignX = "left";
		self.stopwatch_elem.alignY = "top";
		self.stopwatch_elem.x = 10;
		self.stopwatch_elem.y = 30;
		self.stopwatch_elem.alpha = 0;
		self.stopwatch_elem.sort = 2;
		
		self.stopwatch_elem_glass = newClientHudElem(self);
		self.stopwatch_elem_glass.horzAlign = "left";
		self.stopwatch_elem_glass.vertAlign = "top";
		self.stopwatch_elem_glass.alignX = "left";
		self.stopwatch_elem_glass.alignY = "top";
		self.stopwatch_elem_glass.x = 10;
		self.stopwatch_elem_glass.y = 30;
		self.stopwatch_elem_glass.alpha = 0;
		self.stopwatch_elem_glass.sort = 3;
		self.stopwatch_elem_glass setShader( "zombie_stopwatch_glass", level.stopwatch_length_width, level.stopwatch_length_width );
	}

	if( isdefined( stop_notify ) )
	{
		self thread zm_timer::wait_for_stop_notify( stop_notify );
	}
	if( time > 60 )
	{
		time = 0;
	}
	self.stopwatch_elem setClock( time, 60, "zombie_stopwatch", level.stopwatch_length_width, level.stopwatch_length_width );
	self.stopwatch_elem.alpha = 1;
	self.stopwatch_elem_glass.alpha = 1;
	wait( time );
	self notify( "countdown_finished" );
	wait( 1 );
	self.stopwatch_elem.alpha = 0;
	self.stopwatch_elem_glass.alpha = 0;
	
}

function sndCountdown()
{
	level endon( #"stop_countdown" );
	

	clock_sound = spawn ("script_origin", (0,0,0));
	clock_sound thread clock_timer();
	
	//level thread zm_giant::sndPA_DoVox( "vox_maxis_teleporter_ultimatum_0" ); temp

	count = level.link_time;
	num = 11;
	while ( count > 0 )
	{
		play = (count == 20 || count == 15 || count <= 10);
		if ( play )
		{
			//level thread zm_giant::sndPA_DoVox( "vox_maxis_teleporter_count_" + num, undefined, true ); temp
			num--;
		}
		//playsoundatposition( "evt_clock_tick_1sec", (0,0,0) );	Changed this to looped sound to avoid stuttering audio
		wait( 1 );
		count--;
	}
	level notify (#"stop_countdown");
	
	//level thread zm_giant::sndPA_DoVox( "vox_maxis_teleporter_expired_0" ); temp
}
function clock_timer()
{
	timer = 0;
	level thread zm_audio::sndMusicSystem_PlayState("abbey_timer");
	while(level.current_links > 0 && level.current_links < 4)
	{
		if( ! isdefined( level.musicSystem.currentState ) || level.musicSystem.currentState == "none" || IsSubStr(level.musicSystem.currentState, "blood_gene") || IsSubStr(level.musicSystem.currentState, "cue_") )
		{
			level thread zm_audio::sndMusicSystem_StopAndFlush();
			level music::setmusicstate("none");
			level thread zm_audio::sndMusicSystem_PlayState("abbey_timer");
		}

		if(timer % 20 == 0)
		{
			playsoundatposition( "evt_clock_tick_1sec", (0,0,0) );
		}
		
		timer += 1;
		wait(0.05);
	}

	if( isdefined( level.musicSystem.currentState ) && level.musicSystem.currentState == "abbey_timer" )
	{
		level thread zm_audio::sndMusicSystem_StopAndFlush();
		level music::setmusicstate("none");
	}
	
	//self stoploopsound(0);
	self delete();
	
}
//-------------------------------------------------------------------------------
// handles teleporting players when triggered
//-------------------------------------------------------------------------------
function teleport_pad_active_think()
{
	self.teleport_active = true;

	user = undefined;

	while (true)
	{
		self waittill("trigger_activated");
		self player_teleporting();
	}
}

//-------------------------------------------------------------------------------
// handles moving the players and fx, etc...moved out so it can be threaded
//-------------------------------------------------------------------------------
function player_teleporting()
{
	level.teleport[self.index] = "teleporting";
	time_since_last_teleport = GetTime() - level.teleport_time;

	// begin the teleport
	// add 3rd person fx
	exploder::exploder_duration( "teleporter_" + level.teleport_pad_names[self.index % 3] + "_teleporting", 5.3 );

	// play startup fx at the core
	exploder::exploder_duration( "mainframe_warm_up", 4.8 );

	//AUDIO
	level util::clientNotify( "tpw" + (self.index % 3));
	//level thread zm_giant::sndPA_DoVox( "vox_maxis_teleporter_success_0" ); temp

	// start fps fx
	self thread teleport_pad_player_fx( level.teleport_delay );

	PlaySoundAtPosition("teleport_warmup", self.origin);
	
	//AUDIO
	self thread teleport_2d_audio();

	// Activate the TP zombie kill effect
	//self thread teleport_nuke( 20, 300);	// Max 20 zombies and range 300

	// wait a bit
	wait( level.teleport_delay );

	// end fps fx
	level notify( "teleport_fx_done" + self.index );

	dest_index = self.index + 4;
	if(self.index > 3)
	{
		dest_index = self.index - 4;
	}
	// teleport the players
	self teleport_players(dest_index);

	level.teleport_time = GetTime();
}

//-------------------------------------------------------------------------------
// checks if player is within radius of the teleport pad
//-------------------------------------------------------------------------------
function player_is_near_pad( player )
{
	radius = 88;
	scale_factor = 2;

	dist = Distance2D( player.origin, self.origin );
	dist_touching = radius * scale_factor;

	if ( dist < dist_touching )
	{
		return true;
	}

	return false;
}


//-------------------------------------------------------------------------------
// this is the 1st person effect seen when touching the teleport pad
//
// duration = time in seconds
//-------------------------------------------------------------------------------
#define ZM_TRAP_ELECTRIC_MAX 	1.25

function teleport_pad_player_fx( duration )
{
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( isdefined( players[i] ) )
		{
			if ( self player_is_near_pad( players[i] ) )
			{
				visionset_mgr::activate( "overlay", "zm_trap_electric", players[i], ZM_TRAP_ELECTRIC_MAX, ZM_TRAP_ELECTRIC_MAX );
			}
		}
	}
}

//-------------------------------------------------------------------------------
// send players back to the core
//-------------------------------------------------------------------------------
function teleport_players(dest_index)
{
	player_radius = 16;

	players = GetPlayers();

	core_pos = [];
	occupied = [];
	image_room = [];
	players_touching = [];		// the players that will actually be teleported

	player_idx = 0;

	prone_offset = (0, 0, 49);
	crouch_offset = (0, 0, 20);
	stand_offset = (0, 0, 0);

	// send players to a black room to flash images for a few seconds
	for ( i = 0; i < 4; i++ )
	{
		full_dest_index = dest_index + "" + i;
		core_pos[i] = struct::get( "teleport_dest_" + full_dest_index, "targetname" );
		occupied[i] = false;
		image_room[i] = struct::get( "teleport_room_" + i, "targetname" );

		if ( isdefined( players[i] ) && players[i] zm_magicbox::can_buy_weapon() )
		{
			// filter::SetTransported( players[i] );
			
			if ( self player_is_near_pad( players[i] ) )
			{
				players_touching[player_idx] = i;
				player_idx++;

				if ( isdefined( image_room[i] ) )
				{
					visionset_mgr::deactivate( "overlay", "zm_trap_electric", players[i] );
					if(level.shadow_vision_active)
					{
						visionset_mgr::deactivate("visionset", "abbey_shadow", players[i]);
					}
					visionset_mgr::activate( "overlay", "zm_castle_teleport", players[i] ); // turn on the mid-teleport stargate effects
					players[i] disableOffhandWeapons();
					players[i] disableweapons();
					players[i] PlaySoundToPlayer("teleport_2d", players[i]);
					if( players[i] getstance() == "prone" )
					{
						desired_origin = image_room[i].origin + prone_offset;
					}
					else if( players[i] getstance() == "crouch" )
					{
						desired_origin = image_room[i].origin + crouch_offset;
					}
					else
					{
						desired_origin = image_room[i].origin + stand_offset;
					}
					
					players[i].teleport_origin = Spawn( "script_origin", players[i].origin );
					players[i].teleport_origin.angles = players[i].angles;
					players[i] linkto( players[i].teleport_origin );
					players[i].teleport_origin.origin = desired_origin;
					players[i] FreezeControls( true );
					util::wait_network_frame();

					if( IsDefined( players[i] ) )
					{
						util::setClientSysState( "levelNotify", "black_box_start", players[i] );
						players[i].teleport_origin.angles = image_room[i].angles;
					}
				}
			}
		}
	}

	wait( 2 );

	// check if any players are standing on top of core teleport positions
	for ( i = 0; i < players.size; i++ )
	{
		if ( isdefined( players[i] ) )
		{
			for ( j = 0; j < 4; j++ )
			{
				if ( !occupied[j] )
				{
					dist = Distance2D( core_pos[j].origin, players[i].origin );
					if ( dist < player_radius )
					{
						occupied[j] = true;
					}
				}
			}
			util::setClientSysState( "levelNotify", "black_box_end", players[i] );
		}
	}

	util::wait_network_frame();

	// move players to the core
	for ( i = 0; i < players_touching.size; i++ )
	{
		player_idx = players_touching[i];
		player = players[player_idx];

		if ( !IsDefined( player ) )
		{
			continue;
		}

		// find a free space at the core
		slot = i;
		start = 0;
		while ( occupied[slot] && start < 4 )
		{
			start++;
			slot++;
			if ( slot >= 4 )
			{
				slot = 0;
			}
		}
		occupied[slot] = true;
		full_dest_index = dest_index + "" + slot;
		pos_name = "teleport_dest_" +  full_dest_index;
		teleport_core_pos = struct::get( pos_name, "targetname" );

		player unlink();

		if(isdefined(player.teleport_origin))
		{
			player.teleport_origin delete();
			player.teleport_origin = undefined;
		}

		visionset_mgr::deactivate( "overlay", "zm_castle_teleport", player ); // turn off the mid-teleport stargate effects
		
		player thread reactivate_shadow_vision();
		player enableweapons();
		player enableoffhandweapons();
		player setorigin( core_pos[slot].origin );
		player setplayerangles( core_pos[slot].angles );
		player FreezeControls( false );
		player thread teleport_aftereffects();
	}

	level.teleport[self.index] = "active";

	// play beam fx at the core
	exploder::exploder_duration( "mainframe_arrival", 1.7 );
	exploder::exploder_duration( "mainframe_steam", 14.6 );
}

function reactivate_shadow_vision()
{
	self endon("disconnect");

	if(! level flag::get("dog_round"))
	{
		return;
	}
	while(! level.shadow_vision_active && level flag::get("dog_round"))
	{
		wait(0.05);
	}
	if(level.shadow_vision_active)
	{
		visionset_mgr::activate("visionset", "abbey_shadow", self);
	}
}

function stop_countdown()
{
	level notify (#"stop_countdown");  //using this on the new loop timer
	players = GetPlayers();
	
	for( i = 0; i < players.size; i++ )
	{
		players[i] notify( #"stop_countdown" );
	}
}

function teleport_2d_audio()
{
	level endon( "teleport_fx_done" + self.index );

	while ( 1 )
	{
		players = GetPlayers();
		
		wait(1.7);
		
		for ( i = 0; i < players.size; i++ )
		{
			if ( isdefined( players[i] ) )
			{
				if ( self player_is_near_pad( players[i] ) )
				{
					util::setClientSysState("levelNotify", "t2d", players[i]);
				}
			}
		}
	}
}

// Teleporter Aftereffects
function teleport_aftereffects()
{
	if( GetDvarString( "factoryAftereffectOverride" ) == "-1" )
	{
		self thread [[ level.teleport_ae_funcs[RandomInt(level.teleport_ae_funcs.size)] ]]();
	}
	else
	{
		self thread [[ level.teleport_ae_funcs[int(GetDvarString( "factoryAftereffectOverride" ))] ]]();
	}
}

function teleport_aftereffect_shellshock()
{
	self shellshock( "explosion", 4 );
}

function teleport_aftereffect_shellshock_electric()
{
	self shellshock( "electrocution", 4 );
}

// tae indicates to Clientscripts that a teleporter aftereffect should start

function teleport_aftereffect_fov()
{
	util::setClientSysState( "levelNotify", "tae", self );
}

function teleport_aftereffect_bw_vision( localClientNum )
{
	util::setClientSysState( "levelNotify", "tae", self );
}

function teleport_aftereffect_red_vision( localClientNum )
{
	util::setClientSysState( "levelNotify", "tae", self );
}

function teleport_aftereffect_flashy_vision( localClientNum )
{
	util::setClientSysState( "levelNotify", "tae", self );
}

function teleport_aftereffect_flare_vision( localClientNum )
{
	util::setClientSysState( "levelNotify", "tae", self );
}

function packa_door_reminder()
{
	while( !level flag::get( "teleporter_pad_link_3" ) )
	{
		rand = randomintrange(4,16);
		self playsound( "evt_packa_door_hitch" );
		wait(rand);
	}
}