#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\music_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_antiverse;
#using scripts\zm\zm_ai_shadowpeople;
#using scripts\Sphynx\_zm_sphynx_util;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;
#insert scripts\shared\ai\zombie.gsh;
#insert scripts\shared\archetype_shared\archetype_shared.gsh;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_laststand.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache( "eventstring", "solo_lives_update" );

function main()
{
	level.override_use_solo_revive = &override_use_solo_revive;
	level.playerlaststand_func = &player_laststand;
	level.overridePlayerDamage = &player_damage_override;
	callback::on_connect( &on_player_connect );
}

function on_player_connect()
{
	if (self IsHost())
	{
		self.antiverse_skip = false;
		self thread set_lives();
		//self thread testeroo();
	}
}

function set_lives()
{
	while(! level flag::get("initial_blackscreen_passed"))
	{
		wait(0.05);
	}

	self.lives = 3;
	self thread manage_solo_lives();
}

function manage_solo_lives()
{
	prev_solo_flag = false;
	while(true)
	{
		if(prev_solo_flag != level flag::get("solo_game"))
		{
			if(level flag::get("solo_game"))
			{
				self LUINotifyEvent(&"solo_lives_update", 1, self.lives);
			}
			else
			{
				self LUINotifyEvent(&"solo_lives_update", 1, 0);
			}
			prev_solo_flag = level flag::get("solo_game");
		}
		wait(0.05);
	}
}

function override_use_solo_revive()
{
	return false;
}

function player_laststand( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	b_alt_visionset = false;
		
	self AllowJump(false);

	players = GetPlayers();
	if ( players.size == 1 && level flag::get( "solo_game" ) )
	{
		if ( self.lives > 0 && ! self.antiverse_skip )
		{
			self thread wait_and_revive();
		}
	}
	
	self zm_utility::clear_is_drinking();

	self thread zm::remote_revive_watch();
	
	self zm_score::player_downed_penalty();
	
	// Turns out we need to do this after all, but we don't want to change _laststand.gsc postship, so I'm doing it here manually instead
	self DisableOffhandWeapons();

	self thread zm::last_stand_grenade_save_and_return();
	
	if( sMeansOfDeath != "MOD_SUICIDE" && sMeansOfDeath != "MOD_FALLING" )
	{		
		if( !IS_TRUE(self.intermission) )
			self zm_audio::create_and_play_dialog( "general", "revive_down" );
		else
		{
			if(isDefined(level.custom_player_death_vo_func) && !self [[level.custom_player_death_vo_func]]() )
			{
				self zm_audio::create_and_play_dialog( "general", "exert_death" );
			}
		}
	}
	
	if( IsDefined( level._zombie_minigun_powerup_last_stand_func ) )
	{
		self thread [[level._zombie_minigun_powerup_last_stand_func]]();
	}
	
	if( IsDefined( level._zombie_tesla_powerup_last_stand_func ) )
	{
		self thread [[level._zombie_tesla_powerup_last_stand_func]]();
	}
	
	if ( self HasPerk( PERK_ELECTRIC_CHERRY ) )
	{
		b_alt_visionset = true;
		
		if ( IsDefined( level.custom_laststand_func ) )
		{
			self thread [[ level.custom_laststand_func ]]();
		}
	}

	if( IsDefined( self.intermission ) && self.intermission )
	{
		//maps\_zombiemode_challenges::doMissionCallback( "playerDied", self );
		
		wait(.5);
		self stopsounds();
		
		level waittill( "forever" );
	}
	
	if ( !( b_alt_visionset ) )
	{
		visionset_mgr::activate( "visionset", ZM_LASTSTAND_VISIONSET, self, 1 );
	}
}

function player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	iDamage = self zm::check_player_damage_callbacks( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
	
	if( self.scene_takedamage === false )
	{
		return 0;
	}

	if ( IsDefined( eAttacker ) && IS_TRUE( eAttacker.b_aat_fire_works_weapon ) )
	{
		return 0;
	}
	
	if ( IS_TRUE( self.use_adjusted_grenade_damage ) )
    {
        self.use_adjusted_grenade_damage = undefined;
        if( ( self.health > iDamage ) )
        {
        	return iDamage;
        }
    }

	if ( !iDamage )
	{
		return 0;
	}
	
	// WW (8/20/10) - Sledgehammer fix for Issue 43492. This should stop the player from taking any damage while in laststand
	if( self laststand::player_is_in_laststand() )
	{
		return 0;
	}
	
	if ( isDefined( eInflictor ) )
	{
		if ( IS_TRUE( eInflictor.water_damage ) )
		{
			return 0;
		}
	}

	if ( isDefined( eAttacker ) )
	{
		if( IS_EQUAL( eAttacker.owner, self ) ) 
		{
			return 0;
		}
		
		if( isDefined( self.ignoreAttacker ) && self.ignoreAttacker == eAttacker ) 
		{
			return 0;
		}
		
		// AR (5/30/12) - Stop Zombie players from damaging other Zombie players
		if ( IS_TRUE( self.is_zombie ) && IS_TRUE( eAttacker.is_zombie ) )
		{
			return 0;
		}
		
		if( (isDefined( eAttacker.is_zombie ) && eAttacker.is_zombie) )
		{
			self.ignoreAttacker = eAttacker;
			self thread zm::remove_ignore_attacker();

			if ( isdefined( eAttacker.custom_damage_func ) )
			{
				iDamage = eAttacker [[ eAttacker.custom_damage_func ]]( self );
			}
		}
		
		eAttacker notify( "hit_player" ); 

		if ( isdefined( eAttacker ) && isdefined( eAttacker.func_mod_damage_override ) )
		{
			sMeansOfDeath = eAttacker [[ eAttacker.func_mod_damage_override ]]( eInflictor, sMeansOfDeath, weapon );
		}
		
		if( sMeansOfDeath != "MOD_FALLING" )
		{
			self thread zm::playSwipeSound( sMeansOfDeath, eattacker );
			if( IS_TRUE(eattacker.is_zombie) || IsPlayer(eAttacker) )
				self PlayRumbleOnEntity( "damage_heavy" );
			
			if( IS_TRUE(eattacker.is_zombie) )
			{
				self zm_audio::create_and_play_dialog( "general", "attacked" );
			}
			
			canExert = true;
			
			if ( IS_TRUE( level.pers_upgrade_flopper ) )
			{
				// If the player has persistent flopper power, then no exert on explosion
				if ( IS_TRUE( self.pers_upgrades_awarded[ "flopper" ] ) )
				{
					canExert = ( sMeansOfDeath != "MOD_PROJECTILE_SPLASH" && sMeansOfDeath != "MOD_GRENADE" && sMeansOfDeath != "MOD_GRENADE_SPLASH" );
				}
			}
			
			if ( IS_TRUE( canExert ) )
			{
			    if(RandomIntRange(0,1) == 0 )
			    {
			    	self thread zm_audio::playerExert( "hitmed" );
			        //self thread zm_audio::create_and_play_dialog( "general", "hitmed" );
			    }
			    else
			    {
			    	self thread zm_audio::playerExert( "hitlrg" );
			        //self thread zm_audio::create_and_play_dialog( "general", "hitlrg" );
			    }
			}
		}
	}
	
	//Audio(RG:2/1/2016) adding underwater drowning exert.
	if ( isDefined( sMeansOfDeath) && sMeansOfDeath == "MOD_DROWN")
	{
		self thread zm_audio::playerExert( "drowning", true );
		self.voxDrowning = true;
	}
	
	if( isdefined( level.perk_damage_override ) )
	{
		foreach( func in level.perk_damage_override )
		{
			n_damage = self [[ func ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
			if( isdefined( n_damage ) )
			{
				iDamage = n_damage;		
			}
		}
	}	
	finalDamage = iDamage;
	
		
	// claymores and freezegun shatters, like bouncing betties, harm no players
	if ( zm_utility::is_placeable_mine( weapon ) )
	{
		return 0;
	}

	if ( isDefined( self.player_damage_override ) )
	{
		self thread [[ self.player_damage_override ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}

	// exploding quads should not kill player
	if ( IsDefined( eInflictor ) && IsDefined( eInflictor.archetype ) && eInflictor.archetype == ARCHETYPE_ZOMBIE_QUAD )
	{
		if ( sMeansOfDeath == "MOD_EXPLOSIVE" )
		{
			if ( self.health > 75 )
			{
				return 75;
			}
		}
	}
	
	// Players can't die from cooked grenade if trhey have the bgb Danger Closet
	if ( sMeansOfDeath == "MOD_SUICIDE" && self bgb::is_enabled( "zm_bgb_danger_closest" ) )
	{
		return 0;
	}
	
	if ( sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSIVE" )
	{
		if( self bgb::is_enabled( "zm_bgb_danger_closest" ) )
		{
			return 0;
		}
		
		// player explosive splash damage (caps explosive damage), fixes raygun damage being fatal (or grenades) when damaging yourself
		if ( !IS_TRUE( self.is_zombie ) )
		{
			// Don't do this for projectile damage coming from zombies
			if ( !isdefined( eAttacker ) || ( !IS_TRUE( eAttacker.is_zombie ) && !IS_TRUE( eAttacker.b_override_explosive_damage_cap ) ) )
			{
				// Only do it for ray gun
				if( isdefined(weapon.name) && ((weapon.name == "ray_gun") || ( weapon.name == "ray_gun_upgraded" )) )
				{
					// Clamp it, we don't want to increase the damage from player raygun splash damage or grenade splash damage
					// Don't create more damage than we are trying to apply
					if ( ( self.health > 25 ) && ( iDamage > 25 ) )
					{
						return 25;
					}
				}
				else if ( ( self.health > 75 ) && ( iDamage > 75 ) )
				{
					return 75;
				}
			}
		}
	}

	if( iDamage < self.health )
	{
		if ( IsDefined( eAttacker ) )
		{
			if( IsDefined( level.custom_kill_damaged_VO ) )
			{
				eAttacker thread [[ level.custom_kill_damaged_VO ]]( self );
			}
			else
			{
				eAttacker.sound_damage_player = self;	
			}
			
			if( IS_TRUE( eAttacker.missingLegs ) )
			{
			    self zm_audio::create_and_play_dialog( "general", "crawl_hit" );
			}
		}
		
		// MM (08/10/09)
		return finalDamage;
	}
	
	self thread zm::clear_path_timers();
		
	if( level.intermission )
	{
		level waittill( "forever" );
	}
	
	// AR (3/7/12) - Keep track of which player killed player in Zombify modes like Cleansed / Turned
	// Confirmed with Alex 
	if ( level.scr_zm_ui_gametype == "zcleansed" && iDamage > 0 )
	{
		if ( IsDefined( eAttacker ) && IsPlayer( eAttacker ) && eAttacker.team != self.team && ( ( !IS_TRUE( self.laststand ) && !self laststand::player_is_in_laststand() ) || !IsDefined( self.last_player_attacker ) ) )
		{
			// Restore Health To Zombie Player
			//--------------------------------
			if ( IsDefined( eAttacker.maxhealth ) && IS_TRUE( eAttacker.is_zombie ) )
			{
				eAttacker.health = eAttacker.maxhealth;
			}
			
			//self.last_player_attacker = eAttacker;

			if ( IsDefined( level.player_kills_player ) )
			{
				self thread [[ level.player_kills_player]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );
			}			
		}
	}
	
	players = GetPlayers();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] == self || players[i].is_zombie || players[i] laststand::player_is_in_laststand() || players[i].sessionstate == "spectator" )
		{
			count++;
		}
	}
	
	if( count < players.size || (isDefined(level._game_module_game_end_check) && ![[level._game_module_game_end_check]]()) )
	{
		if ( IsDefined( self.lives ) && self.lives > 0 && IS_TRUE( level.force_solo_quick_revive ) && ! IS_TRUE( self.antiverse_skip ) )
		{
			self thread wait_and_revive();
		}
		
		// MM (08/10/09)
		return finalDamage;
	}
	
	// PORTIZ 7/27/16: added level.no_end_game_check here, because if it's true by this point, this function will end up returning finalDamage anyway. additionally, 
	// no_end_game_check has been updated to support incrementing/decrementing, which makes it more robust than a single level.check_end_solo_game_override as more
	// mechanics are introduced that require solo players to go into last stand instead of losing the game immediately
	if ( players.size == 1 && level flag::get( "solo_game" ) )
	{
		if ( IS_TRUE( level.no_end_game_check ) || ( isdefined( level.check_end_solo_game_override ) && [[level.check_end_solo_game_override]]() ) )
		{
			return finalDamage;
		}
		else if ( self.lives == 0 || self.antiverse_skip )
		{
			self.intermission = true;
		}
	}
	
	// WW (01/05/11): When a two players enter a system link game and the client drops the host will be treated as if it was a solo game
	// when it wasn't. This led to SREs about undefined and int being compared on death (self.lives was never defined on the host). While
	// adding the check for the solo game flag we found that we would have to create a complex OR inside of the if check below. By breaking
	// the conditions out in to their own variables we keep the complexity without making it look like a mess.
	solo_death = ( players.size == 1 && level flag::get( "solo_game" ) && ( self.lives == 0 || self.antiverse_skip ) ); // there is only one player AND the flag is set AND self.lives equals 0
	non_solo_death = ( ( count > 1 || ( players.size == 1 && !level flag::get( "solo_game" ) ) ) /*&& !level.is_zombie_level*/ ); // the player size is greater than one OR ( players.size equals 1 AND solo flag isn't set ) AND not a zombify game level
	if ( (solo_death || non_solo_death) && !IS_TRUE(level.no_end_game_check ) ) // if only one player on their last life or any game that started with more than one player
	{	
		level notify("stop_suicide_trigger");
		self AllowProne( true ); //just in case
		self thread zm_laststand::PlayerLastStand( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime );
		if( !isdefined( vDir ) )
		{
			vDir = ( 1.0, 0.0, 0.0 );
		}
		self FakeDamageFrom(vDir);
		
		level notify("last_player_died");
		if ( isdefined(level.custom_player_fake_death) )
			self thread [[level.custom_player_fake_death]](vDir, sMeansOfDeath);
		else
			self thread zm::player_fake_death();
	}

	if( count == players.size && !IS_TRUE( level.no_end_game_check ) )
	{
		if ( players.size == 1 && level flag::get( "solo_game" ))
		{
			if ( self.lives == 0 || self.antiverse_skip ) // && !self laststand::player_is_in_laststand()
			{
				level notify("pre_end_game");
				util::wait_network_frame();
				level notify( "end_game" );
			}
			else
			{
				return finalDamage;
			}
		}
		else
		{
			level notify("pre_end_game");
			util::wait_network_frame();
			level notify( "end_game" );
		}
		return 0;	// MM (09/16/09) Need to return something
	}
	else
	{
		// MM (08/10/09)
		
		surface = "flesh";
		
		return finalDamage;
	}
}

function wait_and_revive()
{
	self endon( "remote_revive" );
	level flag::set( "wait_and_revive" );
	level.wait_and_revive = true;

	if ( isdefined( self.waiting_to_revive ) && self.waiting_to_revive == true )
	{
		return;
	}

	self.waiting_to_revive = true;
	self.lives--;
	self LUINotifyEvent(&"solo_lives_update", 1, self.lives);

	if ( isdefined( level.exit_level_func ) )
	{
		self thread [[ level.exit_level_func ]]();
	}
	else
	{
		if ( GetPlayers().size == 1 )
		{
			player = GetPlayers()[0];
			level.move_away_points =  PositionQuery_Source_Navigation( player.origin, ZM_POSITION_QUERY_LAST_STAND_MOVE_DIST_MIN, ZM_POSITION_QUERY_LAST_STAND_MOVE_DIST_MAX, ZM_POSITION_QUERY_MOVE_DIST_MAX, ZM_POSITION_QUERY_RADIUS );
			if ( !isdefined( level.move_away_points ) )
			{
				level.move_away_points =  PositionQuery_Source_Navigation( player.last_valid_position, ZM_POSITION_QUERY_LAST_STAND_MOVE_DIST_MIN, ZM_POSITION_QUERY_LAST_STAND_MOVE_DIST_MAX, ZM_POSITION_QUERY_MOVE_DIST_MAX, ZM_POSITION_QUERY_RADIUS );
			}
		}
	}

	solo_revive_time = 10.0;

	name = level.player_name_directive[self GetEntityNumber()];

	self flag::wait_till_timeout( 5, #"solo_healing_grenade" );

	if ( self flag::get( #"solo_healing_grenade" ) )
	{
		self flag::clear( #"solo_healing_grenade" );
		self.lives++;
		self LUINotifyEvent(&"solo_lives_update", 1, self.lives);
		self.waiting_to_revive = false;
		level flag::clear( "wait_and_revive" );
		level.wait_and_revive = false;
	}
	else
	{
		// If we haven't been healing grenade revived in the first 5 seconds, it's antiverse time!
		if(level flag::get("dog_round"))
		{
			level thread zm_ai_shadowpeople::pause(true);
		}
		else
		{
			level thread zm_sphynx_util::stop_zombie_spawning();
		}
		level zm_audio::sndMusicSystem_StopAndFlush();
		music::setmusicstate("none");
		level.sndVoxOverride = true;
		self util::show_hud(false);
		self.prev_abbey_no_waypoints = self.abbey_no_waypoints;
		self.abbey_no_waypoints = true;
		self lui::screen_fade_out( 5, "black" );
		self EnableInvulnerability();
		self zm_laststand::auto_revive( self );
		self.waiting_to_revive = false;
		level flag::clear( "wait_and_revive" );
		level.wait_and_revive = false;
		self thread zm_antiverse::send_to_antiverse();
		wait(2);
		self DisableInvulnerability();
	}
}

function testeroo()
{
	while(true)
	{
		IPrintLn(self.lives);
		wait(1.5);
	}
}