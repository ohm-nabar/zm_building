#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#insert scripts\zm\_zm_audio.gsh;
#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_perk_juggernaut.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache("string", "ZM_ABBEY_FOUNTAIN_OFFLINE");
#precache("string", "ZM_ABBEY_FOUNTAIN_DEPOSIT");
#precache("string", "ZM_ABBEY_FOUNTAIN_ACTIVATE");

#namespace zm_juggernog_potions;

REGISTER_SYSTEM( "zm_juggernog_potions", &__init__, undefined )

function __init__()
{
	clientfield::register( "clientuimodel", "jugHeartsUpdate", VERSION_SHIP, 2, "int" );

	callback::on_connect( &on_player_connect );
	callback::on_laststand( &on_laststand );

	players = GetPlayers();
	level.juggernog_uses = (players.size <= 2 ? 2 : 4);
	level.jug_uses_left = 0;

	jug_activates = GetEntArray("jug_activate", "targetname");
	level.jug_bottles = GetEntArray("jug_bottle", "targetname");

	for(i = 0; i < level.jug_bottles.size; i++)
	{
		level.jug_bottles[i] SetInvisibleToAll();
	}

	for(i = 0; i < jug_activates.size; i++)
	{
		jug_activates[i] SetCursorHint( "HINT_NOICON" );
		jug_activates[i] thread activator_think();
	}

	thread player_count_think();
}

function player_count_think()
{
	players = GetPlayers();
	prev_player_count = players.size;
	while(true)
	{
		players = GetPlayers();
		if(prev_player_count <= 2 && players.size > 2)
		{
			level.juggernog_uses = 4;
		}
		else if(prev_player_count > 2 && players.size <= 2)
		{
			level.juggernog_uses = 2;
		}
		prev_player_count = players.size;
		wait(0.05);
	}
}


function on_player_connect()
{
	self.jug_resistance_level = 100;
	self.prev_jug_resistance_level = self.jug_resistance_level;
	self thread fix_health_reset();
	//self thread resistance_level_display();
	//self thread testeroo();
}

function on_laststand()
{
	self.prev_jug_resistance_level = self.jug_resistance_level;
	self change_jug_resistance_level(false, 1);
}

function change_jug_resistance_level(increment, amount)
{
	self.prev_jug_resistance_level = self.jug_resistance_level;
	if(increment)
	{
		new_level = self.jug_resistance_level + (50 * amount);
		self.jug_resistance_level = Int(Min(new_level, 250));
	}
	else
	{
		new_level = self.jug_resistance_level - (50 * amount);
		self.jug_resistance_level = Int(Max(new_level, 100));
	}

	notify_val = Int((self.jug_resistance_level / 50) - 2);
	self clientfield::set_player_uimodel("jugHeartsUpdate", notify_val);

	self.maxhealth = self.jug_resistance_level;
	self SetMaxHealth( self.jug_resistance_level );
	self.health = self.maxhealth;
}

function maintain_jug_resistance_level()
{
	if(self.prev_jug_resistance_level <= self.jug_resistance_level)
	{
		return;
	}

	self.prev_jug_resistance_level = self.jug_resistance_level;
	self change_jug_resistance_level(true, 1);
}

function activator_think()
{
	self SetHintString(&"ZM_ABBEY_FOUNTAIN_OFFLINE");
	
	bottle_weapon = GetWeapon( JUGGERNAUT_PERK_BOTTLE_WEAPON );

	while(! isdefined(level.active_generators) || level.active_generators.size < 2)
	{
		wait(0.05);
	}

	self.script_sound = "mus_perks_jugganog_jingle";
	self.script_label = "mus_perks_jugganog_sting";
	self thread hintstring_management();
	
	while(true)
	{
		self waittill("trigger", player);
		if(level.jug_uses_left <= 0)
		{	
			if(level.hasVial && player zm_magicbox::can_buy_weapon())
			{
				level.hasVial = false;
				
				if(level.players.size > 2)
				{
					level.jug_uses_left = 4;
				}
				else
				{
					level.jug_uses_left = 2;
				}

				for(i = 0; i < level.jug_bottles.size; i++)
				{
					level.jug_bottles[i] SetVisibleToAll();
				}
			}
		}
		else if(player.jug_resistance_level < 250 && zm_perks::vending_trigger_can_player_use(player))
		{
			self thread sndPerksJingles_Player(PERKSACOLA_STINGER);
			gun = player perk_give_bottle_begin( bottle_weapon );
			level.jug_uses_left--;
			if(level.jug_uses_left <= 0)
			{
				for(i = 0; i < level.jug_bottles.size; i++)
				{
					level.jug_bottles[i] SetInvisibleToAll();
				}
			}

			player util::waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete", "perk_abort_drinking");


			if ( player.sessionstate != "spectator" && ! player laststand::player_is_in_laststand() && IsAlive(player) && IsPlayer(player) && isdefined(player) )
			{
				player thread zm_perks::give_perk_presentation(PERK_JUGGERNOG);
				player change_jug_resistance_level(true, 3);
			}
			player perk_give_bottle_end( gun, bottle_weapon);
		}
		wait(0.05);
	}
}

function hintstring_management()
{
	prev_jug_uses_left = -1;
	prev_hintstring_state = -1;
	hintstring_state = -1;
	jug_timer_set = false;

	while(true)
	{
		if(level.jug_uses_left > 0)
		{
			hintstring_state = 0;
		}
		else if(level.hasVial)
		{
			hintstring_state = 1;
		}
		else
		{
			hintstring_state = 2;
		}

		if(prev_hintstring_state != hintstring_state || prev_jug_uses_left != level.jug_uses_left)
		{
			switch(hintstring_state)
			{
				case 0:
				{
					if(! jug_timer_set)
					{
						jug_timer_set = true;
						self thread sndPerksJingles_Timer();
					}
					level exploder::exploder("jug_light");
					self SetHintString(&"ZM_ABBEY_FOUNTAIN_ACTIVATE", level.jug_uses_left);
					break;
				}
				case 1:
				{
					jug_timer_set = false;
					level exploder::stop_exploder("jug_light");
					self SetHintString(&"ZM_ABBEY_FOUNTAIN_DEPOSIT");
					self notify(#"jug_fountain_off");
					break;
				}
				default:
				{
					jug_timer_set = false;
					level exploder::stop_exploder("jug_light");
					self SetHintString(&"ZM_ABBEY_GENERATOR_NO_BLOOD");
					self notify(#"jug_fountain_off");
					break;
				}
			}

			prev_hintstring_state = hintstring_state;
			prev_jug_uses_left = level.jug_uses_left;
		}
		wait(0.05);
	}
}

//Perksacola Jingle Stuff
function sndPerksJingles_Timer()
{
	self endon( "death" );
	self endon( #"jug_fountain_off" );
	
	self.sndJingleCooldown = false;
	self.sndJingleActive = false;
	IPrintLn("starting timer");
	while(1)
	{
		wait(PERKSACOLA_WAIT_TIME);
		
		if( PERKSACOLA_PROBABILITY && !IS_TRUE(self.sndJingleCooldown) )
		{
			IPrintLn("playing jingle");
			self thread sndPerksJingles_Player(PERKSACOLA_JINGLE);
		}
	}
}
function sndPerksJingles_Player(type)
{
	self endon( "death" );
	self endon( #"jug_fountain_off" );
	
	if( !isdefined( self.sndJingleActive ) )
	{
		self.sndJingleActive = false;
	}
	
	alias = self.script_sound;
	
	if( type == PERKSACOLA_STINGER )
		alias = self.script_label;
	
	if( isdefined( level.musicSystem ) && level.musicSystem.currentPlaytype >= PLAYTYPE_SPECIAL )
		return;
	
	self.str_jingle_alias = alias;
	
	if( !IS_TRUE( self.sndJingleActive ) )
	{
		IPrintLn("playing jingle (for real)");
		self.sndJingleActive = true;
		self playsoundwithnotify( alias, "sndDone" );
		
		playbacktime = soundgetplaybacktime( alias );
		if( !isdefined( playbacktime ) || playbacktime <= 0 )
			waittime = 1;
		else
			waittime = playbackTime * .001;
	
		wait(waittime);
		
		if( type == PERKSACOLA_JINGLE )
		{
			self.sndJingleCooldown = true;
			self thread sndPerksJingles_Cooldown();
		}
		
		self.sndJingleActive = false;
	}
}
function sndPerksJingles_Cooldown()
{
	self endon( "death" );
	self endon( #"jug_fountain_off" );
	
	wait(45);
	self.sndJingleCooldown = false;
}

function fix_health_reset()
{
	self endon("disconnect");

	while(true)
	{
		if(self.maxhealth != self.jug_resistance_level)
		{
			self.maxhealth = self.jug_resistance_level;
			self SetMaxHealth( self.jug_resistance_level );
			self.health = self.maxhealth;
		}
		wait(0.05);
	}
}

function perk_give_bottle_begin( perk_bottle )
{
	self endon( "disconnect" );
	
	self zm_utility::increment_is_drinking();
	
	self zm_utility::disable_player_move_states(true);

	original_weapon = self GetCurrentWeapon();

	self GiveWeapon( perk_bottle );
	self SwitchToWeapon( perk_bottle );

	return original_weapon;
}

function perk_give_bottle_end( original_weapon, perk_bottle )
{
	self endon( "disconnect" );

	Assert( !original_weapon.isPerkBottle );
	Assert( original_weapon != level.weaponReviveTool );

	self zm_utility::enable_player_move_states();
	
	// TODO: race condition?
	if ( self laststand::player_is_in_laststand() || IS_TRUE( self.intermission ) )
	{
		self TakeWeapon(perk_bottle);
		return;
	}

	self TakeWeapon(perk_bottle);

	if( self zm_utility::is_multiple_drinking() )
	{
		self zm_utility::decrement_is_drinking();
		return;
	}
	else if( original_weapon != level.weaponNone && !zm_utility::is_placeable_mine( original_weapon ) && !zm_equipment::is_equipment_that_blocks_purchase( original_weapon ) )
	{
		self zm_weapons::switch_back_primary_weapon( original_weapon );
		
		// ww: the knives have no first raise anim so they will never get a "weapon_change_complete" notify
		// meaning it will never leave this funciton and will break buying weapons for the player
		if( zm_utility::is_melee_weapon( original_weapon ) )
		{
			self zm_utility::decrement_is_drinking();
			return;
		}
	}
	else 
	{
		self zm_weapons::switch_back_primary_weapon();
	}

	self zm_utility::decrement_is_drinking();
}

function testeroo()
{
	while(true)
	{
		upgrades = GetEntArray( "zombie_equipment_upgrade", "targetname" );
		IPrintLn("origin: " + upgrades[0].origin);
		wait(1.5);
	}
}