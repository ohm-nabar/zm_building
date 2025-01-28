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
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_utility;
//#using scripts\zm\zm_giant; temp

#precache( "model", "collision_wall_128x128x10" );
#precache( "model", "zm_abbey_teleporter_lights_off" );
#precache( "model", "zm_abbey_teleporter_lights_on" );

#precache( "string", "ZM_ABBEY_TELEPORTER_OFFLINE" );
#precache( "string", "TELEPORTER_SYNCHRONIZE" );
#precache( "string", "TELEPORTER_SYNCHRONIZING" );
#precache( "string", "TELEPORTER_ACTIVATE" );

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

	visionset_mgr::register_info( "overlay", "zm_factory_teleport", VERSION_SHIP, 61, 1, true );
}


function __main__()
{
	// Get the Pad triggers
	for ( i=0; i<8; i++ )
	{
		trig = GetEnt( "trigger_teleport_pad_" + i, "targetname");
		if ( IsDefined(trig) )
		{
			level.teleporter_pad_trig[i] = trig;
		}
	}

	for(i = 0; i < 8; i++)
	{
		level thread teleport_pad_think( i );
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
		while(! (isdefined(level.teleport[self.script_int]) && level.teleport[self.script_int] == "timer_on"))
		{
			wait(0.05);
		}
		self SetModel("zm_abbey_teleporter_lights_on");
		level exploder::stop_exploder(exploder_red_name);
		level exploder::exploder(exploder_name);
		while(level.teleport[self.script_int] == "timer_on")
		{
			wait(0.05);
		}
	}
}


//-------------------------------------------------------------------------------
// handles activating and deactivating pads for cool down
//-------------------------------------------------------------------------------
function pad_manager()
{

	for ( i = 0; i < level.teleporter_pad_trig.size; i++ )
	{
		if ( level.teleporter_pad_trig[i].teleport_active )
		{
			level.teleporter_pad_trig[i] sethintstring( &"ZM_ABBEY_TELEPORTER_ACTIVATE" );
		}
		else
		{
			level.teleporter_pad_trig[i] sethintstring( &"ZM_ABBEY_TELEPORTER_SYNCHRONIZE" );
		}
		level.teleporter_pad_trig[i] teleport_trigger_invisible( false );
	}
}

//-------------------------------------------------------------------------------
// handles turning on the pad and waiting for link
//-------------------------------------------------------------------------------
function teleport_pad_think( index )
{
	/*
	tele_help = getent( "tele_help_" + index, "targetname" );
	if(isdefined( tele_help ) )
	{
		tele_help thread play_tele_help_vox();
	}
	*/

	if(index > 3)
	{
		active = true;
	
		// init the pad
		level.teleport[index] = "active";

		trigger = level.teleporter_pad_trig[ index ];

		trigger setcursorhint( "HINT_NOICON" );
		trigger sethintstring( &"ZM_ABBEY_TELEPORTER_ACTIVATE" );
		trigger.teleport_active = true;
		trigger thread teleport_pad_active_think( index );
	}
	else
	{
		active = false;
	
		// init the pad
		level.teleport[index] = "waiting";

		trigger = level.teleporter_pad_trig[ index ];

		trigger setcursorhint( "HINT_NOICON" );
		trigger sethintstring( &"ZM_ABBEY_TELEPORTER_OFFLINE" );

		level flag::wait_till( "power_on" );

		trigger sethintstring( &"ZM_ABBEY_TELEPORTER_SYNCHRONIZE", level.current_links );
		trigger.teleport_active = false;
	}
	

	if ( isdefined( trigger ) )
	{
		while ( !active )
		{
			trigger waittill( "trigger" );

			/*
			if ( level.active_links < 3 )
			{
				trigger_core = getent( "trigger_teleport_core", "targetname" );
				trigger_core teleport_trigger_invisible( false );
			}

			
			// when one starts the others disabled
			for ( i=0; i<level.teleporter_pad_trig.size; i++ )
			{
				level.teleporter_pad_trig[ i ] teleport_trigger_invisible( true );
			}
			*/

			//trigger teleport_trigger_invisible(true);
			level.current_links += 1;
			level.teleport[index] = "timer_on";

			for(i = 0; i < 4; i++)
			{
				if(level.teleport[i] == "waiting")
				{
					level.teleporter_pad_trig[i] SetHintString(&"ZM_ABBEY_TELEPORTER_SYNCHRONIZE", level.current_links);
				}
				else
				{
					level.teleporter_pad_trig[i] SetHintString(&"ZM_ABBEY_TELEPORTER_SYNCHRONIZING", level.current_links);
				}
				
			}
			
			// start the countdown back to the core
			trigger thread teleport_pad_countdown( index, level.link_time );
			teleporter_vo( "countdown", trigger );

			//IPrintLn("Link started! Current links: " + level.current_links);


			current_links_old = level.current_links;
			// wait for the countdown
			
			while (level.current_links > 0 && level.current_links < 4)
			{
				wait( 0.05 );
			}

			//IPrintLn("Linking ended! Current links: " + level.current_links);

			// core was activated in time
			if ( level.current_links == 4 )
			{
				trigger stop_countdown();
				active = true;
				level.teleport[index] = "active";

				level util::clientNotify( "pw" + index );	// pad wire #
											
				//AUDIO
				level util::clientNotify( "tp" + index );	// Teleporter #

				// MM - Auto teleport the first time
				teleporter_wire_wait( index );

				trigger teleport_trigger_invisible( true );
				trigger thread player_teleporting( index );
			}
			else
			{
				//IPrintLn("Restarting link process");
				level.teleport[index] = "waiting";
			}
			wait( .05 );
		}

		trigger thread teleport_pad_active_think( index );
	}
}

//-------------------------------------------------------------------------------
// updates the teleport pad timer
//-------------------------------------------------------------------------------
function teleport_pad_countdown( index, time )
{
	self endon( "stop_countdown" );

//	iprintlnbold( &"WAW_ZOMBIE_START_TPAD" );

	if ( level.active_timer < 0 )
	{
		level.active_timer = index;
	}

	level.countdown++;

	if(level.current_links == 1)
	{
		//IPrintLn("starting music");
		self thread sndCountdown();
	}
	level util::clientNotify( "TRf" );	// Teleporter receiver map light flash

	// start timer for all players
	//	Add a second for VO sync
	players = GetPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread start_timer( time+1, "stop_countdown" );
	}
	wait( time+1 );

	if ( level.active_timer == index )
	{
		level.active_timer = -1;
	}

	// ran out of time to activate teleporter
	level.teleport[index] = "timer_off";
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
		for(i = 0; i < 4; i++)
		{
			level.teleporter_pad_trig[i] SetHintString( &"ZM_ABBEY_TELEPORTER_SYNCHRONIZE", level.current_links);
		}
		level util::clientNotify( "TRs" );	// Stop flashing the receiver map light
	}
//	iprintlnbold( "out of time" );

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
	self endon( "stop_countdown" );
	

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
	level notify ("stop_countdown");
	
	//level thread zm_giant::sndPA_DoVox( "vox_maxis_teleporter_expired_0" ); temp
}
function clock_timer()
{
	//self playloopsound ("evt_clock_tick_1sec");
	timer_max = 600;
	timer = timer_max;
	while(level.current_links > 0 && level.current_links < 4)
	{
		if( timer >= timer_max || ! isdefined( level.musicSystem.currentState ) || level.musicSystem.currentState == "none" )
		{
			timer = 0;
			if( isdefined( level.musicSystem.currentState ) && level.musicSystem.currentState == "timer" )
			{
				level thread zm_audio::sndMusicSystem_StopAndFlush();
				music::setmusicstate("none");
			}
			level util::delay( 0, undefined, &zm_audio::sndMusicSystem_PlayState, "timer" );
		}

		if(timer % 20 == 0)
		{
			playsoundatposition( "evt_clock_tick_1sec", (0,0,0) );
		}
		
		timer += 1;
		wait(0.05);
	}

	if( isdefined( level.musicSystem.currentState ) && level.musicSystem.currentState == "timer" )
	{
		level thread zm_audio::sndMusicSystem_StopAndFlush();
		music::setmusicstate("none");
	}
	
	//self stoploopsound(0);
	self delete();
	
}
//-------------------------------------------------------------------------------
// handles teleporting players when triggered
//-------------------------------------------------------------------------------
function teleport_pad_active_think( index )
{
	// link established, can be used to teleport
	self setcursorhint( "HINT_NOICON" );
	self.teleport_active = true;

	user = undefined;

	//IPrintLn("Teleporter " + index + " is active!");

	while ( 1 )
	{
		self waittill( "trigger", user );

		if ( zm_utility::is_player_valid( user ) )
		{
			self teleport_trigger_invisible( true );

			// Non-threaded so the trigger doesn't activate before the cooldown
			self player_teleporting( index );
		}
	}
}

//-------------------------------------------------------------------------------
// handles moving the players and fx, etc...moved out so it can be threaded
//-------------------------------------------------------------------------------
function player_teleporting( index )
{
	time_since_last_teleport = GetTime() - level.teleport_time;

	// begin the teleport
	// add 3rd person fx
	exploder::exploder_duration( "teleporter_" + level.teleport_pad_names[index % 3] + "_teleporting", 5.3 );

	// play startup fx at the core
	exploder::exploder_duration( "mainframe_warm_up", 4.8 );

	//AUDIO
	level util::clientNotify( "tpw" + (index % 3));
	//level thread zm_giant::sndPA_DoVox( "vox_maxis_teleporter_success_0" ); temp

	// start fps fx
	self thread teleport_pad_player_fx( level.teleport_delay );

	self PlaySound("teleport_warmup");
	
	//AUDIO
	self thread teleport_2d_audio();

	// Activate the TP zombie kill effect
	//self thread teleport_nuke( 20, 300);	// Max 20 zombies and range 300

	// wait a bit
	wait( level.teleport_delay );

	// end fps fx
	self notify( "fx_done" );

	dest_index = index + 4;
	if(index > 3)
	{
		dest_index = index - 4;
	}
	// teleport the players
	self teleport_players(dest_index);

	thread pad_manager();
	level.teleport_time = GetTime();
}

//-------------------------------------------------------------------------------
// used to enable / disable the pad use trigger for players
//-------------------------------------------------------------------------------
function teleport_trigger_invisible( enable )
{
	players = GetPlayers();

	for ( i = 0; i < players.size; i++ )
	{
		if ( isdefined( players[i] ) )
		{
			self SetInvisibleToPlayer( players[i], enable );
		}
	}
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

		if ( isdefined( players[i] ) )
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
					if(players[i].isInBloodMode)
					{
						visionset_mgr::deactivate( "overlay", "zm_bgb_in_plain_sight", players[i] );
						visionset_mgr::deactivate( "visionset", "zm_bgb_in_plain_sight", players[i] );
					}
					visionset_mgr::activate( "overlay", "zm_factory_teleport", players[i] ); // turn on the mid-teleport stargate effects
					players[i] disableOffhandWeapons();
					players[i] disableweapons();
					self PlaySoundToPlayer("teleport_2d_fnt", players[i]);
					self PlaySoundToPlayer("teleport_2d_rear", players[i]);
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

	// Nuke anything at the core
	core = level.teleporter_pad_trig[dest_index];
	//core thread teleport_nuke( undefined, 300);	// Max any zombies at the pad range 300

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

		visionset_mgr::deactivate( "overlay", "zm_factory_teleport", player ); // turn off the mid-teleport stargate effects
		if(players[i].isInBloodMode)
		{
			visionset_mgr::activate("visionset", "zm_bgb_in_plain_sight", player, 0.5, 9999, 0.5);
			visionset_mgr::activate("overlay", "zm_bgb_in_plain_sight", player);
		}
		
		player thread reactivate_shadow_vision();
		player enableweapons();
		player enableoffhandweapons();
		player setorigin( core_pos[slot].origin );
		player setplayerangles( core_pos[slot].angles );
		player FreezeControls( false );
		player thread teleport_aftereffects();
	}

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

//-------------------------------------------------------------------------------
// updates the hint string when countdown is started and expired
//-------------------------------------------------------------------------------
function teleport_core_hint_update()
{
	self setcursorhint( "HINT_NOICON" );

	while ( 1 )
	{
		// can't use teleporters until power is on
		if ( !level flag::get( "power_on" ) )
		{
			self sethintstring( &"ZOMBIE_NEED_POWER" );
		}
		else if ( teleport_pads_are_active() )
		{
			self sethintstring( &"ZOMBIE_LINK_TPAD" );
		}
		else if ( level.active_links == 0 )
		{
			self sethintstring( &"ZOMBIE_INACTIVE_TPAD" );
		}
		else
		{
			self sethintstring( "" );
		}

		wait( .05 );
	}
}

//-------------------------------------------------------------------------------
// establishes the link between teleporter pads and the core
//-------------------------------------------------------------------------------
function teleport_core_think()
{
	trigger = getent( "trigger_teleport_core", "targetname" );
	if ( isdefined( trigger ) )
	{
		trigger thread teleport_core_hint_update();

		// disable teleporters to power is turned on
		level flag::wait_till( "power_on" );

		while ( 1 )
		{
			if ( teleport_pads_are_active() )
			{
				trigger waittill( "trigger" );
				
				// link the activated pads
				for ( i = 0; i < level.teleport.size; i++ )
				{
					if ( isdefined( level.teleport[i] ) )
					{
						if ( level.teleport[i] == "timer_on" )
						{
							level.teleport[i] = "active";
							level.active_links++;
							level flag::set( "teleporter_pad_link_"+level.active_links );

							//AUDIO
							//level thread zm_giant::sndPA_DoVox( "vox_maxis_teleporter_" + i + "active_0" );
							level util::delay( 10, undefined, &zm_audio::sndMusicSystem_PlayState, "teleporter_"+level.active_links );

							exploder::exploder( "teleporter_" + level.teleport_pad_names[i % 3] + "_linked" );
							exploder::exploder( "lgt_teleporter_" + level.teleport_pad_names[i % 3] + "_linked" );
							exploder::exploder_duration( "mainframe_steam", 14.6 );

							// check for all teleporters active
							if ( level.current_links == 4 )
							{
								exploder::exploder_duration( "mainframe_link_all", 4.6 );
								exploder::exploder( "mainframe_ambient" );
								level util::clientNotify( "pap1" );	// Pack-A-Punch door on
								teleporter_vo( "linkall", trigger );
								Earthquake( 0.3, 2.0, trigger.origin, 3700 );
							}

							// stop the countdown for the teleport pad
							pad = "trigger_teleport_pad_" + i;
							trigger_pad = getent( pad, "targetname" );
							trigger_pad stop_countdown();
							level util::clientNotify( "TRs" );	// Stop flashing the receiver map light
							level.active_timer = -1;
						}
					}
				}
			}

			wait( .05 );
		}
	}
}

function stop_countdown()
{
	self notify( "stop_countdown" );
	level notify ("stop_countdown");  //using this on the new loop timer
	players = GetPlayers();
	
	for( i = 0; i < players.size; i++ )
	{
		players[i] notify( "stop_countdown" );
	}
}

//-------------------------------------------------------------------------------
// checks if any of the teleporter pads are counting down
//-------------------------------------------------------------------------------
function teleport_pads_are_active()
{
	// have any pads started?
	if ( isdefined( level.teleport ) )
	{
		for ( i = 0; i < level.teleport.size; i++ )
		{
			if ( isdefined( level.teleport[i] ) )
			{
				if ( level.teleport[i] == "timer_on" )
				{
					return true;
				}
			}
		}
	}

	return false;
}

function teleport_2d_audio()
{
	self endon( "fx_done" );

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


// kill anything near the pad
function teleport_nuke( max_zombies, range )
{
	zombies = getaispeciesarray( level.zombie_team );

	zombies = util::get_array_of_closest( self.origin, zombies, undefined, max_zombies, range );

	for (i = 0; i < zombies.size; i++)
	{
		wait (randomfloatrange(0.2, 0.3));
		if( !IsDefined( zombies[i] ) )
		{
			continue;
		}

		if( zm_utility::is_magic_bullet_shield_enabled( zombies[i] ) )
		{
			continue;
		}

		if( !( zombies[i].isdog ) )
		{
			zombies[i] zombie_utility::zombie_head_gib();
		}

		zombies[i] dodamage( 10000, zombies[i].origin );
		playsoundatposition( "nuked", zombies[i].origin );
	}
}

function teleporter_vo( tele_vo_type, location )
{
	if( !isdefined( location ))
	{
		self thread teleporter_vo_play( tele_vo_type, 2 );
	}
	else
	{
		players = GetPlayers();
		for (i = 0; i < players.size; i++)
		{
			if (distance (players[i].origin, location.origin) < 64)
			{
				switch ( tele_vo_type )
				{
					case "linkall":
						players[i] thread teleporter_vo_play( "tele_linkall" );
						break;
					case "countdown":
						players[i] thread teleporter_vo_play( "tele_count", 3 );
						break;
				}
			}
		}
	}
}

function teleporter_vo_play( vox_type, pre_wait )
{
	if(!isdefined( pre_wait ))
	{
		pre_wait = 0;
	}
	wait(pre_wait);
//	self _zm_audio::create_and_play_dialog( "level", vox_type );
}

function play_tele_help_vox()
{
	level endon( "tele_help_end" );
	
	while(1)
	{
		self waittill("trigger", who);
		
		if( level flag::get( "power_on" ) )
		{
			who thread teleporter_vo_play( "tele_help" );	
			level notify( "tele_help_end" );
		}
		
		while(IsDefined (who) && (who) IsTouching (self))
		{
			wait(0.1);
		}
	}
}

function play_packa_see_vox()
{
	wait(10);
	
	if( !level flag::get( "teleporter_pad_link_3" ) )
	{
		self waittill("trigger", who);	
		who thread teleporter_vo_play( "perk_packa_see" );
	}
}


//	
//	This should match the perk_wire_fx_client function
//	waits for the effect to travel along the wire
function teleporter_wire_wait( index )
{
	targ = struct::get( "pad_"+index+"_wire" ,"targetname");
	if ( !IsDefined( targ ) )
	{
		return;
	}

	while(isDefined(targ))
	{
		if(isDefined(targ.target))
		{
			target = struct::get(targ.target,"targetname");
			wait( 0.1 );

			targ = target;
		}
		else
		{
			break;
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

function dog_blocker_clip()
{
	//DCS: create collision blocker for dog near revive.
	collision = Spawn("script_model", (-106, -2294, 216));
	collision setmodel("collision_wall_128x128x10");
	collision.angles = (0, 37.2, 0);
	collision Hide();	
	
	// adding clip for barricade glitch
	collision = Spawn("script_model", (-1208, -439, 363));
	collision setmodel("collision_wall_128x128x10");
	collision.angles = (0, 0, 0);
	collision Hide();		
}	