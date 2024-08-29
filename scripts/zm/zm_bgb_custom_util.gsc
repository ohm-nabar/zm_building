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

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_zonemgr;

#using scripts\shared\ai\zombie_utility;

//Perks
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_electric_cherry;

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

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_weap_cymbal_monkey;

#using scripts\zm\zm_usermap;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;

// MAIN
//*****************************************************************************

function checkStringValid( str )
{
	if( str != "" )
		return str;
	return undefined;
}

function getColourValue( activation )
{
	switch(activation)
	{
		case "activated":
			return "purple";
			break;
		case "round":
			return "blue";
			break;	
		case "event":
			return "orange";
			break;	
		case "time":
			return "green";
			break;	
		default:
			return "none";
			break;
	}
}

function gg_name(gumFunc)
{
	return level.gg_names[gumFunc];
}

function lookupGobblgum(name)
{
    index = 1;
    row = TableLookupRow( "gamedata/stats/zm/zm_statstable.csv", index );
    
    while ( isdefined( row ) )
    {
        gumStr = checkStringValid( row[4] );

        if(gumStr == name)
            break;

        index++;

        row = TableLookupRow( "gamedata/stats/zm/zm_statstable.csv", index );
    }

    struct = SpawnStruct();
    struct.name = gumStr;
    struct.displayName = gg_name(struct.name);
    struct.camoIndex = Int(row[5]);
    struct.image = checkStringValid( row[6] );
    struct.description = checkStringValid( row[7] );
    struct.rarity = Int( row[16] );    // 0 = common, 1 = mega, 2 = rare, 3 = urm, 4 = whim
    struct.activation = checkStringValid( row[20] );
    struct.colourValue = getColourValue(struct.activation);
    struct.tableIndex = Int( row[0] );
    struct.releaseType = checkStringValid( row[15] );

    return struct;
}

function giveGobbleGum(gum)
{
	self endon("disconnect");

    gumWeapon = GetWeapon("zombie_bgb_grab");
    oldWeapon = self GetCurrentWeapon();
    gumWeapon = self GetBuildKitWeapon( gumWeapon, false );
    weapon_options = self GetBuildKitWeaponOptions( gumWeapon, gum.camoIndex );
    acvi = self GetBuildKitAttachmentCosmeticVariantIndexes( gumWeapon, false );
    /*
    self DisableWeaponCycling();
    self AllowSprint(false);
    self AllowSlide(false);
    self GiveWeapon( gumWeapon, weapon_options, acvi );
    self SwitchToWeapon(gumWeapon);
    */
    gun = self perk_give_bottle_begin( gumWeapon, weapon_options, acvi );

   	self util::waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete", "perk_abort_drinking");

    if ( self.sessionstate != "spectator" && ! self laststand::player_is_in_laststand() && IsAlive(self) && IsPlayer(self) && isdefined(self) )
	{
		self bgb::give(gum.name);
	}
	self perk_give_bottle_end( gun, gumWeapon);

    /*
    self TakeWeapon(gumWeapon);
    self SwitchToWeapon(oldWeapon);
    if(evt != "player_downed") {
    	self EnableWeaponCycling();
    }
    self AllowSprint(true);
    self AllowSlide(true);
    self PlaySoundToPlayer( "bgb_grab", self );
    */
    
}

function perk_give_bottle_begin( gumWeapon, weapon_options, acvi )
{
	self endon( "disconnect" );
	
	self zm_utility::increment_is_drinking();
	
	self zm_utility::disable_player_move_states(true);

	original_weapon = self GetCurrentWeapon();

	self GiveWeapon( gumWeapon, weapon_options, acvi );
	self SwitchToWeapon( gumWeapon );

	return original_weapon;
}

function perk_give_bottle_end( original_weapon, gumWeapon )
{
	self endon( "disconnect" );

	Assert( !original_weapon.isPerkBottle );
	Assert( original_weapon != level.weaponReviveTool );

	self zm_utility::enable_player_move_states();
	
	// TODO: race condition?
	if ( self laststand::player_is_in_laststand() || IS_TRUE( self.intermission ) )
	{
		self TakeWeapon(gumWeapon);
		return;
	}

	self TakeWeapon(gumWeapon);

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