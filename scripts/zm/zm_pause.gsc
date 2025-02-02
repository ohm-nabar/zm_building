#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\ai\zombie_utility;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;
#insert scripts\zm\zm_abbey_inventory.gsh;

#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_abbey_inventory;
#using scripts\zm\zm_ai_shadowpeople;

#namespace zm_pause;

REGISTER_SYSTEM( "zm_pause", &__init__, undefined )

function __init__()
{
	clientfield::register( "clientuimodel", "abbeyPause", VERSION_SHIP, 1, "int" );
	clientfield::register( "clientuimodel", "abbeyPauseAvailable", VERSION_SHIP, 1, "int" );
	
	level._zombies_round_spawn_failsafe = &round_spawn_failsafe;
	level.coop_pause_threshold = 0;
	level.num_want_pause_change = 0;
	level.in_unpausable_ee_sequence = false;
	level.is_coop_paused = false;
	level.wants_pause = false;
	callback::on_connect( &on_player_connect );
	
	thread should_pause();
}

function round_spawn_failsafe()
{
	self endon("death");//guy just died

	if( IS_TRUE(level.debug_keyline_zombies) )
	{
		self thread zombie_utility::round_spawn_failsafe_debug_draw();
	}
	
	//////////////////////////////////////////////////////////////
	//FAILSAFE "hack shit"  DT#33203
	//////////////////////////////////////////////////////////////
	prevorigin = self.origin;
	while(1)
	{
		if( !level.zombie_vars["zombie_use_failsafe"] )
		{
			return;
		}

		if ( IS_TRUE( self.ignore_round_spawn_failsafe ) )
		{
			return;
		}
		
		if(!IsDefined(level.failsafe_waittime))
		{
			level.failsafe_waittime = 30;	
		}
		
		counter = 0;
		while(counter < level.failsafe_waittime && ! level.is_coop_paused)
		{
			counter += 0.05;
			wait(0.05);
		}

		if( self.missingLegs )
		{
			counter = 0;
			while(counter < 10 && ! level.is_coop_paused)
			{
				counter += 0.05;
				wait(0.05);
			}
		}

		//inert zombies can ignore this
		if ( IS_TRUE( self.is_inert ) )
		{
			wait(0.05);
			continue;
		}

		if(level.is_coop_paused)
		{
			wait(0.05);
			continue;
		}

		//if i've torn a board down in the last 5 seconds, just 
		//wait 30 again.
		if ( IsDefined(self.lastchunk_destroy_time) )
		{
			if ( (GetTime() - self.lastchunk_destroy_time) < 8000 )
				continue; 
		}

		//fell out of world
		if ( self.origin[2] < level.zombie_vars["below_world_check"] )
		{
			if(IS_TRUE(level.put_timed_out_zombies_back_in_queue ) && !level flag::get("special_round") && !IS_TRUE( self.isscreecher ) )
			{
				level.zombie_total++;
				level.zombie_total_subtract++;				
			}			
			
			self dodamage( self.health + 100, (0,0,0) );				
			break;
		}

		//hasnt moved 24 inches in 30 seconds?	
		if ( DistanceSquared( self.origin, prevorigin ) < 576 ) 
		{
			if( IsDefined( level.move_failsafe_override ) )
			{
				self thread [[level.move_failsafe_override]]( prevorigin );
			}
			else
			{
				//add this zombie back into the spawner queue to be re-spawned
				if(IS_TRUE(level.put_timed_out_zombies_back_in_queue ) && !level flag::get("special_round"))
				{
					//only if they have crawled thru a window and then timed out
					if ( !self.ignoreall && !IS_TRUE(self.nuked) && !IS_TRUE(self.marked_for_death) && !IS_TRUE( self.isscreecher ) && !self.missingLegs )
					{
						level.zombie_total++;
						level.zombie_total_subtract++;					
					}
				}
			
				//add this to the stats even tho he really didn't 'die' 
				level.zombies_timeout_playspace++;
			
				// DEBUG HACK
				self dodamage( self.health + 100, (0,0,0) );
			}
			break;
		}

		prevorigin = self.origin;
	}
	//////////////////////////////////////////////////////////////
	//END OF FAILSAFE "hack"
	//////////////////////////////////////////////////////////////
}

function on_player_connect() {
	self thread can_pause();
	self thread can_revive();

	if( self IsHost() )
	{
		self thread wants_pause();
		self thread pause_notif();
	}
	
}

function can_revive()
{
	self endon("disconnect");

	paused_and_downed = false;
	bleedout_time = 30;
	while(true)
	{
		if(level.is_coop_paused && self laststand::player_is_in_laststand() && ! paused_and_downed)
		{
			paused_and_downed = true;
			self notify("stop_revive_trigger");
		}
		else if(paused_and_downed)
		{
			paused_and_downed = false;
			if(self laststand::player_is_in_laststand())
			{
				self zm_laststand::revive_trigger_spawn();
			}
		}
		wait(0.05);
	}
}

function health_check()
{
	self endon("disconnect");

	current_health = self.health;

	while(level.is_coop_paused)
	{	
		self.health = current_health;

		wait(0.05);
	}
}


function should_pause() 
{
	while( true ) 
	{
		wants_pause_change = (IsWorldPaused() ? ! level.wants_pause : level.wants_pause);
		
		if( wants_pause_change && ( ! level.in_unpausable_ee_sequence || IsWorldPaused() ) ) 
		{
			if( IsWorldPaused() ) 
			{
				//IPrintLn("unpausing");
				if(level flag::get("dog_round"))
				{
					zm_ai_shadowpeople::unpause();
				}
				level.is_coop_paused = false;
				foreach(player in level.players) {
					player SetMoveSpeedScale( player.prevMoveSpeedScale );
					player AllowJump(true);
					if(! player.abbey_inventory_active)
					{
						player EnableWeapons();
					}
				}

				SetPauseWorld(0);

				zombies = GetAITeamArray("axis");
				for(i = 0; i < zombies.size; i++)
				{
					zombies[i].is_inert = false;
				}

				level flag::set( "spawn_zombies" );

				foreach(player in level.players) {
					player clientfield::set_player_uimodel("abbeyPause", 0);
				}

				
			}
			else
			{
				//IPrintLn("pausing");
				if(level flag::get("dog_round"))
				{
					zm_ai_shadowpeople::pause();
				}

				level.is_coop_paused = true;
				foreach(player in level.players)
				{
					player.prevMoveSpeedScale = player GetMoveSpeedScale();
					player SetMoveSpeedScale(0);
					player AllowJump(false);
					player DisableWeapons();
					player thread health_check();
				}
				
				level flag::clear( "spawn_zombies" );
				
				zombies = GetAITeamArray("axis");
				for(i = 0; i < zombies.size; i++)
				{
					zombies[i].is_inert = true;
				}

				SetPauseWorld(1);

				foreach(player in level.players) {
					player clientfield::set_player_uimodel("abbeyPause", 1);
				}
				
				wait(0.05);
			}
		}
		
		wait(0.05);
	}
}


function can_pause() 
{
	self endon("disconnect");

	while(! (level flag::exists("initial_blackscreen_passed") && level flag::get("initial_blackscreen_passed")))
	{
		wait(0.05);
	}

	can_pause = false;
	while(true) 
	{
		pause_condition = ( zm_utility::is_player_valid(self) && ! self.isInBloodMode && ! level.in_unpausable_ee_sequence ) || IsWorldPaused();
		if( pause_condition && !can_pause ) 
		{
			self clientfield::set_player_uimodel("abbeyPauseAvailable", 1);
			can_pause = true;
		}
		else if(! pause_condition && can_pause )
		{
			self clientfield::set_player_uimodel("abbeyPauseAvailable", 0);
			can_pause = false;
		}
		util::wait_network_frame();
	}
}

function wants_pause()
{
	self endon("disconnect");

	while(true)
	{
		if( self ActionSlotTwoButtonPressed() )
		{
			while(self ActionSlotTwoButtonPressed())
			{
				wait(0.05);
			}
			level.wants_pause = ! level.wants_pause;
		}
		wait(0.05);
	}
}

function pause_notif()
{
	self endon("disconnect");

	wait_round = 20;
	while(! isdefined(level.round_number) || level.round_number < wait_round)
	{
		if(isdefined(level.next_dog_round) && level.next_dog_round == wait_round)
		{
			wait_round += 1;
		}
		wait(0.05);
	}

	level waittill("start_of_round");
	self zm_abbey_inventory::notifyText(NOTIF_GLOBAL_PAUSE, NOTIF_FLASH_DOWN, NOTIF_ALERT_NEUTRAL);
}

function testeroo() 
{
	while(! level flag::get("initial_blackscreen_passed")) 
	{
		wait(0.05);
	}
	wait(30);
	IPrintLn("hello!");
}