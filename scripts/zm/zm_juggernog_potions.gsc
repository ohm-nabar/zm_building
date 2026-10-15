#using scripts\codescripts\struct;

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
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#using scripts\Sphynx\_zm_sphynx_util;

#insert scripts\zm\_zm_audio.gsh;
#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_perk_juggernaut.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_DEPOSIT");
#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_OFFLINE_BLOOD");

#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_OFFLINE", "^BJUG_HEARTS_NO^");
#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_OFFLINE", "^BJUG_HEARTS_LOW^");
#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_OFFLINE", "^BJUG_HEARTS_MID^");
#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_OFFLINE", "^BJUG_HEARTS_FULL^");

#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_ACTIVATE_SINGULAR", "^BJUG_HEARTS_LOW^");
#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_ACTIVATE_SINGULAR", "^BJUG_HEARTS_MID^");
#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_ACTIVATE_SINGULAR", "^BJUG_HEARTS_FULL^");

#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_ACTIVATE", "^BJUG_HEARTS_LOW^", "2");
#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_ACTIVATE", "^BJUG_HEARTS_MID^", "2");
#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_ACTIVATE", "^BJUG_HEARTS_FULL^", "2");

#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_ACTIVATE", "^BJUG_HEARTS_LOW^", "3");
#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_ACTIVATE", "^BJUG_HEARTS_MID^", "3");
#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_ACTIVATE", "^BJUG_HEARTS_FULL^", "3");

#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_ACTIVATE", "^BJUG_HEARTS_LOW^", "4");
#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_ACTIVATE", "^BJUG_HEARTS_MID^", "4");
#precache("triggerstring", "ZM_ABBEY_FOUNTAIN_ACTIVATE", "^BJUG_HEARTS_FULL^", "4");

#namespace zm_juggernog_potions;

REGISTER_SYSTEM_EX( "zm_juggernog_potions", &__init__, &__main__, undefined )

function __init__()
{
	level clientfield::register( "clientuimodel", "jugHeartsUpdate", VERSION_SHIP, 2, "int" );

	level callback::on_connect( &on_player_connect );
	level callback::on_laststand( &on_laststand );

	level.jug_uses_left = 0;
}

function __main__()
{
	jug_activates = level struct::get_array("jug_activate", "targetname");
	level.jug_bottles = GetEntArray("jug_bottle", "targetname");

	for(i = 0; i < level.jug_bottles.size; i++)
	{
		level.jug_bottles[i] SetInvisibleToAll();
	}

	for(i = 0; i < jug_activates.size; i++)
	{
		jug_activates[i] thread activator_think();
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
	self endon("disconnect");

	self.prev_jug_resistance_level = self.jug_resistance_level;
	self change_jug_resistance_level(false, 1);

	result = self util::waittill_any_return("player_revived", "bled_out");
	if(result == "bled_out")
	{
		self change_jug_resistance_level(false, 3);
	}
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

function manage_sound(jingle_origin, blood_origin)
{
	prev_jug_up = false;

	while(true)
	{
		if(! prev_jug_up && level.jug_uses_left > 0)
		{
			prev_jug_up = true;
			level exploder::exploder("jug_light");
			jingle_origin thread sndPerksJingles_Timer();
			blood_origin PlayLoopSound("jug_fountain_idle");
		}
		else if(prev_jug_up && level.jug_uses_left == 0)
		{
			prev_jug_up = false;
			level exploder::stop_exploder("jug_light");
			jingle_origin notify(#"jug_fountain_off");
			blood_origin StopLoopSound();
		}
		wait(0.05);
	}
}

function activator_think()
{
	self zm_sphynx_util::create_unitrigger_for_player_specific("", undefined, &jug_prompt_and_visibility);
	
	bottle_weapon = GetWeapon( JUGGERNAUT_PERK_BOTTLE_WEAPON );

	jingle_origin = Spawn("script_model", self.origin);
	jingle_origin SetModel("tag_origin");

	jingle_origin.script_sound = "mus_perks_jugganog_jingle";
	jingle_origin.script_label = "mus_perks_jugganog_sting";

	blood_origin = Spawn("script_model", self.origin);
	blood_origin SetModel("tag_origin");

	self thread manage_sound(jingle_origin, blood_origin);

	while(true)
	{
		self waittill("trigger_activated", player);
		if(level.jug_uses_left == 0)
		{	
			if(level.hasVial && level.active_generators.size == 4)
			{
				level.hasVial = false;
				level.jug_uses_left = level.players.size;
				for(i = 0; i < level.jug_bottles.size; i++)
				{
					level.jug_bottles[i] SetVisibleToAll();
				}
			}
		}
		else
		{
			jingle_origin thread sndPerksJingles_Player(PERKSACOLA_STINGER);
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
				player change_jug_resistance_level(true, level.active_generators.size);
			}
			player perk_give_bottle_end(gun, bottle_weapon);
		}
		wait(0.05);
	}
}

function jug_prompt_and_visibility(player)
{
	if(! level zm_perks::vending_trigger_can_player_use(player))
	{
		self SetHintString(&"ZM_ABBEY_EMPTY");
		return false;
	}

	switch(level.jug_uses_left)
	{
		case 0:
			if(level.active_generators.size < 4)
			{
				switch(level.active_generators.size)
				{
					case 0:
						self SetHintString(&"ZM_ABBEY_FOUNTAIN_OFFLINE", "^BJUG_HEARTS_NO^");
						break;
					case 1:
						self SetHintString(&"ZM_ABBEY_FOUNTAIN_OFFLINE", "^BJUG_HEARTS_LOW^");
						break;
					case 2:
						self SetHintString(&"ZM_ABBEY_FOUNTAIN_OFFLINE", "^BJUG_HEARTS_MID^");
						break;
					default:
						self SetHintString(&"ZM_ABBEY_FOUNTAIN_OFFLINE", "^BJUG_HEARTS_FULL^");
						break;
				}
				return false;
			}
			if(! level.hasVial)
			{
				self SetHintString(&"ZM_ABBEY_FOUNTAIN_OFFLINE_BLOOD");
				return false;
			}

			self SetHintString(&"ZM_ABBEY_FOUNTAIN_DEPOSIT");
			return true;
		case 1:
			switch(level.active_generators.size)
			{
				case 1:
					self SetHintString(&"ZM_ABBEY_FOUNTAIN_ACTIVATE_SINGULAR", "^BJUG_HEARTS_LOW^");
					break;
				case 2:
					self SetHintString(&"ZM_ABBEY_FOUNTAIN_ACTIVATE_SINGULAR", "^BJUG_HEARTS_MID^");
					break;
				default:
					self SetHintString(&"ZM_ABBEY_FOUNTAIN_ACTIVATE_SINGULAR", "^BJUG_HEARTS_FULL^");
					break;
			}
			return (player.jug_resistance_level < 250);
	}

	switch(level.active_generators.size)
	{
		case 1:
			self SetHintString(&"ZM_ABBEY_FOUNTAIN_ACTIVATE", "^BJUG_HEARTS_LOW^", level.jug_uses_left);
			break;
		case 2:
			self SetHintString(&"ZM_ABBEY_FOUNTAIN_ACTIVATE", "^BJUG_HEARTS_MID^", level.jug_uses_left);
			break;
		default:
			self SetHintString(&"ZM_ABBEY_FOUNTAIN_ACTIVATE", "^BJUG_HEARTS_FULL^", level.jug_uses_left);
			break;
	}
	return (player.jug_resistance_level < 250);
}

//Perksacola Jingle Stuff
function sndPerksJingles_Timer()
{
	self endon( "death" );
	self endon( #"jug_fountain_off" );
	
	self.sndJingleCooldown = false;
	self.sndJingleActive = false;
	while(1)
	{
		wait(PERKSACOLA_WAIT_TIME);
		
		if( PERKSACOLA_PROBABILITY && !IS_TRUE(self.sndJingleCooldown) )
		{
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