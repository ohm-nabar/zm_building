#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;
#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\_zm_equipment;

#using scripts\shared\ai\zombie_utility;

//Perks
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_electric_cherry;
#using scripts\zm\_zm_perks;

//Powerups
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;

//Traps
#using scripts\zm\_zm_trap_electric;

#using scripts\zm\zm_usermap;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_laststand;

#using scripts\shared\hud_util_shared;

#using scripts\shared\ai\zombie_utility;

#using scripts\shared\visionset_mgr_shared;

#using scripts\zm\_zm_magicbox;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_perk_juggernaut.gsh;

#precache("material", "jug_hearts_full");
#precache("material", "jug_hearts_mid");
#precache("material", "jug_hearts_low");
#precache("material", "jug_hearts_no");

#precache("eventstring", "jug_hearts_update");

#precache("string", "ZM_ABBEY_FOUNTAIN_OFFLINE");
#precache("string", "ZM_ABBEY_FOUNTAIN_DEPOSIT");
#precache("string", "ZM_ABBEY_FOUNTAIN_ACTIVATE");

function main()
{
	callback::on_connect( &on_player_connect );
	callback::on_laststand( &on_laststand );
	// reminder

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
	self LUINotifyEvent(&"jug_hearts_update", 1, 0);
	self thread fix_health_reset();
	//self thread resistance_level_display();
	//self thread testeroo();
}

function on_laststand()
{
	self change_jug_resistance_level(false, 1);
}

function change_jug_resistance_level(increment, amount)
{
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
	self LUINotifyEvent(&"jug_hearts_update", 1, notify_val);

	self.maxhealth = self.jug_resistance_level;
	self SetMaxHealth( self.jug_resistance_level );
	self.health = self.maxhealth;
}

function activator_think()
{
	self SetHintString(&"ZM_ABBEY_FOUNTAIN_OFFLINE");
	
	bottle_weapon = GetWeapon( JUGGERNAUT_PERK_BOTTLE_WEAPON );

	while(! isdefined(level.active_generators) || level.active_generators.size < 2)
	{
		wait(0.05);
	}

	self thread zm_audio::sndPerksJingles_Timer();
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
			self PlaySoundToPlayer("mus_perks_jugganog_sting", player);
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
					self SetHintString(&"ZM_ABBEY_FOUNTAIN_ACTIVATE", level.jug_uses_left);
					break;
				}
				case 1:
				{
					self SetHintString(&"ZM_ABBEY_FOUNTAIN_DEPOSIT");
					break;
				}
				default:
				{
					self SetHintString(&"ZM_ABBEY_GENERATOR_NO_BLOOD");
					break;
				}
			}

			prev_hintstring_state = hintstring_state;
			prev_jug_uses_left = level.jug_uses_left;
		}
		wait(0.05);
	}
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